//
//  JCPhotoBrowserZoomView.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/30.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCPhotoBrowserZoomView.h"

@interface JCPhotoBrowserZoomView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSString *imageURL;

@end

@implementation JCPhotoBrowserZoomView

- (instancetype)initWithURL:(NSString *)imageURL {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.imageURL = imageURL;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [self addSubview:scrollView];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bouncesZoom = YES;
    scrollView.delegate = self;
    self.scrollView = scrollView;

    UIImageView *imageView = [[UIImageView alloc] init];
    [scrollView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(imageView.superview);
    }];
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.imageView = imageView;
    __weak JCPhotoBrowserZoomView *weakSelf = self;
    [imageView setImageWithURL:self.imageURL placeholderImageName:@"placeholder" completionBlock:^(UIImage *image, NSString *imageUrl) {
        [weakSelf setZoomScaleForImage:image];
    }];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTapGesture.numberOfTapsRequired = 1;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [scrollView addGestureRecognizer:singleTapGesture];    
}

- (void)setZoomScaleForImage:(UIImage *)image {
    if (image == nil) {
        return;
    }
    
    CGSize scrollSize = self.scrollView.bounds.size;
    CGFloat imageMaxLength = MAX(image.size.width, image.size.height);
    CGFloat imageMinLength = MIN(image.size.width, image.size.height);
    CGFloat screenScale = scrollSize.height * 2 / imageMaxLength;
    if (imageMaxLength / imageMinLength > 1.5) {
        screenScale *= (imageMaxLength / imageMinLength) / 1.5;
    }
    float xScale = scrollSize.width / image.size.width;
    float yScale = scrollSize.height / image.size.height;
    float minScale = MIN(xScale, yScale);
    minScale *= 0.999999;
    float maxScale;
    if (minScale > 0.8) {
        maxScale = minScale * 1.25;
    } else {
        maxScale = MIN(screenScale, 1.0);
    }
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = maxScale;
    self.scrollView.contentSize = image.size;
    self.scrollView.zoomScale = minScale;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// center
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.superview layoutIfNeeded];
    CGSize screenSize = scrollView.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    if (frameToCenter.size.width < screenSize.width) {
        frameToCenter.origin.x = (screenSize.width - frameToCenter.size.width) / 2.0;
    } else {
        frameToCenter.origin.x = 0;
    }
    if (frameToCenter.size.height < screenSize.height) {
        frameToCenter.origin.y = (screenSize.height - frameToCenter.size.height) / 2.0;
    } else {
        frameToCenter.origin.y = 0;
    }
    self.imageView.frame = frameToCenter;
}

#pragma mark Zoom
- (void)zoomToDefaultScale {
    if (self.imageView) {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    }
}

- (void)doubleTap:(UIGestureRecognizer *)doubleTapGR {
    if (!self.imageView) {
        return;
    }
    if (fabs(self.scrollView.zoomScale - self.scrollView.minimumZoomScale) < DBL_EPSILON) {
        CGPoint pointInImage = [doubleTapGR locationInView:self.imageView];
        CGPoint pointInScreen = [doubleTapGR locationInView:self.scrollView];
        pointInScreen.x += self.imageView.frame.origin.x;
        pointInScreen.y += self.imageView.frame.origin.y;
        CGFloat maxScale = self.scrollView.maximumZoomScale;
        CGFloat offsetX = pointInImage.x - pointInScreen.x / maxScale;
        CGFloat offsetY = pointInImage.y - pointInScreen.y / maxScale;
        CGSize screenSize = self.scrollView.bounds.size;
        CGFloat rectWidth = screenSize.width / maxScale;
        CGFloat rectHeight = screenSize.height / maxScale;
        CGRect zoomRect = CGRectMake(offsetX, offsetY, rectWidth, rectHeight);
        [self.scrollView zoomToRect:zoomRect animated:YES];
    } else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void)singleTap:(UIGestureRecognizer *)singleTapGR {
    if (self.completionBlock) {
        self.completionBlock();
    }
}

@end

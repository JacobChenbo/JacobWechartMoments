//
//  JCPhotoBrowserSlideView.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/30.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCPhotoBrowserSlideView.h"
#import "JCPhotoBrowserZoomView.h"

@interface JCPhotoBrowserSlideView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imageUrlList;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger previousPage;

@end

@implementation JCPhotoBrowserSlideView

- (id)initWithImageUrlList:(NSArray *)imageUrlList {
    if (self = [super init]) {
        self.imageUrlList = imageUrlList;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    NSInteger count = [self.imageUrlList count];
    
    for (int i = 0; i < count; i++) {
        NSString *imagePath = self.imageUrlList[i];
        JCPhotoBrowserZoomView *zoomView = [[JCPhotoBrowserZoomView alloc] initWithURL:imagePath];
        
        zoomView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [scrollView addSubview:zoomView];
        
        __weak JCPhotoBrowserSlideView *weakSelf = self;
        [zoomView setCompletionBlock:^{
            [weakSelf dismiss];
        }];
    }
    
    // contentSize
    CGSize contentSize = [UIScreen mainScreen].bounds.size;
    contentSize.width *= count;
    scrollView.contentSize = contentSize;
    
    // create page control
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl = pageControl;
    pageControl.numberOfPages = count;
    pageControl.userInteractionEnabled = NO;
    pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pageControl.superview);
        make.bottom.equalTo(pageControl.superview).offset(-50);
    }];
}

#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = lround(offsetX / pageWidth);
    if (self.previousPage != currentPage) {
        self.pageControl.currentPage = currentPage;
        JCPhotoBrowserZoomView *zoomView = scrollView.subviews[self.previousPage];
        [zoomView zoomToDefaultScale];
        self.previousPage = currentPage;
    }
}

#pragma mark Set

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    self.previousPage = pageIndex;
    self.pageControl.currentPage = pageIndex;
    self.scrollView.contentOffset = CGPointMake(kScreenWidth * pageIndex, 0);
}

- (void)showSlideView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

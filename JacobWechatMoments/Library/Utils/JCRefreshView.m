//
//  JCRefreshView.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/26.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCRefreshView.h"

typedef NS_ENUM(NSInteger, JCPullToRefreshState) {
    JCPullToRefreshStateIdle = 0,
    JCPullToRefreshStateRefreshing = 1,
    JCPullToRefreshStateDisappearing = 2
};

@interface JCRefreshView ()

@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, assign) JCPullToRefreshState state;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat dropHeight;
@property (nonatomic, assign) CGFloat originalTopContentInset;
@property (nonatomic, copy) void (^handler)(JCRefreshView *);

@end

@implementation JCRefreshView

+ (instancetype)attachToScrollView:(UIScrollView *)scrollView handler:(void(^)(JCRefreshView *))handler {
    JCRefreshView *refresh = [[JCRefreshView alloc] init];
    refresh.scrollView = scrollView;
    refresh.dropHeight = 60;
    refresh.handler = handler;
    [scrollView addSubview:refresh];
    refresh.hidden = YES;
    
    return refresh;
}

- (id)init {
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wechatIcon"]];
    [self addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.left.equalTo(icon.superview).offset(20);
        make.centerY.equalTo(icon.superview);
    }];
    self.icon = icon;
}

- (CGFloat)realContentOffsetY {
    return self.scrollView.contentOffset.y + self.originalTopContentInset;
}

- (CGFloat)animationProgress {
    return MIN(1.0f, MAX(0, fabs([self realContentOffsetY]) / self.dropHeight));
}

#pragma mark UIScrollView scroll

- (void)scrollViewDidScroll {
    self.hidden = NO;
    
    CGFloat height = self.dropHeight;
    CGFloat Y = -self.dropHeight;
    if (-[self realContentOffsetY] > self.dropHeight) {
        height = -[self realContentOffsetY];
        Y = [self realContentOffsetY];
    }
    
//    NSLog(@"realContentOffsetY: %f, height: %f, Y: %f, originalTopContentInset: %f", [self realContentOffsetY], height, Y, self.originalTopContentInset);
    self.frame = CGRectMake(0, Y, self.scrollView.frame.size.width, height);
    
    if (self.state == JCPullToRefreshStateIdle) {
        self.originalTopContentInset = self.scrollView.contentInset.top;
        
        self.icon.transform = CGAffineTransformMakeRotation([self realContentOffsetY] / self.dropHeight * M_PI * 2);
    }
}

- (void)scrollViewDidEndDragging {
    if (self.state == JCPullToRefreshStateIdle && [self realContentOffsetY] < -self.dropHeight) {
        if ([self animationProgress] == 1) {
            self.state = JCPullToRefreshStateRefreshing;
        }
        
        if (self.state == JCPullToRefreshStateRefreshing) {
            UIEdgeInsets newInsets = self.scrollView.contentInset;
            newInsets.top = self.originalTopContentInset + self.dropHeight;
            CGPoint contentOffset = self.scrollView.contentOffset;
            
            [UIView animateWithDuration:0 animations:^{
                self.scrollView.contentInset = newInsets;
                self.scrollView.contentOffset = contentOffset;
            }];
        
            if (self.handler) {
                self.handler(self);
            }
            
            [self startLoadingAnimation];
        }
    }
}

- (void)startLoadingAnimation {
    [self.icon.layer removeAllAnimations];
    
    self.icon.transform = CGAffineTransformIdentity;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0 * 1 * 1]; // full rotation
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT_MAX;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.icon.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)finishingLoading {
    self.state = JCPullToRefreshStateDisappearing;
    UIEdgeInsets newInsets = self.scrollView.contentInset;
    newInsets.top = self.originalTopContentInset;
    
    [UIView animateWithDuration:0.35 animations:^{
        self.scrollView.contentInset = newInsets;
    } completion:^(BOOL finished) {
        self.state = JCPullToRefreshStateIdle;
        self.hidden = YES;
        [self.icon.layer removeAllAnimations];
    }];
}

@end

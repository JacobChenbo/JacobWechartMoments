//
//  JCRefreshView.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/26.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCRefreshView : UIView

+ (instancetype)attachToScrollView:(UIScrollView *)scrollView handler:(void(^)(JCRefreshView *))handler;

- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDragging;
- (void)finishingLoading;

@end

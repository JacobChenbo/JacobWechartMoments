//
//  JCPhotoBrowserZoomView.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/30.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCPhotoBrowserZoomView : UIView

@property (nonatomic, copy) void (^completionBlock)();

- (instancetype)initWithURL:(NSString *)imageURL;

- (void)zoomToDefaultScale;

@end

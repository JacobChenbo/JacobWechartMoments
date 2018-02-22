//
//  JCPhotoBrowserSlideView.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/30.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCPhotoBrowserSlideView : UIView

@property (nonatomic, assign) NSInteger pageIndex;

- (id)initWithImageUrlList:(NSArray *)imageUrlList;
- (void)showSlideView;

@end

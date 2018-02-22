//
//  UIImageView+ImageCache.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completionBlock)(UIImage *image, NSString *imageUrl);

@interface UIImageView (ImageCache)

/**
 set imageURL

 @param url imageURL
 */
- (void)setImageWithURL:(NSString *)url;

/**
 set imageURL, placeholderImageName
 
 @param url             WebUrl
 @param placeholderName placeholderImageName
 */
- (void)setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderName;

- (void)setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderName completionBlock:(completionBlock)completionBlock;

@end

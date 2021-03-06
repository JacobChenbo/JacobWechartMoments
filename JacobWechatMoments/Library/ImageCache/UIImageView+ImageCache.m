//
//  UIImageView+ImageCache.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "UIImageView+ImageCache.h"
#import "JCImageCache.h"
#import "JCImageLoader.h"

@implementation UIImageView (ImageCache)

- (void)setImageWithURL:(NSString *)url {
    return [self setImageWithURL:url placeholderImageName:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderName {
    return [self setImageWithURL:url placeholderImageName:placeholderName completionBlock:nil];
}

- (void)setImageWithURL:(NSString *)url placeholderImageName:(NSString *)placeholderName completionBlock:(completionBlock)completionBlock {
    // placeHolder
    if (placeholderName.length > 0) {
        UIImage *image = [UIImage imageNamed:placeholderName];
        self.image = image;
    }
    
    // Load image data
    JCImageLoader *imageLoader = [[JCImageLoader alloc] init];
    __weak UIImageView *weakSelf = self;
    [imageLoader loadImageDataWithURL:url completed:^(NSData *imageData, BOOL finished, NSString *imageURL, NSError *error) {
        __strong UIImageView *strongSelf = weakSelf;
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // main thread refresh UI
                UIImage *image = [UIImage imageWithData:imageData];
                strongSelf.image = image;
                
                if (completionBlock) {
                    completionBlock(image, imageURL);
                }
            });
        } else {
            if (completionBlock) {
                completionBlock(nil, imageURL);
            }
        }
    }];

}

@end

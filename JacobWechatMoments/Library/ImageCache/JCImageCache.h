//
//  JCImageCache.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCImageCache : NSObject

+ (JCImageCache *)sharedImageCache;

- (void)readDataFromCache:(NSURL *)imageURL completed:(void (^)(NSData *data))completedBlock;

- (void)saveImageData:(NSData *)data imageURL:(NSURL *)imageURL;

- (void)clearMemoryCache;
- (void)clearDiskCache;

@end

//
//  JCImageLoader.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCImageLoader.h"
#import "JCImageCache.h"

static char *queueName = "downloadQueueName";

@implementation JCImageLoader

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)loadImageDataWithURL:(NSString *)url completed:(JCImageDataLoadFinishBlock)completedBlock {
    NSURL *imageURL = [NSURL URLWithString:url];
    if (imageURL == nil) {
        completedBlock(nil, NO, url, [NSError errorWithDomain:NSURLErrorDomain code:405 userInfo:nil]);
        return;
    }
    
    [[JCImageCache sharedImageCache] readDataFromCache:imageURL completed:^(NSData *data) {
        if (data) {
            // already get image
            completedBlock(data, YES, url, nil);
        } else {
            // download data from network
            [self downloadImageFromNetworkWithURL:imageURL completiond:completedBlock];
        }
    }];
}

- (void)downloadImageFromNetworkWithURL:(NSURL *)url completiond:(JCImageDataLoadFinishBlock)completedBlock {
    dispatch_queue_t downloadQuere = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
    dispatch_async(downloadQuere, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if (imageData) {
            // download success
            completedBlock(imageData, YES, [url absoluteString], nil);
            // save to local
            [[JCImageCache sharedImageCache] saveImageData:imageData imageURL:url];
        } else {
            completedBlock(nil, NO, [url absoluteString], [NSError errorWithDomain:NSURLErrorDomain code:404 userInfo:nil]);
        }
    });
}

@end

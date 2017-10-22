//
//  JCImageCache.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCImageCache.h"
#import "CommonUtils.h"

static char *queueName = "IOQueueName";

@interface JCImageCache () {
    // IO queue
    dispatch_queue_t _queue;
}

@property (nonatomic, strong) NSCache *memoryCache;

@end

@implementation JCImageCache

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
}

+ (JCImageCache *)sharedImageCache {
    static JCImageCache *imageCach = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCach = [[JCImageCache alloc] init];
    });
    return imageCach;
}

- (id)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
        _memoryCache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemoryCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];

    }
    return self;
}

- (void)readDataFromCache:(NSURL *)imageURL completed:(void (^)(NSData *))completedBlock {
    // read from memory
    NSData *memoryData = [self.memoryCache objectForKey:[imageURL absoluteString]];
    if (memoryData) {
        if (completedBlock) {
            completedBlock(memoryData);
        }
        return;
    }
    
    // read from disk
    __weak JCImageCache *weakSelf = self;
    dispatch_async(_queue, ^{
        NSString *filePaht = [weakSelf filePathFromImageURL:imageURL];
        NSData *diskData = [[NSFileManager defaultManager] contentsAtPath:filePaht];
        if (diskData) {
            // save to memory
            [weakSelf.memoryCache setObject:diskData forKey:[imageURL absoluteString]];
        }
        if (completedBlock) {
            completedBlock(diskData);
        }
    });
}

- (void)saveImageData:(NSData *)data imageURL:(NSURL *)imageURL {
    // save to memory
    [self.memoryCache setObject:data forKey:[imageURL absoluteString]];
    
    // save to disk
    __weak JCImageCache *weakSelf = self;
    dispatch_async(_queue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *filePath = [weakSelf filePathFromImageURL:imageURL];
        if ([fileManager fileExistsAtPath:filePath]) {
            // remove the old file
            [fileManager removeItemAtPath:filePath error:NULL];
        }
        
        // write
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
    });
}

- (void)clearMemoryCache {
    [self.memoryCache removeAllObjects];
}

- (void)clearDiskCache {
    __weak JCImageCache *weakSelf = self;
    dispatch_async(_queue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fileDirectory = [weakSelf getImageDirectory];
        [fileManager removeItemAtPath:fileDirectory error:NULL];
    });
}

#pragma mark File

- (NSString *)filePathFromImageURL:(NSURL *)imageURL {
    NSString *urlMD5Value = [CommonUtils MD5:[imageURL absoluteString]];
    return [[self getImageDirectory] stringByAppendingPathComponent:urlMD5Value];
}

- (NSString *)getImageDirectory {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imagePath = [cachePath stringByAppendingPathComponent:@"jcImages"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:imagePath]) {
        // create image directory
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imagePath;
}

@end

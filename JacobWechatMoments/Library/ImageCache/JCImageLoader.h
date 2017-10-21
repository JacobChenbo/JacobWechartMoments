//
//  JCImageLoader.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JCImageDataLoadFinishBlock)(NSData *imageData, BOOL finished, NSString *imageURL, NSError *error);

@interface JCImageLoader : NSObject

- (void)loadImageDataWithURL:(NSString *)url completed:(JCImageDataLoadFinishBlock)completedBlock;

@end

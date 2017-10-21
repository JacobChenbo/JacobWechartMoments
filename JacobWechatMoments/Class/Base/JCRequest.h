//
//  JCRequest.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/20.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface JCRequest : YTKRequest

/**
 Request success callback
 */
@property (nonatomic, copy) void (^successJCCompletionBlock)(id responseObject);
/**
 Request failure callback
 */
@property (nonatomic, copy) void (^failureJCCompletionBlock)(id responseObject);

@end

//
//  JCGetTweetsRequest.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCGetTweetsRequest.h"

@implementation JCGetTweetsRequest

- (NSString *)requestUrl {
    return @"user/jsmith/tweets";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{};
}

@end

//
//  JCRequest.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/20.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCRequest.h"

@implementation JCRequest

- (id)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    __weak JCRequest *weakSelf = self;
    self.successCompletionBlock = ^(YTKBaseRequest *request) {
        __strong JCRequest *strongSelf = weakSelf;
        
        id responseObject = request.responseObject;
        
        if (strongSelf.successJCCompletionBlock) {
            strongSelf.successJCCompletionBlock(responseObject);
        }
    };
    
    self.failureCompletionBlock = ^(YTKBaseRequest *request) {
        __strong JCRequest *strongSelf = weakSelf;
        
        id responseObject = request.responseObject;
        
        if (strongSelf.failureJCCompletionBlock) {
            strongSelf.failureJCCompletionBlock(responseObject);
        }
    };
}

- (void)start {
    [super start];
}

- (NSString *)baseUrl {
    return @"http://thoughtworks-ios.herokuapp.com/";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end

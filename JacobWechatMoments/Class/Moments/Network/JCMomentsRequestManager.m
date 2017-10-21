//
//  JCMomentsRequestManager.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCMomentsRequestManager.h"
#import "JCGetUserRequest.h"
#import "JCGetTweetsRequest.h"

@implementation JCMomentsRequestManager

- (id)init {
    if (self = [super init]) {
        [self getUserRequest];
        [self getTweetsRequest];
    }
    return self;
}

- (void)getUserRequest {
    JCGetUserRequest *request = [[JCGetUserRequest alloc] init];
    [request start];
    
    [request setSuccessJCCompletionBlock:^(id response) {
        
    }];
    [request setFailureJCCompletionBlock:^(id response) {
        
    }];
}

- (void)getTweetsRequest {
    JCGetTweetsRequest *request = [[JCGetTweetsRequest alloc] init];
    [request start];

    [request setSuccessJCCompletionBlock:^(id response) {
        
    }];
    [request setFailureJCCompletionBlock:^(id response) {
        
    }];
}

@end

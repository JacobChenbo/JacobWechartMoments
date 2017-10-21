//
//  JCMomentsViewModel.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCMomentsViewModel.h"
#import "JCGetUserRequest.h"
#import "JCGetTweetsRequest.h"
#import "JCSingleTweetModel.h"

@interface JCMomentsViewModel ()

@property (nonatomic, strong) JCUserInfoModel *userInfoModel;

/**
 Cache all tweets
 */
@property (nonatomic, strong) NSMutableArray *tweetsList;

@end

@implementation JCMomentsViewModel

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
    
    __weak JCMomentsViewModel *weakSelf = self;
    [request setSuccessJCCompletionBlock:^(id response) {
        JCUserInfoModel *userInfoModel = nil;
        if ([response isKindOfClass:[NSDictionary class]]) {
            userInfoModel = [JCUserInfoModel mj_objectWithKeyValues:response];
        }
        if (weakSelf.userInfoCallback) {
            weakSelf.userInfoCallback(userInfoModel);
        }
    }];
    [request setFailureJCCompletionBlock:^(id response) {
        
    }];
}

- (void)getTweetsRequest {
    JCGetTweetsRequest *request = [[JCGetTweetsRequest alloc] init];
    [request start];
    
    __weak JCMomentsViewModel *weakSelf = self;
    [request setSuccessJCCompletionBlock:^(id response) {
        if ([response isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictionary in response) {
                JCSingleTweetModel *singleTweetModel = [JCSingleTweetModel mj_objectWithKeyValues:dictionary];
                // ignore the tweet which does not contain a content and images
                if (singleTweetModel.images.count == 0 && singleTweetModel.content.length == 0) {
                    continue;
                }
                [weakSelf.tweetsList addObject:singleTweetModel];
            }
        }
    }];
    [request setFailureJCCompletionBlock:^(id response) {
        
    }];
}

#pragma mark Get

- (NSMutableArray *)tweetsList {
    if (_tweetsList == nil) {
        _tweetsList = [[NSMutableArray alloc] init];
    }
    return _tweetsList;
}

@end

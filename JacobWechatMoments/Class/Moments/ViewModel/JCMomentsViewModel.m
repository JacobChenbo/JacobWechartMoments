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
        // Load all tweets in memory at first time
        [self getTweetsRequest];
    }
    return self;
}

#pragma mark Network method

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
        
        if (weakSelf.loadAllTweetsFinishedCallback) {
            weakSelf.loadAllTweetsFinishedCallback();
        }
    }];
    [request setFailureJCCompletionBlock:^(id response) {
        
    }];
}

#pragma mark public method

- (NSArray *)getTweetsDataByPage:(NSInteger)page pageSize:(NSInteger)pageSize {
    NSArray *result = [[NSArray alloc] init];
    if (self.tweetsList.count == 0) {
        return result;
    }
    
    NSInteger tweetsCount = self.tweetsList.count;
    NSInteger startNumber = (page - 1) * pageSize;
    NSInteger endNumber = page * pageSize;
    
    if (startNumber >= tweetsCount) {
        // startNumber >= tweetsCount, endNumbeer > tweetsCount, empty
    } else if (endNumber > tweetsCount) {
        // startNumber < tweetsCount, endNumber > tweetsCount,
        result = [self.tweetsList subarrayWithRange:NSMakeRange(startNumber, tweetsCount - startNumber)];
    } else {
        // startNumber < tweetsCount, endNumber < tweetsCount
        result = [self.tweetsList subarrayWithRange:NSMakeRange(startNumber, endNumber - startNumber)];
    }
    
    return result;
}

#pragma mark Get

- (NSMutableArray *)tweetsList {
    if (_tweetsList == nil) {
        _tweetsList = [[NSMutableArray alloc] init];
    }
    return _tweetsList;
}

@end

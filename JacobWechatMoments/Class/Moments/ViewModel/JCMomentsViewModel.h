//
//  JCMomentsViewModel.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCUserInfoModel.h"

@interface JCMomentsViewModel : NSObject

@property (nonatomic, copy) void (^userInfoCallback)(JCUserInfoModel *);
@property (nonatomic, copy) void (^loadAllTweetsFinishedCallback)(void);

- (NSArray *)getTweetsDataByPage:(NSInteger)page pageSize:(NSInteger)pageSize;

@end

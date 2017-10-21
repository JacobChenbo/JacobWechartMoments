//
//  JCTweetsListModel.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCSingleTweetModel.h"

@implementation JCSingleTweetModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"images" : [JCMomentsImageModel class],
             @"comments" : [JCMomentsCommentModel class]
             };
}

@end

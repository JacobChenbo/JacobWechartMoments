//
//  JCTweetsListModel.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMomentsSenderModel.h"
#import "JCMomentsImageModel.h"
#import "JCMomentsCommentModel.h"

@interface JCSingleTweetModel : NSObject

/**
 The content
 */
@property (nonatomic, copy) NSString *content;

/**
 Show pictures
 */
@property (nonatomic, strong) NSArray *images;

/**
 The sender
 */
@property (nonatomic, strong) JCMomentsSenderModel *sender;

/**
 All comments
 */
@property (nonatomic, strong) NSArray *comments;

@end

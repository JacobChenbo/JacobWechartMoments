//
//  JCMomentsCommentModel.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMomentsSenderModel.h"

@interface JCMomentsCommentModel : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) JCMomentsSenderModel *sender;

@end

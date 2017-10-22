//
//  JCMomentsTableViewCell.h
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/22.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSingleTweetModel.h"

#define kHorizontalPadding      10
#define kVerticalPadding        8

@interface JCMomentsTableViewCell : UITableViewCell

@property (nonatomic, strong) JCSingleTweetModel *tweetModel;

+ (JCMomentsTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end

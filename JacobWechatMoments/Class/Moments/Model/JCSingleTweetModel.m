//
//  JCTweetsListModel.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCSingleTweetModel.h"
#import "JCMomentsTableViewCell.h"

@implementation JCSingleTweetModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"images" : [JCMomentsImageModel class],
             @"comments" : [JCMomentsCommentModel class]
             };
}

#pragma mark Get method

- (CGFloat)tweetHeight {
    CGFloat result = 0;
    result += 15;   // top padding
    result += 17;   // userName height
    result += kVerticalPadding;    // userName below padding
    
    if (self.content.length > 0) {
        CGSize contentSize = multilineTextSize(self.content, [UIFont systemFontOfSize:14], CGSizeMake(kScreenWidth - 40 - 2 * kHorizontalPadding - 30, MAXFLOAT));
        result += contentSize.height;   // content height
        result += kVerticalPadding;     // content below padding
    }
    
    if (self.images.count > 0) {
        result += self.imagesListHeight;     // images height
        result += kVerticalPadding;     // images below padding
    }
    
    result += 14.5; // time label height
    
    result += 15; // bottom padding
    
    if (self.comments.count > 0) {
        result += kVerticalPadding;
        result += self.commentsListHeight; // comments height
    }
    
    return result;
}

- (CGFloat)imagesListHeight {
    if (self.images.count == 0) {
        return 0;
    }
    
    CGFloat padding = 5;
    CGFloat imagesListViewWidth = kScreenWidth - 40 - 2 * kHorizontalPadding - 80;
    CGFloat singleImageViewWidth = (imagesListViewWidth - 2 * padding) / 3.0;
    
    NSInteger rows = self.images.count / 3 + (self.images.count % 3 > 0 ? 1 : 0);
    
    return singleImageViewWidth * rows + (rows - 1) * padding;
}

- (CGFloat)commentsListHeight {
    if (self.comments.count == 0) {
        return 0;
    }
    
    CGFloat result = 0;
    result += 10;
    for (JCMomentsCommentModel *model in self.comments) {
        NSString *text = [NSString stringWithFormat:@"%@: %@", model.sender.username, model.content];

        CGSize size = multilineTextSize(text, [UIFont systemFontOfSize:13], CGSizeMake(kScreenWidth - 70 - 16, MAXFLOAT));
        result += size.height;
    }
    result += (self.comments.count - 1) * 8;
    result += 8;
    
    return result;
}

@end

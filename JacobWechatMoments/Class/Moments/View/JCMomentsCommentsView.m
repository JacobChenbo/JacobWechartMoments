//
//  JCMomentsCommentsView.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/22.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCMomentsCommentsView.h"

@implementation JCMomentsCommentsView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, UIColorFromRGB(0xEEEEEE).CGColor);
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0xEEEEEE).CGColor);

    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 6);
    CGContextAddLineToPoint(context, 8, 6);
    CGContextAddLineToPoint(context, 13, 0);
    CGContextAddLineToPoint(context, 18, 6);
    CGContextAddLineToPoint(context, viewWidth, 6);

    CGContextAddLineToPoint(context, viewWidth, viewHeight);
    CGContextAddLineToPoint(context, 0, viewHeight);
    CGContextAddLineToPoint(context, 0, 6);

    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)setComments:(NSArray *)comments {
    _comments = comments;
    
    // clear first
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setNeedsDisplay];
    
    UIView *lastView = nil;
    for (JCMomentsCommentModel *model in comments) {
        NSString *text = [NSString stringWithFormat:@"%@: %@", model.sender.username, model.content];
        
        UILabel *commentLabel = [UILabel new];
        [self addSubview:commentLabel];
        [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commentLabel.superview).offset(8);
            make.right.equalTo(commentLabel.superview).offset(-8);
            if (lastView == nil) {
                make.top.equalTo(commentLabel.superview).offset(10);
            } else {
                make.top.equalTo(lastView.mas_bottom).offset(8);
            }
        }];
        commentLabel.textColor = [UIColor blackColor];
        commentLabel.font = [UIFont systemFontOfSize:13];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
        [attributeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x8F9DB1) range:[text rangeOfString:[NSString stringWithFormat:@"%@: ", model.sender.username]]];
        commentLabel.attributedText = attributeString;

        
        lastView = commentLabel;
    }
}

@end

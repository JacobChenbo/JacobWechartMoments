//
//  JCMomentsTableViewCell.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/22.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCMomentsTableViewCell.h"
#import "JCMomentsCommentsView.h"
#import "JCPhotoBrowserSlideView.h"

@interface JCMomentsTableViewCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *senderNameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *imagesListView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) JCMomentsCommentsView *commentsView;

// the 9 empty imageviews
@property (nonatomic, strong) NSMutableArray *emptyImageViews;

@end

@implementation JCMomentsTableViewCell

+ (JCMomentsTableViewCell *)cellWithTableView:(UITableView *)tableView {
    static NSString *identifier = @"JCMomentsTableViewCell";
    JCMomentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JCMomentsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *avatarImageView = [UIImageView new];
    [self.contentView addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImageView.superview).offset(kHorizontalPadding);
        make.top.equalTo(avatarImageView.superview).offset(15);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    avatarImageView.backgroundColor = UIColorFromRGB(0xDDDDDD);
    self.avatarImageView = avatarImageView;
    
    UILabel *senderNameLabel = [UILabel new];
    [self.contentView addSubview:senderNameLabel];
    [senderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(avatarImageView.mas_right).offset(kHorizontalPadding);
        make.top.equalTo(senderNameLabel.superview).offset(15);
        make.right.equalTo(senderNameLabel.superview).offset(-30);
    }];
    senderNameLabel.textColor = UIColorFromRGB(0x8F9DB1);
    senderNameLabel.font = [UIFont boldSystemFontOfSize:14];
    self.senderNameLabel = senderNameLabel;
    
    UILabel *contentLabel = [UILabel new];
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(senderNameLabel);
        make.right.equalTo(contentLabel.superview).offset(-30);
        make.top.equalTo(senderNameLabel.mas_bottom).offset(kVerticalPadding);
    }];
    contentLabel.textColor = [UIColor blackColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.clipsToBounds = YES;
    self.contentLabel = contentLabel;
    
    UIView *imagesListView = [UIView new];
    [self.contentView addSubview:imagesListView];
    [imagesListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(senderNameLabel);
        make.right.equalTo(imagesListView.superview).offset(-80);
        make.top.equalTo(contentLabel.mas_bottom).offset(kVerticalPadding);
        make.height.equalTo(imagesListView.mas_width);
    }];
    imagesListView.clipsToBounds = YES;
    self.imagesListView = imagesListView;
    [self createTempImageViews];
    
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(senderNameLabel);
        make.top.equalTo(imagesListView.mas_bottom).offset(kVerticalPadding);
    }];
    timeLabel.textColor = UIColorFromRGBA(0x000000, 0.4);
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.text = @"刚刚";
    self.timeLabel = timeLabel;
    
    UIButton *actionButton = [UIButton new];
    [self.contentView addSubview:actionButton];
    [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(actionButton.superview).offset(-kHorizontalPadding);
        make.centerY.equalTo(timeLabel);
        make.size.mas_equalTo(CGSizeMake(20, 15));
    }];
    actionButton.backgroundColor = UIColorFromRGB(0xDEDEDE);
    
    JCMomentsCommentsView *commentsView = [[JCMomentsCommentsView alloc] init];
    [self.contentView addSubview:commentsView];
    [commentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(senderNameLabel);
        make.right.equalTo(commentsView.superview).offset(-kHorizontalPadding);
        make.top.equalTo(timeLabel.mas_bottom).offset(kVerticalPadding);
        make.height.equalTo(@0);
    }];
    self.commentsView = commentsView;
    
    UIView *bottomLine = [UIView new];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomLine.superview);
        make.height.equalTo(@1);
    }];
    bottomLine.backgroundColor = UIColorFromRGB(0xd5d5d5);
}

/**
 Description when init the tableview cell, create all of empty imageviews for reused
 */
- (void)createTempImageViews {
    CGFloat padding = 5;
    // 3 x 3 = 9 temp imageviews
    UIView *lastTempView = nil;
    for (int row = 0; row < 3; row++) {
        for (int column = 0; column < 3; column++) {
            UIImageView *tempImageView = [UIImageView new];
            tempImageView.contentMode = UIViewContentModeScaleAspectFill;
            tempImageView.clipsToBounds = YES;
            [self.imagesListView addSubview:tempImageView];
            
            NSInteger index = row * 3 + column;
            [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.width.equalTo(self.imagesListView.mas_width).dividedBy(3).offset(-(padding * 2) / 3).priority(999);
                
                if (lastTempView == nil) {
                    make.left.top.equalTo(self.imagesListView);
                } else {
                    // the first column in the row
                    BOOL isFirstViewInRow = index % 3 == 0;
                    if (isFirstViewInRow) {
                        make.top.equalTo(lastTempView.mas_bottom).offset(padding);
                        make.left.equalTo(self.imagesListView);
                    }
                    else{
                        make.centerY.equalTo(lastTempView);
                        make.left.equalTo(lastTempView.mas_right).offset(padding);
                    }
                }
            }];
            
            [self.emptyImageViews addObject:tempImageView];
            lastTempView = tempImageView;
            
            // tap image action
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImage:)];
            [tempImageView addGestureRecognizer:tapGesture];
        }
    }
}

- (void)onTapImage:(UIGestureRecognizer *)gesture {
    UIImageView *imageView = (UIImageView *)gesture.view;
    
    NSInteger indexInEmptyImageViews = [self.emptyImageViews indexOfObject:imageView];
    NSInteger indexInTweetImages = indexInEmptyImageViews;
    if (self.tweetModel.images.count == 4) {
        // special index for 4
        if (indexInEmptyImageViews >= 2) {
            indexInTweetImages = indexInEmptyImageViews - 1;
        }
    }
    
    NSLog(@"tap index: %ld", indexInTweetImages);
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (JCMomentsImageModel *imageModel in self.tweetModel.images) {
        [tempArray addObject:imageModel.url];
    }
    
    JCPhotoBrowserSlideView *slideView = [[JCPhotoBrowserSlideView alloc] initWithImageUrlList:tempArray];
    slideView.pageIndex = indexInTweetImages;
    [slideView showSlideView];
}

#pragma mark Set value

- (void)setTweetModel:(JCSingleTweetModel *)tweetModel {
    _tweetModel = tweetModel;
    
    [self.avatarImageView setImageWithURL:tweetModel.sender.avatar placeholderImageName:@"placeholder"];
    self.senderNameLabel.text = tweetModel.sender.username;
    
    if (tweetModel.content.length > 0) {
        self.contentLabel.text = tweetModel.content;
        
        [self.imagesListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.senderNameLabel);
            make.right.equalTo(self.imagesListView.superview).offset(-80);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(9);
            make.height.equalTo(@(self.tweetModel.imagesListHeight));
        }];
    } else {
        self.contentLabel.text = nil;
        
        [self.imagesListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.senderNameLabel);
            make.right.equalTo(self.imagesListView.superview).offset(-80);
            make.top.equalTo(self.senderNameLabel.mas_bottom).offset(9);
            make.height.equalTo(@(self.tweetModel.imagesListHeight));
        }];
    }
    
    // clear the reused image data
    [self clearCachedImageData];

    if (tweetModel.images.count > 0) {
        [self setImagesData];
        
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imagesListView.mas_bottom).offset(kVerticalPadding);
        }];
    } else {
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imagesListView.mas_bottom).offset(0);
        }];
    }
    
    [self.commentsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(tweetModel.commentsListHeight));
    }];
    self.commentsView.comments = tweetModel.comments;
    
}

- (void)setImagesData {
    for (int i = 0; i < self.tweetModel.images.count; i++) {
        JCMomentsImageModel *imageModel = self.tweetModel.images[i];
        
        UIImageView *emptyImageView = [self.emptyImageViews objectAtIndex:i];
        if (self.tweetModel.images.count == 4) {
            // special for 4
            if (i >= 2) {
                emptyImageView = [self.emptyImageViews objectAtIndex:i + 1];
            }
        } else if (self.tweetModel.images.count == 1) {
            // special size for only 1
        }
        [emptyImageView setImageWithURL:imageModel.url placeholderImageName:@"placeholder"];
        emptyImageView.userInteractionEnabled = YES;
    }
}

- (void)clearCachedImageData {
    [self.emptyImageViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = (UIImageView *)obj;
        if (imageView.image) {
            imageView.image = nil;
            imageView.userInteractionEnabled = NO;
        }
    }];
}

#pragma mark Get

- (NSMutableArray *)emptyImageViews {
    if (_emptyImageViews == nil) {
        _emptyImageViews = [[NSMutableArray alloc] init];
    }
    return _emptyImageViews;
}

@end

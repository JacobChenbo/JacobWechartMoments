//
//  JCMomentsHeaderView.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/21.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCMomentsHeaderView.h"

@interface JCMomentsHeaderView ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *avatarImageView;

@end

@implementation JCMomentsHeaderView

- (id)init {
    if (self = [super init]) {
        CGFloat height = 0;
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            height = 250;
        } else {
            height = 300;
        }
        self.frame = CGRectMake(0, 0, kScreenWidth, height);
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *bgImage = [UIImageView new];
    [self addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgImage.superview);
        make.bottom.equalTo(bgImage.superview).offset(-40);
    }];
    bgImage.backgroundColor = UIColorFromRGB(0xDDDDDD);
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView = bgImage;
    
    UIImageView *avatarImageView = [UIImageView new];
    [self addSubview:avatarImageView];
    [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(avatarImageView.superview).offset(-10);
        make.bottom.equalTo(avatarImageView.superview).offset(-20);
        make.size.mas_equalTo(CGSizeMake(72, 72));
    }];
    avatarImageView.layer.borderColor = UIColorFromRGBA(0x000000, 0.3).CGColor;
    avatarImageView.layer.borderWidth = 0.5;
    self.avatarImageView = avatarImageView;
    
    UILabel *nameLabel = [UILabel new];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(avatarImageView.mas_left).offset(-18);
        make.bottom.equalTo(bgImage.mas_bottom);
        make.height.equalTo(@40);
        make.left.equalTo(nameLabel.superview).priority(999);
    }];
    nameLabel.textColor = UIColorFromRGB(0xFFFFFF);
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel = nameLabel;
}

- (void)setUserInfoModel:(JCUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    
    self.nameLabel.text = userInfoModel.nick;
    [self.avatarImageView setImageWithURL:userInfoModel.avatar placeholderImageName:@"placeholder"];
    [self.bgImageView setImageWithURL:userInfoModel.profileImage placeholderImageName:@""];
}

@end

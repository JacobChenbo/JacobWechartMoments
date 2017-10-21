//
//  JCMomentsViewController.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/20.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "JCMomentsViewController.h"
#import "JCMomentsViewModel.h"
#import "JCMomentsHeaderView.h"
#import "JCUserInfoModel.h"

@interface JCMomentsViewController ()

@property (nonatomic, strong) JCMomentsViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JCMomentsHeaderView *headerView;

@end

@implementation JCMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Wechat Moments";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupTableView];
    [self setupMomentsViewModel];
}

- (void)setupTableView {
    UITableView *tableView = [UITableView new];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableView.superview);
    }];
    tableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    JCMomentsHeaderView *headerView = [[JCMomentsHeaderView alloc] init];
    self.headerView = headerView;
    tableView.tableHeaderView = headerView;
    
    
}

- (void)setupMomentsViewModel {
    JCMomentsViewModel *viewModel = [[JCMomentsViewModel alloc] init];
    self.viewModel = viewModel;
    
    __weak JCMomentsViewController *weakSelf = self;
    [viewModel setUserInfoCallback:^(JCUserInfoModel *userInfoModel) {
        weakSelf.headerView.userInfoModel = userInfoModel;
    }];
}

@end

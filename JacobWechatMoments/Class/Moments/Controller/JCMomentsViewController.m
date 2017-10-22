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
#import "JCMomentsTableViewCell.h"
#import "JCSingleTweetModel.h"
#import <MJRefresh/MJRefresh.h>

@interface JCMomentsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JCMomentsViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JCMomentsHeaderView *headerView;

// UITableView's dataSource;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) BOOL loadingData;
@property (nonatomic, assign) BOOL needLoadMore;

@end

@implementation JCMomentsViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Wechat Moments";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.page = 1;
    self.pageSize = 5;
    self.loadingData = YES;
    self.needLoadMore = YES;
    
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
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];

    self.tableView = tableView;
}

- (void)setupMomentsViewModel {
    JCMomentsViewModel *viewModel = [[JCMomentsViewModel alloc] init];
    self.viewModel = viewModel;
    
    __weak JCMomentsViewController *weakSelf = self;
    // user request callback to update table header view
    [viewModel setUserInfoCallback:^(JCUserInfoModel *userInfoModel) {
        weakSelf.headerView.userInfoModel = userInfoModel;
    }];
    
    // tweets request finished, get data from it
    [viewModel setLoadAllTweetsFinishedCallback:^{
        // first page data
        [weakSelf getDataFromTweetsList];
    }];
}

- (void)refresh {
    self.page = 1;
    [self getDataFromTweetsList];
}

- (void)loadMore {
    self.loadingData = YES;
    self.page++;
    [self.tableView.mj_footer endRefreshing];

    [self getDataFromTweetsList];
}

- (void)getDataFromTweetsList {
    NSLog(@"page: %ld", self.page);
    NSArray *pageData = [self.viewModel getTweetsDataByPage:self.page pageSize:self.pageSize];
    if (self.page == 1) {
        [self.dataSource removeAllObjects];
        [self.tableView.mj_header endRefreshing];
    }
    
    if (pageData.count < self.pageSize) {
        self.needLoadMore = NO;
    } else {
        self.needLoadMore = YES;
    }
    
    [self.dataSource addObjectsFromArray:pageData];
    [self.tableView reloadData];
    // Wait tableview reload finish
    [self.tableView layoutIfNeeded];
    self.loadingData = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset > 20.0 && !self.loadingData && self.needLoadMore) {
        [self loadMore];
    }

}

#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCMomentsTableViewCell *cell = [JCMomentsTableViewCell cellWithTableView:tableView];
    JCSingleTweetModel *tweetModel = [self.dataSource objectAtIndex:indexPath.row];
    cell.tweetModel = tweetModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JCSingleTweetModel *tweetModel = [self.dataSource objectAtIndex:indexPath.row];
    
    return tweetModel.tweetHeight;
}

#pragma mark Get

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end

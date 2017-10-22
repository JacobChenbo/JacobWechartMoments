//
//  ViewController.m
//  JacobWechatMoments
//
//  Created by 陈波 on 2017/10/20.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "ViewController.h"
#import "JCMomentsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button.superview);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [button setTitle:@"Moments" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor lightGrayColor];
    button.titleLabel.textColor = [UIColor blackColor];
    [button addTarget:self action:@selector(onClickButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickButton {
    JCMomentsViewController *viewController = [[JCMomentsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

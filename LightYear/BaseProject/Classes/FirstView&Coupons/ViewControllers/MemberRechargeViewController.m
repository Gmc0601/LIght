//
//  MemberRechargeViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MemberRechargeViewController.h"
#import "RechargeInfoCell.h"
#import "WMTableView.h"

@interface MemberRechargeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;

@end

@implementation MemberRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"充值优惠";
    [self.view addSubview:self.tableV];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SizeHeigh(68);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"RechargeInfoCell";
    RechargeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RechargeInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell fillWithType:@""];
    return cell;
}

#pragma mark - lazyLoad
- (WMTableView *)tableV
{
    if (!_tableV) {
        _tableV = [[WMTableView alloc] initWithFrame:CGRectMake( 0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableV;
}

@end

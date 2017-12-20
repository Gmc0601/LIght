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
#import "RechargeListModel.h"

@interface MemberRechargeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, retain) UILabel *lab;
@end

@implementation MemberRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"充值优惠";
    [self.view addSubview:self.tableV];
    [self.view addSubview:self.lab];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rightBar removeFromSuperview];
    _dataArray = [NSMutableArray array];
    [self syncWithQueryList];
}

#pragma mark - Service
- (void)syncWithQueryList {
    [ConfigModel showHud:self];
    
    [HttpRequest postPath:rechargeListURL params:nil resultBlock:^(id responseObject, NSError *error) {
        
        RechargeListModel * model = [[RechargeListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            for (RechargeListInfo *info in model.info) {
                [_dataArray addObject:info];
            }
            [self.tableV reloadData];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
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
    RechargeListInfo *info = _dataArray[indexPath.row];
    [cell fillWithType:info];
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

- (UILabel *)lab {
    if (!_lab) {
        _lab = [[UILabel alloc] initWithFrame:FRAME(0, kScreenH - 50, kScreenW, 20)];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.font = NormalFont(12);
        _lab.textColor = UIColorFromHex(0x999999);
        _lab.text = @"请到附近的门店进行会员卡充值";
        _lab.backgroundColor = [UIColor clearColor];
    }
    return _lab;
}

@end

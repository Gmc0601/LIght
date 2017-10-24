//
//  SelectCouponViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "SelectCouponViewController.h"
#import "WMTableView.h"
#import "CouponDefaultCell.h"

@interface SelectCouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SelectCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"选择优惠券";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rightBar removeFromSuperview];
    _dataArray = [NSMutableArray array];
}

#pragma mark - Service
- (void)syncWithRequest {
    [ConfigModel showHud:self];
    NSDictionary *dic = @{
                          @"type":@"2",
                          @"amount":self.amount,
                          };
    [HttpRequest postPath:couponListURL params:dic resultBlock:^(id responseObject, NSError *error) {
        
        CouponListModel * model = [[CouponListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            for (CouponInfo *info in model.info) {
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
    return SizeHeigh(84);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponInfo *info = _dataArray[indexPath.row];
    static NSString *identifier = @"CouponDefaultCell";
    CouponDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CouponDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell fillWithModel:info WithExpire:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CouponInfo *info = _dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(callbackWithSelectCoupon:)]) {
        [self.delegate callbackWithSelectCoupon:info];
        [self.navigationController popViewControllerAnimated:YES];
    }
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

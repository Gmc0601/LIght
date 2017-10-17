//
//  InspectCouponViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "InspectCouponViewController.h"
#import "CouponDefaultCell.h"
#import "couponDetailsCell.h"
#import "WMTableView.h"
#import "ExpireCouponViewController.h"

@interface InspectCouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation InspectCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLab.text = @"优惠券";
    [self initRightBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.rightBar removeFromSuperview];
}

- (void)initRightBar {
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake( kScreenW - 10 - 40, 25, 40, 30)];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitle:@"过期券" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    leftBtn.titleLabel.font = SourceHanSansCNRegular(13);
    [leftBtn addTarget:self action:@selector(expireCoupon) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:leftBtn];
}

- (void)expireCoupon {
    ExpireCouponViewController *expireVC = [[ExpireCouponViewController alloc] init];
    [self.navigationController pushViewController:expireVC animated:YES];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SizeHeigh(68);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (1) {
        static NSString *identifier = @"CouponDefaultCell";
        CouponDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[CouponDefaultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell fillWith:NO];
        return cell;
    } else {
        static NSString *identifier = @"couponDetailsCell";
        couponDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[couponDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell fillWith:NO];
        return cell;
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

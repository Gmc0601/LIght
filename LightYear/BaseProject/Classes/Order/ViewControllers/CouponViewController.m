//
//  CouponViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CouponViewController.h"
#import "CouponTableViewCell.h"

@interface CouponViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetFahter];
    
    [self createview];
}

- (void)resetFahter {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"选择优惠券";
}

- (void)createview {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"coupon";
    
    CouponTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[CouponTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(85);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        [_noUseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            view;
        });
    }
    return _noUseTableView;
}


@end

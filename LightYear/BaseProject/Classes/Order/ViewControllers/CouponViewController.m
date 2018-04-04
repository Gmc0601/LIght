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
@property (nonatomic, retain) NSArray *couponArr;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetFahter];
    
    [self createview];
    
    NSDictionary *couDic = @{
                             @"type" : @"1",
                             @"amount" : self.amout,
                             @"ctype" : @"1"
                             };
    
    [HttpRequest postPath:@"_coupon_list_001" params:couDic resultBlock:^(id responseObject, NSError *error) {
        if([error isEqual:[NSNull null]] || error == nil){
            NSLog(@"success");
        }
        NSDictionary *datadic = responseObject;
        if ([datadic[@"error"] intValue] == 0) {
            self.couponArr = datadic[@"info"];
            [self.noUseTableView reloadData];
        }else {
            NSString *str = datadic[@"info"];
            [ConfigModel mbProgressHUD:str andView:nil];
        }
    }];
}

- (void)resetFahter {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"选择优惠券";
}

- (void)createview {
    [self.view addSubview:self.noUseTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.couponArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"coupon";
    
    CouponTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[CouponTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSDictionary *dic = self.couponArr[indexPath.row];
    NSString *money = dic[@"condition"];
    cell.couponLab.text = money;
    
    return cell;
    
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SizeHeigh(85);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.couponArr[indexPath.row];
    NSString *idStr = dic[@"id"];
    NSString *cutMoney = dic[@"denomination"];
    if (self.couponBlock) {
        self.couponBlock(idStr, cutMoney);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.height, kScreenW, kScreenH - self.height) style:UITableViewStylePlain];
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

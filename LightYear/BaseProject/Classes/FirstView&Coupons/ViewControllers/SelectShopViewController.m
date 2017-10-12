//
//  SelectShopViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "SelectShopViewController.h"
#import "WMTableView.h"
#import "SelectShopCell.h"

@interface SelectShopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;

@end

@implementation SelectShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightBar removeFromSuperview];
    self.titleLab.text = @"选择门店";
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
    static NSString *identifier = @"SelectShopCell";
    SelectShopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SelectShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell fillWithData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(callbackWithSelectShop:code:)]) {
        [self.delegate callbackWithSelectShop:@"浙江商店" code:@"adfa"];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

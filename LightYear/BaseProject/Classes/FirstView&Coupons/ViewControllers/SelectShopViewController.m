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
#import "ShopListModel.h"

@interface SelectShopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMTableView *tableV;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SelectShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightBar removeFromSuperview];
    self.titleLab.text = @"选择门店";
    [self.view addSubview:self.tableV];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _dataArray = [NSMutableArray array];
    [self syncWithShopListRequest];
}

#pragma mark - Service
- (void)syncWithShopListRequest {
    [ConfigModel showHud:self];
    NSDictionary *dic = @{
//                        @"lng": [NSString stringWithFormat:@"%f",_currentLocation.coordinate.longitude],
//                        @"lat": [NSString stringWithFormat:@"%f",_currentLocation.coordinate.latitude],
                          @"lng": @"112.587329",
                          @"lat": @"26.885513",
                       };
    [HttpRequest postPath:shoplistURL params:dic resultBlock:^(id responseObject, NSError *error) {
        
        ShopListModel * model = [[ShopListModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            [_dataArray addObjectsFromArray:model.info];
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
    static NSString *identifier = @"SelectShopCell";
    SelectShopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SelectShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell fillWithData:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopListInfo *info = _dataArray[indexPath.row];
    [[TMCache sharedCache] setObject:info.aid forKey:kShopInfo];
    if (self.delegate && [self.delegate respondsToSelector:@selector(callbackWithSelectShop:code:)]) {
        [self.delegate callbackWithSelectShop:info.shopname code:info.aid];
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

//
//  FirstLevelGoodsViewController.m
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsCategory.h"
#import "GoodDetialViewController.h"
#import "GoodsModel.h"
#import "GoodsCell.h"

#define TAG 100

@interface GoodsListViewController () <UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tb;
    NSString *_cellIdentifier;
    NSMutableArray *_dataSource;
}

@end

@implementation GoodsListViewController
@synthesize categry = _categry;
-(void) setCategry:(GoodsCategory *)categry{
    _categry = categry;
    self.titleLab.text = _categry.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mockData];
    [self addFavoriteButton];
    [self addTableView];
}

-(void) mockData{
    _dataSource = [NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        GoodsModel *model = [GoodsModel new];
        model._id = @"1";
        model.name = @"小龙虾";
        model.canTakeBySelf = YES;
        model.hasDiscounts = YES;
        model.canDelivery = NO;
        model.isNew = NO;
        model.price = @"111";
        model.memberPrice = @"1";
        [_dataSource addObject:model];
    }
}

-(void) addTableView{
    _cellIdentifier = @"cell";
    _tb = [[UITableView alloc] init];
    _tb.rowHeight = SizeHeigh(161);
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:_cellIdentifier];
    _tb.tableFooterView = [UIView new];
    
    [self.view addSubview:_tb];
    
    [_tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
        if ([self hasBottomView]) {
            make.bottom.equalTo(self.bottomView.mas_top);
        }else{
            make.bottom.equalTo(self.view);
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    cell.model = _dataSource[indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodDetialViewController *newVC = [GoodDetialViewController new];
   
    [self.navigationController pushViewController:newVC animated:YES];
}


@end

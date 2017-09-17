//
//  GoodsListView.m
//  BaseProject
//
//  Created by LeoGeng on 14/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "GoodsListView.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import "TBRefresh.h"

@interface GoodsListView ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_cellIdentifier;
}
@property(retain,atomic)     UITableView *tb;
@end
@implementation GoodsListView

@synthesize datasource = _dataSource;
-(void) setDatasource:(NSMutableArray *)datasource{
    _dataSource = datasource;
    [_tb reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTableView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTableView];
//        [self mockData];
    }
    return self;
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
    
    [_tb reloadData];
}

-(void) addTableView{
    _cellIdentifier = @"cell";
    _tb = [[UITableView alloc] init];
    _tb.rowHeight = SizeHeigh(161);
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.allowsSelection = YES;
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:_cellIdentifier];
    _tb.tableFooterView = [UIView new];
    
    [self addSubview:_tb];
    
    [_tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    __weak GoodsListView *weakSelf = self;

    [_tb addRefreshHeaderWithBlock:^{
        [weakSelf.tb.header endHeadRefresh];
    }];
    
    [_tb addRefreshFootWithBlock:^{
        [weakSelf.tb.footer endFooterRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    cell.model = _dataSource[indexPath.row];
    cell.isFavorite = self.isFavorite;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsModel *model = (GoodsModel *) _dataSource[indexPath.row];
    [self.delegate didSelectGoods:model._id];
}
@end

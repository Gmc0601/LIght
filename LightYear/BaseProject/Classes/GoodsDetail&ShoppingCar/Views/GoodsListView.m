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
#import "NetHelper.h"
#import <TMCache/TMCache.h>

@interface GoodsListView ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_cellIdentifier;
    int pageIndex;
}
@property(retain,atomic)     UITableView *tb;
@property(retain,atomic)     NSMutableArray *datasource;
@end
@implementation GoodsListView

@synthesize goodsType = _goodsType;
-(void) setGoodsType:(NSString *)goodsType{
    _goodsType = goodsType;
    [_tb.header beginRefreshing];
}

@synthesize isFavorite = _isFavorite;
-(void) setIsFavorite:(BOOL)isFavorite{
    _isFavorite = isFavorite;
    [_tb.header beginRefreshing];
}

-(void) reloadData{
    [_tb.header beginRefreshing ];
}

-(void) fetchDate{
    [ConfigModel showHud:_owner];
    
    if (_isFavorite) {
        NSString *shopId = [[TMCache sharedCache] objectForKey:kShopInfo];
        [NetHelper getFavoriteListWithShopId:shopId withPage:pageIndex callBack:^(NSString *error, NSArray *data) {
            [ConfigModel hideHud:_owner];
            if (error != nil) {
                [ConfigModel mbProgressHUD:error andView:_owner.view];
            }else{
                if(data != nil && data.count > 0){
                    if (pageIndex == 1) {
                        _datasource = [NSMutableArray arrayWithCapacity:0];
                    }
                    [_datasource addObjectsFromArray:data];

                    [_tb reloadData];
                }
            }
        }];
    }else{
        NSString *shopId = [[TMCache sharedCache] objectForKey:kShopInfo];
        [NetHelper getGoodsListWithId:_goodsType withShopId:shopId withPage:pageIndex callBack:^(NSString *error, NSArray *data) {
            [ConfigModel hideHud:_owner];
            if (error != nil) {
                [ConfigModel mbProgressHUD:error andView:_owner.view];
            }else{
                if(data != nil && data.count > 0){
                    if (pageIndex == 1) {
                        _datasource = [NSMutableArray arrayWithCapacity:0];
                    }
                    [_datasource addObjectsFromArray:data];
                    [_tb reloadData];
                }
            }
        }];
    }
}

- (instancetype)init:(UIViewController *) owner
{
    self = [super init];
    if (self) {
        _owner = owner;
//        [self addTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTableView];
    }
    return self;
}

-(void) addTableView{
    _datasource = [NSMutableArray arrayWithCapacity:0];
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
        pageIndex = 1;
        [weakSelf fetchDate];
        [weakSelf.tb.header endHeadRefresh];
    }];
    
    [_tb addRefreshFootWithBlock:^{
        pageIndex++;
        [weakSelf fetchDate];
        [weakSelf.tb.footer endFooterRefreshing];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    cell.model = _datasource[indexPath.row];
    cell.isFavorite = self.isFavorite;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GoodsModel *model = (GoodsModel *) _datasource[indexPath.row];
    if (model.outOfStack) {
        return;
    }
    [self.delegate didSelectGoods:model._id];
}
@end

//
//  GoodsListView.m
//  BaseProject
//
//  Created by LeoGeng on 14/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "SearchListView.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import "TBRefresh.h"
#import "NetHelper.h"

@interface SearchListView ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *_cellIdentifier;
    int pageIndex;
}
@property(retain,atomic)     UIViewController *owner;
@end
@implementation SearchListView

-(void) fetchDate{
    [self.delegate reloadData:self PageIndex:pageIndex];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTableView];
    }
    return self;
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
    pageIndex = 1;
    [self addSubview:_tb];
    
    [_tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    __weak SearchListView *weakSelf = self;
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

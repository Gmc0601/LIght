//
//  FirstLevelGoodsViewController.m
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "SecondLevelGoodsViewController.h"
#import "GoodsCategory.h"
#import "GoodsListViewController.h"

#define TAG 100

@interface SecondLevelGoodsViewController () <UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tb;
    NSString *_cellIdentifier;
    NSMutableArray *_dataSource;
}

@end

@implementation SecondLevelGoodsViewController
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
        GoodsCategory *c = [GoodsCategory new];
        c._id = @"1";
        c.text = @"二级级目录";
        [_dataSource addObject:c];
    }
}

-(void) addTableView{
    _cellIdentifier = @"cell";
    _tb = [[UITableView alloc] init];
    _tb.rowHeight = SizeHeigh(66);
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tb registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsListViewController *newVC = [GoodsListViewController new];
    newVC.categry = _dataSource[indexPath.row];
    [self.navigationController pushViewController:newVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    UILabel *lbl = [cell viewWithTag:TAG + indexPath.row];
    if (lbl == nil) {
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f2"];
        lbl = [self getTitleLableWithIndex:indexPath.row];
        [cell addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(SizeWidth(15));
            make.right.equalTo(cell);
            make.top.equalTo(cell);
            make.bottom.equalTo(cell);
        }];
    }
    
    lbl.text = ((GoodsCategory *) _dataSource[indexPath.row]).text;
    
    return cell;
}

-(UILabel *) getTitleLableWithIndex:(NSInteger) index{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(17));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.tag = TAG + index;
    
    return lblTitle;
}
@end
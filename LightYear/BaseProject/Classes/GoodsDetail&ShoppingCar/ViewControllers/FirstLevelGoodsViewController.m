//
//  FirstLevelGoodsViewController.m
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "FirstLevelGoodsViewController.h"

#define tag 100

@interface FirstLevelGoodsViewController () <UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tb;
    NSString *_cellIdentifier;
    NSMutableArray *_dataSource;
}

@end

@implementation FirstLevelGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray arrayWithCapacity:0];
    [self addFavoriteButton];
    [self addSearchButton];
}

-(void) addTableView{
    _cellIdentifier = @"cell";
    _tb = [[UITableView alloc] init];
    _tb.rowHeight = SizeHeigh(66);
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    _tb.tableFooterView = [UIView new];
    [self.view addSubview:_tb];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    return cell;
}

-(void) addTitleLableTo:(UITableViewCell *)cell{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(17));
//    lblTitle.textColor = [UIColor colo]
    
}

-(void) addSearchButton{
    self.titleLab.text = @"输入商品名称";
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nav_ss"]];
    [self.navigationView addSubview:imgView];

    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.right.equalTo(self.titleLab.mas_left).offset(SizeWidth(10));
        make.height.equalTo(@(CGRectGetHeight(self.titleLab.bounds)/2));
        make.width.equalTo(@(CGRectGetHeight(self.titleLab.bounds)/2));
    }];
}

@end

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
#import "GoodsListView.h"
#import "GoodsModel.h"

#define TAG 100

@interface GoodsListViewController (){
    GoodsListView *_list;
    NSMutableArray *_dataSource;
}

@end

@implementation GoodsListViewController
@synthesize categry = _categry;
-(void) setCategry:(GoodsCategory *)categry{
    if (_list == nil) {
        [self addTableView];
    }
    _categry = categry;
    self.titleLab.text = _categry.text;
    _list.goodsType = _categry._id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFavoriteButton];
    [self addBottomView];
}

-(void) addTableView{
    _list = [[GoodsListView alloc] init:self];
    _list.delegate = self;
    [self.view addSubview:_list];
    
    [_list mas_makeConstraints:^(MASConstraintMaker *make) {
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

@end

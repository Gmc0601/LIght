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
    _categry = categry;
    self.titleLab.text = _categry.text;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addFavoriteButton];
    [self addBottomView];
    [self addTableView];
    [self mockData];
}

-(void) mockData{
    _dataSource = [NSMutableArray arrayWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        GoodsModel *model = [GoodsModel new];
        model._id = @"1";
        model.name = @"小龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾龙虾";
        model.canTakeBySelf = YES;
        model.hasDiscounts = YES;
        model.price = @"111";
        if (i%2 == 0) {
            model.memberPrice = @"1";
        }
        
        if (i%3 == 0) {
            model.isNew = YES;
        }
        
        if (i%4 == 0) {
            model.canDelivery = YES;
        }
        [_dataSource addObject:model];
    }
    
    _list.datasource = _dataSource;
}

-(void) addTableView{
    _list = [GoodsListView new];
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

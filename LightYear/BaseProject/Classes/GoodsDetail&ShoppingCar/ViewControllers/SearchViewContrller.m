//
//  SearchViewContrller.m
//  BaseProject
//
//  Created by LeoGeng on 15/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "SearchViewContrller.h"
#import "HistoryTableView.h"
#import "SearchResultView.h"
#import "GoodDetialViewController.h"
#import "GoodsModel.h"

@interface SearchViewContrller()<SearchBarViewDelegate
,HistoryTableViewDelegate,SearchResultViewDelegate>{
    NSString *historyKey;
}
@property(retain,atomic) HistoryTableView *initialView;
@property(retain,atomic) SearchResultView *searchResult;
@end

@implementation SearchViewContrller
-(void) viewDidLoad{
    historyKey = @"search_history";
    [super viewDidLoad];
    [self addSearchButton];
    self.searchBar.delegate = self;
    [self addInitialView];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadSearchResultView];
}

-(void) addInitialView{
    _initialView = [HistoryTableView new];
    [self.view addSubview:_initialView];
    NSArray *history = [ConfigModel getArrforKey:historyKey];
    _initialView.datasource = history;
    _initialView.delegate = self;
    _initialView.ownerVC = self;
    
    [_initialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

-(void) didSearch:(NSString *)keyworkd{
    NSMutableArray *history = [ConfigModel getArrforKey:historyKey];
    [history removeObject:keyworkd];
    [history insertObject:keyworkd atIndex:0];
    if (history.count > 10) {
        [history removeLastObject];
    }
    
    [ConfigModel saveArr:history forKey:historyKey];
    
    if (_searchResult== nil) {
        
        _searchResult = [SearchResultView new];
        _searchResult.delegate = self;
        [self.view addSubview:_searchResult];
        
        [_searchResult mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navigationView.mas_bottom);
            make.right.equalTo(self.view);
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    
    [self reloadSearchResultView];
}

-(void) didSelect:(NSString *)keyworkd{
    self.searchBar.keyword = keyworkd;
}

-(void) didClearKeyword{
    [_searchResult removeFromSuperview];
    _searchResult = nil;
    NSArray *history = [ConfigModel getArrforKey:historyKey];
    _initialView.datasource = history;
}

-(void) gotoFirstCategory{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSMutableArray *) mockData{
    NSMutableArray *datasource = [NSMutableArray arrayWithCapacity:10];
    
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
        [datasource addObject:model];
    }
    
    return datasource;
}

-(void) reloadSearchResultView{
    if (_searchResult == nil) {
        return;
    }
    _searchResult.datasource = [self mockData];
}
@end

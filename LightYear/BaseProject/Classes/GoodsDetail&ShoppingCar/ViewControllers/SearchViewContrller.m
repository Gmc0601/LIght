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
#import "SearchListView.h"

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
    self.rightBar.hidden = YES;
    [self addSearchButton];
    self.searchBar.delegate = self;
    [self addInitialView];
}

//-(void) viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self reloadSearchResultView];
//}

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
    
    [NetHelper searchBy:self.searchBar.keyword withShopId:@"64" withPage:1 callBack:^(NSString *error, NSArray *datasource) {
        [ConfigModel hideHud:self];
        if (error != nil) {
            [ConfigModel mbProgressHUD:error andView:self.view];
        }else{
            _searchResult.datasource = datasource;
        }
    }];
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

-(void) reloadData:(SearchListView *)sender PageIndex:(int)index{
    [ConfigModel showHud:self];
    [NetHelper searchBy:self.searchBar.keyword withShopId:@"64" withPage:index callBack:^(NSString *error, NSArray *datasource) {
        [ConfigModel hideHud:self];
        if (error != nil) {
            [ConfigModel mbProgressHUD:error andView:self.view];
        }else{
            if(datasource != nil && datasource.count > 0){
                sender.datasource = datasource;
                [sender.tb reloadData];
            }
        }
    }];
}
@end

//
//  SearchViewContrller.m
//  BaseProject
//
//  Created by LeoGeng on 15/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "SearchViewContrller.h"
#import "HistoryTableView.h"

@interface SearchViewContrller()<SearchBarViewDelegate,HistoryTableViewDelegate>{
    NSString *historyKey;
}
@property(retain,atomic) HistoryTableView *initialView;
@end

@implementation SearchViewContrller
-(void) viewDidLoad{
    historyKey = @"search_history";
    [super viewDidLoad];
    [self addSearchButton];
    self.searchBar.delegate = self;
    [self addInitialView];
}

-(void) addInitialView{
    _initialView = [HistoryTableView new];
    [self.view addSubview:_initialView];
    NSArray *history = [ConfigModel getArrforKey:historyKey];
    _initialView.datasource = history;
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
}

-(void) didSelect:(NSString *)keyworkd{
    self.searchBar.keyword = keyworkd;
}
@end

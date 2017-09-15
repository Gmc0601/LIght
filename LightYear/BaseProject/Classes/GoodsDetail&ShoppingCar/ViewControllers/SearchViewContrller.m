//
//  SearchViewContrller.m
//  BaseProject
//
//  Created by LeoGeng on 15/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "SearchViewContrller.h"

@interface SearchViewContrller()<SearchBarViewDelegate>{
    NSString *historyKey;
}
@property(retain,atomic) UIView *initialView;
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
    _initialView = [UIView new];
    [self.view addSubview:_initialView];
    
    [_initialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNRegular(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = @"历史搜索";
    [_initialView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_initialView.mas_top).offset(SizeHeigh(20));
        make.left.equalTo(_initialView).offset(SizeWidth(15));
        make.right.equalTo(_initialView).offset(-SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(13)));
    }];
    
    UIView *seperatorView = [UIView new];
    seperatorView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [_initialView addSubview:seperatorView];
    
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTitle.mas_bottom).offset(SizeHeigh(20));
        make.left.equalTo(_initialView).offset(SizeWidth(15));
        make.right.equalTo(_initialView).offset(-SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(0.5)));
    }];
    
    NSArray *history = [ConfigModel getArrforKey:historyKey];
    if (history.count > 0) {
        
    }else{
        UILabel *lblMsg = [UILabel new];
        lblMsg.font = SourceHanSansCNRegular(SizeWidth(12));
        lblMsg.textColor = [UIColor colorWithHexString:@"#999999"];
        lblMsg.textAlignment = NSTextAlignmentCenter;
        lblMsg.text = @"暂无历史搜索";
        [_initialView addSubview:lblMsg];
        
        [lblMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(seperatorView).offset(SizeHeigh(30));
            make.left.equalTo(_initialView).offset(SizeWidth(15));
            make.right.equalTo(_initialView).offset(-SizeWidth(15));
            make.height.equalTo(@(SizeHeigh(13)));
        }];
    }
}

-(void) didSearch:(NSString *)keyworkd{
    NSMutableArray *history = [ConfigModel getArrforKey:historyKey];
    [history removeObject:keyworkd];
    [history addObject:keyworkd];
    [ConfigModel saveArr:history forKey:historyKey];
}

@end

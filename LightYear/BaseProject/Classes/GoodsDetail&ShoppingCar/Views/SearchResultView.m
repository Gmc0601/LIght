//
//  SearchResultView.m
//  BaseProject
//
//  Created by LeoGeng on 16/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "SearchResultView.h"
#import "GoodsListView.h"
#import "UIColor+BGHexColor.h"
#import <Masonry/Masonry.h>

@interface SearchResultView()<GoodsListViewDelegate>{
    NSString *_cellIdentifier;
}
@property(retain,strong) GoodsListView *listView;

@end

@implementation SearchResultView
@synthesize datasource = _datasource;

-(void) setDatasource:(NSArray *)datasource{
    _datasource = datasource;
    [self addSubViews];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return self;
}

-(void) addSubViews{
    [self removeAllSubviews];
    
    if (self.datasource.count > 0) {
        [self addTableView];
    }else{
        [self addViewsForEmpty];
    }
}


-(void) addViewsForEmpty{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_qs"]];
    
    [self addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(SizeHeigh(-86));
        make.width.equalTo(@(SizeWidth(164/2)));
        make.height.equalTo(@(SizeHeigh(86/2)));
    }];
    
    UILabel *lblMsg = [UILabel new];
    lblMsg.font = SourceHanSansCNRegular(SizeWidth(13));
    lblMsg.textColor = [UIColor colorWithHexString:@"#999999"];
    lblMsg.textAlignment = NSTextAlignmentCenter;
    lblMsg.text = @"暂时没有相关商品信息";
    [self addSubview:lblMsg];
    
    [lblMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(SizeHeigh(106/2));
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(@(SizeHeigh(15)));
    }];
    
    UIButton *btnGoto = [UIButton new];
    [btnGoto setTitle:@"浏览商品" forState:UIControlStateNormal];
    btnGoto.backgroundColor = [UIColor colorWithHexString:@"#3e7bb1"];
    btnGoto.layer.cornerRadius = SizeWidth(5/2);
    [btnGoto setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    btnGoto.titleLabel.font = SourceHanSansCNMedium(SizeWidth(15));
    [btnGoto addTarget:self action:@selector(gotoFirstCategory) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnGoto];
    
    [btnGoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblMsg.mas_bottom).offset(SizeHeigh(40/2));
        make.centerX.equalTo(self);
        make.width.equalTo(@(SizeWidth(150)));
        make.height.equalTo(@(SizeHeigh(88/2)));
    }];
}

-(void) addTableView{
    _listView = [GoodsListView new];
    _listView.delegate = self;
    [self addSubview:_listView];
    
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

-(void) gotoFirstCategory{
    [self.delegate gotoFirstCategory];
}

-(void) didSelectGoods:(NSString *)goodsId{
    [self.delegate didSelectGoods:goodsId];
}


@end

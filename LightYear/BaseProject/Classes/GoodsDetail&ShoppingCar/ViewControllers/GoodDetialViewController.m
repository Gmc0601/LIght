//
//  FirstLevelGoodsViewController.m
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "GoodDetialViewController.h"
#import "GoodsCategory.h"
#import "GoodDetialViewController.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import <ZYBannerView/ZYBannerView.h>
#import "NSString+Category.h"
#define TAG 100

@interface GoodDetialViewController () <UITableViewDelegate,UITableViewDataSource,ZYBannerViewDelegate,ZYBannerViewDataSource>{
    UITableView *_tb;
    NSString *_cellIdentifier;
    ZYBannerView *_banner;
    UILabel *_lblTitle;
    UILabel *_lblPrice1;
    UILabel *_lblPrice2;
    UILabel *_lblMember;
    UILabel *_lblNoMember;
    UILabel *_lblCanDelivery;
    UILabel *_lblTakeBySelf;
    UIImageView *_imgDiscounts;
    UIImageView *_imgNew;
    GoodsModel *_model;
    BOOL _showDetail;
    BOOL _showReminder;
    CGFloat _heightOfDetail;
}

@end

@implementation GoodDetialViewController
@synthesize goodsId = _goodsId;
-(void) setGoodsId:(NSString *)goodsId{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
}


-(void) addTableView{
    _cellIdentifier = @"cell";
    _tb = [[UITableView alloc] init];
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:_cellIdentifier];
    _tb.tableFooterView = [UIView new];
    _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tb.allowsSelection = NO;
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
    return  4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodDetialViewController *newVC = [GoodDetialViewController new];
    
    [self.navigationController pushViewController:newVC animated:YES];
}

-(void) addBannerToCell:(UITableViewCell *) cell{
    _banner = [ZYBannerView new];
    _banner.dataSource = self;
    _banner.delegate = self;
    _banner.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
    _banner.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#333333"];
    [cell addSubview:_banner];
    
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell);
        make.top.equalTo(cell);
        make.right.equalTo(cell);
        make.height.equalTo(@(SizeHeigh(227)));
    }];
}

-(void) addGoodsDetailToCell:(UITableViewCell *) cell{
    [self addTitleToCell:cell];
    [self addPriceLableToCell:cell];
}

-(void) addTitleToCell:(UITableViewCell *) cell{
    _lblTitle = [UILabel new];
    _lblTitle.font = SourceHanSansCNMedium(SizeWidth(15));
    _lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:_lblTitle];
    
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(SizeWidth(15));
        make.top.equalTo(_banner.mas_bottom).offset(SizeHeigh(25));
        make.right.equalTo(cell).offset(SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(30)));
    }];
}

-(void) addPriceLableToCell:(UITableViewCell *) cell{
    _lblPrice1 = [UILabel new];
    _lblPrice1.font = VerdanaBold(SizeWidth(28));
    _lblPrice1.textAlignment = NSTextAlignmentLeft;
    _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.memberPrice];
    
    [cell addSubview:_lblPrice1];
    
    
    if ([_model.memberPrice isEqualToString:@""]) {
        _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.price];
    }
    
    CGFloat width = [_lblPrice1.text widthWithFontSize:SizeWidth(28) height:SizeWidth(28)];
    if (_model.isNew) {
        width += SizeWidth(22);
        _lblPrice1.textAlignment = NSTextAlignmentCenter;
    }
    
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(20));
        make.left.equalTo(_lblTitle.mas_left);
        make.height.equalTo(@(SizeHeigh(28)));
        make.width.equalTo(@(width));
    }];
    
    if (!_model.isNew) {
        if ([_model.memberPrice isEqualToString:@""]) {
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        }else{
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#ff9e23"];;
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(5) toCell:cell];
            [self addPriceLabel2ToCell:cell];
        }
    }else{
        _lblPrice1.backgroundColor = [UIColor colorWithHexString:@"fecd2f"];
        _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        
        if (![_model.memberPrice isEqualToString:@""]) {
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(10) toCell:cell];
            [self addPriceLabel2ToCell:cell];
        }
        
        _lblPrice1.layer.shadowOpacity = 1.0;
        _lblPrice1.layer.shadowRadius = 0.0;
        _lblPrice1.layer.shadowColor = [UIColor colorWithHexString:@"#ff3b30"].CGColor;
        _lblPrice1.layer.shadowOffset = CGSizeMake(SizeWidth(5), SizeHeigh(5));
        
    }
}

-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin toCell:(UITableViewCell *) cell{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员" withConstraintView:_lblPrice1 withLeftMargin:leftMargin toCell:cell];
}

-(void) addPriceLabel2ToCell:(UITableViewCell *) cell{
    _lblPrice2 = [UILabel new];
    _lblPrice2.font = VerdanaBold(SizeWidth(15));
    _lblPrice2.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblPrice2.textAlignment = NSTextAlignmentLeft;
    _lblPrice2.text = [NSString stringWithFormat:@"￥%@",_model.price];
    
    [cell addSubview:_lblPrice2];
    CGFloat width = [_lblPrice2.text widthWithFontSize:SizeWidth(15) height:SizeWidth(15)] + SizeWidth(10);
    [_lblPrice2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblPrice1.mas_bottom).offset(SizeHeigh(18));
        make.left.equalTo(_lblPrice1);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(width));
    }];
    
    [self getLabeForMemberAndNoMemberLabel:[UIColor colorWithHexString:@"#333333"] withText:@"非会员" withConstraintView:_lblPrice2 withLeftMargin:SizeWidth(2) toCell:cell];
}

-(UILabel *) getLabeForMemberAndNoMemberLabel:(UIColor *) fontColor withText:(NSString *) text withConstraintView:(UIView *) constraintView withLeftMargin:(CGFloat) leftMargin toCell:(UITableViewCell *) cell{
    UILabel *lbl = [UILabel new];
    lbl.font = VerdanaBold(SizeWidth(15));
    lbl.textColor = fontColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    
    [cell addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(constraintView).offset(SizeHeigh(-1));
        make.left.equalTo(constraintView.mas_right).offset(leftMargin);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(100)));
    }];
    
    return lbl;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return SizeHeigh(616/2);
    }else if(indexPath.row == 1){
        if (_showDetail) {
            return SizeHeigh(61 + _heightOfDetail + 100);
        }else{
            return SizeHeigh(61);
        }
    }else if(indexPath.row == 2){
        if (_showReminder) {
            return SizeHeigh(61 + _heightOfDetail + 100);
        }else{
            return SizeHeigh(61);
        }
    }
    
    return  SizeHeigh(271);
}
@end

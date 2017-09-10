//
//  GoodsCell.m
//  BaseProject
//
//  Created by LeoGeng on 09/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "GoodsCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+BGHexColor.h"
#import "NSString+Category.h"
#import "UIImageView+WebCache.h"

@interface GoodsCell(){
    UIImageView *_img;
    UILabel *_lblTitle;
    UILabel *_lblPrice1;
    UILabel *_lblPrice2;
    UILabel *_lblMember;
    UILabel *_lblNoMember;
    UILabel *_lblCanDelivery;
    UILabel *_lblTakeBySelf;
    UIImageView *_imgDiscounts;
    UIImageView *_imgNew;
}

@end

@implementation GoodsCell

@synthesize model = _model;
-(void) setModel:(GoodsModel *)model{
    _model = model;
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    _img = nil;
    _lblTitle = nil;
    _lblPrice1 = nil;
    _lblPrice2 = nil;
    _lblMember = nil;
    _lblNoMember = nil;
    _lblCanDelivery = nil;
    _lblTakeBySelf = nil;
    _imgDiscounts = nil;
    _imgNew = nil;
    
    [self addSubView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsMake(0, SizeWidth(15), 0, SizeWidth(15));
    return  self;
}

-(void) addSubView{
    _img = [UIImageView new];
    _img.backgroundColor = [UIColor redColor];
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    [self addSubview:_img];
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SizeWidth(15));
        make.top.equalTo(self.mas_top).offset(SizeHeigh(31));
        make.height.equalTo(@(SizeHeigh(100)));
        make.width.equalTo(@(SizeHeigh(100)));
    }];
    
    if (_model.outOfStack) {
        UIView *layerView = [UIView new];
        layerView.backgroundColor = [UIColor colorWithHexString:@"1000000"];
        layerView.alpha = 0.6;
        
        [_img addSubview:layerView];
        [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_img.mas_left);
            make.top.equalTo(_img.mas_top);
            make.bottom.equalTo(_img.mas_bottom);
            make.right.equalTo(_img);
        }];
        
        UILabel *lblOutOfStack = [UILabel new];
        lblOutOfStack.font = SourceHanSansCNMedium(SizeWidth(13));
        lblOutOfStack.textColor = [UIColor colorWithHexString:@"#ffffff"];
        lblOutOfStack.textAlignment = NSTextAlignmentCenter;
        lblOutOfStack.text = @"已售完";
        [layerView addSubview:lblOutOfStack];
        
        [lblOutOfStack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(layerView);
            make.centerY.equalTo(layerView);
            make.height.equalTo(@(SizeHeigh(13)));
            make.width.equalTo(@(SizeWidth(100)));
        }];
        
    }
    
    _lblTitle = [UILabel new];
    _lblTitle.font = SourceHanSansCNMedium(SizeWidth(15));
    _lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.text = _model.name;
    
    [self addSubview:_lblTitle];
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_right).offset(SizeWidth(16));
        make.top.equalTo(_img.mas_top);
        make.height.equalTo(@(SizeHeigh(15)));
        make.right.equalTo(self.mas_right).offset(SizeWidth(15));
    }];
    
    [self addCanDeliveryLable:_model.canDelivery];
    [self addTakeBySelfLabel:_model.canTakeBySelf];
    [self addPriceLable];
    
    if (_model.hasDiscounts) {
        [self addDiscountsImage];
    }
    
    if (_model.isNew) {
        [self addNewImage];
    }
    
}

-(UILabel *) getLableForTag:(BOOL) highlight{
    UIColor *fontColor = [UIColor colorWithHexString:@"#4ead35"];
    if (!highlight) {
        fontColor = [UIColor colorWithHexString:@"#666666"];
    }
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = PingFangSCMedium(SizeWidth(11));
    lblTitle.textColor = fontColor;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.layer.borderColor = fontColor.CGColor;
    lblTitle.layer.borderWidth = SizeWidth(1);
    lblTitle.layer.cornerRadius = SizeWidth(5);
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SizeWidth(31)));
        make.height.equalTo(@(SizeWidth(14)));
    }];
    
    [self addSubview:lblTitle];
    return lblTitle;
}

-(void) addCanDeliveryLable:(BOOL) canDelivery{
    _lblCanDelivery = [self getLableForTag:canDelivery];
    _lblCanDelivery.text = @"配送";
    [_lblCanDelivery mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblTitle.mas_left);
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(15));
    }];
}

-(void) addTakeBySelfLabel:(BOOL) takeBySelf{
    _lblTakeBySelf = [self getLableForTag:takeBySelf];
    _lblTakeBySelf.text = @"自取";
    [_lblTakeBySelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblCanDelivery.mas_right).offset(SizeWidth(10));
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(15));
    }];
}

-(void) addDiscountsImage{
    _imgDiscounts = [UIImageView new];
    _imgDiscounts.image = [UIImage imageNamed:@"icon_nav_yh.png"];
    [self addSubview:_imgDiscounts];
    
    [_imgDiscounts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblTakeBySelf.mas_right).offset(SizeWidth(10));
        make.centerY.equalTo(_lblTakeBySelf);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(22)));
    }];
}

-(void) addNewImage{
    _imgNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_xq_xp"]];
    [self addSubview:_imgNew];
    
    [_imgNew mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_imgDiscounts == nil) {
            make.left.equalTo(_lblTakeBySelf.mas_right).offset(SizeWidth(10));
        }else{
            make.left.equalTo(_imgDiscounts.mas_right).offset(SizeWidth(10));
        }
        
        make.centerY.equalTo(_lblTakeBySelf);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(22)));
    }];
}

-(void) addPriceLable{
    _lblPrice1 = [UILabel new];
    _lblPrice1.font = VerdanaBold(SizeWidth(28));
    _lblPrice1.textAlignment = NSTextAlignmentLeft;
    _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.memberPrice];
    
    [self addSubview:_lblPrice1];
    
    
    if ([_model.memberPrice isEqualToString:@""]) {
        _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.price];
    }
    
    CGFloat width = [_lblPrice1.text widthWithFontSize:SizeWidth(28) height:SizeWidth(28)];
    if (_model.isNew) {
        width += SizeWidth(22);
        _lblPrice1.textAlignment = NSTextAlignmentCenter;
    }
    
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTakeBySelf.mas_bottom).offset(SizeHeigh(16));
        make.left.equalTo(_lblTitle.mas_left);
        make.height.equalTo(@(SizeHeigh(28)));
        make.width.equalTo(@(width));
    }];
    
    if (!_model.isNew) {
        if ([_model.memberPrice isEqualToString:@""]) {
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        }else{
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#ff9e23"];;
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(5)];
            [self addPriceLabel2];
        }
    }else{
        _lblPrice1.backgroundColor = [UIColor colorWithHexString:@"fecd2f"];
        _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        
        if (![_model.memberPrice isEqualToString:@""]) {
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(10)];
            [self addPriceLabel2];
        }
        
        _lblPrice1.layer.shadowOpacity = 1.0;
        _lblPrice1.layer.shadowRadius = 0.0;
        _lblPrice1.layer.shadowColor = [UIColor colorWithHexString:@"#ff3b30"].CGColor;
        _lblPrice1.layer.shadowOffset = CGSizeMake(SizeWidth(5), SizeHeigh(5));
        
    }
}

-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员" withConstraintView:_lblPrice1 withLeftMargin:leftMargin];
}

-(void) addPriceLabel2{
    _lblPrice2 = [UILabel new];
    _lblPrice2.font = VerdanaBold(SizeWidth(15));
    _lblPrice2.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblPrice2.textAlignment = NSTextAlignmentLeft;
    _lblPrice2.text = [NSString stringWithFormat:@"￥%@",_model.price];
    
    [self addSubview:_lblPrice2];
    CGFloat width = [_lblPrice2.text widthWithFontSize:SizeWidth(15) height:SizeWidth(15)] + SizeWidth(10);
    [_lblPrice2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblPrice1.mas_bottom).offset(SizeHeigh(18));
        make.left.equalTo(_lblPrice1);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(width));
    }];
    
    [self getLabeForMemberAndNoMemberLabel:[UIColor colorWithHexString:@"#333333"] withText:@"非会员" withConstraintView:_lblPrice2 withLeftMargin:SizeWidth(2)];
}

-(UILabel *) getLabeForMemberAndNoMemberLabel:(UIColor *) fontColor withText:(NSString *) text withConstraintView:(UIView *) constraintView withLeftMargin:(CGFloat) leftMargin{
    UILabel *lbl = [UILabel new];
    lbl.font = VerdanaBold(SizeWidth(15));
    lbl.textColor = fontColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    
    [self addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(constraintView).offset(SizeHeigh(-1));
        make.left.equalTo(constraintView.mas_right).offset(leftMargin);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(100)));
    }];
    
    return lbl;
}

@end

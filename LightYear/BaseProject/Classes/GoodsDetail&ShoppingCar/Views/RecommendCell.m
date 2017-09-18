//
//  GoodsCell.m
//  BaseProject
//
//  Created by LeoGeng on 09/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "RecommendCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+BGHexColor.h"
#import "NSString+Category.h"
#import "UIImageView+WebCache.h"

@interface RecommendCell(){
    UIImageView *_img;
    UILabel *_lblTitle;
    UILabel *_lblPrice1;
    UILabel *_lblPrice2;
    UILabel *_lblMember;
    UILabel *_lblNoMember;
    CGFloat _imgTop;
    CGSize _imgSize;
}

@end

@implementation RecommendCell

-(void) setModel:(GoodsModel *)model{
    _model = model;
    
    [self removeAllSubviews];
    
    _img = nil;
    _lblTitle = nil;
    _lblPrice2 = nil;
    _lblMember = nil;
    _lblNoMember = nil;
    _lblPrice1 = nil;
    
    [self addSubView];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _imgTop = SizeHeigh(31);
        _imgSize = CGSizeMake(SizeWidth(100), SizeHeigh(100));
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void) addSubView{
    
    _img = [UIImageView new];
    _img.backgroundColor = [UIColor redColor];
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    [self addSubview:_img];
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@(SizeHeigh(284/2)));
        make.width.equalTo(self);
    }];
    
    _lblTitle = [UILabel new];
    _lblTitle.font = SourceHanSansCNMedium(SizeWidth(14));
    _lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.text = _model.name;
    _lblTitle.numberOfLines = 2;
    [self addSubview:_lblTitle];
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(_img.mas_bottom).offset(SizeHeigh(20/2));
        make.height.equalTo(@(SizeHeigh(30)));
        make.width.equalTo(self);
    }];
    
    [self addPriceLable];
    
    if (_model.outOfStack) {
        [self addOutOfStackView];
    }
    
}


-(void) addPriceLable{
    _lblPrice1 = [UILabel new];
    _lblPrice1.font = VerdanaBold(SizeWidth(15));
    _lblPrice1.textAlignment = NSTextAlignmentLeft;
    _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.memberPrice];
    
    [self addSubview:_lblPrice1];
    
    
    if ([_model.memberPrice isEqualToString:@""]) {
        _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.price];
    }
    
    CGFloat width = [_lblPrice1.text widthWithFontSize:SizeWidth(15) height:SizeWidth(15)];
    if (_model.isNew) {
        width += SizeWidth(6);
        _lblPrice1.textAlignment = NSTextAlignmentCenter;
    }
    
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(38/2));
        make.left.equalTo(_lblTitle);
        make.height.equalTo(@(SizeHeigh(15)));
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
    _lblPrice2.font = VerdanaBold(SizeWidth(10));
    _lblPrice2.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblPrice2.textAlignment = NSTextAlignmentLeft;
    _lblPrice2.text = [NSString stringWithFormat:@"￥%@",_model.price];
    
    [self addSubview:_lblPrice2];
    CGFloat width = [_lblPrice2.text widthWithFontSize:SizeWidth(12) height:SizeWidth(10)] + SizeWidth(5);
    [_lblPrice2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblPrice1.mas_bottom).offset(SizeHeigh(10));
        make.left.equalTo(_lblPrice1);
        make.height.equalTo(@(SizeHeigh(10)));
        make.width.equalTo(@(width));
    }];
    
    [self getLabeForMemberAndNoMemberLabel:[UIColor colorWithHexString:@"#333333"] withText:@"非会员" withConstraintView:_lblPrice2 withLeftMargin:SizeWidth(2)];
}

-(UILabel *) getLabeForMemberAndNoMemberLabel:(UIColor *) fontColor withText:(NSString *) text withConstraintView:(UIView *) constraintView withLeftMargin:(CGFloat) leftMargin{
    UILabel *lbl = [UILabel new];
    lbl.font = SourceHanSansCNLight(SizeWidth(8));
    lbl.textColor = fontColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    
    [self addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(constraintView).offset(SizeHeigh(-1));
        make.left.equalTo(constraintView.mas_right).offset(leftMargin);
        make.height.equalTo(@(SizeHeigh(8)));
        make.width.equalTo(@(SizeHeigh(70)));
    }];
    
    return lbl;
}

-(void) addOutOfStackView{
    
    UIView *backgroudView = [UIView new];
    backgroudView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    backgroudView.alpha = 0.49;
    [self addSubview:backgroudView];
    
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_img);
        make.left.equalTo(_img);
        make.right.equalTo(_img);
        make.bottom.equalTo(_img);
    }];
    
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithHexString:@"#ffffff"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"已售完";
    [self addSubview:lblTitle];
    
    [backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_img);
        make.centerY.equalTo(_img);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(SizeWidth(100)));
    }];
}
@end

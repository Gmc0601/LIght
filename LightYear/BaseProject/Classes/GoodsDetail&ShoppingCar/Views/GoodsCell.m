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
#import "NSMutableAttributedString+Category.h"

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
    CGFloat _imgTop;
    CGSize _imgSize;
}

@end

@implementation GoodsCell

@synthesize model = _model;
@synthesize isFavorite = _isFavorite;
-(void) setIsFavorite:(BOOL)isFavorite{
    _isFavorite = isFavorite;
    if (isFavorite) {
        _imgTop = SizeHeigh(15);
        _imgSize = CGSizeMake(SizeWidth(72), SizeHeigh(72));
    }
}

-(void) setModel:(GoodsModel *)model{
    _model = model;
    [self removeAllSubviews];
    
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
    _imgTop = SizeHeigh(31);
    _imgSize = CGSizeMake(SizeWidth(100), SizeHeigh(100));
    
    return  self;
}

-(void) addSubView{
    UIView *seperator = [UIView new];
    seperator.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self addSubview:seperator];
    [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(SizeWidth(15));
        make.right.equalTo(self).offset(SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(0.5)));
    }];
    
    _img = [UIImageView new];
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img[0]]];
    [self addSubview:_img];
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(SizeWidth(15));
        make.top.equalTo(self.mas_top).offset(_imgTop);
        make.height.equalTo(@(_imgSize.height));
        make.width.equalTo(@(_imgSize.width));
    }];
    
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
        make.right.equalTo(self.mas_right).offset(-SizeWidth(15));
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
    
    
    if (_model.outOfStack) {
        [self addOutOfStackView];
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
    NSString *price1 = _model.memberPrice;
    NSString *price2 = nil;
    _lblPrice1 = [UILabel new];
    _lblPrice1.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_lblPrice1];
    
    if (_model.specilPrice == nil) {
        if(_model.memberPrice == nil){
            price1 = _model.price;
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        }else{
            price1 = _model.memberPrice;
            price2 = _model.price;
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#ff9e23"];;
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(5)];
            [self addPriceLabel2:price2];
        }
    }else{
        if (_model.isUser) {
            price1 = _model.specilPrice;
        }else{
            price1 = _model.specilPrice;
            price2 = _model.specilPrice;
        }
        
        _lblPrice1.backgroundColor = [UIColor colorWithHexString:@"fecd2f"];
        _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        _lblPrice1.layer.shadowOpacity = 1.0;
        _lblPrice1.layer.shadowRadius = 0.0;
        _lblPrice1.layer.shadowColor = [UIColor colorWithHexString:@"#ff3b30"].CGColor;
        _lblPrice1.layer.shadowOffset = CGSizeMake(SizeWidth(5), SizeHeigh(5));
        _lblPrice1.textAlignment = NSTextAlignmentCenter;
        if (price2 != nil) {
            [self addPriceLabel2:price2];
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(15)];
        }
    }
    
    CGFloat width = [price1 widthWithFont:VerdanaBold(SizeWidth(28)) height:SizeWidth(28)] + SizeWidth(28);
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTakeBySelf.mas_bottom).offset(SizeHeigh(16));
        make.left.equalTo(_lblTitle.mas_left);
        make.height.equalTo(@(SizeHeigh(28)));
        make.width.equalTo(@(width));
    }];
    
    _lblPrice1.attributedText = [NSMutableAttributedString attributeString:@"￥ " prefixFont:VerdanaItalic(SizeWidth(28)) prefixColor:_lblPrice1.textColor suffixString:price1 suffixFont: VerdanaBold(SizeWidth(28)) suffixColor:_lblPrice1.textColor];
}

-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员" withConstraintView:_lblPrice1 withLeftMargin:leftMargin];
}

-(void) addPriceLabel2:(NSString *) price{
    _lblPrice2 = [UILabel new];
    _lblPrice2.font = VerdanaBold(SizeWidth(15));
    _lblPrice2.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblPrice2.textAlignment = NSTextAlignmentLeft;
    _lblPrice2.attributedText = [NSMutableAttributedString attributeString:@"￥ " prefixFont:VerdanaItalic(SizeWidth(15)) prefixColor:_lblPrice1.textColor suffixString:price suffixFont: VerdanaBold(SizeWidth(15)) suffixColor:_lblPrice1.textColor];
    
    [self addSubview:_lblPrice2];
    CGFloat width = [_lblPrice2.text widthWithFont:_lblPrice2.font height:SizeWidth(15)] + SizeWidth(10);
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
    lbl.font = SourceHanSansCNLight(SizeWidth(12));
    lbl.textColor = fontColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    
    [self addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(constraintView);
        make.left.equalTo(constraintView.mas_right).offset(leftMargin);
        make.height.equalTo(@(SizeHeigh(12)));
        make.width.equalTo(@(SizeHeigh(100)));
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

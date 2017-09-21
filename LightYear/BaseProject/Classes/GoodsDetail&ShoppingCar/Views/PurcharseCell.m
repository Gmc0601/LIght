//
//  GoodsCell.m
//  BaseProject
//
//  Created by LeoGeng on 09/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "PurcharseCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+BGHexColor.h"
#import "NSString+Category.h"
#import "UIImageView+WebCache.h"

@interface PurcharseCell(){
    UIImageView *_img;
    UILabel *_lblTitle;
    UILabel *_lblPrice1;
    UILabel *_lblCanDelivery;
    UILabel *_lblTakeBySelf;
    UILabel *_lblUserNeed;
    CGSize _imgSize;
}

@end

@implementation PurcharseCell

@synthesize model = _model;

-(void) setModel:(GoodsModel *)model{
    _model = model;
    [self removeAllSubviews];
    
    _img = nil;
    _lblTitle = nil;
    _lblPrice1 = nil;
    _lblCanDelivery = nil;
    _lblTakeBySelf = nil;
    
    [self addSubView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsMake(0, SizeWidth(15), 0, SizeWidth(15));
    _imgSize = CGSizeMake(SizeWidth(198/2), SizeHeigh(198/2));
    
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
    
    UIButton *btnDelete = [UIButton new];
    [btnDelete setImage:[UIImage imageNamed:@"icon_sc"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(deleteGoods) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDelete];
    [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SizeWidth(30/2));
        make.centerY.equalTo(self);
        make.width.equalTo(@(SizeWidth(44/2)));
        make.height.equalTo(@(SizeHeigh(44/2)));
    }];
    
    _img = [UIImageView new];
    _img.backgroundColor = [UIColor redColor];
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img]];
    [self addSubview:_img];
    
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnDelete.mas_right).offset(SizeWidth(17));
        make.centerY.equalTo(self);
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
        make.left.equalTo(_img.mas_right).offset(SizeWidth(15));
        make.top.equalTo(self.mas_top).offset(SizeHeigh(16));
        make.height.equalTo(@(SizeHeigh(15)));
        make.right.equalTo(self.mas_right).offset(-SizeWidth(15));
    }];
    
    _lblUserNeed = [UILabel new];
    _lblUserNeed.font = SourceHanSansCNLight(SizeWidth(10));
    _lblUserNeed.textColor = [UIColor colorWithHexString:@"#999999"];
    _lblUserNeed.textAlignment = NSTextAlignmentLeft;
    _lblUserNeed.text = _model.name;
    
    [self addSubview:_lblUserNeed];
    
    [_lblUserNeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblTitle);
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(10));
        make.height.equalTo(@(SizeHeigh(10)));
        make.right.equalTo(self.mas_right).offset(-SizeWidth(15));
    }];
    
    [self addCanDeliveryLable:_model.canDelivery];
    [self addTakeBySelfLabel:_model.canTakeBySelf];
    [self addPriceLable];
    
    [self addChangeNumberControl];
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
        make.top.equalTo(_lblUserNeed.mas_bottom).offset(SizeHeigh(10));
    }];
}

-(void) addTakeBySelfLabel:(BOOL) takeBySelf{
    _lblTakeBySelf = [self getLableForTag:takeBySelf];
    _lblTakeBySelf.text = @"自取";
    [_lblTakeBySelf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblCanDelivery.mas_right).offset(SizeWidth(10));
        make.top.equalTo(_lblCanDelivery);
    }];
}

-(void) addPriceLable{
    _lblPrice1 = [UILabel new];
    _lblPrice1.font = VerdanaBold(SizeWidth(28));
    _lblPrice1.textAlignment = NSTextAlignmentLeft;
    _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.memberPrice];
    
    [self addSubview:_lblPrice1];
    
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTakeBySelf.mas_bottom).offset(SizeHeigh(16));
        make.left.equalTo(_lblTitle.mas_left);
        make.height.equalTo(@(SizeHeigh(28)));
        make.width.equalTo(@(SizeWidth(100)));
    }];
}

-(void) addChangeNumberControl{
//    UIFont *buttonFont = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:SizeWidth(13)];
    UIFont *buttonFont = SourceHanSansCNLight(13);
    UIButton *btnSubtract = [UIButton new];
    [btnSubtract addTarget:self action:@selector(tapPlusButton) forControlEvents:UIControlEventTouchUpInside];
    btnSubtract.titleLabel.font = buttonFont;
[btnSubtract setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btnSubtract.layer.cornerRadius = SizeWidth(2.5);
    btnSubtract.layer.borderWidth = SizeWidth(1);
    btnSubtract.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    [btnSubtract addTarget:self action:@selector(tapSubtractButton) forControlEvents:UIControlEventTouchUpInside];
    [btnSubtract setTitle:@"+" forState:UIControlStateNormal];
    [self addSubview:btnSubtract];
    
    [btnSubtract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(SizeWidth(-30/2));
        make.top.equalTo(_lblPrice1.mas_top).offset(SizeHeigh(9));
        make.width.equalTo(@(SizeWidth(40/2)));
        make.height.equalTo(@(SizeHeigh(50/2)));
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = Verdana(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.layer.borderWidth = SizeWidth(1);
    lblTitle.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    lblTitle.text = @"1";
    [self addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnSubtract.mas_centerY);
        make.right.equalTo(btnSubtract.mas_left).offset(SizeWidth(1));
        make.width.equalTo(@(SizeWidth(80/2)));
        make.height.equalTo(btnSubtract);
    }];
    
    UIButton *btnPlus = [UIButton new];
    [btnPlus addTarget:self action:@selector(tapPlusButton) forControlEvents:UIControlEventTouchUpInside];
    btnPlus.titleLabel.font = buttonFont;
    [btnPlus setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btnPlus.layer.cornerRadius = SizeWidth(2.5);
    btnPlus.layer.borderWidth = SizeWidth(1);
    btnPlus.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    [btnPlus addTarget:self action:@selector(tapPlusButton) forControlEvents:UIControlEventTouchUpInside];
    [btnPlus setTitle:@"-" forState:UIControlStateNormal];
    [self addSubview:btnPlus];
    
    [btnPlus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnSubtract.mas_centerY);
        make.right.equalTo(lblTitle.mas_left).offset(SizeWidth(1));
        make.width.equalTo(@(SizeWidth(40/2)));
        make.height.equalTo(btnSubtract);
    }];
}

-(void) tapPlusButton{
    
}

-(void) tapSubtractButton{
    
}

-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员" withConstraintView:_lblPrice1 withLeftMargin:leftMargin];
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

-(void) deleteGoods{
    [self.delegate didDelete:_model._id];
}
@end
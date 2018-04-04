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
    UILabel *_lblCount;
}

@end

@implementation PurcharseCell

@synthesize model = _model;

-(void) setModel:(PurchaseModel *)model{
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
    
    
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(0);
        make.width.equalTo(@(self.contentView.width));
        make.height.equalTo(@(self.contentView.height));
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
    [_img sd_setImageWithURL:[NSURL URLWithString:_model.img[0]]];
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
        make.top.equalTo(_img.mas_top).offset(0);
        make.height.equalTo(@(SizeHeigh(15)));
        make.right.equalTo(self.mas_right).offset(-SizeWidth(15));
    }];
    
    _lblUserNeed = [UILabel new];
    _lblUserNeed.font = SourceHanSansCNLight(SizeWidth(10));
    _lblUserNeed.textColor = [UIColor colorWithHexString:@"#999999"];
    _lblUserNeed.textAlignment = NSTextAlignmentLeft;
 _lblUserNeed.text = _model.sku == nil ? @"":_model.sku;
    
    [self addSubview:_lblUserNeed];
    
    [_lblUserNeed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblTitle);
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(10));
        make.height.equalTo(@(SizeHeigh(10)));
        make.right.equalTo(self.mas_right).offset(-SizeWidth(15));
    }];
    
    [self addCanDeliveryLable:_model.centerStock > 0];
    [self addTakeBySelfLabel:_model.shopStock > 0];
    [self addPriceLable];
    
    [self addChangeNumberControl];
    if (_model.stock == 0) {
        [self addOutOfStackView];
    }
    
}

- (void)imgClick {
    
    if (self.imageBlock) {
        self.imageBlock();
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
    _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.price];
    
    [self addSubview:_lblPrice1];
    
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTakeBySelf.mas_bottom).offset(SizeHeigh(8));
        make.left.equalTo(_lblTitle.mas_left);
        make.height.equalTo(@(SizeHeigh(28)));
        make.width.equalTo(@(SizeWidth(110)));
    }];
}

-(void) addChangeNumberControl{
//    UIFont *buttonFont = [UIFont fontWithName:@"AdobeHeitiStd-Regular" size:SizeWidth(13)];
    UIFont *buttonFont = SourceHanSansCNLight(13);
    UIButton *btnPlus = [UIButton new];
    btnPlus.titleLabel.font = buttonFont;
[btnPlus setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btnPlus.layer.cornerRadius = SizeWidth(2.5);
    btnPlus.layer.borderWidth = SizeWidth(1);
    btnPlus.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    [btnPlus addTarget:self action:@selector(tapPlusButton) forControlEvents:UIControlEventTouchUpInside];
    [btnPlus setTitle:@"+" forState:UIControlStateNormal];
    [self addSubview:btnPlus];
    
    [btnPlus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(SizeWidth(-30/2));
        make.bottom.equalTo(_lblPrice1.mas_bottom).offset(SizeHeigh(50/2));
        make.width.equalTo(@(SizeWidth(40/2)));
        make.height.equalTo(@(SizeHeigh(50/2)));
    }];
    
    _lblCount = [UILabel new];
    _lblCount.font = Verdana(SizeWidth(13));
    _lblCount.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblCount.textAlignment = NSTextAlignmentCenter;
    _lblCount.layer.borderWidth = SizeWidth(1);
    _lblCount.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    _lblCount.text = [NSString stringWithFormat:@"%d",_model.count] ;
    [self addSubview:_lblCount];
    
    [_lblCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnPlus.mas_centerY);
        make.right.equalTo(btnPlus.mas_left).offset(SizeWidth(1));
        make.width.equalTo(@(SizeWidth(80/2)));
        make.height.equalTo(btnPlus);
    }];
    
    UIButton *btnSubtract= [UIButton new];
    btnSubtract.titleLabel.font = buttonFont;
    [btnSubtract setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btnSubtract.layer.cornerRadius = SizeWidth(2.5);
    btnSubtract.layer.borderWidth = SizeWidth(1);
    btnSubtract.layer.borderColor = [UIColor colorWithHexString:@"e0e0e0"].CGColor;
    [btnSubtract addTarget:self action:@selector(tapSubtractButton) forControlEvents:UIControlEventTouchUpInside];
    [btnSubtract setTitle:@"-" forState:UIControlStateNormal];
    [self addSubview:btnSubtract];
    
    [btnSubtract mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btnPlus.mas_centerY);
        make.right.equalTo(_lblCount.mas_left).offset(SizeWidth(1));
        make.width.equalTo(@(SizeWidth(40/2)));
        make.height.equalTo(btnPlus);
    }];
}

-(void) tapSubtractButton{
    if ((_model.count - 1) > 0) {
        _model.count -= 1;
        _lblCount.text = [NSString stringWithFormat:@"%d",_model.count] ;
        [self.delegate didChangeNumber:_model withSender:self];
    }
}

-(void) tapPlusButton{
    if ((_model.count + 1) <= _model.stock) {
        _model.count += 1;
        _lblCount.text = [NSString stringWithFormat:@"%d",_model.count] ;
        [self.delegate didChangeNumber:_model withSender:self];
    }
}

-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员价" withConstraintView:_lblPrice1 withLeftMargin:leftMargin];
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
    lblTitle.text = @"已售罄";
    [self addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backgroudView);
        make.centerY.equalTo(backgroudView);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(SizeWidth(100)));
    }];
}

-(void) deleteGoods{
    [self.delegate didDelete:_model._id];
}
@end

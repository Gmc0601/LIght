//
//  OrderFootView.m
//  BaseProject
//
//  Created by cc on 2017/9/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderFootView.h"
#import "UIView+Utils.h"
#import <Masonry/Masonry.h>
@implementation OrderFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)changeBtnStyle:(OrderBtnStyle)type {
    
    if (type == Red) {
        self.payBtn.backgroundColor = UIColorFromHex(0xff543a);
        [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (type == Gray){
        self.payBtn.backgroundColor = RGBColor(239, 240, 241);
        [self.payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if (type == Yellow){
        self.payBtn.backgroundColor = RGBColor(252, 203, 66);
        [self.payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)choiseType:(OrderFootType)type {
    if (type == FootOneLab) {
        self.infoLab.hidden =  YES;
        self.priceLab.hidden = YES;
        self.balanceLab.hidden = YES;
        self.topUpBtn.hidden = YES;
        [self.backView addSubview:self.logoImage];
        [self.backView addSubview:self.moreLab];
    }else {
        self.infoLab.hidden =  NO;
        self.priceLab.hidden = NO;
        self.balanceLab.hidden = NO;
        self.topUpBtn.hidden = NO;
        [self.logoImage removeFromSuperview];
        [self.moreLab removeFromSuperview];
    }
}

- (void)createView {
    [self addSubview:self.backView];
    [self.backView addSubview:self.infoLab];
    [self.backView addSubview:self.priceLab];
    [self.backView addSubview:self.balanceLab];
    [self.backView addSubview:self.topUpBtn];
    [self.backView addSubview:self.payBtn];
    
    [self chagneFrame];
}

- (void)chagneFrame {
    
    int top = SizeHeigh(10);
    if (kDevice_Is_iPhoneX) {
        top = SizeHeigh(5);
    }
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(SizeWidth(15));
        make.top.equalTo(self.backView.mas_top).offset(top);
        make.height.mas_equalTo(SizeHeigh(15));
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLab.mas_right).offset(SizeWidth(5));
        make.top.equalTo(self.backView.mas_top).offset(top);
        make.height.mas_equalTo(SizeHeigh(15));
    }];
    
    [self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(SizeWidth(15));
        make.top.equalTo(self.infoLab.mas_bottom).offset(SizeHeigh(5));
        make.height.mas_equalTo(SizeHeigh(15));
    }];
    
    [self.topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceLab.mas_right).offset(SizeWidth(10));
        make.top.equalTo(self.infoLab.mas_bottom).offset(SizeHeigh(5));
        make.height.mas_equalTo(SizeHeigh(15));
        make.width.mas_equalTo(SizeWidth(55));
    }];
    
    if (kDevice_Is_iPhoneX) {
        top = SizeHeigh(2);
    }else {
        SizeHeigh(5);
    }
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(-SizeWidth(15));
        make.top.equalTo(self.backView.mas_top).offset(top - SizeHeigh(5)) ;
        make.height.mas_equalTo(SizeHeigh(44));
        make.width.mas_equalTo(SizeWidth(100));
    }];
    
    
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeigh(54))];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.font = SourceHanSansCNMedium(13);
        _infoLab.text = @"应付:";
        _infoLab.textColor = UIColorFromHex(0x333333);
    }
    return _infoLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = VerdanaBold(18);
        _priceLab.textColor = UIColorFromHex(0x333333);
        _priceLab.text = @"￥12.80";
    }
    return _priceLab;
}

- (UILabel *)balanceLab {
    if (!_balanceLab) {
        _balanceLab = [[UILabel alloc] init];
        _balanceLab.textColor = UIColorFromHex(0x999999);
        _balanceLab.font = Verdana(11);
        _balanceLab.text = @"账户余额：￥120.00";
    }
    return _balanceLab;
}

- (void)topupClick:(UIButton *)sender {
    if (self.topupBlock) {
        self.topupBlock();
    }
}

- (UIButton *)topUpBtn {
    if (!_topUpBtn) {
        _topUpBtn = [[UIButton alloc] init];
        _topUpBtn.backgroundColor = [UIColor clearColor];
        [_topUpBtn setTitle:@"充值优惠" forState:UIControlStateNormal];
        [_topUpBtn setTitleColor:UIColorFromHex(0x3e7bb1) forState:UIControlStateNormal];
        _topUpBtn.titleLabel.font = NormalFont(11);
        [_topUpBtn addTarget:self action:@selector(topupClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topUpBtn;
}

- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [[UIButton alloc] init];
        _payBtn.layer.masksToBounds = YES;
        _payBtn.layer.cornerRadius  = SizeWidth(5);
        [_payBtn setTitleColor:UIColorFromHex(0xeeeeee) forState:UIControlStateNormal];
        [_payBtn setTitle:@"还差8元起送" forState:UIControlStateNormal];
        _payBtn.backgroundColor = MainBlue;
        _payBtn.titleLabel.font = SourceHanSansCNRegular(13);
        [_payBtn addTarget:self action:@selector(payBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (void)payBtnClick:(UIButton *)sender {
    if (self.payBlock) {
        self.payBlock();
    }
}

- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(20), SizeWidth(16), SizeWidth(16))];
        _logoImage.backgroundColor = [UIColor clearColor];
        _logoImage.image = [UIImage imageNamed:@"icon_tx"];
    }
    return _logoImage;
}

- (UILabel *)moreLab {
    if (!_moreLab) {
        _moreLab = [[UILabel alloc] initWithFrame:FRAME(self.logoImage.right, SizeHeigh(20), kScreenW/2, SizeHeigh(15))];
        _moreLab.font = SourceHanSansCNRegular(12);
        _moreLab.textColor = UIColorFromHex(0x999999);
        _moreLab.text = @"收货地址超出配送范围,无法配送";
    }
    return _moreLab;
}

@end

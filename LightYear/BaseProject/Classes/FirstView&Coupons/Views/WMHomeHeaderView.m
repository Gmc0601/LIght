//
//  WMHomeHeaderView.m
//  BaseProject
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "WMHomeHeaderView.h"

@interface WMHomeHeaderView()

@property (nonatomic, strong) UIImageView *localImageV;
@property (nonatomic, strong) UIButton *otherBtn;
@property (nonatomic, strong) UIButton *goodsBtn;
@property (nonatomic, strong) UIButton *memberBtn;
@property (nonatomic, strong) UILabel *goodsLabel;
@property (nonatomic, strong) UILabel *memberLabel;
@property (nonatomic, strong) UIView *lineV;
@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation WMHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.localImageV];
        [self addSubview:self.addressLabel];
        [self addSubview:self.otherBtn];
        [self addSubview:self.lineV];
        [self addSubview:self.goodsBtn];
        [self addSubview:self.memberBtn];
        [self addSubview:self.goodsLabel];
        [self addSubview:self.memberLabel];
        [self addSubview:self.promptLabel];
    }
    return self;
}
#pragma mark - btnClick
- (void)otherBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(callbackOtherClick)]) {
        [self.delegate callbackOtherClick];
    }
}

- (void)goodsBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(callbackGoodsClick)]) {
        [self.delegate callbackGoodsClick];
    }
}

- (void)memberBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(callbackMemberClick)]) {
        [self.delegate callbackMemberClick];
    }
}

#pragma mark - lazyLoad
- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake( _localImageV.origin.x+_localImageV.width+SizeWidth(10), 0, SizeWidth(185), SizeHeigh(20))];
        _addressLabel.centerY = _localImageV.centerY;
        _addressLabel.font = SourceHanSansCNMedium(SizeWidth(18));
        _addressLabel.textColor = UIColorFromHex(0x333333);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.text = @"12e123k123";
    }
    return _addressLabel;
}

- (UIImageView *)localImageV {
    if (!_localImageV) {
        _localImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(85), SizeHeigh(21), SizeWidth(14.5), SizeHeigh(17))];
        _localImageV.image = [UIImage imageNamed:@"icon_dw"];
    }
    return _localImageV;
}

- (UIButton *)otherBtn {
    if (!_otherBtn) {
        _otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _addressLabel.origin.y+_addressLabel.height+SizeHeigh(15), SizeWidth(120), SizeHeigh(16))];
        _otherBtn.centerX = self.width/2;
        [_otherBtn.titleLabel setFont:SourceHanSansCNRegular(SizeWidth(12))];
        [_otherBtn setTitle:@"其他门店" forState:UIControlStateNormal];
        [_otherBtn setTitleColor:UIColorFromHex(0x3e7bb1) forState:UIControlStateNormal];
        [_otherBtn addTarget:self action:@selector(otherBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _otherBtn;
}

- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, _otherBtn.origin.y+_otherBtn.height+SizeHeigh(41.5), SizeWidth(0.5), SizeHeigh(41))];
        _lineV.centerX = self.width/2;
        _lineV.backgroundColor = UIColorFromHex(0xe0e0e0);
    }
    return _lineV;
}

- (UIButton *)goodsBtn {
    if (!_goodsBtn) {
        _goodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2-SizeWidth(82.5), _otherBtn.origin.y+_otherBtn.height+SizeHeigh(37), SizeWidth(25), SizeHeigh(35))];
        [_goodsBtn setBackgroundImage:[UIImage imageNamed:@"icon_sy_xsp"] forState:UIControlStateNormal];
        [_goodsBtn addTarget:self action:@selector(goodsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goodsBtn;
}

- (UIButton *)memberBtn {
    if (!_memberBtn) {
        _memberBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width/2+SizeWidth(49.5), _otherBtn.origin.y+_otherBtn.height+SizeHeigh(37), SizeWidth(44), SizeHeigh(35))];
        [_memberBtn setBackgroundImage:[UIImage imageNamed:@"icon_sy_hyk"] forState:UIControlStateNormal];
        [_memberBtn addTarget:self action:@selector(memberBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _memberBtn;
}

- (UILabel *)goodsLabel {
    if (!_goodsLabel) {
        _goodsLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _goodsBtn.origin.y+_goodsBtn.height+SizeHeigh(5), SizeWidth(100), SizeHeigh(12))];
        _goodsLabel.centerX = _goodsBtn.centerX;
        _goodsLabel.font = SourceHanSansCNRegular(SizeWidth(10));
        _goodsLabel.textColor = UIColorFromHex(0x999999);
        _goodsLabel.textAlignment = NSTextAlignmentCenter;
        _goodsLabel.text = @"商品";
    }
    return _goodsLabel;
}

- (UILabel *)memberLabel {
    if (!_memberLabel) {
        _memberLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _memberBtn.origin.y+_memberBtn.height+SizeHeigh(5), SizeWidth(100), SizeHeigh(12))];
        _memberLabel.centerX = _memberBtn.centerX;
        _memberLabel.font = SourceHanSansCNRegular(SizeWidth(10));
        _memberLabel.textColor = UIColorFromHex(0x999999);
        _memberLabel.textAlignment = NSTextAlignmentCenter;
        _memberLabel.text = @"会员";
    }
    return _memberLabel;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, _goodsLabel.origin.y+_goodsLabel.height+SizeHeigh(30), SizeWidth(185), SizeHeigh(20))];
        _promptLabel.centerX = self.width/2;
        _promptLabel.font = SourceHanSansCNMedium(SizeWidth(15));
        _promptLabel.textColor = UIColorFromHex(0x333333);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.text = @"优惠和活动";
    }
    return _promptLabel;
}

@end

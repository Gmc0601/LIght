//
//  RechargeInfoCell.m
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "RechargeInfoCell.h"

@interface RechargeInfoCell ()

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *couponLabel;
@property (nonatomic, strong) UILabel *giveMoneyLabel;
@property (nonatomic, strong) UIView *lineV;

@end

@implementation RechargeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.size = CGSizeMake(kScreenW, SizeHeigh(65));
        self.contentView.size = CGSizeMake(kScreenW, SizeHeigh(65));
        [self addSubview:self.lineV];
    }
    return self;
}

- (void)fillWithType:(NSString *)type {
    self.amountLabel.text = @"10";

    if (type) {
        self.giveMoneyLabel.text = @"充值即送5元";
        self.couponLabel.text = @"送满减券";
    } else if ([type isEqualToString:@""]) {
        self.couponLabel.origin = CGPointMake(self.width-SizeWidth(64+31), SizeHeigh(17));
        self.couponLabel.text = @"送满减券";
    } else {
        self.giveMoneyLabel.text = @"充值即送5元";
    }
}

#pragma mark - lazyLoad
- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake( SizeWidth(25), 0, self.width, SizeHeigh(20))];
        _amountLabel.centerY = self.height/2;
        _amountLabel.textColor = UIColorFromHex(0x333333);
        _amountLabel.textAlignment = NSTextAlignmentLeft;
        _amountLabel.font = VerdanaBold(SizeWidth(15));
        [self addSubview:_amountLabel];
    }
    return _amountLabel;
}

- (UILabel *)giveMoneyLabel {
    if (!_giveMoneyLabel) {
        _giveMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.width-SizeWidth(76+31), 0, SizeWidth(76), SizeHeigh(17))];
        _giveMoneyLabel.backgroundColor = UIColorFromHex(0xff543a);
        _giveMoneyLabel.layer.masksToBounds = YES;
        _giveMoneyLabel.layer.cornerRadius = SizeWidth(2.5);
        _giveMoneyLabel.centerY = self.height/2;
        _giveMoneyLabel.font = SourceHanSansCNRegular(SizeWidth(12));
        _giveMoneyLabel.textColor = UIColorFromHex(0xffffff);
        _giveMoneyLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_giveMoneyLabel];
    }
    return _giveMoneyLabel;
}

- (UILabel *)couponLabel {
    if (!_couponLabel) {
        _couponLabel = [[UILabel alloc] initWithFrame:CGRectMake( _giveMoneyLabel.origin.x-SizeWidth(69), 0, SizeWidth(64), SizeHeigh(17))];
        _couponLabel.backgroundColor = UIColorFromHex(0xff543a);
        _couponLabel.layer.masksToBounds = YES;
        _couponLabel.layer.cornerRadius = SizeWidth(2.5);
        _couponLabel.centerY = self.height/2;
        _couponLabel.font = SourceHanSansCNRegular(SizeWidth(12));
        _couponLabel.textColor = UIColorFromHex(0xffffff);
        _couponLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_couponLabel];
    }
    return _couponLabel;
}

- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectMake((self.width-SizeWidth(343))/2, self.height-SizeHeigh(0.5), SizeWidth(343), SizeHeigh(0.5))];
        _lineV.backgroundColor = UIColorFromHex(0xe0e0e0);
    }
    return _lineV;
}

@end

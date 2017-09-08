//
//  CouponTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CouponTableViewCell.h"

@implementation CouponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.addView];
        [self.addView addSubview:self.couponLab];
    }
    return self;
}

- (UIView *)addView {
    if (!_addView) {
        _addView = [[UIView alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(5), kScreenW - SizeWidth(30), SizeHeigh(75))];
        _addView.backgroundColor = UIColorFromHex(0x87bafe);
        _addView.layer.masksToBounds = YES;
        _addView.layer.cornerRadius = SizeHeigh(5);
    }
    return _addView;
}

- (UILabel *)couponLab {
    if (!_couponLab) {
        _couponLab  = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(30), SizeHeigh(17), kScreenW - SizeWidth(90), SizeHeigh(20))];
        _couponLab.textColor = [UIColor whiteColor];
        _couponLab.font = SourceHanSansCNBold(24);
        _couponLab.text = @"100元优惠券";
    }
    return _couponLab;
}

@end

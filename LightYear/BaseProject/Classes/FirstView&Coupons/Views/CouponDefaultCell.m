//
//  CouponDefaultCell.m
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CouponDefaultCell.h"

@interface CouponDefaultCell ()

@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *stateLabel;

@end

@implementation CouponDefaultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.size = CGSizeMake(kScreenW, SizeHeigh(74));
        self.contentView.size = CGSizeMake(kScreenW, SizeHeigh(74));
    }
    return self;
}

- (void)fillWith:(BOOL)isSelectList {
    if (isSelectList) {
        self.titleLabel.textColor = RGBColor(159, 158, 158);
        self.stateLabel.text = @"已过期";
    }
    self.titleLabel.text = @"10元优惠券";
}

#pragma mark - lazyLoad
- (UIImageView *)bgImageV {
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeHeigh(10), kScreenW-SizeWidth(30), SizeHeigh(203))];
        _bgImageV.backgroundColor = [UIColor orangeColor];
        _bgImageV.layer.masksToBounds = YES;
        _bgImageV.layer.cornerRadius = SizeWidth(2.5);
    }
    return _bgImageV;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(27), SizeHeigh(15), SizeWidth(180), SizeHeigh(25))];
        _titleLabel.font = SourceHanSansCNBold(SizeWidth(24));
        _titleLabel.textColor = UIColorFromHex(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-SizeWidth(145), SizeHeigh(30), SizeWidth(120), SizeHeigh(20))];
        _stateLabel.font = SourceHanSansCNMedium(SizeWidth(13));
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.textColor = UIColorFromHex(0xffffff);
    }
    return _stateLabel;
}

@end

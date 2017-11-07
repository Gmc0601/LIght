//
//  SelectShopCell.m
//  BaseProject
//
//  Created by wmk on 2017/9/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "SelectShopCell.h"

@interface SelectShopCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SelectShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.size = CGSizeMake( kScreenW, SizeHeigh(68));
        self.contentView.size = CGSizeMake( kScreenW, SizeHeigh(68));
        [self addSubview:self.titleLabel];
        [self addSubview:self.distanceLabel];
        [self addSubview:self.addressLabel];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)fillWithData:(ShopListInfo *)info {
    self.titleLabel.text = info.shopname;
    self.distanceLabel.text = [NSString stringWithFormat:@"据您%.2fkm",info.distance];
    self.addressLabel.text = info.address;
}

#pragma mark - lazyLoad
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeHeigh(15), SizeWidth(200), SizeHeigh(20))];
        _titleLabel.font = SourceHanSansCNMedium(SizeWidth(15));
        _titleLabel.textColor = UIColorFromHex(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-SizeWidth(15)-SizeWidth(100), SizeHeigh(15), SizeWidth(100), SizeHeigh(20))];
        _distanceLabel.font = SourceHanSansCNMedium(SizeWidth(13));
        _distanceLabel.textColor = UIColorFromHex(0x666666);
        _distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), _titleLabel.origin.y+_titleLabel.height+SizeHeigh(10), self.contentView.width-SizeWidth(30), SizeHeigh(20))];
        _addressLabel.font = SourceHanSansCNRegular(SizeWidth(13));
        _addressLabel.textColor = UIColorFromHex(0x999999);
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _addressLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(SizeWidth(15), self.contentView.height-0.5, self.contentView.width-SizeWidth(30), 0.5)];
        _lineView.backgroundColor = UIColorFromHex(0xe0e0e0);
    }
    return _lineView;
}


@end

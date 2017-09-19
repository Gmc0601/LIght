//
//  OrderAddressTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderAddressTableViewCell.h"
#import "Masonry.h"

@implementation OrderAddressTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorFromHex(0xf1f2f2);
        [self createView];
    }
    return self;
}

- (void)createView {
    [self.contentView addSubview:self.addLogo];
    [self.contentView addSubview:self.addaddresslab];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.phoneLab];
    [self.contentView addSubview:self.addressLab];
    [self.contentView addSubview:self.moreLab];
}

- (UIImageView *)addLogo {
    if (!_addLogo) {
        _addLogo = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(35), SizeWidth(22), SizeHeigh(22))];
        _addLogo.backgroundColor = [UIColor clearColor];
        _addLogo.image = [UIImage imageNamed:@"icon_zj"];
    }
    return _addLogo;
}

- (UILabel *)addaddresslab {
    if (!_addaddresslab) {
        _addaddresslab = [[UILabel alloc] initWithFrame:FRAME(self.addLogo.right + SizeWidth(10), SizeHeigh(35), kScreenW/2, SizeWidth(20))];
        _addaddresslab.font = SourceHanSansCNRegular(15);
        _addaddresslab.textColor = UIColorFromHex(0x333333);
        _addaddresslab.text = @"添加收货地址";
        _addaddresslab.backgroundColor = [UIColor clearColor];
    }
    return _addaddresslab;
}


- (UILabel *)moreLab {
    if (!_moreLab) {
        _moreLab = [[UILabel alloc] init];
        _moreLab.backgroundColor = [UIColor clearColor];
        _moreLab.text = @">";
        _moreLab.textColor = RGBColor(239, 240, 241);
    }
    return _moreLab;
}


@end

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

- (void)updateinfo:(Receiptinfo *)model {
    self.nameLab.text = model.username;
    self.phoneLab.text = model.phone;
    self.addressLab.text = model.address;
}

- (void)update:(OrderAddressCellType)type {
    if (type == Order_haveAddress) {
        self.addLogo.hidden = YES;
        self.addaddresslab.hidden = YES;
        self.moreLab.hidden = YES;
        self.nameLab.hidden = NO;
        self.phoneLab.hidden = NO;
        self.addressLab.hidden = NO;
        [self updateFrame];
    }else if(type == Order_withoutAddress){
        self.nameLab.hidden = YES;
        self.phoneLab.hidden = YES;
        self.addressLab.hidden = YES;
        self.addLogo.hidden = NO;
        self.addaddresslab.hidden = NO;
        self.moreLab.hidden = NO;
    }else {
        self.nameLab.hidden = YES;
        self.phoneLab.hidden = YES;
        self.addressLab.hidden = YES;
        self.addLogo.hidden = YES;
        self.addaddresslab.hidden = YES;
        self.moreLab.hidden = YES;
    }
}

- (void)updateFrame {
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(SizeWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(SizeHeigh(20));
        make.height.mas_equalTo(SizeHeigh(15));
    }];
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right).offset(SizeWidth(10));
        make.top.equalTo(self.contentView.mas_top).offset(SizeHeigh(20));
        make.height.mas_equalTo(SizeHeigh(15));
    }];
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(SizeWidth(15));
        make.top.equalTo(self.nameLab.mas_bottom).offset(SizeHeigh(5));
        make.right.equalTo(self.contentView.mas_right).offset(-SizeWidth(15));
        make.height.mas_equalTo(SizeHeigh(15));
    }];
}

- (void)createView {
    [self.contentView addSubview:self.addLogo];
    [self.contentView addSubview:self.addaddresslab];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.phoneLab];
    [self.contentView addSubview:self.addressLab];
    [self.contentView addSubview:self.moreLab];
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = SourceHanSansCNMedium(14);
        _nameLab.text = @"我是名";
    }
    return _nameLab;
}

- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [[UILabel alloc] init];
        _phoneLab.font = Verdana(14);
        _phoneLab.text = @"11011011011011";
    }
    return _phoneLab;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] init];
        _addressLab.font = SourceHanSansCNRegular(14);
        _addressLab.textColor = UIColorFromHex(0x333333);
        _addressLab.text = @"浙江省杭州市和地沟挖地雷的";
    }
    return _addressLab;
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
        _addaddresslab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(50), SizeHeigh(35), kScreenW/2, SizeWidth(20))];
        _addaddresslab.font = SourceHanSansCNRegular(15);
        _addaddresslab.textColor = UIColorFromHex(0x333333);
        _addaddresslab.text = @"添加收货地址";
        _addaddresslab.backgroundColor = [UIColor clearColor];
    }
    return _addaddresslab;
}


- (UILabel *)moreLab {
    if (!_moreLab) {
        _moreLab = [[UILabel alloc] initWithFrame:FRAME(kScreenW - SizeWidth(28), SizeHeigh(30), SizeWidth(13), SizeHeigh(20))];
        _moreLab.backgroundColor = [UIColor clearColor];
        _moreLab.text = @">";
        _moreLab.textColor = UIColorFromHex(0x999999);
    }
    return _moreLab;
}


@end

//
//  OrderStoreInfoTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/9/25.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderStoreInfoTableViewCell.h"
#import "UIView+Utils.h"

@implementation OrderStoreInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = RGBColor(239, 240, 241);
        [self createview];
    }
    return self;
}

- (void)updateinfo:(ShopInfo *)model {
    self.storeNameLab.text = model.shopname;
    self.storeAddressLab.text = model.address;
    NSString *str1 = [NSString stringWithFormat:@"工作日：%@ - %@", model.startdate,  model.enddate];
    NSString *str2 = [NSString stringWithFormat:@"节假日：%@ - %@", model.hstartdate,  model.henddate];
    self.workTimeLab.text = str1;
    self.holidayLab.text = str2;
}

- (void)createview {
    [self.contentView addSubview:self.storeNameLab];
    [self.contentView addSubview:self.storeAddressLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.workTimeLab];
    [self.contentView addSubview:self.holidayLab];
}

- (UILabel *)storeNameLab {
    if (!_storeNameLab) {
        _storeNameLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(20), kScreenW - SizeWidth(30), SizeHeigh(15))];
        _storeNameLab.font = SourceHanSansCNMedium(15);
        _storeNameLab.textColor = UIColorFromHex(0x333333);
        _storeNameLab.backgroundColor = [UIColor clearColor];
        _storeNameLab.text = @"光年浙工店";
    }
    return _storeNameLab;
}

- (UILabel *)storeAddressLab {
    if (!_storeAddressLab) {
        _storeAddressLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), self.storeNameLab.bottom + SizeHeigh(10), kScreenW - SizeWidth(30), SizeHeigh(15))];
        _storeAddressLab.font = SourceHanSansCNRegular(13);
        _storeAddressLab.textColor = UIColorFromHex(0x333333);
        _storeAddressLab.backgroundColor = [UIColor clearColor];
        _storeAddressLab.text = @"那个我欧尼扫地杆欧舒丹工农ad感受到了";
    }
    return _storeAddressLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), self.storeAddressLab.bottom + SizeHeigh(15), kScreenW - SizeWidth(30), SizeHeigh(15))];
        _timeLab.backgroundColor = [UIColor clearColor];
        _timeLab.font = SourceHanSansCNMedium(15);
        _timeLab.textColor = UIColorFromHex(0x333333);
        _timeLab.text = @"营业时间";
    }
    return _timeLab;
}

- (UILabel *)workTimeLab {
    if (!_workTimeLab) {
        _workTimeLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), self.timeLab.bottom + SizeHeigh(10), kScreenW - SizeWidth(30), SizeHeigh(15))];
        _workTimeLab.backgroundColor = [UIColor clearColor];
        _workTimeLab.font = SourceHanSansCNRegular(13);
        _workTimeLab.text = @"工作日：19：00 - 18：00";
        _workTimeLab.textColor = UIColorFromHex(0x333333);
    }
    return _workTimeLab;
}

- (UILabel *)holidayLab {
    if (!_holidayLab) {
        _holidayLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), self.workTimeLab.bottom + SizeHeigh(10), kScreenW - SizeWidth(30), SizeHeigh(15))];
        _holidayLab.backgroundColor = [UIColor clearColor];
        _holidayLab.font = SourceHanSansCNRegular(13);
        _holidayLab.textColor = UIColorFromHex(0x333333);
        _holidayLab.text = @"节假日日：19：00 - 18：00";
    }
    return _holidayLab;
}




@end

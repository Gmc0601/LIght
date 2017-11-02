//
//  OrderGoodsTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderGoodsTableViewCell.h"
#import "UIView+Frame.h"
@implementation OrderGoodsTableViewCell
//  160
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)updateinfo:(NSDictionary *)dic {
    
    NSString *num = [NSString stringWithFormat:@"%@x",dic[@"count"]];
    NSString *pic = dic[@"img_path"];
    NSString *name, *des;
    if([dic[@"good_name"] isEqual:[NSNull null]] || dic[@"good_name"] == nil){
        name = nil;
    }else {
        name = [NSString stringWithFormat:@"%@", dic[@"good_name"]];
    }
    if([dic[@"sku"] isEqual:[NSNull null]] || dic[@"sku"] == nil){
        des = nil;
    }else {
        des = [NSString stringWithFormat:@"%@", dic[@"sku"]];
    }
    NSString *price = [NSString stringWithFormat:@"￥%.2f",[dic[@"price"] floatValue]];
    
    self.numLab.text = num;
    [self.goodsPic sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:nil];
    self.titleLab.text = name;
    self.desLab.text = des;
    self.priceLab.text = price;
    
}

- (void)createView {
    
    [self.contentView addSubview:self.numLab];
    [self.contentView addSubview:self.goodsPic];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.desLab];
    [self.contentView addSubview:self.taglab1];
    [self.contentView addSubview:self.taglab2];
    [self.contentView addSubview:self.priceLab];
    [self.contentView addSubview:self.lineLab];
    
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(70), SizeWidth(30), SizeHeigh(15))];
        _numLab.font = VerdanaBold(18);
        _numLab.text = @"2x";
    }
    return _numLab;
}

- (UIImageView *)goodsPic {
    if (!_goodsPic) {
        _goodsPic = [[UIImageView alloc] initWithFrame:FRAME(self.numLab.right + SizeWidth(15), SizeHeigh(30), SizeWidth(100), SizeHeigh(100))];
        _goodsPic.backgroundColor = [UIColor grayColor];
    }
    return _goodsPic;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(self.goodsPic.right + SizeWidth(15), SizeHeigh(30), SizeWidth(190), SizeHeigh(20))];
        _titleLab.font = SourceHanSansCNMedium(15);
        _titleLab.text = @"你好年年豆豆的豆豆的";
    }
    return _titleLab;
}

- (UILabel *)desLab {
    if (!_desLab) {
        _desLab = [[UILabel alloc] initWithFrame:FRAME(self.goodsPic.right + SizeWidth(15), self.titleLab.bottom + SizeHeigh(10), SizeWidth(190), SizeHeigh(15))];
        _desLab.font = SourceHanSansCNRegular(13);
        _desLab.textColor = UIColorFromHex(0x333333);
        _desLab.text = @"加冰，去沙";
    }
    return _desLab;
}

- (UILabel *)taglab1 {
    if (!_taglab1) {
        _taglab1 = [[UILabel alloc] initWithFrame:FRAME(self.goodsPic.right + SizeWidth(15), self.desLab.bottom + SizeHeigh(10), SizeWidth(30), SizeHeigh(10))];
        _taglab1.layer.masksToBounds = YES;
        _taglab1.layer.borderWidth = 1;
        _taglab1.layer.borderColor = [UIColorFromHex(0x4ead35) CGColor];
        _taglab1.textColor = UIColorFromHex(0x4ead35);
        _taglab1.font = NormalFont(11);
        _taglab1.textAlignment = NSTextAlignmentCenter;
        _taglab1.text = @"配送";
    }
    return _taglab1;
}

- (UILabel *)taglab2 {
    if (!_taglab2) {
        _taglab2 = [[UILabel alloc] initWithFrame:FRAME(self.taglab1.right + SizeWidth(10), self.desLab.bottom + SizeHeigh(10), SizeWidth(30), SizeHeigh(10))];
        _taglab2.layer.masksToBounds = YES;
        _taglab2.layer.borderWidth = 1;
        _taglab2.layer.borderColor = [UIColorFromHex(0x4ead35) CGColor];
        _taglab2.textColor = UIColorFromHex(0x4ead35);
        _taglab2.font = NormalFont(11);
        _taglab2.textAlignment = NSTextAlignmentCenter;
        _taglab2.text = @"自取";
    }
    return _taglab2;
}

- (UILabel *)priceLab  {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] initWithFrame:FRAME(self.goodsPic.right + SizeWidth(15), self.taglab1.bottom + SizeHeigh(15), SizeWidth(190), SizeHeigh(25))];
        _priceLab.font = VerdanaBold(SizeHeigh(24));
        _priceLab.text = @"￥12.80";
    }
    return _priceLab;
}

- (UILabel *)lineLab {
    if (!_lineLab) {
        _lineLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(159), kScreenW - SizeWidth(30), SizeHeigh(1))];
        _lineLab.backgroundColor = RGBColor(239, 240, 241);
    }
    return _lineLab;
}

@end

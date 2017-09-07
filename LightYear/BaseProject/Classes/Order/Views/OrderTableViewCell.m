//
//  OrderTableViewCell.m
//  BaseProject
//
//  Created by cc on 2017/9/7.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createCell];
    }
    return self;
}

- (void)changeCellType:(OrderCellType)type {
    NSString *stateStr, *btnStr;
    
    switch (type) {
        case Order_Topay:{// 待支付
            stateStr = @"待支付";
            btnStr = @"立即支付";
            [self.clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.clickBtn.backgroundColor = MainRed;
        }
            break;
        case Order_Distribution:{// 待配送
            stateStr = @"待配送";
            self.clickBtn.hidden = YES;
        }
            break;
        case Order_Distributioning:{// 配送中
            stateStr = @"配送中";
            self.clickBtn.hidden = YES;
            self.dislab.hidden = NO;
        }
            break;
        case Order_Invite:{// 待自取
            stateStr = @"待自取";
            btnStr = @"取货码";
            self.clickBtn.backgroundColor = MainBlue;
            [self.clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case Order_Finished:{// 已完成
            stateStr = @"已完成";
            btnStr = @"再来一单";
            self.clickBtn.backgroundColor  = MainYellow;
            [self.clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case Order_Cancle:{// 已取消
            stateStr = @"已取消";
            btnStr = @"再来一单";
            self.clickBtn.backgroundColor  = MainYellow;
            [self.clickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
        case Order_Refunding:{// 退款审核中
            stateStr = @"退款审核中";
            self.clickBtn.hidden = YES;
        }
            break;
        case Order_Refundsuccess:{// 退款成功
            stateStr = @"退款成功";
            self.clickBtn.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    self.stateLab.text = stateStr;
    [self.clickBtn setTitle:btnStr forState:UIControlStateNormal];
}

- (void)changeFoodviewType:(FoodViewType)type {
    if (type == Foods_One) {
        self.foodimageview2.hidden = YES;
    }else {
        self.foodTitleLab.hidden = YES;
        self.foodDesLab.hidden = YES;
    }
}

- (void)createCell {
    [self.contentView addSubview:self.storeNameLab];
    [self.contentView addSubview:self.stateLab];
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.foodimageview1];
    [self.contentView addSubview:self.foodimageview2];
    [self.contentView addSubview:self.foodTitleLab];
    [self.contentView addSubview:self.foodDesLab];
    [self.contentView addSubview:self.foodsNumLab];
    [self.contentView addSubview:self.priceLab];
    [self.contentView addSubview:self.dislab];
    [self.contentView addSubview:self.clickBtn];
    [self.contentView addSubview:self.line2];
}

- (UILabel *)storeNameLab {
    if (!_storeNameLab) {
        _storeNameLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(15), kScreenW/2, SizeHeigh(15))];
        _storeNameLab.font = SourceHanSansCNRegular(15);
        _storeNameLab.text = @"光年浙工商店";
    }
    return _storeNameLab;
}

- (UILabel *)stateLab {
    if (!_stateLab) {
        _stateLab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2, SizeHeigh(15), kScreenW/2 - SizeWidth(15), SizeHeigh(15))];
        _stateLab.font = SourceHanSansCNRegular(12);
        _stateLab.textColor = UIColorFromHex(0x50ae34);
        _stateLab.text = @"状态";
        _stateLab.textAlignment = NSTextAlignmentRight;
    }
    return _stateLab;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] initWithFrame:FRAME(0, SizeHeigh(40), kScreenW, 1)];
        _line1.backgroundColor = RGBColor(239, 240, 241);
    }
    return _line1;
}

- (UIImageView *)foodimageview1 {
    if (!_foodimageview1) {
        _foodimageview1 = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(52), SizeWidth(100), SizeHeigh(100))];
        _foodimageview1.backgroundColor = [UIColor grayColor];
    }
    return _foodimageview1;
}

- (UIImageView *)foodimageview2 {
    if (!_foodimageview2) {
        _foodimageview2 = [[UIImageView alloc] initWithFrame:FRAME(SizeWidth(125), SizeHeigh(53), SizeWidth(100), SizeHeigh(100))];
        _foodimageview2.backgroundColor = [UIColor grayColor];
    }
    return _foodimageview2;
}

- (UILabel *)foodTitleLab {
    if (!_foodTitleLab) {
        _foodTitleLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(125), SizeHeigh(55), kScreenW - SizeWidth(140), SizeHeigh(15))];
        _foodTitleLab.font = SourceHanSansCNMedium(15);
        _foodTitleLab.textColor = UIColorFromHex(0x333333);
        _foodTitleLab.text = @"土豆土豆我是地瓜土豆土豆我是地瓜土豆土豆我是地瓜";
    }
    return _foodTitleLab;
}

- (UILabel *)foodDesLab {
    if (!_foodDesLab) {
        _foodDesLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(125), SizeHeigh(80), kScreenW - SizeWidth(140), SizeHeigh(15))];
        _foodDesLab.textColor = UIColorFromHex(0x666666);
        _foodDesLab.font = SourceHanSansCNRegular(13);
        _foodDesLab.text = @"会冰,会火";
    }
    return _foodDesLab;
}

- (UILabel *)foodsNumLab {
    if (!_foodsNumLab) {
        _foodsNumLab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2 , SizeHeigh(100), kScreenW/2 - SizeWidth(15), SizeHeigh(15))];
        _foodsNumLab.font = SourceHanSansCNRegular(12);
        _foodsNumLab.textColor = UIColorFromHex(0x999999);
        _foodsNumLab.text = @"共你猜件  >";
        _foodsNumLab.textAlignment = NSTextAlignmentRight;
    }
    return _foodsNumLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(15), SizeHeigh(190), kScreenW, SizeHeigh(15))];
        _priceLab.font = VerdanaBold(18);
        _priceLab.textColor = UIColorFromHex(0x333333);
        _priceLab.text = @"待付：￥250.00";
    }
    return _priceLab;
}

- (UILabel *)dislab {
    if (!_dislab) {
        _dislab = [[UILabel alloc] initWithFrame:FRAME(kScreenW/2 , SizeHeigh(190), kScreenW/2 - SizeWidth(15), SizeHeigh(15))];
        _dislab.font = SourceHanSansCNRegular(12);
        _dislab.textColor = UIColorFromHex(0x999999);
        _dislab.textAlignment = NSTextAlignmentRight;
        _dislab.text = @"配送员正在狂奔送货中...";
        _dislab.hidden = YES;
    }
    return _dislab;
}

- (UIButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [[UIButton alloc] initWithFrame:FRAME(kScreenW - SizeWidth(115), SizeHeigh(175), SizeWidth(100), SizeHeigh(45))];
        _clickBtn.layer.masksToBounds = YES;
        _clickBtn.layer.cornerRadius = 5;
        _clickBtn.backgroundColor = MainYellow;
        [_clickBtn addTarget:self action:@selector(clickBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_clickBtn setTitle:@"按钮" forState:UIControlStateNormal];
        [_clickBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _clickBtn.titleLabel.font = SourceHanSansCNRegular(13);
    }
    return _clickBtn;
}

- (void)clickBtnClick:(UIButton *)sender {
    if (self.BtnClickBlock) {
        self.BtnClickBlock();
    }
}


- (UIView *)line2 {
    if (!_line2) {
        _line2 =  [[UIView alloc] initWithFrame:FRAME(0, SizeHeigh(225), kScreenW, SizeHeigh(5))];
        _line2.backgroundColor = RGBColor(239, 240, 241);
    }
    return _line2;
}

@end

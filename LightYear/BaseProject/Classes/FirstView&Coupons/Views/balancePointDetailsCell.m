//
//  balancePointDetailsCell.m
//  BaseProject
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "balancePointDetailsCell.h"

@interface balancePointDetailsCell()

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation balancePointDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.size = CGSizeMake(kScreenW, SizeHeigh(71));
        self.contentView.size = CGSizeMake(kScreenW, SizeHeigh(71));
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.promptLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)fillWithPoint:(integralListInfo *)info {
    if ([info.type isEqualToString:@"1"]) {
        self.promptLabel.text = @"门店购物";
        self.amountLabel.text = [NSString stringWithFormat:@"%@",info.integral];
    } else if ([info.type isEqualToString:@"2"]) {
        self.promptLabel.text = @"线上购物";
        self.amountLabel.text = [NSString stringWithFormat:@"%@",info.integral];
    } else {
        self.promptLabel.text = @"门店消费";
        self.amountLabel.text = [NSString stringWithFormat:@"%@",info.integral];
    }
    self.timeLabel.text = info.create_time;
}

- (void)fillWithBalance:(tradeListInfo *)info {
    if ([info.otype isEqualToString:@"0"]) {
        self.promptLabel.text = @"线上购物";
    } else if ([info.otype isEqualToString:@"1"]) {
        self.promptLabel.text = @"门店购物";
    } else if ([info.otype isEqualToString:@"2"]) {
        self.promptLabel.text = @"线上充值";
    } else if ([info.otype isEqualToString:@"3"]) {
        self.promptLabel.text = @"门店充值";
    } else if ([info.otype isEqualToString:@"4"]){
        self.promptLabel.text = @"充值赠送";
    } else {
        self.promptLabel.text = @"订单退款";
    }
    self.amountLabel.text = [NSString stringWithFormat:@"%@",info.money];
    self.timeLabel.text = info.create_date;
}

#pragma mark - lazyLoad
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeHeigh(18), SizeWidth(150), SizeHeigh(15))];
        _promptLabel.textColor = UIColorFromHex(0x333333);
        _promptLabel.font = SourceHanSansCNRegular(SizeWidth(13));
        _promptLabel.text = @"店内消费";
        _promptLabel.textAlignment = NSTextAlignmentLeft;
        [_promptLabel sizeToFit];
    }
    return _promptLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), CGRectGetMaxY(_promptLabel.frame)+SizeHeigh(10), SizeWidth(240), SizeHeigh(15))];
        _timeLabel.textColor = UIColorFromHex(0xcccccc);
        _timeLabel.font = Verdana(SizeWidth(13));
        _timeLabel.text = @"店内消费";
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectMake( self.width-SizeWidth(165), 0, SizeWidth(150), SizeHeigh(15))];
        _amountLabel.centerY = _promptLabel.centerY;
        _amountLabel.textColor = UIColorFromHex(0x333333);
        _amountLabel.font = VerdanaBold(SizeWidth(13));
        _amountLabel.text = @"+500";
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(SizeWidth(15), self.height-0.5, self.width-SizeWidth(30), 0.5)];
        _lineView.backgroundColor = UIColorFromHex(0xe0e0e0);
    }
    return _lineView;
}

@end

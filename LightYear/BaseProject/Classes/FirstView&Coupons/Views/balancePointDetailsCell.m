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

- (void)fillDataWithModel {
    
}

#pragma mark - lazyLoad
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeHeigh(25), SizeWidth(150), SizeHeigh(15))];
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

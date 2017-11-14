//
//  couponDetailsCell.m
//  BaseProject
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "couponDetailsCell.h"

@interface couponDetailsCell()

@property (nonatomic, strong) UIImageView *bgImageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UIImageView *lineImgeV;
@property (nonatomic, strong) UILabel *timePromptLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation couponDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.size = CGSizeMake(kScreenW, SizeHeigh(213));
        self.contentView.size = CGSizeMake(kScreenW, SizeHeigh(213));
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.bgImageV];
        [self.bgImageV addSubview:self.titleLabel];
        [self.bgImageV addSubview:self.stateLabel];
        [self.bgImageV addSubview:self.promptLabel];
        [self.bgImageV addSubview:self.conditionLabel];
        [self.bgImageV addSubview:self.lineImgeV];
        [self.bgImageV addSubview:self.timePromptLabel];
        [self.bgImageV addSubview:self.timeLabel];
    }
    return self;
}

- (void)fillWith:(BOOL)isExpire {
    if (isExpire) {
        self.stateLabel.text = @"已过期";
    }
    self.titleLabel.text = @"领物券";
    self.promptLabel.text = @"使用条件";
    self.conditionLabel.text = @"到店选择需要领取的物品";
    self.timePromptLabel.text = @"过期时间";
    self.timeLabel.text = @"2017-09-01 24点前";
}

- (void)fillWithModel:(CouponInfo *)info WithExpire:(BOOL)isExpire{
    [_bgImageV sd_setImageWithURL:[NSURL URLWithString:info.img]];
    if (isExpire) {
        self.stateLabel.text = @"已过期";
    } else {
        self.stateLabel.text = @"";
    }
    if ([info.full_type isEqualToString:@"1"]) {
        self.conditionLabel.text = [NSString stringWithFormat:@"订单金额满%@优惠%@",info.condition,info.denomination];
        self.titleLabel.text = [NSString stringWithFormat:@"%@元优惠券",info.denomination];
    } else {
        self.conditionLabel.text = @"到店选择需要领取的物品";
        self.titleLabel.text = @"领物券";
    }
    self.promptLabel.text = @"使用条件";
    self.timePromptLabel.text = @"过期时间";
    self.timeLabel.text = info.end_time;
}

- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, UIColorFromHex(0x80f9f9f9).CGColor);
    CGContextSetLineDash(line, 0, lengths, 1); //画虚线
    CGContextMoveToPoint(line, 0.0, 1.0); //开始画线
    CGContextAddLineToPoint(line, kScreenW - 10, 1.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark - lazyLoad
- (UIImageView *)bgImageV {
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(15), SizeHeigh(10), kScreenW-SizeWidth(30), SizeHeigh(203))];
        _bgImageV.backgroundColor = [UIColor orangeColor];
        _bgImageV.contentMode = UIViewContentModeScaleToFill;
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
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-SizeWidth(160), SizeHeigh(30), SizeWidth(120), SizeHeigh(20))];
        _stateLabel.font = SourceHanSansCNMedium(SizeWidth(13));
        _stateLabel.textAlignment = NSTextAlignmentRight;
        _stateLabel.textColor = UIColorFromHex(0xffffff);
    }
    return _stateLabel;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.origin.x, SizeHeigh(87), SizeWidth(120), SizeHeigh(20))];
        _promptLabel.font = PingFangSCMedium(SizeWidth(12));
        _promptLabel.textAlignment = NSTextAlignmentLeft;
        _promptLabel.textColor = UIColorFromHex(0xe6f9f9f9);
    }
    return _promptLabel;
}

- (UILabel *)conditionLabel {
    if (!_conditionLabel) {
        _conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.origin.x, SizeHeigh(109), SizeWidth(200), SizeHeigh(20))];
        _conditionLabel.font = PingFangSCMedium(SizeWidth(13));
        _conditionLabel.textAlignment = NSTextAlignmentLeft;
        _conditionLabel.textColor = UIColorFromHex(0xffffff);
    }
    return _conditionLabel;
}

- (UIImageView *)lineImgeV {
    if (!_lineImgeV) {
        _lineImgeV = [[UIImageView alloc] initWithFrame:CGRectMake( 0, SizeHeigh(138), self.width, 1)];
        _lineImgeV.image = [self drawLineByImageView:_lineImgeV];
    }
    return _lineImgeV;
}

- (UILabel *)timePromptLabel {
    if (!_timePromptLabel) {
        _timePromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.origin.x, SizeHeigh(148), SizeWidth(120), SizeHeigh(20))];
        _timePromptLabel.font = PingFangSCMedium(SizeWidth(12));
        _timePromptLabel.textAlignment = NSTextAlignmentLeft;
        _timePromptLabel.textColor = UIColorFromHex(0xe6f9f9f9);
    }
    return _timePromptLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.origin.x, SizeHeigh(170), SizeWidth(200), SizeHeigh(20))];
        _timeLabel.font = PingFangSCMedium(SizeWidth(13));
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = UIColorFromHex(0xffffff);
    }
    return _timeLabel;
}


@end

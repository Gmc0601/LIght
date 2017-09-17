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
        
    }
    return self;
}

#pragma mark - lazyLoad
- (UIImageView *)bgImageV {
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SizeWidth(15), 0, kScreenW-SizeWidth(30), SizeHeigh(203))];
        _bgImageV.backgroundColor = [UIColor orangeColor];
    }
    return _bgImageV;
}

- (UILabel *)titleLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SizeWidth(27), SizeHeigh(15), SizeWidth(180), SizeHeigh(25))];
        _timeLabel.font = SourceHanSansCNBold(SizeWidth(24));
//        _timeLabel.
    }
    return _timeLabel;
}

@end

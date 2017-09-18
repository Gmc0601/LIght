//
//  FeedBackTableViewCell.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FeedBackTableViewCell.h"

@interface FeedBackTableViewCell ()
{
    UIView * baseView;
    UILabel * timeLabel;
    UILabel * tipLabel;
    UILabel * contentLabel;
    UIButton * moreButton;
}

@end

@implementation FeedBackTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeView];
    }
    return self;
}
- (void)makeView{
    baseView = [UIView new];
    baseView.layer.cornerRadius = 4.0f;
    baseView.layer.masksToBounds = YES;
    baseView.backgroundColor = UIColorFromHex(0xf4f4f4);
    [self.contentView addSubview:baseView];
    [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
    
    timeLabel = [UILabel new];
    timeLabel.text = @"06-27";
    timeLabel.font = [UIFont systemFontOfSize:16];
    timeLabel.textColor = [UIColor grayColor];
    [baseView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.top.mas_offset(15);
    }];
    
    UILabel * currentLabel;
    for (int i = 0; i < 2; i++) {
        tipLabel = [UILabel new];
        tipLabel.text = @[@"Q:",@"A:"][i];
        tipLabel.font = VerdanaBoldItalic(26);
        tipLabel.textColor = [UIColor blackColor];
        [baseView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            if (i == 0) {
                make.top.mas_equalTo(timeLabel.mas_bottom).offset(15);
            }else{
                make.top.mas_equalTo(currentLabel.mas_bottom).offset(15);
            }
        }];
        
        contentLabel = [UILabel new];
        contentLabel.numberOfLines = 0;
        contentLabel.text = @[@"小米MIX 2全陶瓷尊享版上手组图曝光IT之家9月17日消息 9月11日下午，小米在北京工业大学体育馆召开了新品发布会，发布了全面屏2.0手机小米MIX 2，售价3299元起",@"据官方介绍，小米MIX2尊享版就像一整块浑然天成的玉。工艺难度和成本也超乎想象。每一块Unibody全陶瓷都要经过1400℃高温7天烧结；两层楼高的设备，240吨冲压成型；金刚砂刀头0.01mm反复雕琢，每加工一部手机，都要更换刀头。"][i];
        contentLabel.font = [UIFont systemFontOfSize:16];
        contentLabel.textColor = UIColorFromHex(0x666666);
        [baseView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.right.mas_offset(-10);
            make.top.mas_equalTo(tipLabel.mas_bottom).offset(10);
        }];
        currentLabel = contentLabel;
    }
    
    moreButton = [UIButton new];
    [moreButton setImage:[UIImage imageNamed:@"sg_ic_down_up"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"sg_ic_down"] forState:UIControlStateSelected];
    [moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(currentLabel.mas_bottom).offset(10);
        make.bottom.mas_offset(-10);
        make.centerX.mas_offset(0);
    }];
}
- (void)setModel:(FeedBackModel *)model{
    if (model.isLookMore == YES) {
        moreButton.selected = YES;
    }else{
        moreButton.selected = NO;
    }
}
- (void)moreButtonAction:(UIButton *)button{
    button.selected = ! button.selected;
    if ([self.delegate respondsToSelector:@selector(didFeedBackTableViewCellMoreButton:)]) {
        [self.delegate didFeedBackTableViewCellMoreButton:button];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

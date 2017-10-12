//
//  FeedBackTableViewCell.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FeedBackTableViewCell.h"
#import "NSString+DisplayTime.h"
#import "UILabel+Width.h"

@interface FeedBackTableViewCell ()
{
    UIView * baseView;
    UILabel * timeLabel;
    UILabel * tipLabel;
    UILabel * questionLabel;
    UILabel * answerLabel;
    UIButton * moreButton;
}

@end

@implementation FeedBackTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
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
        make.top.mas_offset(0);
        make.bottom.mas_offset(-15);
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
        
        UILabel * contentLabel = [UILabel new];
        if (i == 0) {
            questionLabel = contentLabel;
        }else{
            answerLabel = contentLabel;
        }
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
    moreButton.hidden = YES;
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
- (void)setModel:(FeedBackInfo *)model{
    CGFloat  labelHeightOne = [UILabel getHeightByWidth:kScreenW-60 title:@"小米MIX 2全陶瓷尊享版上手组图曝光IT之家9月17日消息 9月11日下午，小米在北京工业大学体育馆召开了新品发布会，发布了全面屏2.0手机小米MIX 2，售价3299元起" font:[UIFont systemFontOfSize:16]];
    CGFloat  labelHeightTwo = [UILabel getHeightByWidth:kScreenW-60 title:@"据官方介绍，小米MIX2尊享版就像一整块浑然天成的玉。工艺难度和成本也超乎想象。每一块Unibody全陶瓷都要经过1400℃高温7天烧结；两层楼高的设备，240吨冲压成型；金刚砂刀头0.01mm反复雕琢，每加工一部手机，都要更换刀头。" font:[UIFont systemFontOfSize:16]];
    
    if (labelHeightOne > 20 || labelHeightTwo > 20) {
        moreButton.hidden = NO;
    }else{
        moreButton.hidden = YES;
    }
    
    if (model.isLookMore == YES) {
        moreButton.selected = YES;
        questionLabel.numberOfLines = 0;
        answerLabel.numberOfLines = 0;
    }else{
        moreButton.selected = NO;
        questionLabel.numberOfLines = 1;
        answerLabel.numberOfLines = 1;
    }
    
    questionLabel.text = @"小米MIX 2全陶瓷尊享版上手组图曝光IT之家9月17日消息 9月11日下午，小米在北京工业大学体育馆召开了新品发布会，发布了全面屏2.0手机小米MIX 2，售价3299元起";
    answerLabel.text = @"据官方介绍，小米MIX2尊享版就像一整块浑然天成的玉。工艺难度和成本也超乎想象。每一块Unibody全陶瓷都要经过1400℃高温7天烧结；两层楼高的设备，240吨冲压成型；金刚砂刀头0.01mm反复雕琢，每加工一部手机，都要更换刀头。";
    
    timeLabel.text = [NSString getStringWithTimestamp:[model.create_time integerValue] formatter:@"MM-dd"];
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

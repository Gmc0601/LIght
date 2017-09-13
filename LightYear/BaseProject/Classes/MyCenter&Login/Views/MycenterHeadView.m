//
//  MycenterHeadView.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MycenterHeadView.h"

@implementation MycenterHeadView
{
    UIImageView * headImage;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
- (void)configUI{
    UIButton * headButton = [UIButton new];
    headButton.tag = 10;
    [headButton addTarget:self action:@selector(headViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    headButton.layer.cornerRadius = 40.0f;
    headButton.layer.masksToBounds = YES;
    [self addSubview:headButton];
    [headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(40);
        make.size.mas_offset(CGSizeMake(80, 80));
    }];
    
    headImage = [UIImageView new];
    headImage.image = [UIImage imageNamed:@"icon_grzl_tx"];
    [headButton addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    UILabel * headEditLabel = [UILabel new];
    headEditLabel.text = @"编辑";
    headEditLabel.alpha = 0.5f;
    headEditLabel.textAlignment = NSTextAlignmentCenter;
    headEditLabel.font = [UIFont systemFontOfSize:14];
    headEditLabel.textColor = [UIColor whiteColor];
    headEditLabel.backgroundColor = [UIColor blackColor];
    [headButton addSubview:headEditLabel];
    [headEditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.left.right.mas_offset(0);
    }];
    
    NSArray * imageArr = @[@"icon_grzx_qbdd",@"icon_grzx_dps",@"icon_grzx_dzt",@"icon_grzx_psz",@"icon_grzx_dzf"];
    NSArray * titleArr = @[@"全部订单",@"待配送",@"待自取",@"配送中",@"待支付"];
    CGFloat buttonWidth = kScreenW/8;
    CGFloat buttonLeft= (kScreenW-kScreenW/8*5-15*4)/2;
    UIButton * baseButton;
    for (int i = 0; i < 5; i++) {
        UIButton * button = [UIButton new];
        button.tag = 20+i;
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-20);
            make.size.mas_offset(CGSizeMake(buttonWidth, 50));
            if (i == 0) {
                make.left.mas_offset(buttonLeft);
            }else{
                make.left.mas_equalTo(baseButton.mas_right).offset(15);
            }
        }];
        baseButton = button;
        
        UIImageView * imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:imageArr[i]];
        [button addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_offset(0);
            make.top.mas_offset(0);
        }];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.text = titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [button addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.centerX.mas_offset(0);
        }];
    }
}
- (void)headViewButtonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(didMycenterHeadViewButton:)]) {
        [self.delegate didMycenterHeadViewButton:button];
    }
}
@end

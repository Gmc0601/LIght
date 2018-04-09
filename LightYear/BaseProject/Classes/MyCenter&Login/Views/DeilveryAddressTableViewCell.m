//
//  DeilveryAddressTableViewCell.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "DeilveryAddressTableViewCell.h"

@implementation DeilveryAddressTableViewCell
{
    UILabel * nameLabel;
    UILabel * telephoneLabel;
    UILabel * addressLabel;
    UILabel * normalLabel;
    UIButton * editButton;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self makeView];
    }
    return self;
}
- (void)makeView{
    nameLabel = [UILabel new];
    
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_offset(20);
    }];

    telephoneLabel = [UILabel new];
    telephoneLabel.font = [UIFont boldSystemFontOfSize:16];
    telephoneLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:telephoneLabel];
    [telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.left.mas_equalTo(nameLabel.mas_right).offset(20);
    }];
    
    editButton = [UIButton new];
    [editButton setImage:[UIImage imageNamed:@"icon_xg"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.right.mas_offset(-20);
    }];
    
    normalLabel = [UILabel new];
    normalLabel.text = @"[默认]";
    normalLabel.hidden = YES;
    normalLabel.font = [UIFont systemFontOfSize:14];
    normalLabel.textColor = UIColorFromHex(0x4ead35);
    [self.contentView addSubview:normalLabel];
    [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
        make.left.mas_offset(20);
        make.width.mas_offset(50);
    }];
    
    addressLabel = [UILabel new];
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
        make.left.mas_offset(20);
        make.right.bottom.mas_offset(-20);
    }];
}
- (void)setModel:(DeliveryAddressInfo *)model{
    if (model.isdefault == 1) {
        normalLabel.hidden = NO;
        [addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(normalLabel.mas_right).offset(0);
            make.right.bottom.mas_offset(-20);
        }];
    }else{
        normalLabel.hidden = YES;
        [addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(15);
            make.left.mas_offset(20);
            make.right.bottom.mas_offset(-20);
        }];
    }
    nameLabel.text = model.username;
    telephoneLabel.text = model.phone;
    addressLabel.text = [NSString stringWithFormat:@"%@%@",model.address,model.tablet];
}
- (void)editAction:(UIButton *)button{
    if (self.clickBlock) {
        self.clickBlock();
    }
    
    if ([self.delegate respondsToSelector:@selector(didDeilveryAddressTableViewCellEditButton:)]) {
        [self.delegate didDeilveryAddressTableViewCellEditButton:button];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

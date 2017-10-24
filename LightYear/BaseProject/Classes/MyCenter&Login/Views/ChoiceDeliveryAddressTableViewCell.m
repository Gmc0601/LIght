//
//  ChoiceDeliveryAddressTableViewCell.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChoiceDeliveryAddressTableViewCell.h"

@interface ChoiceDeliveryAddressTableViewCell ()
{
    UILabel * nameLabel;
    UILabel * addressLabel;
}

@end

@implementation ChoiceDeliveryAddressTableViewCell

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
    
    addressLabel = [UILabel new];
    addressLabel.numberOfLines = 0;
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(5);
        //make.left.mas_equalTo(normalLabel.mas_right).offset(0);
        make.left.mas_offset(20);
        make.right.bottom.mas_offset(-20);
    }];
}
- (void)setPointModel:(AMapPOI *)pointModel{
    nameLabel.text = pointModel.name;
    addressLabel.text = pointModel.address;
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

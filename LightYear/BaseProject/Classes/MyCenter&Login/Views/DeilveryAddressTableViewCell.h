//
//  DeilveryAddressTableViewCell.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryAddressModel.h"

@protocol DeilveryAddressTableViewCellDelegate <NSObject>

@optional

- (void)didDeilveryAddressTableViewCellEditButton:(UIButton*)button;

@end

@interface DeilveryAddressTableViewCell : UITableViewCell

@property (nonatomic, weak) id<DeilveryAddressTableViewCellDelegate> delegate;
@property (nonatomic, strong) DeliveryAddressInfo * model;

@end

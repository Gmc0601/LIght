//
//  OrderStoreInfoTableViewCell.h
//  BaseProject
//
//  Created by cc on 2017/9/25.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderStoreInfoTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *storeNameLab, *storeAddressLab, *timeLab, *workTimeLab, *holidayLab;

- (void)updateinfo:(ShopInfo *)model;

@end

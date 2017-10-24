//
//  RechargeInfoCell.h
//  BaseProject
//
//  Created by wmk on 2017/9/27.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeListModel.h"

@interface RechargeInfoCell : UITableViewCell

- (void)fillWithType:(RechargeListInfo *)info;

@end

//
//  couponDetailsCell.h
//  BaseProject
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponListModel.h"

@interface couponDetailsCell : UITableViewCell

- (void)fillWithModel:(CouponInfo *)info WithExpire:(BOOL)isExpire;

@end

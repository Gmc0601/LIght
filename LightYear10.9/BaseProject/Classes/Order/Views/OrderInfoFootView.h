//
//  OrderInfoFootView.h
//  BaseProject
//
//  Created by cc on 2017/9/26.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface OrderInfoFootView : UIView

@property (nonatomic, retain) UILabel *orderNumLab, *orderTimeLab, *OrderState;

@property (nonatomic, retain) UIButton *copuBtn;

@property (nonatomic, copy) void(^copyBtnBlock)();

- (void)updateinfo:(OrderDetailModel *)model;

@end

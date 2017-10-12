//
//  OrderAlterView.h
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface OrderAlterView : UIView

@property (nonatomic, retain) UIView *backView, *whitView;
/*
 *   标题  取货码 取货时间 线  店铺名  店铺地址 营业时间  工作日  节假日
 */
@property (nonatomic, retain) UILabel *titleLab, *codeLab, *getTimeLab, *line, *stroNameLab, *addressLab, *workTimeLab, *workTimeLab1, *workTimeLab2;

@property (nonatomic, retain) UIButton *closeBtn, *callBtn;

@property (nonatomic, copy) void(^callBtnBlock)();

- (void)update:(OrderModel *)model;

- (void)pop;

- (void)dismiss;

@end

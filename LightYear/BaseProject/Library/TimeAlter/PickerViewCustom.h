//
//  PickerViewCustom.h
//  picker自定义选择器
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@protocol PickerViewCustomDelegate<NSObject>
-(void)title:(NSString *)title;
@end
@interface PickerViewCustom : UIView
@property (weak, nonatomic) id<PickerViewCustomDelegate>delegate;

@property (nonatomic, retain) OrderModel *model;

-(void)show;
-(void)hide;
@end

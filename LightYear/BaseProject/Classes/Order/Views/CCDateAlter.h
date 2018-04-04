//
//  CCDateAlter.h
//  BaseProject
//
//  Created by cc on 2017/11/10.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface CCDateAlter : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
/** // 选择框
 UIPickerView *pickerView  */
@property (nonatomic,strong) UIPickerView *pickerView ;

@property (nonatomic, retain) UIView *backView, *whitView;

@property (nonatomic, retain) UILabel *titleLab;

@property (nonatomic, retain) UIButton *closeBtn, *finishBtn;

@property (nonatomic, retain) NSMutableArray *dataArr, *arr0, *arr1, *arr2;

@property (nonatomic, copy) void(^finishBlock)(NSString *);

@property (nonatomic, copy) NSString *timeStr, *str0, *str1;

@property (nonatomic, assign) int row;

- (void)update:(OrderDetailModel *)model ;

- (void)pop;

- (void)dismiss;

@end

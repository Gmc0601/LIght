//
//  UserInfoPicketView.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserInfoPicketViewDelegate <NSObject>

@required
/**
 * 选择的选项的代理方法  必须实现
 */
- (void)PickerSelectorIndex:(NSInteger)index contentString:(NSString *)str ;

@end

typedef enum : NSUInteger {
    PicketViewTypeDefault,
    PicketViewTypeNormal,
} PicketViewType;

@interface UserInfoPicketView : UIView

@property (nonatomic,assign)id<UserInfoPicketViewDelegate>delegate;

/** 数据源数组 */
@property (nonatomic,strong) NSMutableArray *pickViewTextArray;

/** 图片数据源数组 */
@property (nonatomic,strong) NSMutableArray *pickViewImageArray;

/** pickview的背景颜色 */
@property (nonatomic,strong) UIColor *backgroundColor;

/** 文字的颜色 */
@property (nonatomic,strong) UIColor *contentTextColor;

/** 列宽 */
@property (nonatomic,assign) CGFloat LieWidth;

/** 列高 */
@property (nonatomic,assign) CGFloat LieHeight;

/** 标题 */
@property (nonatomic,copy) NSString * picketTitle;

/** 风格 */
@property (nonatomic,assign) PicketViewType  picketType;

/** 确定按钮字 */
@property (nonatomic,copy) NSString * sureButtonTitle;

//默认选择的哪一个
- (void)MoRenSelectedRowWithObject:(id)object;

@end

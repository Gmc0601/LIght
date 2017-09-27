//
//  WMHomeHeaderView.h
//  BaseProject
//
//  Created by mac on 2017/9/21.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeHeaderDelegate <NSObject>

- (void)callbackOtherClick;
- (void)callbackGoodsClick;
- (void)callbackMemberClick;

@end

@interface WMHomeHeaderView : UIView

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, assign) id<HomeHeaderDelegate> delegate;

@end

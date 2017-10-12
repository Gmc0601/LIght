//
//  OrderFootView.h
//  BaseProject
//
//  Created by cc on 2017/9/23.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
typedef enum {
    
    FootNoraml,
    FootOneLab,
    
}OrderFootType;

@interface OrderFootView : UIView

@property (nonatomic, retain) UIView *backView;

@property (nonatomic, retain) UIButton *topUpBtn , *payBtn;

@property (nonatomic, retain) UILabel  *infoLab, *priceLab, *balanceLab, *moreLab;

@property (nonatomic, retain) UIImageView *logoImage;

@property (nonatomic, copy) void (^topupBlock)();

@property (nonatomic, copy) void (^payBlock)();

- (void)choiseType:(OrderFootType)type;


@end

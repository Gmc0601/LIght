//
//  OrderTableViewCell.h
//  BaseProject
//
//  Created by cc on 2017/9/7.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

typedef enum {
    
    Ordercell_Topay = 0,        // 待支付
    Ordercell_Distribution,     // 待配送
    Ordercell_Distributioning,  // 配送中
    Ordercell_Invite,           // 待自取
    Ordercell_Finished,         // 已完成
    Ordercell_Cancle,           // 已取消
    Ordercell_Refunding,        // 退款审核中
    Ordercell_Refundsuccess,    // 退款成功
    Cellwrong,
    
}OrderCellType;

typedef enum {
    
    Foods_One,  //  一件商品
    Foods_More, //  超过一件
    
}FoodViewType;


@interface OrderTableViewCell : UITableViewCell
/*
 *   超市名称  状态  商品标题 商品备注 商品数目 商品金额 配送
 */
@property (nonatomic, retain) UILabel *storeNameLab, *stateLab, *foodTitleLab, *foodDesLab, *foodsNumLab, *priceLab, *dislab;

@property (nonatomic, retain) UIButton *clickBtn;

@property (nonatomic, retain) UIView *line1, *line2;

@property (nonatomic, retain) UIImageView *foodimageview1, *foodimageview2;

@property (nonatomic, copy) NSString *stateStr;

@property (nonatomic, assign) FoodViewType foodviewtype;

@property (nonatomic, assign) OrderCellType ordercelltype;

@property (nonatomic, copy) void(^BtnClickBlock)();

- (void)updatcell:(OrderModel *)model;

- (void)changeCellType:(OrderCellType)type;

- (void)changeFoodviewType:(FoodViewType)type;

@end

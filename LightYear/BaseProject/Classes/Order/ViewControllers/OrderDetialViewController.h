//
//  OrderDetialViewController.h
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef enum {
    
    Order_Topay = 0,        // 待支付
    Order_Distribution,     // 待配送
    Order_Distributioning,  // 配送中
    Order_Invite,           // 待自取
    Order_Finished,         // 已完成
    Order_Cancle,           // 已取消
    Order_Refunding,        // 退款审核中
    Order_Refundsuccess,    // 退款成功
    wrong,
    
}OrderDetailType;


@interface OrderDetialViewController : CCBaseViewController

@property (nonatomic, assign) OrderDetailType orderType;  //  订单状态

@property (nonatomic, assign) BOOL backHome;

@property (nonatomic, copy) NSString *OrderID;  //  订单ID

@end

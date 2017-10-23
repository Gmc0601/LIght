//
//  OrderViewController.h
//  BaseProject
//
//  Created by cc on 2017/9/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "CCBaseViewController.h"

typedef enum OrderListType {
    
    OrderList_All,            //  全部订单
    OrderList_Distribution,   //  待配送
    OrderList_Invite,         //  待自取
    OrderList_Distributioning,//  配送中
    OrderList_Topay           //  待支付
 
}OrderListType;

@interface OrderViewController : CCBaseViewController

@property (nonatomic,assign) OrderListType listType;

@end

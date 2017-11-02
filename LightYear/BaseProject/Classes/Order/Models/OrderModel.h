//
//  OrderModel.h
//  BaseProject
//
//  Created by cc on 2017/9/7.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponList :NSObject
@property (nonatomic , copy) NSString              * end_time;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , copy) NSString              * condition;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * full_type;
@property (nonatomic , copy) NSString              * denomination;
@property (nonatomic , copy) NSString              * express_time;
@property (nonatomic , copy) NSString              * start_time;

@end

@interface Receiptinfo :NSObject
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * province;
@property (nonatomic , copy) NSString              * user_id;
@property (nonatomic , copy) NSString              * area;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , copy) NSString              * lat;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , copy) NSString              * lng;
@property (nonatomic , copy) NSString              * tablet;
@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * isdefault;

@end

@interface Goodlist :NSObject
@property (nonatomic , copy) NSString              * sku;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , copy) NSString              * img_path;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , assign) NSInteger              stock;
@property (nonatomic , assign) NSInteger              w_stock;
@property (nonatomic , copy) NSString              * good_name;
@property (nonatomic , copy) NSString              * good_id;
@property (nonatomic , assign) NSInteger              s_stock;

@end

@interface Coupon_info :NSObject
@property (nonatomic , copy) NSString              * discount_content;
@property (nonatomic , copy) NSString              * coupon_type;

@end

@interface ShopInfo :NSObject
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , copy) NSString              * hstartdate;
@property (nonatomic , copy) NSString              * ordertimes;
@property (nonatomic , copy) NSString              * customphone;
@property (nonatomic , copy) NSString              * startdate;
@property (nonatomic , copy) NSString              * enddate;
@property (nonatomic , copy) NSString              * orderdays;
@property (nonatomic , copy) NSString              * henddate;
@property (nonatomic , copy) NSString              * shopname;

@end

@interface OrderModel :NSObject
@property (nonatomic , copy) NSString              * production_time;
@property (nonatomic , copy) NSString              * update_time;
@property (nonatomic , copy) NSString              * delivery;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * posttype;
@property (nonatomic , copy) NSString              * end_time;
@property (nonatomic , copy) NSString              * receipt_id;
@property (nonatomic , copy) NSString              * integel;
@property (nonatomic , copy) NSString              * postid;
@property (nonatomic , copy) NSString              * exception;
@property (nonatomic , strong) Receiptinfo              * receiptinfo;
@property (nonatomic , copy) NSString              * refuse;
@property (nonatomic , copy) NSString              * express_time;
@property (nonatomic , copy) NSString              * old_order;
@property (nonatomic , strong) NSArray<Goodlist *>              * goodlist;
@property (nonatomic , copy) NSString              * supplier;
@property (nonatomic , copy) NSString              * take_delivery_time;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) ShopInfo              * shopInfo;
@property (nonatomic , copy) NSString              * pay_order_no;
@property (nonatomic , copy) NSString              * coupon_money;
@property (nonatomic , copy) NSString              * order_no;
@property (nonatomic , copy) NSString              * status_name;
@property (nonatomic , copy) NSString              * paysuccess;
@property (nonatomic , copy) NSString              * user_id;
@property (nonatomic , copy) NSString              * isrefund;    //申请退款0未申请1待审核2审核通过3审核未通过
@property (nonatomic , copy) NSString              * drawtime;
@property (nonatomic , copy) NSString              * pay_type;
@property (nonatomic , copy) NSString              * transaction_id;
@property (nonatomic , copy) NSString              * postage;
@property (nonatomic , copy) NSString              * ip;
@property (nonatomic , copy) NSString              * pay_money;
@property (nonatomic , copy) NSString              * note;
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic, copy) NSString *  can_selftake;
@property (nonatomic, copy) NSString *  can_ship;

@end






@interface WarehouseInfo :NSObject
@property (nonatomic , copy) NSString              * deliverfee;
@property (nonatomic , copy) NSString              * uid;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * minprice;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * freeprice;
@property (nonatomic , copy) NSString              * create_date;
@property (nonatomic , copy) NSString              * coordinate;

@end

@interface OrderDetailModel :NSObject
@property (nonatomic , copy) NSString              * production_time;
@property (nonatomic , copy) NSString              * delivery;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSArray<CouponList *>              * couponList;
@property (nonatomic , assign) NSInteger              end_time;
@property (nonatomic , copy) NSString              * receipt_id;
@property (nonatomic , assign) NSInteger              integel;
@property (nonatomic , copy) NSString              * refuse;
@property (nonatomic , copy) NSString              * exception;
@property (nonatomic , copy) NSString              * take_delivery_time;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , copy) NSString              * supplier;
@property (nonatomic , copy) NSString              * old_order;
@property (nonatomic , strong) Receiptinfo              * receiptinfo;
@property (nonatomic , copy) NSArray<Goodlist *>              * goodlist;
@property (nonatomic , strong) Coupon_info              * coupon_info;
@property (nonatomic , copy) NSString              * create_time;
@property (nonatomic , copy) NSString              * code;
@property (nonatomic , copy) NSString              * status;
@property (nonatomic , strong) ShopInfo              * shopInfo;
@property (nonatomic , copy) NSString              * pay_order_no;
@property (nonatomic , copy) NSString              * coupon_money;
@property (nonatomic , copy) NSString              * order_no;
@property (nonatomic , copy) NSString              * status_name;
@property (nonatomic , copy) NSString              * paysuccess;
@property (nonatomic , copy) NSString              * user_id;
@property (nonatomic , copy) NSString              * isrefund;
@property (nonatomic , copy) NSString              * drawtime;
@property (nonatomic , copy) NSString              * pay_type;
@property (nonatomic , copy) NSString              * userAmount;
@property (nonatomic , copy) NSString              * transaction_id;
@property (nonatomic , copy) NSString              * postage;
@property (nonatomic , copy) NSString              * ip;
@property (nonatomic , copy) NSString              *all_amount;
@property (nonatomic , strong) WarehouseInfo              * warehouseInfo;
@property (nonatomic , copy) NSString              * note;
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic, copy) NSString *  can_selftake;
@property (nonatomic, copy) NSString *  can_ship;


@end



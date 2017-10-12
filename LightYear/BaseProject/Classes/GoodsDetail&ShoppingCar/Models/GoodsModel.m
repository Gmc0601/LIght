//
//  GoodsModel.m
//  BaseProject
//
//  Created by LeoGeng on 09/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel
@synthesize hasDiscounts = _hasDiscounts;
-(BOOL)hasDiscounts{
    return self.couponid == nil || [self.couponid isEqualToString:@""];
}

@synthesize canDelivery = _canDelivery;
-(BOOL) canDelivery{
    return self.centerStock > 0;
}

@synthesize canTakeBySelf = _canTakeBySelf;
-(BOOL) canTakeBySelf{
    return self.shopStock > 0;
}

@synthesize count = _count;
-(int) count{
    return _shopStock + _centerStock;
}
@end

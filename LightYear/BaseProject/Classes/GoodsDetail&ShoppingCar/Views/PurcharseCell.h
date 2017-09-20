//
//  PurcharseCell.h
//  BaseProject
//
//  Created by LeoGeng on 20/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol PurcharseCellDelegate <NSObject>

-(void) didDelete:(NSString *) goodsId;
-(void) didChangeNumber:(NSString *) goodsId withNumber:(int) number;

@end

@interface PurcharseCell : UITableViewCell
@property(retain,nonatomic) GoodsModel *model;
@property(weak,nonatomic) id<PurcharseCellDelegate> delegate;
@end


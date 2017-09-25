//
//  PurcharseCell.h
//  BaseProject
//
//  Created by LeoGeng on 20/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseModel.h"
@class PurcharseCell;
@protocol PurcharseCellDelegate <NSObject>

-(void) didDelete:(NSString *) _id;
-(void) didChangeNumber:(PurchaseModel *) model withSender:(PurcharseCell *) sender;

@end

@interface PurcharseCell : UITableViewCell
@property(retain,nonatomic) PurchaseModel *model;
@property(weak,nonatomic) id<PurcharseCellDelegate> delegate;
@end


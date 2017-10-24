//
//  balancePointDetailsCell.h
//  BaseProject
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tradeListModel.h"
#import "integralListModel.h"

@interface balancePointDetailsCell : UITableViewCell

- (void)fillWithPoint:(integralListInfo *)info;
- (void)fillWithBalance:(tradeListInfo *)info;

@end

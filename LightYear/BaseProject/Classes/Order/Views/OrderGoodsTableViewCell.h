//
//  OrderGoodsTableViewCell.h
//  BaseProject
//
//  Created by cc on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderGoodsTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *numLab, *titleLab, *desLab, *taglab1, *taglab2, *priceLab, *lineLab;

@property (nonatomic, retain) UIImageView *goodsPic;

- (void)updateinfo:(NSDictionary *)dic;

@end

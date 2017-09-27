//
//  OrderAddressTableViewCell.h
//  BaseProject
//
//  Created by cc on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    Order_haveAddress,
    Order_withoutAddress,
    Order_Nothing,
    
}OrderAddressCellType;

@interface OrderAddressTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *nameLab, *phoneLab, *addressLab, *moreLab, *addaddresslab;

@property (nonatomic, retain) UIImageView *addLogo ;

- (void)update:(OrderAddressCellType)type;

@end

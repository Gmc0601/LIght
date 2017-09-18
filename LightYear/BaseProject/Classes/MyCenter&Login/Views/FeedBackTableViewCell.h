//
//  FeedBackTableViewCell.h
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedBackModel.h"

@protocol FeedBackTableViewCellDelegate <NSObject>

@optional

- (void)didFeedBackTableViewCellMoreButton:(UIButton*)button;

@end

@interface FeedBackTableViewCell : UITableViewCell

@property (nonatomic , strong) FeedBackModel * model;
@property (nonatomic, weak) id<FeedBackTableViewCellDelegate> delegate;

@end

//
//  HistoryTableView.h
//  BaseProject
//
//  Created by LeoGeng on 16/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryTableViewDelegate <NSObject>

-(void) didDelete:(NSString *) keywords;
-(void) didSelect:(NSString *) keywords;

@end

@interface HistoryTableView : UIView
@property(retain,nonatomic) NSArray *datasource;
@property(retain,atomic) UIViewController *ownerVC;
@property(weak,nullable) id<HistoryTableViewDelegate> delegate;
@end

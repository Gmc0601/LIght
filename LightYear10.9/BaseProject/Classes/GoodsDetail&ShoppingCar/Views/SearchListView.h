//
//  GoodsListView.h
//  BaseProject
//
//  Created by LeoGeng on 14/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchListView;
@protocol SearchListViewViewDelegate <NSObject>

-(void) didSelectGoods:(NSString *) goodsId;
-(void) reloadData:(SearchListView *) sender PageIndex:(int) index;
@end

@interface SearchListView : UIView
@property(weak,nullable) id<SearchListViewViewDelegate> delegate;
@property(retain,atomic)     NSArray *datasource;
@property(retain,atomic)     UITableView *tb;
@end

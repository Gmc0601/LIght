//
//  SearchResultView.h
//  BaseProject
//
//  Created by LeoGeng on 16/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchListView.h"

@protocol SearchResultViewDelegate <NSObject>

-(void) gotoFirstCategory;
-(void) didSelectGoods:(NSString *) goodsId;
-(void) reloadData:(SearchListView *)sender PageIndex:(int)index;
@end

@interface SearchResultView : UIView
@property(retain,nonatomic) NSArray *datasource;
@property(weak,nonatomic) id<SearchResultViewDelegate> delegate;
@end

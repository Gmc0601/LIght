//
//  ShopBaseViewController.h
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "CCBaseViewController.h"
#import "SearchBarView.h"
#import "ConfigModel.h"
#import "TBRefresh.h"

@interface ShopBaseViewController : CCBaseViewController
@property(retain,atomic) SearchBarView *searchBar;
@property(retain,atomic) UIView *bottomView;


-(void) addBottomView;
-(void) addFavoriteButton;
-(BOOL) hasBottomView;
-(void) addSearchButton;
@end

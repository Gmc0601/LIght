//
//  SearchBarView.h
//  BaseProject
//
//  Created by LeoGeng on 15/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchBarViewDelegate <NSObject>

-(void) didSearch:(NSString *) keyworkd;
-(void) didClearKeyword;

@end

@interface SearchBarView : UIView
@property(assign,nonatomic)  BOOL enable;
@property(retain,nonatomic)  NSString *keyword;
@property(retain,atomic)  UITextField *txtSearch;
@property(weak,nullable)  id<SearchBarViewDelegate> delegate;
@end

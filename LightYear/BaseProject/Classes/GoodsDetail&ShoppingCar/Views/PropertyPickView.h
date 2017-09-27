//
//  PropertyPickView.h
//  BaseProject
//
//  Created by LeoGeng on 18/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyPickView : UIView
-(void) setDatasource:(NSArray *)datasource withSelectValues:(NSArray *) selectValue;
@property(retain,atomic) NSMutableArray *selectValue;
@end

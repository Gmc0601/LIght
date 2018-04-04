//
//  BaseViewController.h
//  EasyMake
//
//  Created by cc on 2017/5/5.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "UIColor+BGHexColor.h"
@interface CCBaseViewController : UIViewController

@property (nonatomic, retain) UIView *navigationView;

@property (nonatomic, retain) UIButton *leftBar;

@property (nonatomic, retain) UIButton *rightBar;

@property (nonatomic, retain) UILabel *titleLab;

@property (nonatomic, retain) UILabel *line;

@property (nonatomic, assign) int height;

 @property (nonatomic, assign)int top;

//
- (void)back:(UIButton *)sender ;

- (void)more:(UIButton *)sender ;
@end

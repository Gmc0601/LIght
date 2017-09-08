//
//  ShopBaseViewController.m
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "ShopBaseViewController.h"

@interface ShopBaseViewController ()

@end

@implementation ShopBaseViewController
@synthesize bottomView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addFavoriteButton{
    [self.rightBar setTitle:@"喜欢" forState:UIControlStateNormal];
}

-(BOOL) hasBottomView{
    return  self.bottomView != nil;
}

-(void) injected{
    [self viewDidLoad];
}

@end

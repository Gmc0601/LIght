//
//  ChangeUserInfoViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChangeUserInfoViewController.h"

@interface ChangeUserInfoViewController ()

@end

@implementation ChangeUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == UserInfoTypeName) {
        self.titleLab.text = @"修改昵称";
    }else if (self.type == UserInfoTypePayPassword){
        self.titleLab.text = @"修改支付密码";
    }
    [self createBaseView];
}
- (void)createBaseView{
    if (self.type == UserInfoTypeName) {
        for (int i = 0; i < 2; i++) {
            UILabel * baseLabel = [UILabel new];
            baseLabel.text = @[@"姓氏",@"姓名"][i];
        }
    }else if (self.type == UserInfoTypePayPassword){
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

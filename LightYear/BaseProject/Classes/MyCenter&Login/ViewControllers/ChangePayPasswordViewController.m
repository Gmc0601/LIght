//
//  ChangePayPasswordViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChangePayPasswordViewController.h"

#import "BaseTextField.h"

@interface ChangePayPasswordViewController ()<BaseTextFieldDelegate>

@end

@implementation ChangePayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"修改支付密码";
    [self createBaseView];
}
- (void)createBaseView{
    for (int i = 0; i < 2; i++) {
        UILabel * baseLabel = [UILabel new];
        baseLabel.text = @[@"新密码:",@"确认密码:"][i];
        baseLabel.font = [UIFont boldSystemFontOfSize:16];
        baseLabel.textColor = UIColorFromHex(0x666666);
        [self.view addSubview:baseLabel];
        [baseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.top.mas_offset(70+50*i);
            make.size.mas_offset(CGSizeMake(80, 40));
        }];
        
        BaseTextField * baseTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@[@"6位纯数字",@"请再次输入密码"][i] isBorder:YES];
        baseTextField.keyboardType = UIKeyboardTypeDefault;
        baseTextField.textDelegate = self;
        baseTextField.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:baseTextField];
        [baseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(baseLabel.mas_right).offset(0);
            make.right.mas_offset(-20);
            make.top.mas_offset(70+50*i);
            make.height.mas_offset(40);
        }];
    }
    
    UIButton * bottomButton = [UIButton new];
    bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    bottomButton.backgroundColor = UIColorFromHex(0x3e7bb1);
    bottomButton.layer.cornerRadius = 4.0f;
    bottomButton.layer.masksToBounds = YES;
    [bottomButton setTitle:@"保存" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(180);
        make.height.mas_offset(40);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
}
//确定
- (void)sureAction:(UIButton *)button{
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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

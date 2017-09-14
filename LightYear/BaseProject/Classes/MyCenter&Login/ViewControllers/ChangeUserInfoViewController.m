//
//  ChangeUserInfoViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChangeUserInfoViewController.h"
#import "ChangePayPasswordViewController.h"
#import "BaseTextField.h"
#import "NSString+Category.h"
@interface ChangeUserInfoViewController ()<BaseTextFieldDelegate>

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
            baseLabel.text = @[@"姓氏:",@"姓名:"][i];
            baseLabel.font = [UIFont boldSystemFontOfSize:16];
            baseLabel.textColor = UIColorFromHex(0x666666);
            [self.view addSubview:baseLabel];
            [baseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(20);
                make.top.mas_offset(70+50*i);
                make.size.mas_offset(CGSizeMake(50, 40));
            }];
            
            BaseTextField * baseTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@[@"请输入姓氏",@"请输入姓名"][i] isBorder:YES];
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
    }else if (self.type == UserInfoTypePayPassword){
        UILabel * tipLabel = [UILabel new];
        tipLabel.text = @"请验证您的手机号，以便后续操作";
        tipLabel.font = [UIFont systemFontOfSize:14];
        tipLabel.textColor = UIColorFromHex(0x666666);
        [self.view addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.top.mas_offset(70);
        }];
        UILabel * currentLabel;
        for (int i = 0; i < 2; i++) {
            UILabel * baseLabel = [UILabel new];
            baseLabel.text = @[@"手机号:",@"验证码:"][i];
            baseLabel.font = [UIFont boldSystemFontOfSize:16];
            baseLabel.textColor = UIColorFromHex(0x666666);
            [self.view addSubview:baseLabel];
            [baseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(20);
                if (i == 0) {
                    make.top.mas_equalTo(tipLabel.mas_bottom).offset(10);
                }else{
                    make.top.mas_equalTo(currentLabel.mas_bottom).offset(10);
                }
                make.size.mas_offset(CGSizeMake(60, 40));
            }];
            if (i == 0) {
                UILabel * telephoneLabel = [UILabel new];
                telephoneLabel.text = [NSString getSecrectStringWithPhoneNumber:@"17611308925"];
                telephoneLabel.font = [UIFont systemFontOfSize:15];
                telephoneLabel.textColor = UIColorFromHex(0x666666);
                [self.view addSubview:telephoneLabel];
                [telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(baseLabel.mas_right).offset(0);
                    make.top.mas_equalTo(baseLabel.mas_top);
                    make.height.mas_offset(40);
                }];
                
                UIButton * verificationButton = [UIButton new];
                verificationButton.layer.masksToBounds = YES;
                verificationButton.layer.cornerRadius = 3.0f;
                verificationButton.layer.borderWidth = 0.5f;
                verificationButton.layer.borderColor = [UIColor blackColor].CGColor;
                verificationButton.titleLabel.font = [UIFont systemFontOfSize:14];
                [verificationButton setTitle:@" 获取验证码 " forState:UIControlStateNormal];
                [verificationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [verificationButton addTarget:self action:@selector(getValidationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:verificationButton];
                [verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_offset(-20);
                    make.top.mas_equalTo(baseLabel.mas_top).offset(5);
                    make.height.mas_offset(30);
                }];
            }else{
                BaseTextField * baseTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@"请输入4位验证码" isBorder:YES];
                baseTextField.keyboardType = UIKeyboardTypeNumberPad;
                baseTextField.textDelegate = self;
                baseTextField.font = [UIFont systemFontOfSize:16];
                [self.view addSubview:baseTextField];
                [baseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(baseLabel.mas_right).offset(0);
                    make.right.mas_offset(-20);
                    make.top.mas_equalTo(baseLabel.mas_top);
                    make.height.mas_offset(40);
                }];
            }
            currentLabel = baseLabel;
        }
        
        UIButton * bottomButton = [UIButton new];
        bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        bottomButton.backgroundColor = UIColorFromHex(0x3e7bb1);
        bottomButton.layer.cornerRadius = 4.0f;
        bottomButton.layer.masksToBounds = YES;
        [bottomButton setTitle:@"下一步" forState:UIControlStateNormal];
        [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottomButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:bottomButton];
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(220);
            make.height.mas_offset(40);
            make.left.mas_offset(20);
            make.right.mas_offset(-20);
        }];
    }
}
//确定
- (void)sureAction:(UIButton *)button{
    if (self.type == UserInfoTypeName) {
        
    }else if (self.type == UserInfoTypePayPassword){
        ChangePayPasswordViewController * payPasswordVC = [[ChangePayPasswordViewController alloc] init];
        [self.navigationController pushViewController:payPasswordVC animated:YES];
    }
}
//发送验证码
- (void)getValidationCodeAction:(UIButton *)sender{
    
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

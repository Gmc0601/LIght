//
//  ChangePayPasswordViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChangePayPasswordViewController.h"
#import "MakeOrderViewController.h"
#import "BaseTextField.h"

@interface ChangePayPasswordViewController ()<BaseTextFieldDelegate>
{
    UserInfo * userModel;
}
@end

@implementation ChangePayPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userModel = [[TMCache sharedCache] objectForKey:UserInfoModel];
    if (userModel.is_trade == 0) {
        self.titleLab.text = @"设置支付密码";
    }else{
        self.titleLab.text = @"修改支付密码";
    }
    self.rightBar.hidden = YES;
    [self createBaseView];
}
- (void)createBaseView{
    int hei = 70 ;
    if (kDevice_Is_iPhoneX) {
        hei = 90;
    }
    for (int i = 0; i < 2; i++) {
        UILabel * baseLabel = [UILabel new];
        if (userModel.is_trade == 0) {
            baseLabel.text = @[@"输入密码:",@"确认密码:"][i];
        }else{
            baseLabel.text = @[@"新密码:",@"确认密码:"][i];
        }
        baseLabel.font = [UIFont boldSystemFontOfSize:16];
        baseLabel.textColor = UIColorFromHex(0x666666);
        [self.view addSubview:baseLabel];
        [baseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.top.mas_offset(hei+50*i);
            make.size.mas_offset(CGSizeMake(80, 40));
        }];
        
        BaseTextField * baseTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@[@"6位纯数字",@"请再次输入密码"][i] isBorder:YES];
        baseTextField.tag = 10+i;
        baseTextField.keyboardType = UIKeyboardTypeDefault;
        baseTextField.textDelegate = self;
        baseTextField.secureTextEntry = YES;
        baseTextField.font = [UIFont systemFontOfSize:16];
        [self.view addSubview:baseTextField];
        [baseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(baseLabel.mas_right).offset(0);
            make.right.mas_offset(-20);
            make.top.mas_offset(hei+50*i);
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
        make.top.mas_offset(110 + hei);
        make.height.mas_offset(40);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
}
//确定
- (void)sureAction:(UIButton *)button{
    BaseTextField * firstTextField = [self.view viewWithTag:10];
    if (firstTextField.text.length < 6) {
        [ConfigModel mbProgressHUD:@"请输入6位数密码" andView:nil];
        return;
    }
    BaseTextField * secondTextField = [self.view viewWithTag:11];
    if (secondTextField.text.length < 6) {
        [ConfigModel mbProgressHUD:@"请输入6位数密码" andView:nil];
        return;
    }
    if (![firstTextField.text isEqualToString:secondTextField.text]) {
        [ConfigModel mbProgressHUD:@"两次输入的密码不一致" andView:nil];
        return;
    }
    [ConfigModel showHud:self];
    NSDictionary * params = @{@"mobile":userModel.username,@"code":self.code,@"newPwd":secondTextField.text};
    [HttpRequest postPath:ChangePayCodeURL params:params resultBlock:^(id responseObject, NSError *error) {
        [ConfigModel hideHud:self];
        BaseModel * baseModel = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        if (baseModel.error == 0) {
            
            if (userModel.is_trade == 0) {
                userModel.is_trade = 1;
                [[TMCache sharedCache] setObject:userModel forKey:UserInfoModel];
                [ConfigModel mbProgressHUD:@"设置成功" andView:nil];
            }else{
                [ConfigModel mbProgressHUD:@"修改成功" andView:nil];
            }
            for (id vc in self.navigationController.childViewControllers) {
                if ([vc isKindOfClass:[MakeOrderViewController class]]) {
                  [self.navigationController popToViewController:vc animated:YES];
                    return ;
                }
            }
            UIViewController * viewController = self.navigationController.childViewControllers[2];
            [self.navigationController popToViewController:viewController animated:YES];
        }else {
            [ConfigModel mbProgressHUD:baseModel.message andView:nil];
        }
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma BaseTextFileldDelegate
//内容将要发生改变编辑 限制输入文本长度 监听TextView 点击了ReturnKey 按钮
- (void)textFieldTextChange:(UITextField *)textField  Text:(NSString *)text{
    if (textField.tag == 10) {
        if (text.length > 6) {
            textField.text = [text substringWithRange:NSMakeRange(0, 6)];
        }
    }else if (textField.tag == 11){
        if (text.length > 6) {
            textField.text = [text substringWithRange:NSMakeRange(0, 6)];
        }
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

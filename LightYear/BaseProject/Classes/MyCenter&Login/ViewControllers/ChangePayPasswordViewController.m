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
    [self createBaseView];
}
- (void)createBaseView{
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
            make.top.mas_offset(70+50*i);
            make.size.mas_offset(CGSizeMake(80, 40));
        }];
        
        BaseTextField * baseTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@[@"6位纯数字",@"请再次输入密码"][i] isBorder:YES];
        baseTextField.tag = 10+i;
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
    BaseTextField * firstTextField = [self.view viewWithTag:10];
    if (firstTextField.text.length == 0) {
        [ConfigModel mbProgressHUD:@"密码为空" andView:nil];
        return;
    }
    BaseTextField * secondTextField = [self.view viewWithTag:11];
    if (secondTextField.text.length == 0) {
        [ConfigModel mbProgressHUD:@"确认密码为空" andView:nil];
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
            userModel.is_trade = 1;
            [[TMCache sharedCache] setObject:userModel forKey:UserInfoModel];
            UIViewController * viewController = self.navigationController.childViewControllers[2];
            [self.navigationController popToViewController:viewController animated:YES];
        }else {
            //                [ConfigModel mbProgressHUD:baseModel.info andView:nil];
        }
    }];
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

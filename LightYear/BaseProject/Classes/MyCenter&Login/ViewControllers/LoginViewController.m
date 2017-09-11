//
//  LoginViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseTextField.h"
@interface LoginViewController ()<BaseTextFieldDelegate>
{
    BaseTextField * _userTextField;
    BaseTextField * _passTextField;
    UIButton * _verificationButton;
    UIButton * _loginButton;
}
@property (assign, nonatomic) NSInteger timeCount;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftBar.hidden = YES;
    self.rightBar.hidden = YES;
    
    [self makeView];
}
- (void)makeView{
    UIImageView * logoView = [UIImageView new];
    logoView.image = [UIImage imageNamed:@"img_dl"];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.mas_offset(80);
    }];
    
    UILabel * userLabel = [UILabel new];
    userLabel.text = @"手机号";
    userLabel.font = [UIFont systemFontOfSize:18];
    userLabel.textColor = UIColorFromHex(0x666666);
    [self.view addSubview:userLabel];
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.mas_equalTo(logoView.mas_bottom).offset(30);
        make.height.mas_offset(40);
    }];
    
    _userTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@"请输入11位手机号"];
    _userTextField.keyboardType = UIKeyboardTypeNumberPad;
    _userTextField.tag = 100;
    _userTextField.textDelegate = self;
    [self.view addSubview:_userTextField];
    [_userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-125);
        make.top.mas_equalTo(userLabel.mas_bottom).offset(5);
        make.height.mas_offset(50);
    }];
    
    _verificationButton = [UIButton new];
    _verificationButton.layer.masksToBounds = YES;
    _verificationButton.layer.cornerRadius = 3.0f;
    _verificationButton.layer.borderWidth = 0.5f;
    _verificationButton.layer.borderColor = [UIColor blackColor].CGColor;
    _verificationButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_verificationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_verificationButton addTarget:self action:@selector(getValidationCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_verificationButton];
    [_verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(userLabel.mas_bottom).offset(5);
        make.height.mas_offset(50);
    }];
    
    UILabel * passLabel = [UILabel new];
    passLabel.text = @"验证码";
    passLabel.font = [UIFont systemFontOfSize:18];
    passLabel.textColor = UIColorFromHex(0x666666);
    [self.view addSubview:passLabel];
    [passLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.top.mas_equalTo(_verificationButton.mas_bottom).offset(10);
        make.height.mas_offset(40);
    }];
    
    _passTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@"请输入6位验证码"];
    _passTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passTextField.tag = 101;
    _passTextField.isChangeKeyBoard = YES;
    _passTextField.textDelegate = self;
    [self.view addSubview:_passTextField];
    [_passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.mas_equalTo(passLabel.mas_bottom).offset(5);
        make.height.mas_offset(50);
    }];

    _loginButton = [UIButton new];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.backgroundColor = UIColorFromHex(0x3e7bb1);
    _loginButton.layer.cornerRadius = 4.0f;
    _loginButton.layer.masksToBounds = YES;
    //_loginButton.userInteractionEnabled = NO;
    //_loginButton.alpha = 0.5f;
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passTextField.mas_bottom).offset(20);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_offset(50);
    }];
    
    UILabel * tipLabel = [UILabel new];
    tipLabel.text = @"或使用快捷登录";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_equalTo(_loginButton.mas_bottom).offset(20);
    }];
}
//登录
- (void)loginAction:(UIButton *)sender{
//    [ConfigModel showHud:self];
//    NSDictionary *logindic = @{
//                               @"username": _userTextField.text,
//                               @"code": _passTextField.text,
//                               };
//    [HttpRequest postPath:LoginURL params:logindic resultBlock:^(id responseObject, NSError *error) {
//        
//        if([error isEqual:[NSNull null]] || error == nil){
//            NSLog(@"LoginSuccess");
//        }
//        NSDictionary *datadic = responseObject;
//        
//        [ConfigModel hideHud:self];
//        if ([datadic[@"error"] intValue] == 0) {
//            //UserModel * infoDic = [[UserModel alloc] initWithDictionary:datadic[@"info"] error:nil];
//            NSDictionary * dict = datadic[@"info"];
            [ConfigModel saveBoolObject:YES forKey:IsLogin];
//            [ConfigModel saveString:dict[@"userToken"] forKey:User_Token];
//            [ConfigModel saveString:dict[@"mobile"] forKey:User_Mobile];
//            [ConfigModel saveString:dict[@"nickname"] forKey:User_Nick];
//            [ConfigModel saveString:dict[@"avatar_url"] forKey:User_Logo];
//            
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(0)];
//        }else {
//            NSString *info = datadic[@"info"];
//            [ConfigModel mbProgressHUD:info andView:nil];
//        }
//    }];
}
//发送验证码
- (void)getValidationCodeAction:(UIButton *)sender{
//    if (_userTextField.text.length == 11 ) {
//        [self HttpRequestWithPath:GetCodeURL Params:@{@"mobile":_userTextField.text,@"userToken": [ConfigModel getStringforKey:User_Token]}];
//    }else{
//        [ConfigModel mbProgressHUD:@"您输入的手机号错误" andView:nil];
//    }
}
- (void)reduceTime:(NSTimer *)codeTimer {
    self.timeCount--;
    if (self.timeCount == 0) {
        [_verificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_verificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIButton * info = codeTimer.userInfo;
        info.enabled = YES;
        _verificationButton.userInteractionEnabled = YES;
        _verificationButton.enabled  = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%zus", (long)self.timeCount];
        [_verificationButton setTitle:str forState:UIControlStateNormal];
    }
}
//监听输入内容
- (void)textFieldTextChange:(UITextField *)textField{
    if (textField.tag == 100) {
        if (textField.text.length == 11) {
            [_passTextField becomeFirstResponder];
        }
    }else{
        if (textField.text.length == 4) {
            [self.view endEditing:YES];
            //_loginButton.userInteractionEnabled = YES;
            //_loginButton.alpha = 1.0f;
        }else{
            //_loginButton.userInteractionEnabled = NO;
            //_loginButton.alpha = 0.5f;
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginNotification object:nil];
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

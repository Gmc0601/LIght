//
//  EditDeliveryAddressViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/14.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "EditDeliveryAddressViewController.h"
#import "ChoiceDeliveryAddressViewController.h"
#import "BaseTextField.h"

@interface EditDeliveryAddressViewController ()<BaseTextFieldDelegate>
{
    UILabel * addressLabel;
}
@end

@implementation EditDeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_addressModel == nil) {
        _addressModel = [[DeliveryAddressInfo alloc] init];
        self.titleLab.text = @"新建收货地址";
    }else{
        self.titleLab.text = @"编辑收货地址";
    }
    [self createBaseView];
}

- (void)createBaseView{
    UIView * currentView;
    for (int i = 0; i < 4; i++) {
        UIView * baseView = [UIView new];
        baseView.layer.borderWidth = .5f;
        baseView.layer.borderColor = UIColorFromHex(0xcccccc).CGColor;
        [self.view addSubview:baseView];
        [baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(20);
            make.right.mas_offset(-20);
            make.height.mas_offset(50);
            if (i == 0) {
                make.top.mas_offset(70);
            }else{
                make.top.mas_equalTo(currentView.mas_bottom).offset(15);
            }
        }];
        currentView = baseView;
        
        UILabel * baseLabel = [UILabel new];
        baseLabel.text = @[@"收货人",@"手机号",@"地址",@"门牌号"][i];
        baseLabel.font = [UIFont boldSystemFontOfSize:16];
        baseLabel.textColor = UIColorFromHex(0x666666);
        [baseView addSubview:baseLabel];
        [baseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.width.mas_offset(50);
            make.left.mas_offset(20);
        }];
        
        if (i != 2) {
            BaseTextField * baseTextField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@[@"姓名",@"手机号",@"选择收货地址",@"例：5号楼205室"][i] isBorder:NO];
            baseTextField.keyboardType = UIKeyboardTypeDefault;
            if (i == 0) {
                baseTextField.text = _addressModel.username;
            }else if (i == 1) {
                baseTextField.text = _addressModel.phone;
                baseTextField.keyboardType = UIKeyboardTypeNumberPad;
            }else if (i == 3) {
                baseTextField.text = _addressModel.tablet;
            }
            baseTextField.textDelegate = self;
            baseTextField.tag = 100+i;
            baseTextField.font = [UIFont systemFontOfSize:16];
            [baseView addSubview:baseTextField];
            [baseTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(baseLabel.mas_right).offset(0);
                make.top.bottom.mas_offset(0);
                make.right.mas_offset(-30);
            }];
        }else{
            addressLabel = [UILabel new];
            if (_addressModel.address.length > 0) {
                addressLabel.text = _addressModel.address;
                addressLabel.textColor = UIColorFromHex(0x3e7bb1);
            }else{
                addressLabel.text = @"选择收货地址";
                addressLabel.textColor = UIColorFromHex(0xcccccc);
            }
            addressLabel.font = [UIFont systemFontOfSize:16];
            addressLabel.numberOfLines = 2;
            [baseView addSubview:addressLabel];
            [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(baseLabel.mas_right).offset(20);
                make.top.bottom.mas_offset(0);
                make.right.mas_offset(-30);
            }];
            
            UIButton * arrowButton = [UIButton new];
            [arrowButton addTarget:self action:@selector(arrowAction:) forControlEvents:UIControlEventTouchUpInside];
            [arrowButton setImage:[UIImage imageNamed:@"icon_gds"] forState:UIControlStateNormal];
            [baseView addSubview:arrowButton];
            [arrowButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_offset(0);
                make.right.mas_offset(0);
                make.width.mas_offset(30);
            }];
        }
    }
    
    UILabel * tipLabel = [UILabel new];
    tipLabel.text = @"设为默认收货地址";
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = UIColorFromHex(0x666666);
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(currentView.mas_bottom).offset(20);
        make.left.mas_offset(40);
    }];
    
    UIButton * normalButton = [UIButton new];
    [normalButton addTarget:self action:@selector(normalAction:) forControlEvents:UIControlEventTouchUpInside];
    [normalButton setImage:[UIImage imageNamed:@"icon_hy_xz_ys"] forState:UIControlStateNormal];
    [normalButton setImage:[UIImage imageNamed:@"icon_hy_xz"] forState:UIControlStateSelected];
    if (_addressModel.isdefault == 1) {
        normalButton.selected = YES;
    }
    [self.view addSubview:normalButton];
    [normalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(currentView.mas_bottom).offset(20);
        make.right.mas_offset(-40);
    }];
    
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
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(20);
        make.height.mas_offset(40);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
}
//确定
- (void)sureAction:(UIButton *)button{
    [ConfigModel showHud:self];
    BaseTextField * nameText = [self.view viewWithTag:100];
    _addressModel.username = nameText.text;
    if (nameText.text.length == 0) {
        [ConfigModel mbProgressHUD:@"收货人不能为空" andView:nil];
        return;
    }
    BaseTextField * mobileText = [self.view viewWithTag:101];
    _addressModel.phone = mobileText.text;
    if (mobileText.text.length == 0) {
        [ConfigModel mbProgressHUD:@"手机号不能为空" andView:nil];
        return;
    }
    if (addressLabel.text.length == 0) {
        [ConfigModel mbProgressHUD:@"地址不能为空" andView:nil];
        return;
    }
    BaseTextField * tabletText = [self.view viewWithTag:103];
    _addressModel.tablet = tabletText.text;
    if (tabletText.text.length == 0) {
        [ConfigModel mbProgressHUD:@"门牌号不能为空" andView:nil];
        return;
    }
    NSString * addressID = @"";
    if (_addressModel.aid.length > 0) {
        addressID = _addressModel.aid;
    }
    NSDictionary * params = @{@"default":@(_addressModel.isdefault).stringValue,@"tablet":_addressModel.tablet,@"address":_addressModel.address,@"phone":_addressModel.phone,@"username":_addressModel.username,@"id":addressID,@"lat":_addressModel.lat,@"lng":_addressModel.lng};
    [HttpRequest postPath:SetReceiptURL params:params resultBlock:^(id responseObject, NSError *error) {
        BaseModel * model = [[BaseModel alloc] initWithDictionary:responseObject error:nil];
        NSLog(@"%@",responseObject[@"info"]);
        [ConfigModel hideHud:self];
        if (model.error == 0) {
            if (self.finishBlock) {
                self.finishBlock(_addressModel);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
//选取收货地址
- (void)arrowAction:(UIButton *)button{
    ChoiceDeliveryAddressViewController * choiceAddressVC = [[ChoiceDeliveryAddressViewController alloc] init];
    [choiceAddressVC setFinishBlock:^(AMapPOI * point){
        _addressModel.lat = @(point.location.latitude).stringValue;
        _addressModel.lng = @(point.location.longitude).stringValue;
        _addressModel.address = point.address;
        addressLabel.text = point.address;
        addressLabel.textColor = UIColorFromHex(0x3e7bb1);
    }];
    [self.navigationController pushViewController:choiceAddressVC animated:YES];
}
//默认选取
- (void)normalAction:(UIButton *)button{
    button.selected = !button.selected;
    _addressModel.isdefault = button.selected ? 1:2;
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

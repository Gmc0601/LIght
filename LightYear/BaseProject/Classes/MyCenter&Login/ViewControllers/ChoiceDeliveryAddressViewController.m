//
//  ChoiceDeliveryAddressViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ChoiceDeliveryAddressViewController.h"

#import "ChoiceDeliveryAddressTableViewCell.h"
#import "BaseTextField.h"

@interface ChoiceDeliveryAddressViewController ()<BaseTextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BaseTextField * searchField;
    UIButton * searchButton;
    UITableView * myTableView;
    NSMutableArray * dataArray;
}
@end

@implementation ChoiceDeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"选择收货地址";
    dataArray = [NSMutableArray array];
    [self createBaseView];
}
- (void)createBaseView{
    UIView * searchView = [UIView new];
    searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.mas_offset(0);
        make.height.mas_offset(50);
    }];
    
    UIImageView * searchImage = [UIImageView new];
    searchImage.image = [UIImage imageNamed:@"icon_nav_ss"];
    [searchView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.centerY.mas_offset(0);
        make.size.mas_offset(CGSizeMake(20, 20));
    }];
    
    searchButton = [UIButton new];
    searchButton.layer.cornerRadius = 3.0f;
    searchButton.layer.masksToBounds = YES;
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchButton setBackgroundColor:UIColorFromHex(0x3e7bb1)];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.centerY.mas_offset(0);
        make.size.mas_offset(CGSizeMake(60, 40));
    }];
    
    searchField = [[BaseTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0) PlaceholderStr:@"搜索收货地址" isBorder:NO];
    searchField.keyboardType = UIKeyboardTypeDefault;
    searchField.textDelegate = self;
    searchField.font = [UIFont systemFontOfSize:16];
    [searchView addSubview:searchField];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchImage.mas_right).offset(0);
        make.right.mas_equalTo(searchButton.mas_left).offset(-10);
        make.centerY.mas_offset(0);
        make.height.mas_offset(40);
    }];
    
    UILabel * lineLabel = [UILabel new];
    lineLabel.backgroundColor = UIColorFromHex(0xcccccc);
    [searchView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-0.5);
        make.left.right.mas_offset(0);
        make.height.mas_offset(0.5);
    }];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.estimatedRowHeight = 50.0f;
    myTableView.rowHeight = UITableViewAutomaticDimension;
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView registerClass:[ChoiceDeliveryAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(0);
        make.left.right.bottom.mas_offset(0);
    }];
}
- (void)searchButtonAction:(UIButton *)button{
    
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = UIColorFromHex(0xcccccc);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [UIView new];
    UIView * lineView = [UIView new];
    lineView.backgroundColor = UIColorFromHex(0xcccccc);
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.right.mas_offset(-15);
        make.top.bottom.mas_offset(1);
    }];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return dataArray.count;
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChoiceDeliveryAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[ChoiceDeliveryAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
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

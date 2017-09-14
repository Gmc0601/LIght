//
//  MycenterViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MycenterViewController.h"
#import "UserInfoViewController.h"

#import "MycenterHeadView.h"
#import "DeliveryAddressViewController.h"
#import "FeedBackViewController.h"
@interface MycenterViewController ()<UITableViewDelegate,UITableViewDataSource,MycenterHeadViewDelegate>
{
    UIButton * bottomButton;
    UITableView * myTableView;
    NSMutableArray * dataArray;
    MycenterHeadView * headView;
}
@end

@implementation MycenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = [NSString stringWithFormat:@"%@！光年",[self getCurrentTime]];
    dataArray = [NSMutableArray arrayWithObjects:@"收货地址",@"意见反馈",@"联系我们",@"分享App给朋友", nil];
    [self createBaseView];
}
- (void)createBaseView{
    bottomButton = [UIButton new];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [bottomButton setTitle:@"退出" forState:UIControlStateNormal];
    [bottomButton setTitleColor:UIColorFromHex(0x3e7bb1) forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(exitLoginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-20);
        make.centerX.mas_offset(0);
    }];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.mas_offset(0);
        make.bottom.mas_equalTo(bottomButton.mas_top).mas_offset(-10);
    }];
    [self initTbaleViewHeadView];
}
- (void)initTbaleViewHeadView{
    headView = [[MycenterHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH*0.35)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.delegate = self;
    myTableView.tableHeaderView = headView;
}
#pragma mark MycenterHeadViewDelegate
- (void)didMycenterHeadViewButton:(UIButton*)button{
    if (button.tag == 10) {
        //个人中心
        UserInfoViewController * userInfoVC = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }else{
        //订单 20--24
    }
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 0.000001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = UIColorFromHex(0xcccccc);
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = UIColorFromHex(0xcccccc);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = dataArray[indexPath.section];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    if (indexPath.section == 2) {
        UILabel * detailLabel = [UILabel new];
        detailLabel.text = @"0571-0000999";
        detailLabel.textColor = UIColorFromHex(0x999999);
        detailLabel.font = [UIFont systemFontOfSize:14];
        [cell.textLabel addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(0);
            make.centerY.mas_offset(0);
        }];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        //收货地址
        DeliveryAddressViewController * addressVC = [[DeliveryAddressViewController alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }else if (indexPath.section == 1){
        //意见反馈
        FeedBackViewController * feedBackVC = [[FeedBackViewController alloc] init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
    }else if (indexPath.section == 2){
        //联系我们
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"0571-0000999"];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else if (indexPath.section == 3){
        //分享
    }
}
//退出登录
- (void)exitLoginAction{
    [ConfigModel saveBoolObject:NO forKey:IsLogin];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(1)];
}
//获取当前时间
-(NSString * )getCurrentTime{
    //获取当前的时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [comps hour];
    NSString * timeStr;
    if (hour > 5 &&hour < 12) {
        timeStr = @"早上好";
    }else if (hour > 11 &&hour < 18){
        timeStr = @"下午好";
    }else{
        timeStr = @"晚上好";
    }
    return timeStr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

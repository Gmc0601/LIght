//
//  MycenterViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MycenterViewController.h"
#import "MycenterHeadView.h"
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
    
    self.titleLab.text = @"早上好，光年";
    self.rightBar.hidden = YES;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = dataArray[indexPath.section];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
//退出登录
- (void)exitLoginAction{
    [ConfigModel saveBoolObject:NO forKey:IsLogin];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:@(1)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

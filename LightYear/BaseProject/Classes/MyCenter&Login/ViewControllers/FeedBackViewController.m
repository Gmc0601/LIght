//
//  FeedBackViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FeedBackViewController.h"
#import "EditFeedBackViewController.h"
#import "FeedBackTableViewCell.h"
#import "FeedBackModel.h"

@interface FeedBackViewController ()<UITableViewDelegate,UITableViewDataSource,FeedBackTableViewCellDelegate>
{
    UITableView * myTableView;
    NSMutableArray * dataArray;
}
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        FeedBackModel * model = [[FeedBackModel alloc] init];
        model.isLookMore = NO;
        [dataArray addObject:model];
    }
    
    self.titleLab.text = @"意见反馈";
    [self.rightBar setTitle:@"编辑" forState:UIControlStateNormal];
    [self createBaseView];
}
- (void)more:(UIButton *)sender{
    EditFeedBackViewController * editFeddVC = [[EditFeedBackViewController alloc] init];
    [self.navigationController pushViewController:editFeddVC animated:YES];
}
- (void)createBaseView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.bounces = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.estimatedRowHeight = 50.0f;
    myTableView.rowHeight = UITableViewAutomaticDimension;
    myTableView.backgroundColor = [UIColor whiteColor];
    [myTableView registerClass:[FeedBackTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.bottom.mas_offset(0);
    }];
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
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[FeedBackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    FeedBackModel * model = dataArray[indexPath.section];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark FeedBackTableViewCellDelegate
- (void)didFeedBackTableViewCellMoreButton:(UIButton *)button{
    CGPoint point = button.center;
    point = [myTableView convertPoint:point fromView:button.superview];
    NSIndexPath* indexPath = [myTableView indexPathForRowAtPoint:point];
    
    FeedBackModel * model = dataArray[indexPath.section];
    model.isLookMore = button.selected;
    
    NSIndexSet * indexSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
    [myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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

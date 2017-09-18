//
//  EditFeedBackViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "EditFeedBackViewController.h"

#import "FeedBackTableViewCell.h"
#import "FeedBackModel.h"

@interface EditFeedBackViewController ()<UITableViewDelegate,UITableViewDataSource,FeedBackTableViewCellDelegate,UITextViewDelegate>
{
    UIView * contentBaseView;
    UITableView * myTableView;
    NSMutableArray * dataArray;
    UIButton * currentTitleBtn;
    UITextView * contentTextView;
}

@end

@implementation EditFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        FeedBackModel * model = [[FeedBackModel alloc] init];
        model.isLookMore = NO;
        [dataArray addObject:model];
    }
    self.titleLab.text = @"意见反馈";
    [self createBaseView];
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
    
    contentBaseView = [UIView new];
    contentBaseView.backgroundColor = [UIColor whiteColor];
    contentBaseView.size = CGSizeMake(kScreenW, kScreenH*0.7);
    myTableView.tableHeaderView = contentBaseView;
    
    NSArray * titleArray = @[@"商品种类",@"物流配送",@"订单支付",@"功能异常",@"新功能建议",@"其他"];
    UIButton * baseButton;
    CGFloat buttonWidth = (kScreenW-20*4)/3;
    CGFloat buttonHeight = 40;
    for (int i = 0; i < 6; i++) {
        UIButton * titleButton = [UIButton new];
        titleButton.tag = i;
        titleButton.layer.cornerRadius = 3.0f;
        titleButton.layer.masksToBounds = YES;
        titleButton.backgroundColor = UIColorFromHex(0xf1f2f2);
        titleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [titleButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
        [titleButton addTarget:self action:@selector(titltButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [titleButton setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
            currentTitleBtn = titleButton;
        }
        [contentBaseView addSubview:titleButton];
        [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i < 3) {
                make.top.mas_offset(20);
                make.left.mas_offset(20+i*(buttonWidth+20));
            }else{
                make.top.mas_offset(10+buttonHeight+20);
                make.left.mas_offset(20+(i-3)*(buttonWidth+20));
            }
            make.size.mas_offset(CGSizeMake(buttonWidth, buttonHeight));
        }];
        baseButton = titleButton;
    }
    
    UILabel * tipLabel = [UILabel new];
    tipLabel.text = @"近期意见反馈";
    tipLabel.textColor = UIColorFromHex(0x999999);
    tipLabel.font = [UIFont systemFontOfSize:13];
    [contentBaseView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.bottom.mas_offset(-10);
    }];
    
    UIButton * bottomButton = [UIButton new];
    bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    bottomButton.backgroundColor = UIColorFromHex(0x3e7bb1);
    bottomButton.layer.cornerRadius = 4.0f;
    bottomButton.layer.masksToBounds = YES;
    [bottomButton setTitle:@"提交" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentBaseView addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tipLabel.mas_top).offset(-20);
        make.height.mas_offset(40);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
    
    contentTextView = [UITextView new];
    contentTextView.delegate = self;
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.layer.cornerRadius = 3.0f;
    contentTextView.layer.masksToBounds = YES;
    contentTextView.layer.borderColor = UIColorFromHex(0xf1f2f2).CGColor;
    contentTextView.layer.borderWidth = 1.0f;
    contentTextView.text = @"请描述你的问题，我们将会及时处理！";
    contentTextView.textColor = UIColorFromHex(0xcccccc);
    [contentBaseView addSubview:contentTextView];
    [contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.bottom.mas_equalTo(bottomButton.mas_top).offset(-10);
        make.top.mas_equalTo(baseButton.mas_bottom).offset(10);
    }];
}
- (void)titltButtonAction:(UIButton *)button{
    if (button.tag != currentTitleBtn.tag) {
        [button setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
        [currentTitleBtn setTitleColor:UIColorFromHex(0x999999) forState:UIControlStateNormal];
        currentTitleBtn = button;
    }
}
- (void)sureAction:(UIButton *)button{
    
}
#pragma mark UITextViewDelegate
//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请描述你的问题，我们将会及时处理！"]) {
        textView.text = @"";
        textView.textColor = UIColorFromHex(0x333333);
    }
}
//结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length <1) {
        textView.text = @"请描述你的问题，我们将会及时处理！";
        textView.textColor = UIColorFromHex(0xcccccc);
    }
}
//内容将要发生改变编辑 限制输入文本长度 监听TextView 点击了ReturnKey 按钮
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < 100)
    {
        return  YES;
    } else  if ([textView.text isEqualToString:@"\n"]) {
        //这里写按了ReturnKey 按钮后的代码
        return NO;
    }
    if (textView.text.length == 100) {
        return NO;
    }
    return YES;
}
//内容发生改变编辑 自定义文本框placeholder
- (void)textViewDidChange:(UITextView *)textView
{
    
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
    
//    NSIndexSet * indexSet = [[NSIndexSet alloc]initWithIndex:indexPath.section];
//    [myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
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

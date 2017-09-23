//
//  FeedBackViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "FeedBackViewController.h"
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
    
    self.titleLab.text = @"意见反馈";
    
    dataArray = [NSMutableArray array];
    [self createBaseView];
    [self getData];
}
- (void)getData{
    [ConfigModel showHud:self];
    NSDictionary * params = @{@"page":@"1",@"size":@"10"};
    [HttpRequest postPath:FeedBackURL params:params resultBlock:^(id responseObject, NSError *error) {
        FeedBackModel * model = [[FeedBackModel alloc] initWithDictionary:responseObject error:nil];
        if (model.error == 0) {
            [dataArray addObjectsFromArray:model.info];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [ConfigModel hideHud:self];
        [myTableView reloadData];
    }];
}

- (void)createBaseView{
    myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[FeedBackTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    FeedBackInfo * model = dataArray[indexPath.row];
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
    
    FeedBackInfo* model = dataArray[indexPath.row];
    model.isLookMore = button.selected;
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationFade];
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

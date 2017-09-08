//
//  OrderViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/6.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderAlterView.h"

@interface OrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetFather];
    
    [self createView];
}

- (void)resetFather {
    self.rightBar.hidden = YES;
    self.titleLab.text = @"订单";
    self.titleLab.font = SourceHanSansCNMedium(17);
    self.titleLab.textColor = UIColorFromHex(0x333333);
}

- (void)createView {
    
    [self.view addSubview:self.noUseTableView];
    
}

#pragma mark - UITableDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellId = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    OrderTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    [cell changeCellType:indexPath.row];
    
    FoodViewType type;
    if (indexPath.row == 0) {
        type = Foods_One;
    }else {
        type = Foods_More;
    }
    
    [cell changeFoodviewType:type];
    __block int i  = indexPath.row;
    cell.BtnClickBlock = ^{
        if (i == Order_Invite) {
            OrderAlterView *view = [[OrderAlterView alloc] initWithFrame:FRAME(0, 0, kScreenW, kScreenH)];
            [view pop];
        }
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SizeHeigh(230);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
        _noUseTableView.backgroundColor = RGBColor(239, 240, 241);
        _noUseTableView.delegate = self;
        _noUseTableView.dataSource = self;
        [_noUseTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _noUseTableView.tableHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
            view;
        });
        _noUseTableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW,  SizeHeigh(0))];
            view;
        });
    }
    return _noUseTableView;
}


@end

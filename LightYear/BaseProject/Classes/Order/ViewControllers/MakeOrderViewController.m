//
//  MakeOrderViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MakeOrderViewController.h"

@interface MakeOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *noUseTableView;

@end

@implementation MakeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetFather];
    
    [self createview];
}


- (void)resetFather {
    self.titleLab.text = @"确认订单";
    self.rightBar.hidden = YES;
}

- (void)createview {
//    [self.view addSubview:self.noUseTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = [tableView rectForRowAtIndexPath:indexPath].size.height;
    static NSString *cellIdentifyWithRowOne = @"cellIdentifyWithRowOne";
    return nil;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (UITableView *)noUseTableView {
    if (!_noUseTableView) {
        _noUseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 64- SizeHeigh(50)) style:UITableViewStylePlain];
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
            view.backgroundColor = [UIColor blueColor];
            view;
        });
    }
    return _noUseTableView;
}

@end

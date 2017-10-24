//
//  DeliveryAddressViewController.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/13.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "DeliveryAddressViewController.h"
#import "DeilveryAddressTableViewCell.h"
#import "EditDeliveryAddressViewController.h"
@interface DeliveryAddressViewController ()<UITableViewDelegate,UITableViewDataSource,DeilveryAddressTableViewCellDelegate>
{
    UITableView * myTableView;
    UIButton * bottomButton;
    UILabel * normalLabel;
    NSMutableArray * dataArray;
}
@end

@implementation DeliveryAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLab.text = @"收货地址";
    dataArray = [NSMutableArray array];
    [self getData];
    [self createBaseView];
}

- (void)getData{
    [ConfigModel showHud:self];
    [HttpRequest postPath:ReceiptListURL params:nil resultBlock:^(id responseObject, NSError *error) {
        DeliveryAddressModel * model = [[DeliveryAddressModel alloc] initWithDictionary:responseObject error:nil];
        [dataArray removeAllObjects];
        if (model.error == 0) {
            [dataArray addObjectsFromArray:model.info];
        }else{
            [ConfigModel mbProgressHUD:model.message andView:nil];
        }
        [self changeEmptyView];
        [ConfigModel hideHud:self];
        [myTableView reloadData];
    }];
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
    [myTableView registerClass:[DeilveryAddressTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(64);
        make.left.right.mas_offset(0);
        make.bottom.mas_offset(-70);
    }];
    
    bottomButton = [UIButton new];
    bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    bottomButton.backgroundColor = UIColorFromHex(0x3e7bb1);
    bottomButton.layer.cornerRadius = 4.0f;
    bottomButton.layer.masksToBounds = YES;
    [bottomButton setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(addDeliveryAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-20);
        make.height.mas_offset(40);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
    
    normalLabel = [UILabel new];
    normalLabel.text = @"您还没有收货地址";
    normalLabel.hidden = YES;
    normalLabel.font = [UIFont systemFontOfSize:16];
    normalLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:normalLabel];
    [normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
    }];
}

- (void)changeEmptyView{
    if (dataArray.count == 0) {
        myTableView.hidden = YES;
        normalLabel.hidden = NO;
        [bottomButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(normalLabel.mas_bottom).offset(20);
            make.height.mas_offset(40);
            make.left.mas_offset(20);
            make.right.mas_offset(-20);
        }];
    }else{
        myTableView.hidden = NO;
        normalLabel.hidden = YES;
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-20);
            make.height.mas_offset(40);
            make.left.mas_offset(20);
            make.right.mas_offset(-20);
        }];
    }
}
//新建收货地址
- (void)addDeliveryAddressAction:(UIButton *)button{
    EditDeliveryAddressViewController * editAddressVC = [[EditDeliveryAddressViewController alloc] init];
    [editAddressVC setFinishBlock:^(DeliveryAddressInfo *model) {
        if (model.isdefault == 1) {
            for (DeliveryAddressInfo * info in dataArray) {
                info.isdefault = 0;
            }
            [dataArray insertObject:model atIndex:0];
        }else{
            [dataArray addObject:model];
        }
        [myTableView reloadData];
        [self changeEmptyView];
    }];
    [self.navigationController pushViewController:editAddressVC animated:YES];
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
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeilveryAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[DeilveryAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.model = dataArray[indexPath.section];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeliveryAddressInfo *model = [[DeliveryAddressInfo alloc] init];
    model = dataArray[indexPath.section];
    if (self.addressBlock) {
        self.addressBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark DeilveryAddressTableViewCellDelegate
- (void)didDeilveryAddressTableViewCellEditButton:(UIButton *)button{
    CGPoint point = button.center;
    point = [myTableView convertPoint:point fromView:button.superview];
    NSIndexPath* indexPath = [myTableView indexPathForRowAtPoint:point];
    EditDeliveryAddressViewController * editAddressVC = [[EditDeliveryAddressViewController alloc] init];
    editAddressVC.addressModel = dataArray[indexPath.section];
    [editAddressVC setFinishBlock:^(DeliveryAddressInfo *model) {
        if (model.isdefault == 1) {
            [dataArray removeObject:dataArray[indexPath.section]];
            for (DeliveryAddressInfo * info in dataArray) {
                info.isdefault = 0;
            }
            [dataArray insertObject:model atIndex:0];
        }else{
            [dataArray replaceObjectAtIndex:indexPath.section withObject:model];
        }
        [myTableView reloadData];
    }];
    [self.navigationController pushViewController:editAddressVC animated:YES];
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

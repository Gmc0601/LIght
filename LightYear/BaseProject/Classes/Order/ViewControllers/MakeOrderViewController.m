//
//  MakeOrderViewController.m
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "MakeOrderViewController.h"
#import "OrderGoodsTableViewCell.h"
#import "OrderAddressTableViewCell.h"


@interface MakeOrderViewController ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL post; //  配送
    NSString *getTime, *storeName;  //  自取时间   商店名称
}

@property (nonatomic, retain) UITableView *noUseTableView;

@property (nonatomic, retain) NSMutableArray *goodsArr;

@end

@implementation MakeOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetFather];
    
    [self createview];
    
}


- (void)resetFather {
    storeName = @"光年浙工商店";
    self.titleLab.text = @"确认订单";
    self.rightBar.hidden = YES;
}

- (void)createview {
    [self.view addSubview:self.noUseTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return post ? 3 : 4;
        }
            break;
        case 1:{
            return self.goodsArr.count;
        }
            break;
        case 2:{
            return 3;
        }
            break;
            
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = [NSString stringWithFormat:@"%ld%ld", (long)indexPath.section, (long)indexPath.row];
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0 : case 1 :case 2:{
                    return nil;
                }
                    break;
                    
                case 3:{
                    return nil;
                }
                    break;
                    
                default:
                    return nil;
                    break;
            }
        }
            break;
        case 1:{
            OrderGoodsTableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            }
            return cell;
        }
            break;
        case 2:{
            UITableViewCell *cell = [self.noUseTableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId];
                cell.textLabel.font = SourceHanSansCNRegular(15);
                cell.textLabel.text = @"标题";
                cell.detailTextLabel.text = @"附表图";
                cell.detailTextLabel.font = VerdanaBold(15);
                return cell;
            }
        }
            break;
            
        default:
            return nil;
            break;
    }
    return nil;
}

#pragma mark - UITableDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 3) {
                return SizeHeigh(150);
            }else if (indexPath.row == 2){
                return post ? SizeHeigh(90) : SizeHeigh(50);
            }else {
                return SizeHeigh(50);
            }
        }
            break;
        case 1:{
            return SizeHeigh(160);
        }
            break;
        case 2:{
            return SizeHeigh(50);
        }
            break;
            
        default:
            return 0;
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, kScreenW, SizeHeigh(45))];
        UILabel *lab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(10), SizeHeigh(15), kScreenW, SizeHeigh(20))];
        lab.text = storeName;
        lab.font = NormalFont(15);
        
        UILabel *line = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeigh(44), kScreenW, SizeHeigh(1))];
        line.backgroundColor = RGBColor(239, 240, 241);
        
        [view addSubview:lab];
        [view addSubview:line];
        
        return view;
    }else{
        return nil;
    }
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

- (NSMutableArray *)goodsArr {
    if (!_goodsArr) {
        _goodsArr = [NSMutableArray new];
    }
    return _goodsArr;
}

@end

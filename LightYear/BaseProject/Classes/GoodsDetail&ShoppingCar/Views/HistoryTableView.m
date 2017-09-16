//
//  HistoryTableView.m
//  BaseProject
//
//  Created by LeoGeng on 16/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "HistoryTableView.h"
#import <Masonry/Masonry.h>
#import "UIColor+BGHexColor.h"
#import <PopupDialog/PopupDialog-Swift.h>

#define TAG 20001

@interface HistoryTableView()<UITableViewDataSource,UITableViewDelegate>{
    NSString *_cellIdentifier;
}
@property(retain,strong) UITableView *tb;
@end

@implementation HistoryTableView

@synthesize datasource = _datasource;
-(void) setDatasource:(NSArray *)datasource{
    _datasource = datasource;
    [self addSubViews];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void) addSubViews{
    [self removeAllSubviews];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNRegular(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = @"历史搜索";
    [self addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(SizeHeigh(20));
        make.left.equalTo(self).offset(SizeWidth(15));
        make.right.equalTo(self).offset(-SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(13)));
    }];
    
    UIView *seperatorView = [UIView new];
    seperatorView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    [self addSubview:seperatorView];
    
    [seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lblTitle.mas_bottom).offset(SizeHeigh(20));
        make.left.equalTo(self).offset(SizeWidth(15));
        make.right.equalTo(self).offset(-SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(0.5)));
    }];
    
    if (self.datasource.count > 0) {
        [self addTableView];
        [_tb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(seperatorView.mas_bottom).offset(SizeHeigh(20));
            make.left.equalTo(self).offset(SizeWidth(15));
            make.right.equalTo(self).offset(-SizeWidth(15));
            make.bottom.equalTo(self);
        }];
        
        UIButton *btnDelete = [UIButton new];
        [btnDelete setImage:[UIImage imageNamed:@"icon_qk"] forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(tapDeleteAllButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDelete];
        
        [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-SizeWidth(15));
            make.centerY.equalTo(lblTitle.mas_centerY);
            make.height.equalTo(@(SizeHeigh(21)));
            make.width.equalTo(@(SizeHeigh(21)));
        }];
    }else{
        UILabel *lblMsg = [UILabel new];
        lblMsg.font = SourceHanSansCNRegular(SizeWidth(12));
        lblMsg.textColor = [UIColor colorWithHexString:@"#999999"];
        lblMsg.textAlignment = NSTextAlignmentCenter;
        lblMsg.text = @"暂无历史搜索";
        [self addSubview:lblMsg];
        
        [lblMsg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(seperatorView).offset(SizeHeigh(30));
            make.left.equalTo(self).offset(SizeWidth(15));
            make.right.equalTo(self).offset(-SizeWidth(15));
            make.height.equalTo(@(SizeHeigh(13)));
        }];
    }
}

-(void) addTableView{
    _cellIdentifier = @"cell";
    _tb = [[UITableView alloc] init];
    _tb.rowHeight = SizeHeigh(132/2);
    _tb.delegate = self;
    _tb.dataSource = self;
    _tb.allowsSelection = YES;
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tb registerClass:[UITableViewCell class] forCellReuseIdentifier:_cellIdentifier];
    _tb.tableFooterView = [UIView new];
    
    [self addSubview:_tb];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    UILabel *lbl = [cell viewWithTag:TAG];
    
    if (lbl == nil) {
        [self addSubViewToCell:cell withIndex:indexPath.row];
        lbl = [cell viewWithTag:TAG];
    }
    
    lbl.text = self.datasource[indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelect:self.datasource[indexPath.row]];
}

-(void) addSubViewToCell:(UITableViewCell *) cell withIndex:(NSInteger) index{
    
    UIButton *btnDelete = [UIButton new];
    btnDelete.tag = index;
    [btnDelete setImage:[UIImage imageNamed:@"icon_sc"] forState:UIControlStateNormal];
    [btnDelete addTarget:self action:@selector(tapDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btnDelete];
    
    [btnDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(SizeWidth(15));
        make.centerY.equalTo(cell.mas_centerY);
        make.height.equalTo(@(SizeHeigh(22)));
        make.width.equalTo(@(SizeHeigh(22)));
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(17));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.tag = TAG;
    [cell addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnDelete.mas_right).offset(SizeWidth(15));
        make.centerY.equalTo(cell.mas_centerY);
        make.height.equalTo(@(SizeHeigh(22)));
        make.right.equalTo(cell).offset(-SizeWidth(15));
    }];
    
}

-(void) tapDeleteButton:(UIButton *) sender{
    
    NSString *text = self.datasource[sender.tag];
    NSMutableArray *history = [ConfigModel getArrforKey:@"search_history"];
    [history removeObject:text];
    [ConfigModel saveArr:history forKey:@"search_history"];
    self.datasource = history;
    //    [self.delegate didDelete:text];
}

-(void) tapDeleteAllButton{
    PopupDialog *popup = [[PopupDialog alloc] initWithTitle:@"" message:@"确定要清空历史搜索吗？" image:nil buttonAlignment:(UILayoutConstraintAxisHorizontal) transitionStyle:PopupDialogTransitionStyleBounceDown gestureDismissal:YES completion:nil];

    // Create buttons
    CancelButton *leftBotton = [[CancelButton alloc] initWithTitle:@"取消" height:SizeHeigh(50) dismissOnTap:YES action:^{
        [popup dismiss:nil];
    }];
    
    DefaultButton *okButton = [[DefaultButton alloc] initWithTitle:@"确定" height:SizeHeigh(50) dismissOnTap:YES action:^{
        NSMutableArray *history = [NSMutableArray arrayWithCapacity:0] ;
        
        [ConfigModel saveArr:history forKey:@"search_history"];
        self.datasource = history;
        
        [popup dismiss:nil];
    }];
    
    [popup addButton:leftBotton];
    [popup addButton:okButton];
    [self.ownerVC presentViewController:popup animated:YES completion:nil];
}

@end

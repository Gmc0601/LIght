//
//  WMBalancePointDetailsViewController.m
//  BaseProject
//
//  Created by wmk on 2017/9/17.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "WMBalancePointDetailsViewController.h"
#import "balancePointDetailsCell.h"
#import "WMSegmentView.h"
#import "WMScrollView.h"
#import "WMTableView.h"

@interface WMBalancePointDetailsViewController () <WMSegmentViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WMSegmentView *segmentView;
@property (nonatomic, strong) WMScrollView *scrollView;
@property (nonatomic, strong) WMTableView *balanceTableV;
@property (nonatomic, strong) WMTableView *pointTableV;

@property (nonatomic, assign) NSInteger segmentCurrentIndex;

@end

@implementation WMBalancePointDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _segmentView.currentIndex = _segmentCurrentIndex;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _segmentCurrentIndex = _segmentView.currentIndex;
}

#pragma mark - WMTableViewDelegate && UITableViewDataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SizeHeigh(71);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"balancePointDetailsCell";
    balancePointDetailsCell *detailCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!detailCell) {
        detailCell = [[balancePointDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [detailCell fillDataWithModel];
    return detailCell;
}

#pragma mark - WMSegmentViewDelegate

- (void)segment:(WMSegmentView *)segment didSelectAtIndex:(NSInteger)index;
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.width*index, 0) animated:YES];
    
    if (index == 0) {
        
    } else if (index == 1) {
        
    } else {
        
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView) {
        int index = scrollView.contentOffset.x / _scrollView.width;
        [_segmentView setSelectedBtn:index];
    }
}

- (void)setupSubView
{
    self.navigationItem.titleView = self.segmentView;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.balanceTableV];
    [self.scrollView addSubview:self.pointTableV];
}

- (WMSegmentView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[WMSegmentView alloc] initWithFrame:CGRectMake(0, 0, SizeWidth(185), SizeHeigh(35))];
        _segmentView.items = @[@"余额明细",@"积分明细"];
        _segmentView.delegate = self;
    }
    return _segmentView;
}

- (WMScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[WMScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)];
        _scrollView.contentSize = CGSizeMake(kScreenW*2, 0);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (WMTableView *)balanceTableV
{
    if (!_balanceTableV) {
        _balanceTableV = [[WMTableView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, _scrollView.height) style:UITableViewStylePlain];
        _balanceTableV.delegate = self;
        _balanceTableV.dataSource = self;
        _balanceTableV.backgroundColor = [UIColor clearColor];
        _balanceTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _balanceTableV;
}

- (WMTableView *)pointTableV
{
    if (!_pointTableV) {
        _pointTableV = [[WMTableView alloc] initWithFrame:CGRectMake(kScreenW, 10, kScreenW, _scrollView.height-74) style:UITableViewStylePlain];
        _pointTableV.delegate = self;
        _pointTableV.dataSource = self;
        _pointTableV.backgroundColor = [UIColor clearColor];
        _pointTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _pointTableV;
}



@end

//
//  FirstLevelGoodsViewController.m
//  BaseProject
//
//  Created by LeoGeng on 08/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "GoodDetialViewController.h"
#import "GoodsCategory.h"
#import "GoodDetialViewController.h"
#import "GoodsModel.h"
#import "GoodsCell.h"
#import <ZYBannerView/ZYBannerView.h>
#import "NSString+Category.h"

#define TAG 100
#define ARROW_TAG 1000
#define Detail_TAG 10001
#define Remaind_TAG 10002

@interface GoodDetialViewController () <UITableViewDelegate,UITableViewDataSource,ZYBannerViewDelegate,ZYBannerViewDataSource>{
    
}
@property(retain,atomic) UITableView *tb;
@property(retain,atomic) NSString *cellIdentifier;
@property(retain,atomic) NSString *headerIdentifier;
@property(retain,atomic) ZYBannerView *banner;
@property(retain,atomic) UILabel *lblTitle;
@property(retain,atomic) UILabel *lblPrice1;
@property(retain,atomic) UILabel *lblPrice2;
@property(retain,atomic) UILabel *lblMember;
@property(retain,atomic) UILabel *lblNoMember;
@property(retain,atomic) UILabel *lblCanDelivery;
@property(retain,atomic) UILabel *lblTakeBySelf;
@property(retain,atomic) UIImageView *imgDiscounts;
@property(retain,atomic) UIImageView *imgNew;
@property(retain,atomic) GoodsModel *model;
@property(assign,nonatomic) BOOL showDetail;
@property(assign,nonatomic) BOOL showReminder;
@property(assign,nonatomic) CGFloat heightOfDetail;
@property(retain,atomic) UIView *pricePanel;
@property(retain,atomic) UIButton *btnFaveritor;
@property(retain,atomic) UIView *choosePanel;
@property(retain,atomic) UIView *purchasePanel;

@end

@implementation GoodDetialViewController
@synthesize goodsId = _goodsId;
-(void) setGoodsId:(NSString *)goodsId{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mockData];
    [self addTableView];
    self.rightBar.hidden = YES;
}

-(void) mockData{
    _model = [GoodsModel new];
    _model._id = @"1";
    _model.name = @"小龙虾";
    _model.canTakeBySelf = YES;
    _model.hasDiscounts = YES;
    _model.canDelivery = NO;
    _model.isNew = NO;
    _model.price = @"111";
    _model.memberPrice = @"1";
}


-(void) addTableView{
    _cellIdentifier = @"cell";
    _headerIdentifier = @"header";
    _tb = [[UITableView alloc] init];
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:_cellIdentifier];
    [_tb registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:_headerIdentifier];
    _tb.tableFooterView = [UIView new];
    _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tb.allowsSelection = NO;
    [self.view addSubview:_tb];
    
    [_tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
        if ([self hasBottomView]) {
            make.bottom.equalTo(self.bottomView.mas_top);
        }else{
            make.bottom.equalTo(self.view);
        }
    }];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    
    if (indexPath.section != 3) {
        [self addSeperatorToView:cell];
    }
    
    switch (indexPath.section) {
        case 0:
            [self addBannerToCell:cell];
            [self addGoodsDetailToCell:cell];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodDetialViewController *newVC = [GoodDetialViewController new];
    
    [self.navigationController pushViewController:newVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return SizeHeigh(625);
    }else if(indexPath.section == 1){
        if (_showDetail) {
            return SizeHeigh(_heightOfDetail + 100);
        }else{
            return 0;
        }
    }else if(indexPath.section == 2){
        if (_showReminder) {
            return SizeHeigh( _heightOfDetail + 100);
        }else{
            return 0;
        }
    }
    
    return  SizeHeigh(271);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 2) {
        return SizeHeigh(61);
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:_headerIdentifier];
    
    if (section == 1) {
        header.tag = Detail_TAG;
        [self setHeader:header withSection:section withText:@"产品详情" isShowing:_showDetail];
    }else if (section == 2){
        header.tag = Remaind_TAG;
        [self setHeader:header withSection:section withText:@"重要提示" isShowing:_showReminder];
    }
    
    return header;
}

-(void) addBannerToCell:(UITableViewCell *) cell{
    _banner = [ZYBannerView new];
    _banner.dataSource = self;
    _banner.delegate = self;
    _banner.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#cccccc"];
    _banner.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#333333"];
    [cell addSubview:_banner];
    
    [_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell);
        make.top.equalTo(cell);
        make.right.equalTo(cell);
        make.height.equalTo(@(SizeHeigh(227)));
    }];
}

-(void) addGoodsDetailToCell:(UITableViewCell *) cell{
    [self addTitleToCell:cell];
    [self addPriceLableToCell:cell];
    [self addFavoriteButtonToCell:cell];
    [self addShareButtonToCell:cell];
    [self addChoosePanelToCell:cell];
    [self addPurchasePanelToCell:cell];
    [self addDDPanelToCell:cell];
}

-(void) addTitleToCell:(UITableViewCell *) cell{
    _lblTitle = [UILabel new];
    _lblTitle.font = SourceHanSansCNMedium(SizeWidth(15));
    _lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.text = _model.name;
    [cell addSubview:_lblTitle];
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(SizeWidth(15));
        make.top.equalTo(_banner.mas_bottom).offset(SizeHeigh(25));
        make.right.equalTo(cell).offset(SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(30)));
    }];
}

-(void) addPriceLableToCell:(UITableViewCell *) cell{
    CGFloat heightOfPricePanel = SizeHeigh(28);
    _pricePanel = [UIView new];
    [cell addSubview:_pricePanel];
    
    _lblPrice1 = [UILabel new];
    _lblPrice1.font = VerdanaBold(SizeWidth(28));
    _lblPrice1.textAlignment = NSTextAlignmentLeft;
    _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.memberPrice];
    
    [cell addSubview:_lblPrice1];
    
    
    if ([self noMemberPriceLable]) {
        _lblPrice1.text = [NSString stringWithFormat:@"￥%@",_model.price];
        heightOfPricePanel = SizeHeigh(33);
    }
    
    CGFloat width = [_lblPrice1.text widthWithFontSize:SizeWidth(28) height:SizeWidth(28)];
    if (_model.isNew) {
        width += SizeWidth(22);
        _lblPrice1.textAlignment = NSTextAlignmentCenter;
    }
    
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pricePanel);
        make.left.equalTo(_pricePanel);
        make.height.equalTo(@(SizeHeigh(28)));
        make.width.equalTo(@(width));
    }];
    
    if (!_model.isNew) {
        if ([self noMemberPriceLable]) {
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        }else{
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#ff9e23"];;
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(5) toCell:_pricePanel];
            [self addPriceLabel2ToCell:cell];
        }
    }else{
        _lblPrice1.backgroundColor = [UIColor colorWithHexString:@"fecd2f"];
        _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        
        if (![self noMemberPriceLable]) {
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(10) toCell:cell];
            [self addPriceLabel2ToCell:cell];
        }
        
        _lblPrice1.layer.shadowOpacity = 1.0;
        _lblPrice1.layer.shadowRadius = 0.0;
        _lblPrice1.layer.shadowColor = [UIColor colorWithHexString:@"#ff3b30"].CGColor;
        _lblPrice1.layer.shadowOffset = CGSizeMake(SizeWidth(5), SizeHeigh(5));
    }
    
    [_pricePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(20));
        make.left.equalTo(_lblTitle);
        make.height.equalTo(@(heightOfPricePanel));
        make.width.equalTo(@(SizeWidth(400)));
    }];
}

-(void) addNewImageToCell:(UITableViewCell *) cell{
    _imgNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_xq_xp"]];
    [cell addSubview:_imgNew];
    
    [_imgNew mas_makeConstraints:^(MASConstraintMaker *make) {
        if (_imgDiscounts == nil) {
            make.left.equalTo(_lblTakeBySelf.mas_right).offset(SizeWidth(10));
        }else{
            make.left.equalTo(_imgDiscounts.mas_right).offset(SizeWidth(10));
        }
        
        make.centerY.equalTo(_lblTakeBySelf);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(22)));
    }];
}

-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin toCell:(UIView *) cell{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员" withConstraintView:_lblPrice1 withLeftMargin:leftMargin toCell:cell];
}

-(void) addPriceLabel2ToCell:(UIView *) cell{
    _lblPrice2 = [UILabel new];
    _lblPrice2.font = VerdanaBold(SizeWidth(15));
    _lblPrice2.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblPrice2.textAlignment = NSTextAlignmentLeft;
    _lblPrice2.text = [NSString stringWithFormat:@"￥%@",_model.price];
    
    [cell addSubview:_lblPrice2];
    CGFloat width = [_lblPrice2.text widthWithFontSize:SizeWidth(15) height:SizeWidth(15)] + SizeWidth(10);
    [_lblPrice2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblPrice1.mas_bottom).offset(SizeHeigh(18));
        make.left.equalTo(_lblPrice1);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(width));
    }];
    
    [self getLabeForMemberAndNoMemberLabel:[UIColor colorWithHexString:@"#333333"] withText:@"非会员" withConstraintView:_lblPrice2 withLeftMargin:SizeWidth(2) toCell:cell];
}

-(UILabel *) getLabeForMemberAndNoMemberLabel:(UIColor *) fontColor withText:(NSString *) text withConstraintView:(UIView *) constraintView withLeftMargin:(CGFloat) leftMargin toCell:(UIView *) cell{
    UILabel *lbl = [UILabel new];
    lbl.font = SourceHanSansCNLight(SizeWidth(12));
    lbl.textColor = fontColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    
    [cell addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(constraintView).offset(SizeHeigh(-1));
        make.left.equalTo(constraintView.mas_right).offset(leftMargin);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(100)));
    }];
    
    return lbl;
}

-(void) setHeader:(UITableViewHeaderFooterView *) header withSection:(NSInteger) section withText:(NSString *) text isShowing:(BOOL) show{
    UILabel *lblTitle = [header viewWithTag:TAG + section];
    if (lblTitle == nil) {
        lblTitle = [self addLableToHeaderView:header  withIndex:section];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        
        [header addGestureRecognizer:tapGesture];
    }
    
    lblTitle.text = text;
    
    header.backgroundView = [UIView new];
    UIImageView *img = [ self addImageToHeaderView:header withIndex:section];
    if (show) {
        img.image = [UIImage imageNamed:@"sg_ic_down"];
        header.contentView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f2"];
    }else{
        img.image = [UIImage imageNamed:@"sg_ic_down_up"];
    }
}

-(UILabel *) addLableToHeaderView:(UIView *) header withIndex:(NSInteger) index{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.tag = TAG + index;
    
    [header addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header);
        make.left.equalTo(header.mas_left).offset(SizeWidth(15));
        make.width.equalTo(@(SizeWidth(100)));
    }];
    
    return lblTitle;
}

-(UIImageView *) addImageToHeaderView:(UIView *) header withIndex:(NSInteger) index{
    NSInteger tag = ARROW_TAG + index;
    UIImageView *imgView = [header viewWithTag:tag];
    
    if (imgView == nil) {
        imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sg_ic_down.png"]];
        
        [header addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(header);
            make.right.equalTo(header.mas_right).offset(SizeWidth(-15));
            make.width.equalTo(@(SizeWidth(14)));
            make.height.equalTo(@(SizeHeigh(7)));
            
        }];
    }
    
    return imgView;
}

-(void) addSeperatorToView:(UIView *) superView{
    UIView * lineView = [UIView new];
    lineView.backgroundColor = [UIColor grayColor];
    
    [superView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superView.mas_width);
        make.height.equalTo(@(0.5));
        make.bottom.equalTo(superView.mas_bottom);
    }];
}

-(void) tapHeader:(UITapGestureRecognizer *) gesture{
    NSUInteger index = 0;
    if (gesture.view.tag == Detail_TAG) {
        index = 1;
        _showDetail = !_showDetail;
    }else if(gesture.view.tag == Remaind_TAG){
        _showReminder = !_showReminder;
        index = 2;
    }
    
    [_tb reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) addFavoriteButtonToCell:(UIView *) superView{
    _btnFaveritor = [UIButton new];
    [_btnFaveritor setImage:[UIImage imageNamed:@"icon_xq_sc"] forState:UIControlStateNormal];
    [superView addSubview:_btnFaveritor];
    
    [_btnFaveritor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(SizeWidth(-15));
        if ([self noMemberPriceLable]) {
            make.bottom.equalTo(_pricePanel);
        }else{
            make.centerY.equalTo(_pricePanel);
        }
        
        make.width.equalTo(@(SizeWidth(22)));
        make.height.equalTo(@(SizeHeigh(22)));
    }];
}

-(void) addShareButtonToCell:(UIView *) superView{
    UIButton *btnShare = [UIButton new];
    [btnShare setImage:[UIImage imageNamed:@"icon_xq_fx"] forState:UIControlStateNormal];
    
    [superView addSubview:btnShare];
    
    [btnShare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btnFaveritor.mas_left).offset(-SizeWidth(72/2));
        make.centerY.equalTo(_btnFaveritor);
        make.width.equalTo(@(SizeWidth(22)));
        make.height.equalTo(@(SizeHeigh(22)));
    }];
    
}

-(void) addChoosePanelToCell:(UIView *) superView{
    _choosePanel = [UIView new];
    [superView addSubview:_choosePanel];
    
    [_choosePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@(SizeHeigh(92/2)));
        make.top.equalTo(_pricePanel.mas_bottom).offset(SizeHeigh(40));;
    }];
    
    UILabel *lblName = [UILabel new];
    lblName.font = SourceHanSansCNMedium(SizeWidth(15));
    lblName.textColor = [UIColor colorWithHexString:@"#333333"];
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.text = @"已选";
    
    [_choosePanel addSubview:lblName];
    
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_choosePanel.mas_centerY);
        make.left.equalTo(_lblTitle);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(SizeWidth(50)));
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_xq_xzsx"]];
    
    [_choosePanel addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_choosePanel.mas_centerY);
        make.right.equalTo(_choosePanel.mas_right).offset(-SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeWidth(8)));
    }];
}

-(void) addPurchasePanelToCell:(UIView *) superView{
    _purchasePanel = [UIView new];
    _purchasePanel.layer.cornerRadius = SizeWidth(2.5);
    [superView addSubview:_purchasePanel];
    
    [_purchasePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SizeHeigh(44)));
        make.top.equalTo(_choosePanel.mas_bottom).offset(SizeHeigh(20));
        make.width.equalTo(@(SizeWidth(690/2)));
        make.centerX.equalTo(superView);
    }];
    
    if (_model.count > 0) {
        _purchasePanel.backgroundColor = [UIColor colorWithHexString:@"#3e7bb1"];
        [self addPurchaseButtonToPurchasePanel];
    }else{
        _purchasePanel.backgroundColor = [UIColor colorWithHexString:@"#e3e3e3"];
        [self addCompleteMessageToPurchasePanel];
    }
}

-(void) addPurchaseButtonToPurchasePanel{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buy)];
    [_purchasePanel addGestureRecognizer:tapGesture];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(15));
    lblTitle.textColor = [UIColor colorWithHexString:@"#ffffff"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"添加至购物清单";
    
    [_purchasePanel addSubview:lblTitle];
    
    CGFloat width = [lblTitle.text widthWithFontSize:SizeWidth(15) height:SizeHeigh(15)];
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_purchasePanel.mas_centerY);
        make.centerX.equalTo(_purchasePanel.mas_centerX).offset(SizeWidth(54/2));
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(width));
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nav_tjzqd"]];
    
    [_purchasePanel addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_purchasePanel.mas_centerY);
        make.right.equalTo(lblTitle.mas_left).offset(-SizeWidth(10));
        make.height.equalTo(@(SizeHeigh(22)));
        make.width.equalTo(@(SizeWidth(22)));
    }];
}

-(void) addCompleteMessageToPurchasePanel{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(15));
    lblTitle.textColor = [UIColor colorWithHexString:@"#999999"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"已售罄";
    
    [_purchasePanel addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_purchasePanel.mas_centerY);
        make.centerX.equalTo(_purchasePanel.mas_centerX);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(SizeWidth(150)));
    }];
}

-(void) addDDPanelToCell:(UIView *) superView{
    UIView *view1 = [self addDilivery:superView preView:_purchasePanel top:SizeHeigh(30) text:@"本商品支持配送"];
    
    UIView *view2 = [self addDilivery:superView preView:view1 top:SizeHeigh(25) text:@"本商品支持到店自取"];
    
    [self addDiscountPanel:superView preView:view2 top:SizeHeigh(25)];
    
}

-(UIView *) addDilivery:(UIView *) superView preView:(UIView *) preView top:(CGFloat) top text:(NSString *) text{
    UIView *view = [UIView new];
    [superView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preView.mas_bottom).offset(SizeHeigh(top));
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@(SizeHeigh(16)));
    }];
    
    BOOL highlight = NO;
    
    UIView *dotView = [self getDotViewWithHighlight:highlight];
    
    [view addSubview:dotView];
    
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(SizeWidth(16));
        make.centerY.equalTo(view);
        make.width.equalTo(@(SizeWidth(10)));
        make.height.equalTo(@(SizeHeigh(10)));
    }];
    
    UILabel *lbl = [self getLableForDiscount:text withHighlight:highlight];
    [view addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dotView.mas_right).offset(SizeWidth(25));
        make.bottom.equalTo(view);
        make.top.equalTo(view);
        make.right.equalTo(view.mas_right);
    }];
    
    return view;
}

-(void) addDiscountPanel:(UIView *) superView preView:(UIView *) preView top:(CGFloat) top{
    UIView *view = [UIView new];
    [superView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.top.equalTo(preView.mas_bottom).offset(SizeHeigh(top));
        make.height.equalTo(@(SizeHeigh(16)));
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nav_yh"]];
    
    [view addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(SizeWidth(15));
        make.bottom.equalTo(view);
        make.top.equalTo(view);
        make.width.equalTo(@(SizeWidth(22)));
    }];
    
    BOOL highlight = NO;
    UILabel *lbl = [self getLableForDiscount:_model.discountMessage withHighlight:highlight];
    [view addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(SizeWidth(13));
        make.bottom.equalTo(view);
        make.top.equalTo(view);
        make.right.equalTo(view.mas_right);
    }];
}

-(UIView *) getDotViewWithHighlight:(BOOL) highlight{
    UIView *dotView = [UIView new];
    dotView.layer.cornerRadius = SizeWidth(10/2);

    
    if (highlight) {
        dotView.backgroundColor = [UIColor colorWithHexString:@"#4ead35"];
    }else{
        dotView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        
    }
    
    return dotView;
}


-(UILabel *) getLableForDiscount:(NSString *) text withHighlight:(BOOL) highlight{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNRegular(SizeWidth(13));
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = text;
    
    if (highlight) {
        lblTitle.textColor = [UIColor colorWithHexString:@"#4ead35"];
    }else{
        lblTitle.textColor = [UIColor colorWithHexString:@"#999999"];
        
    }
    
    return lblTitle;
}

-(void) addSubViewForLastCell:(UIView *) superView{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(13));
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    lblTitle.text = @"推荐";
    
    [superView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.top.equalTo(superView).offset(SizeHeigh(19));
        make.height.equalTo(@(SizeHeigh(13)));
        make.width.equalTo(@(SizeHeigh(100)));
    }];
}

-(BOOL) noMemberPriceLable{
    return [_model.memberPrice isEqualToString:@""];
}

-(void) buy{
    
}
@end

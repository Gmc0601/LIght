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
#import "KLCPopup.h"
#import "RecommendCV.h"
#import "PropertyPickView.h"
#import "NSMutableAttributedString+Category.h"
#import "UIImageView+WebCache.h"
#import "SKU.h"
#import "SKUPrice.h"
#import "NSString+Category.h"

#define TAG 100
#define ARROW_TAG 1000
#define Detail_TAG 10001
#define Remaind_TAG 10002
#define Share_TAG 100000

@interface GoodDetialViewController () <UITableViewDelegate,UITableViewDataSource,ZYBannerViewDelegate,ZYBannerViewDataSource,UIWebViewDelegate>{
    
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
@property(retain,atomic) UIImageView *imgDiscounts;
@property(retain,atomic) UIImageView *imgNew;
@property(retain,atomic) GoodsModel *model;
@property(assign,nonatomic) BOOL showDetail;
@property(assign,nonatomic) BOOL showReminder;
@property(assign,nonatomic) CGFloat heightOfInfo;
@property(assign,nonatomic) CGFloat heightOfDesc;
@property(retain,atomic) UIView *pricePanel;
@property(retain,atomic) UIButton *btnFaveritor;
@property(retain,atomic) UIView *choosePanel;
@property(retain,atomic) UIView *purchasePanel;
@property(retain,atomic) KLCPopup* sharePopup;
@property(retain,atomic) KLCPopup* choosePopup;
@property(retain,atomic) RecommendCV* recommendCV;
@property(retain,atomic) NSArray* skuList;
@property(retain,atomic) NSArray* skuPriceList;
@property (retain,nonatomic) NSString *goodsId;
@property (retain,nonatomic) NSString *shopId;
@property (retain,nonatomic) SKU *sku;
@property(retain,atomic) NSMutableArray *skuLableArray;
@property(retain,atomic) PropertyPickView *pickView;
@property(retain,atomic) NSMutableArray *skuSelectValue;
@property(retain,atomic) UIWebView *infoWebView;
@property(retain,atomic) UIWebView *descWebView;
@property(retain,atomic)  SKUPrice *skuPrice;
@property(assign,atomic)  int *countOfCell;
@property(assign,atomic)  BOOL *multiLine;
@end

@implementation GoodDetialViewController
@synthesize goodsId = _goodsId;
-(void) setGoodsId:(NSString *)goodsId{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _countOfCell = 3;
    [self addBottomView];

    [self addTableView];
    self.rightBar.hidden = YES;
}

-(void) addTableView{
    _cellIdentifier = @"cell";
    _headerIdentifier = @"header";
    _tb = [[UITableView alloc] init];
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:@"cell1"];
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:@"cell2"];
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:@"cell3"];
    [_tb registerClass:[GoodsCell class] forCellReuseIdentifier:@"cell4"];
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
    return _countOfCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    ;
    
    if (_model != nil) {
        switch (indexPath.section) {
            case 0:
                [self addGoodsDetailToCell:cell];
                break;
            case 1:
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
                _infoWebView = [self addWebViewToCell:cell withHtml:_model.info];
                break;
            case 2:
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                _descWebView = [self addWebViewToCell:cell withHtml:_model.desc];
                break;
            case 3:
                cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
                [self addRecommendViewToCell:cell];
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodDetialViewController *newVC = [GoodDetialViewController new];
    
    [self.navigationController pushViewController:newVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat height = 575;
        if (_model.hasDiscounts) {
            height += 30;
        }
        
        if ([self titleIsMultiLine]) {
            height += 20;
        }
        
        return SizeHeigh(height);
    }else if(indexPath.section == 1){
        _infoWebView.hidden = !_showDetail;
        
        if (_showDetail) {
            return _heightOfInfo +SizeHeigh(50);
        }else{
            return 0;
        }
    }else if(indexPath.section == 2){
        _descWebView.hidden = !_showReminder;
        if (_showReminder) {
            return _heightOfDesc + SizeHeigh(50);
        }else{
            return 0;
        }
    }
    
    return  SizeHeigh(350);
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
    if ([self hasView:_banner inSuperView:cell]) {
        return;
    }
    _banner = [ZYBannerView new];
    _banner.dataSource = self;
    _banner.delegate = self;
    _banner.backgroundColor = [UIColor whiteColor];
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

-(NSInteger) numberOfItemsInBanner:(ZYBannerView *)banner{
    return _model.img.count;
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    UIImageView *img = [UIImageView new];
    [img sd_setImageWithURL:[NSURL URLWithString:_model.img[index]]];
    
    return img;
}

-(void) addGoodsDetailToCell:(UITableViewCell *) cell{

    [self addBannerToCell:cell];
    [self addTitleToCell:cell];
    [self addNewFlagToCell:cell];

    [self addPriceLableToCell:cell];
    if (![self hasView:_btnFaveritor inSuperView:cell]) {
        [self addFavoriteButtonToCell:cell];
        [self addShareButtonToCell:cell];
        [self addChoosePanelToCell:cell];
        [self addPurchasePanelToCell:cell];
        [self addDDPanelToCell:cell];
        [self addSeperatorToView:cell];
    }
}

-(void) addNewFlagToCell:(UITableViewCell *) cell{
    if (!_model.isNew || [self hasView:_imgNew inSuperView:cell]) {
        return;
    }
    
    _imgNew = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sign_xq_xp"]];
    [cell addSubview:_imgNew];
    
    [_imgNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(SizeWidth(15));
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(5));
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(22)));
    }];

}

-(void) addTitleToCell:(UITableViewCell *) cell{
    if ([self hasView:_lblTitle inSuperView:cell]) {
        return;
    }
    _lblTitle = [UILabel new];
    _lblTitle.font = SourceHanSansCNMedium(SizeWidth(15));
    _lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblTitle.textAlignment = NSTextAlignmentLeft;
    _lblTitle.text = _model.name;
    _lblTitle.numberOfLines = 2;
    _lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [cell addSubview:_lblTitle];
    
    CGFloat height = SizeHeigh(15);
   
    if ([self titleIsMultiLine]) {
        height = SizeHeigh(45);
    }
    
    [_lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell).offset(SizeWidth(15));
        make.top.equalTo(_banner.mas_bottom).offset(SizeHeigh(25));
        make.right.equalTo(cell).offset(-SizeWidth(15));
        make.height.equalTo(@(height));
    }];
}

-(BOOL) titleIsMultiLine{
    UIFont *font = [UIFont systemFontOfSize:SizeWidth(15)];
    CGFloat width = [_model.name widthWithFont:font height:SizeHeigh(12)];
    if (width > ScreenWidth - SizeWidth(30)) {
        return YES;
    }
    
    return NO;
}

-(void) addPriceLableToCell:(UITableViewCell *) cell{
    CGFloat heightOfPricePanel = SizeHeigh(28);
    
    if (![self hasView:_pricePanel inSuperView:cell]) {
        _pricePanel = [UIView new];
        [cell addSubview:_pricePanel];
    }else{
        [_pricePanel removeAllSubviews];
        [_pricePanel removeConstraints:_pricePanel.constraints];
    }
    
    
    NSString *price1 = _model.memberPrice;
    NSString *price2 = nil;
    _lblPrice1 = [UILabel new];
    _lblPrice1.textAlignment = NSTextAlignmentLeft;
    
    [_pricePanel addSubview:_lblPrice1];
    
    if (_model.specilPrice == nil || [_model.specilPrice isEqualToString:@"0"]) {
        if(_model.memberPrice == nil || [_model.memberPrice isEqualToString:@"0"]){
            price1 = _model.price;
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        }else{
            price1 = _model.memberPrice;
            price2 = _model.price;
            _lblPrice1.textColor = [UIColor colorWithHexString:@"#ff9e23"];;
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(5)];
            [self addPriceLabel2:price2];
        }
    }else{
        if (_model.isUser) {
            price1 = _model.specilPrice;
        }else{
            price1 = _model.specilPrice;
            price2 = _model.specilPrice;
        }
        
        _lblPrice1.backgroundColor = [UIColor colorWithHexString:@"fecd2f"];
        _lblPrice1.textColor = [UIColor colorWithHexString:@"#333333"];
        _lblPrice1.layer.shadowOpacity = 1.0;
        _lblPrice1.layer.shadowRadius = 0.0;
        _lblPrice1.layer.shadowColor = [UIColor colorWithHexString:@"#ff3b30"].CGColor;
        _lblPrice1.layer.shadowOffset = CGSizeMake(SizeWidth(5), SizeHeigh(5));
        _lblPrice1.textAlignment = NSTextAlignmentCenter;
        if (price2 != nil) {
            [self addPriceLabel2:price2];
            [self addMemberLabel:_lblPrice1.textColor withLeftMargin:SizeWidth(15)];
        }
    }
    
    CGFloat width = [price1 widthWithFont:VerdanaBold(SizeWidth(28)) height:SizeWidth(28)] + SizeWidth(28);
    [_lblPrice1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pricePanel);
        make.left.equalTo(_pricePanel);
        make.height.equalTo(@(SizeHeigh(28)));
        make.width.equalTo(@(width));
    }];
    
    _lblPrice1.attributedText = [NSMutableAttributedString attributeString:@"￥ " prefixFont:VerdanaItalic(SizeWidth(28)) prefixColor:_lblPrice1.textColor suffixString:price1 suffixFont: VerdanaBold(SizeWidth(28)) suffixColor:_lblPrice1.textColor];
    CGFloat height = 20;
    if (_model.isNew) {
        height = 30;
    }
    
    [_pricePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblTitle.mas_bottom).offset(SizeHeigh(height));
        make.left.equalTo(_lblTitle);
        make.height.equalTo(@(heightOfPricePanel));
        make.width.equalTo(@(SizeWidth(400)));
    }];
}


-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员" withConstraintView:_lblPrice1 withLeftMargin:leftMargin];
}

-(void) addPriceLabel2:(NSString *) price{
    _lblPrice2 = [UILabel new];
    //    _lblPrice2.font = VerdanaBold(SizeWidth(15));
    _lblPrice2.textColor = [UIColor colorWithHexString:@"#333333"];
    _lblPrice2.textAlignment = NSTextAlignmentLeft;
    _lblPrice2.attributedText = [NSMutableAttributedString attributeString:@"￥ " prefixFont:VerdanaItalic(SizeWidth(15)) prefixColor:_lblPrice2.textColor suffixString:price suffixFont: VerdanaBold(SizeWidth(15)) suffixColor:_lblPrice2.textColor];
    
    [_pricePanel addSubview:_lblPrice2];
    CGFloat width = [_lblPrice2.text widthWithFont:_lblPrice2.font height:SizeWidth(15)] + SizeWidth(10);
    [_lblPrice2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lblPrice1.mas_bottom).offset(SizeHeigh(18));
        make.left.equalTo(_lblPrice1);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(width));
    }];
    
    [self getLabeForMemberAndNoMemberLabel:[UIColor colorWithHexString:@"#333333"] withText:@"非会员" withConstraintView:_lblPrice2 withLeftMargin:SizeWidth(2)];
}

-(UILabel *) getLabeForMemberAndNoMemberLabel:(UIColor *) fontColor withText:(NSString *) text withConstraintView:(UIView *) constraintView withLeftMargin:(CGFloat) leftMargin{
    UILabel *lbl = [UILabel new];
    lbl.font = SourceHanSansCNLight(SizeWidth(12));
    lbl.textColor = fontColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    
    [_pricePanel addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(constraintView);
        make.left.equalTo(constraintView.mas_right).offset(leftMargin);
        make.height.equalTo(@(SizeHeigh(12)));
        make.width.equalTo(@(SizeHeigh(100)));
    }];
    
    return lbl;
}

-(void) addMemberLabel:(UIColor *) fontColor withLeftMargin:(CGFloat) leftMargin toCell:(UIView *) cell{
    [self getLabeForMemberAndNoMemberLabel:fontColor withText:@"会员" withConstraintView:_lblPrice1 withLeftMargin:leftMargin toCell:cell];
}

-(UILabel *) getLabeForMemberAndNoMemberLabel:(UIColor *) fontColor withText:(NSString *) text withConstraintView:(UIView *) constraintView withLeftMargin:(CGFloat) leftMargin toCell:(UIView *) cell{
    UILabel *lbl = [UILabel new];
    lbl.font = SourceHanSansCNLight(SizeWidth(12));
    lbl.textColor = fontColor;
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.text = text;
    
    [cell addSubview:lbl];
    
    [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(constraintView);
        make.left.equalTo(constraintView.mas_right).offset(leftMargin);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeHeigh(100)));
    }];
    
    return lbl;
}

-(void) setHeader:(UITableViewHeaderFooterView *) header withSection:(NSInteger) section withText:(NSString *) text isShowing:(BOOL) show{
    [header removeAllSubviews];
    UILabel *lblTitle = [header viewWithTag:TAG + section];
    if (lblTitle == nil) {
        lblTitle = [self addLableToHeaderView:header  withIndex:section];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
        
        [header addGestureRecognizer:tapGesture];
        header.backgroundView = [UIView new];
    }
    
    lblTitle.text = text;
    
    UIImageView *img = [ self addImageToHeaderView:header withIndex:section];
    
    if (show) {
        img.image = [UIImage imageNamed:@"sg_ic_down"];
        header.backgroundView.backgroundColor = [UIColor colorWithHexString:@"#f1f2f2"];
    }else{
        img.image = [UIImage imageNamed:@"sg_ic_down_up"];
        header.backgroundView.backgroundColor = [UIColor clearColor];
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
    [_btnFaveritor setSelected:_model.isFollow];
    [_btnFaveritor setImage:[UIImage imageNamed:@"icon_xq_sc"] forState:UIControlStateNormal];
    [_btnFaveritor setImage:[UIImage imageNamed:@"icon_xq_sc_pre"] forState:UIControlStateSelected];
    [_btnFaveritor addTarget:self action:@selector(tapFavoriteButton) forControlEvents:UIControlEventTouchUpInside];
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

-(void) tapFavoriteButton{
    [ConfigModel showHud:self];
    if (_btnFaveritor.selected) {
        [NetHelper cancelFavoriteWithGoodsId:_model._id withShopId:_model.shopId callBack:^(NSString *error, NSString *message) {
            [ConfigModel hideHud:self];
            
            if (error == nil) {
                [_btnFaveritor setSelected:NO];
                [ConfigModel mbProgressHUD:message andView:self.view];
            }else{
                [ConfigModel mbProgressHUD:error andView:self.view];
            }
        }];
    }else{
        [NetHelper addToFavoriteWithGoodsId:_model._id withShopId:_model.shopId callBack:^(NSString *error, NSString *message) {
            [ConfigModel hideHud:self];
            
            if (error == nil) {
                [_btnFaveritor setSelected:YES];
                [ConfigModel mbProgressHUD:message andView:self.view];
            }else{
                [ConfigModel mbProgressHUD:error andView:self.view];
            }
        }];
    }
}

-(void) addShareButtonToCell:(UIView *) superView{
    UIButton *btnShare = [UIButton new];
    btnShare.hidden = YES;
    [btnShare setImage:[UIImage imageNamed:@"icon_xq_fx"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
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
    _choosePanel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showChooseView)];
    [_choosePanel addGestureRecognizer:tapGuesture];
    [_choosePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@(SizeHeigh(92/2)));
        make.top.equalTo(_pricePanel.mas_bottom).offset(SizeHeigh(40));
    }];
    
    [self resetSubViewsToChoosePanel];
}

-(void) resetSubViewsToChoosePanel{
    [_choosePanel removeAllSubviews];
    UILabel *lblName = [UILabel new];
    lblName.font = SourceHanSansCNMedium(SizeWidth(15));
    lblName.textColor = [UIColor colorWithHexString:@"#333333"];
    lblName.textAlignment = NSTextAlignmentLeft;
    lblName.text = @"已选";
    
    [_choosePanel addSubview:lblName];
    CGFloat width = [lblName.text widthWithFont:lblName.font height:SizeHeigh(15)];
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_choosePanel.mas_centerY);
        make.left.equalTo(_lblTitle);
        make.height.equalTo(@(SizeHeigh(15)));
        make.width.equalTo(@(width));
    }];
    
    [self addSkuLable:lblName];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_xq_xzsx"]];
    
    [_choosePanel addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_choosePanel.mas_centerY);
        make.right.equalTo(_choosePanel.mas_right).offset(-SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeWidth(8)));
    }];
}

-(void) addSkuLable:(UIView *) leftView{
    if (_skuSelectValue == nil) {
        [self getDataSourceForSKU];
    }
    
    if (_skuLableArray != nil) {
        for (UILabel *lbl in _skuLableArray) {
            [lbl removeFromSuperview];
        }
    }
    _skuLableArray = [NSMutableArray arrayWithCapacity:_skuSelectValue.count];
    
    UIView *left = leftView;
    int index = 0;
    for (SKU *obj in _skuSelectValue) {
        NSString *value = obj.value;
        if (index == 2) {
            value = [NSString stringWithFormat:@"x%@",value];
        }
        
        left = [self addSKUValueLableWith:value withLetView:left withLeftMargin:SizeWidth(10)];
        [_skuLableArray addObject:left];
        index++;
    }
}

-(UILabel *) addSKUValueLableWith:(NSString *) text withLetView:(UIView *) leftView withLeftMargin:(CGFloat)  left{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNRegular(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithHexString:@"#999999"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = text;
    [_choosePanel addSubview:lblTitle];
    CGFloat width = [text widthWithFont:lblTitle.font height:SizeHeigh(15)];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftView.mas_centerY);
        make.left.equalTo(leftView.mas_right).offset(left);
        make.width.equalTo(@(width + SizeWidth(5)));
        make.height.equalTo(@(SizeHeigh(15)));
    }];
    
    return lblTitle;
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
    
    [self resetPurchasePanel:_model.count];
}

-(void) resetPurchasePanel:(int) stock{
    [_purchasePanel removeAllSubviews];
    
    if (stock > 0) {
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
    
    CGFloat width = [lblTitle.text widthWithFont:lblTitle.font height:SizeHeigh(15)];
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
    BOOL highlight = _model.centerStock > 0;
    
    UIView *view1 = [self addDilivery:superView preView:_purchasePanel top:SizeHeigh(20) text:@"本商品支持配送" withHighlight:highlight];
    highlight = _model.shopStock > 0;
    
    UIView *view2 = [self addDilivery:superView preView:view1 top:SizeHeigh(25) text:@"本商品支持到店自取" withHighlight:highlight];
    
    if (_model.hasDiscounts) {
        [self addDiscountPanel:superView preView:view2 top:SizeHeigh(25)];
    }
    
}

-(UIView *) addDilivery:(UIView *) superView preView:(UIView *) preView top:(CGFloat) top text:(NSString *) text withHighlight:(BOOL) highlight{
    UIView *view = [UIView new];
    [superView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preView.mas_bottom).offset(SizeHeigh(top));
        make.left.equalTo(superView);
        make.right.equalTo(superView);
        make.height.equalTo(@(SizeHeigh(16)));
    }];
    
    
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
    
    BOOL highlight = YES;
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

-(BOOL) noMemberPriceLable{
    return [_model.memberPrice isEqualToString:@""];
}

-(void) buy{
    if (_skuPrice == nil) {
        _skuPrice = [self getSkuPrice];
    }
    
    int count = ((SKU *)(_skuSelectValue[_skuSelectValue.count - 1])).value.intValue;
    NSString *price = _model.price;
    if (_model.specilPrice !=nil) {
            price = _model.specilPrice;
    }else if(_model.memberPrice == nil){
        price = _model.memberPrice;
    }else{
        price = _model.price;
    }
    
    [ConfigModel showHud:self];
    [NetHelper addGoodsToCardWithGoodsId:_model._id withShopId:_model.shopId withCount:count withId:nil withSKUId:_skuPrice._id withPrice:price callBack:^(NSString *error, NSString *info) {
        [ConfigModel hideHud:self];
        if (error == nil) {
            [ConfigModel mbProgressHUD:@"已添加到购物车" andView:self.view];
            [self refreshCountOfGoodsInCar];
        }else{
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
    }];
}

-(void) showShareView{
    if (_sharePopup == nil) {
        UIView* contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        CGFloat width = SizeWidth(686/2);
        contentView.frame = CGRectMake(self.view.centerX, self.view.centerY, width, SizeHeigh(450/2));
        
        [self addCloseButtonTo:contentView];
        
        CGFloat offset = - SizeWidth(88+62+62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"icon_fx_pyq" withTitle:@"朋友圈" withLeft:offset withIndex:1];
        offset = -SizeWidth(62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"icon_fx_wx" withTitle:@"微信好友" withLeft:offset withIndex:2];
        
        offset = SizeWidth(62/2+88/2)/2;
        [self addButtonToShareView:contentView withImage:@"icon_fx_qq" withTitle:@"QQ好友" withLeft:offset withIndex:3];
        offset = SizeWidth(88+62+62/2+88/2)/2;
        
        [self addButtonToShareView:contentView withImage:@"icon_fx_qqkj" withTitle:@"QQ空间" withLeft:offset withIndex:4];
        
        _sharePopup = [KLCPopup popupWithContentView:contentView];
        _sharePopup.showType = KLCPopupShowTypeSlideInFromTop;
        _sharePopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
    }
    
    [_sharePopup show];
}

-(void) addButtonToShareView:(UIView *) superView withImage:(NSString *) img withTitle:(NSString *) title withLeft:(CGFloat) offset withIndex:(NSInteger) index{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    imgView.tag = Share_TAG + index;
    [superView addSubview:imgView];
    
    UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShareButton:)];
    [imgView addGestureRecognizer:tapGuesture];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX).offset(offset);
        make.top.equalTo(superView).offset(SizeHeigh(172/2));
        make.width.equalTo(@(SizeWidth(88/2)));
        make.height.equalTo(@(SizeHeigh(88/2)));
    }];
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNLight(SizeWidth(12));
    lblTitle.textColor = [UIColor colorWithHexString:@"#8f8f8f"];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = title;
    [superView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imgView.mas_centerX);
        make.top.equalTo(imgView.mas_bottom).offset(SizeHeigh(48/2));
        make.width.equalTo(@(SizeWidth(70)));
        make.height.equalTo(@(SizeHeigh(12)));
    }];
}

-(void) tapComplete{
    _skuSelectValue = _pickView.selectValue;
//    [self resetSubViewsToChoosePanel];
    [self restPrice];
    [self dismissPopup];
}

-(void) dismissPopup{
    if ([_sharePopup isShowing]) {
        [_sharePopup dismiss:YES];
    }else{
        [_choosePopup dismiss:YES];
    }
}

-(void) tapShareButton:(UITapGestureRecognizer *) gesture{
    
}

-(void) showChooseView{
    if (_choosePopup == nil) {
        UIView* contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        CGFloat width = SizeWidth(686/2);
        contentView.frame = CGRectMake(self.view.centerX, self.view.centerY, width, SizeHeigh(674/2));
        
        [self addSubViewsToChooseView:contentView];
        _choosePopup = [KLCPopup popupWithContentView:contentView];
        _choosePopup.showType = KLCPopupShowTypeSlideInFromTop;
        _choosePopup.dismissType = KLCPopupDismissTypeSlideOutToTop;
    }
    
    [_choosePopup show];
}

-(void) addSubViewsToChooseView:(UIView *) superView{
    [self addCloseButtonTo:superView];
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(15));
    lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"选择商品属性";
    [superView addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX);
        make.top.equalTo(superView.mas_top).offset(SizeHeigh(32/2));
        make.width.equalTo(@(SizeWidth(150)));
        make.height.equalTo(@(SizeHeigh(15)));
    }];
    
    _pickView = [PropertyPickView new];
    [self bindDataToPickView:_pickView];
    [superView addSubview:_pickView];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(SizeWidth(15));
        make.top.equalTo(lblTitle.mas_bottom).offset(SizeHeigh(60/2));
        make.right.equalTo(superView).offset(-SizeWidth(15));
        make.height.equalTo(@(SizeHeigh(180)));
    }];
    
    UIButton *btnComplete = [UIButton new];
    [btnComplete setTitle:@"完成" forState:UIControlStateNormal];
    btnComplete.backgroundColor = [UIColor colorWithHexString:@"3e7bb1"];
    btnComplete.titleLabel.font = SourceHanSansCNMedium(SizeWidth(15));
    [btnComplete setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [btnComplete addTarget:self action:@selector(tapComplete) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:btnComplete];
    
    [btnComplete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.bottom.equalTo(superView.mas_bottom).offset(-SizeHeigh(40/2));
        make.width.equalTo(@(SizeWidth(630/2)));
        make.height.equalTo(@(SizeHeigh(88/2)));
    }];
}

-(void) addCloseButtonTo:(UIView *) superView{
    UIButton *btnClose = [UIButton new];
    [btnClose setImage:[UIImage imageNamed:@"sg_ic_quxiao"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(SizeWidth(-30/2));
        make.top.equalTo(superView.mas_top).offset(SizeHeigh(30/2));
        make.width.equalTo(@(SizeWidth(34/2)));
        make.height.equalTo(@(SizeHeigh(34/2)));
    }];
}

-(void) addRecommendViewToCell:(UITableViewCell *) cell{
    if (_recommendCV != nil) {
        return;
    }
    
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = @"推荐";
    [cell addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.top.equalTo(cell.mas_top).offset(SizeHeigh(38/2));
        make.width.equalTo(@(SizeWidth(70)));
        make.height.equalTo(@(SizeHeigh(14)));
    }];
    
    _recommendCV = [RecommendCV new];
    _recommendCV.backgroundColor = [UIColor whiteColor];
    [cell addSubview:_recommendCV];
    
    [_recommendCV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell);
        make.top.equalTo(lblTitle.mas_bottom).offset(SizeHeigh(38/2));
        make.right.equalTo(cell).offset(-SizeWidth(15));
        make.left.equalTo(cell).offset(SizeWidth(15));
    }];
}

-(void) setGoodsId:(NSString *)goodsId withShopId:(NSString *) shopId{
    _goodsId = goodsId;
    _shopId = shopId;
    [self loadData];
}

-(void) loadData{
    [ConfigModel showHud:self];
    
    [NetHelper getGoodsDetailWithId:_goodsId withShopId:_shopId callBack:^(NSString *error, NSArray *skuList, NSArray *skuPriceList, GoodsModel *model) {
        [ConfigModel hideHud:self];
        if (error == nil) {
            _model = model;
            _skuList = skuList;
            _skuPriceList = skuPriceList;
            
            [NetHelper recommendList:_model._id withGoodsId:_model.shopId callBack:^(NSString *error, NSArray *data) {
                if (data.count > 0) {
                    _countOfCell = 4;
                    [_recommendCV setDataSource:data];
                }
                [_tb reloadData];
            }];
        }else{
            [ConfigModel mbProgressHUD:error andView:self.view];
        }
    }];
}

-(void) bindDataToPickView:(PropertyPickView *) pickView{
    NSArray *data = [self getDataSourceForSKU];
    
    if (data.count >0) {
        [pickView setDatasource:data withSelectValues:_skuSelectValue];
    }
}

-(NSArray *) getDataSourceForSKU{
    int stock = _model.shopStock + _model.centerStock;
    NSString *key1 = nil;
    NSMutableArray *datasource = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *arr3 = [NSMutableArray arrayWithCapacity:stock];
    
    for (SKU *sku in _skuList) {
        if (key1 == nil) {
            key1 = sku.name;
            [arr1 addObject:sku];
        }else if(key1 == sku.name){
            [arr1 addObject:sku];
        }else{
            [arr2 addObject:sku];
        }
    }
    
    for (int i=1; i<=stock; i++) {
        SKU *s = [SKU new];
        s.value = [NSString stringWithFormat:@"%d",i];
        s.name = @"数量";
        s._id = s.value;
        [arr3 addObject:s];
    }
    
    if (arr1.count > 0) {
        [datasource addObject:arr1];
    }
    
    if (arr2.count > 0) {
        [datasource addObject:arr2];
    }
    
    if (arr3.count > 0) {
        [datasource addObject:arr3];
    }
    
    if (_skuSelectValue == nil) {
        _skuSelectValue = [NSMutableArray arrayWithCapacity:datasource.count];
        for (NSArray *arr in datasource) {
            [_skuSelectValue addObject:arr[0]];
        }
    }
    
    return datasource;
}

-(UIWebView *) addWebViewToCell:(UITableViewCell *) cell withHtml:(NSString *) html{
    UIWebView *web  = nil;
    for (UIView *view in cell.subviews) {
        if ([view isKindOfClass:[UIWebView class]]) {
            web = (UIWebView *)view;
            break;
        }
    }
    
    if (web == nil) {
        [self addSeperatorToView:cell];
        
        web = [UIWebView new];
        web.delegate = self;
        web.scrollView.scrollEnabled = NO;
        [cell addSubview:web];
        [web mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell).offset(SizeWidth(15));
            make.right.equalTo(cell).offset(-SizeWidth(15));
            make.top.equalTo(cell).offset(SizeHeigh(20));
            make.bottom.equalTo(cell).offset(-SizeHeigh(30));
        }];
    }
    
    [web loadHTMLString:html baseURL:nil];
    
    return web;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    if (webView == _descWebView) {
        _heightOfDesc = fittingSize.height;
    }else{
        _heightOfInfo = fittingSize.height;
    }
    
    [_tb beginUpdates];
    [_tb endUpdates];
}

-(void) restPrice{
    //    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if (_skuSelectValue.count > 1) {
        [self getSkuPrice];
        
        [_tb reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(SKUPrice *) getSkuPrice{
    if (_skuSelectValue.count > 1 && _skuPriceList.count > 0) {
        for (SKUPrice *price in _skuPriceList) {
            if (price.skuIdList.count == 2) {
                NSString * value1 = ((SKU *)_skuSelectValue[0])._id;
                NSString * value2 = ((SKU *)_skuSelectValue[1])._id;
                if (price.skuIdList[0] == value1 && price.skuIdList[1] == value2) {
                    _skuPrice = price;
                    break;
                }
            }else{
                NSString * value1 = ((SKU *)_skuSelectValue[0])._id;
                if (price.skuIdList[0] == value1) {
                    _skuPrice = price;
                    break;
                }
            }
        }
    }
    
    return _skuPrice;
}

-(BOOL) hasView:(UIView *) view inSuperView:(UIView *) superView{
    for (UIView *subView in superView.subviews) {
        if (subView == view) {
            return YES;
        }
    }
    return NO;
}
@end

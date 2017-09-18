//
//  UserInfoPicketView.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/9/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "UserInfoPicketView.h"

@interface UserInfoPicketView ()<UIPickerViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
/** 数组 */
@property (nonatomic,strong) NSMutableArray *proTitleList;
/** 选择框 */
@property (nonatomic,strong) UIPickerView *pickerView;
/** 显示视图 */
@property (nonatomic,strong) UIView *baseView;
/** 显示视图 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 取消按钮*/
@property (nonatomic,strong) UIButton *cancelButton;
/** 确定按钮 */
@property (nonatomic,strong) UIButton *sureButton;
/** 选项 */
@property (nonatomic,assign) NSInteger contentIndex;

@end

@implementation UserInfoPicketView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        [self createBaseView];
    }
    return self;
}
- (void)createBaseView{
    UIView * backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.5f;
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_offset(0);
    }];
    
    _baseView = [UIView new];
    _baseView.layer.cornerRadius = 4.0f;
    _baseView.layer.masksToBounds = YES;
    _baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseView];
    [_baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_offset(0);
        make.size.mas_offset(CGSizeMake(kScreenW-40, kScreenH/2));
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_baseView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(20);
        make.centerX.mas_offset(0);
    }];
    
    _cancelButton = [UIButton new];
    [_cancelButton setImage:[UIImage imageNamed:@"sg_ic_quxiao"] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-20);
        make.centerY.mas_equalTo(_titleLabel);
    }];
    
    _sureButton = [UIButton new];
    _sureButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _sureButton.backgroundColor = UIColorFromHex(0x3e7bb1);
    _sureButton.layer.cornerRadius = 4.0f;
    _sureButton.layer.masksToBounds = YES;
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [_baseView addSubview:_sureButton];
    [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-20);
        make.height.mas_offset(40);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
}
- (void)cancelButtonAction{
    [self removeFromSuperview];
}
- (void)sureAction{
    NSString * contentStr = @"";
    if (_pickViewTextArray.count > 0) {
        contentStr = _pickViewTextArray[_contentIndex];
    }
    if ([self.delegate respondsToSelector:@selector(PickerSelectorIndex:contentString:)]) {
        [self.delegate PickerSelectorIndex:_contentIndex contentString:contentStr];
    }
    [self cancelButtonAction];
}
#pragma mark - 设置风格
- (void)setPicketType:(PicketViewType)picketType{
    if (picketType == PicketViewTypeDefault) {
        //默认
        _pickerView = [UIPickerView new];
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [_baseView addSubview:_pickerView];
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_offset(0);
            make.size.mas_offset(CGSizeMake(kScreenW-40, kScreenH/4));
        }];
    }else if (picketType == PicketViewTypeNormal){
        //正常的
        [_baseView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_offset(0);
            make.size.mas_offset(CGSizeMake(kScreenW-40, kScreenH/3));
        }];
        _sureButton.hidden = YES;
        
        CGFloat buttonWidth = (kScreenW-40-25*2-30*(_pickViewTextArray.count-1))/_pickViewTextArray.count;
        UIButton * baseButton;
        for (int i = 0; i < _pickViewTextArray.count; i++) {
            UIButton * button = [UIButton new];
            button.tag = i;
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(picketViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_baseView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_offset(-10);
                if (i == 0) {
                    make.left.mas_offset(25);
                }else{
                    make.left.mas_equalTo(baseButton.mas_right).offset(30);
                }
                make.width.mas_offset(buttonWidth);
            }];
            baseButton = button;
            
            UIImageView * imageView = [UIImageView new];
            imageView.image = [UIImage imageNamed:_pickViewImageArray[i]];
            [button addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_offset(0);
                make.top.mas_offset(0);
            }];
            
            UILabel * titleLabel = [UILabel new];
            titleLabel.text = _pickViewTextArray[i];
            titleLabel.font = [UIFont systemFontOfSize:14];
            [button addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imageView.mas_bottom).offset(10);
                make.centerX.mas_offset(0);
            }];
        }
    }
}
- (void)picketViewButtonAction:(UIButton *)button{
    NSString * contentStr = @"";
    if (_pickViewTextArray.count > 0) {
        contentStr = _pickViewTextArray[button.tag];
    }
    if ([self.delegate respondsToSelector:@selector(PickerSelectorIndex:contentString:)]) {
        [self.delegate PickerSelectorIndex:button.tag contentString:contentStr];
    }
    [self cancelButtonAction];
}
#pragma mark - 默认选中的是
- (void)MoRenSelectedRowWithObject:(id)object{
    if (object == nil) {
        return;
    }
    NSInteger row = [_pickViewTextArray indexOfObject:object];
    [self.pickerView selectRow:row inComponent:0 animated:YES];
}
#pragma mark - 改变分割线的颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = UIColorFromHex(0xdddddd);//取消分割线
        }
    }
    //设置文字的属性
    UILabel *Label = [UILabel new];
    Label.textAlignment = NSTextAlignmentCenter;
    Label.text = _pickViewTextArray[row];
    Label.textColor = _contentTextColor?_contentTextColor:[UIColor blackColor];
    
    return Label;
}
#pragma mark - UIPickerViewDataSource 相关代理
#pragma Mark -- 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
#pragma mark - pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickViewTextArray.count;
}
#pragma mark - UIPickerViewDelegate 相关代理方法
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return _LieHeight?_LieHeight:180;
}
// 每列高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return _LieWidth?_LieWidth:40;
}
#pragma mark - 返回当前行cell的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _pickViewTextArray[row];
}
#pragma mark - 返回选中的行didSelectRow
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _contentIndex = row;
}
#pragma mark - 设置标题
- (void)setPicketTitle:(NSString *)picketTitle{
    _picketTitle = picketTitle;
    _titleLabel.text = picketTitle;
}
#pragma mark - 设置PickView的背景颜色
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    _backgroundColor = backgroundColor;
    _pickerView.backgroundColor = backgroundColor;
}
#pragma mark - 设置字体颜色
-(void)setContentTextColor:(UIColor *)contentTextColor{
    _contentTextColor = contentTextColor;
}
#pragma mark - 设置数据源数组
-(void)setPickViewTextArray:(NSMutableArray *)pickViewTextArray{
    _pickViewTextArray = pickViewTextArray;
}
#pragma mark - 设置图片数据源数组
-(void)setPickViewImageArray:(NSMutableArray *)pickViewImageArray{
    _pickViewImageArray = pickViewImageArray;
}
#pragma mark - 设置列宽
-(void)setLieWidth:(CGFloat)LieWidth{
    _LieWidth = LieWidth;
    if (_LieWidth < 40) {
        _LieWidth = 180;
    }
}
#pragma mark - 设置列高
-(void)setLieHeight:(CGFloat)LieHeight{
    _LieHeight = LieHeight;
    if (_LieHeight < 40) {
        _LieHeight = 40;
    }
}
#pragma mark - 确定按钮字
- (void)setSureButtonTitle:(NSString *)sureButtonTitle{
    _sureButtonTitle = sureButtonTitle;
    [_sureButton setTitle:sureButtonTitle forState:UIControlStateNormal];
}
@end

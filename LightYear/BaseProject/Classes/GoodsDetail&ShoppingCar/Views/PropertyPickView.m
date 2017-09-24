//
//  PropertyPickView.m
//  BaseProject
//
//  Created by LeoGeng on 18/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "PropertyPickView.h"
#import "UIColor+BGHexColor.h"
#import <Masonry/Masonry.h>
#import "SKU.h"

@interface PropertyPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(retain,atomic) UIPickerView *pickerView;
@property(assign,atomic) BOOL hasIntial;
@property(retain,atomic) NSMutableArray *pickViews;
@property(retain,atomic) NSArray *datasource;
@end

@implementation PropertyPickView
-(void) setDatasource:(NSArray *)datasource withSelectValues:(NSArray *) selectValue{
    _datasource = datasource;
    _selectValue = [NSMutableArray arrayWithArray:selectValue] ;
    
    if (!_hasIntial) {
        _hasIntial = YES;
        _pickViews = [NSMutableArray arrayWithCapacity:_datasource.count];
        CGFloat offSet = SizeWidth(626/2)/_datasource.count;
        if (_datasource.count == 3) {
            [self addTitleWithText:((SKU *)_datasource[0][0]).name withOffSet:-offSet withIndex:0];
            [self addTitleWithText:((SKU *)_datasource[1][0]).name withOffSet:0 withIndex:1];
            [self addTitleWithText:((SKU *)_datasource[2][0]).name withOffSet:offSet withIndex:2];
        }else if(_datasource.count == 2){
            [self addTitleWithText:((SKU *)_datasource[0][0]).name withOffSet:-offSet/2 withIndex:0];
            [self addTitleWithText:((SKU *)_datasource[1][0]).name withOffSet:offSet/2 withIndex:1];
        }else{
            [self addTitleWithText:((SKU *)_datasource[0][0]).name withOffSet:0 withIndex:0];
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hasIntial = NO;
    }
    return self;
}

-(void) addPickView{
    _pickerView = [UIPickerView new];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;

//    [_pickerView selectRow:1 inComponent:0 animated:NO];
//    [_pickerView selectRow:1 inComponent:1 animated:NO];
//    [_pickerView selectRow:1 inComponent:2 animated:NO];
    [self addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SizeHeigh(30));
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(SizeHeigh(70)));
    }];
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return ((NSArray *)_datasource[pickerView.tag]).count;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return SizeHeigh(70/2);
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SizeWidth(50);
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return  @"tes";
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lblTitle;
    
    if (view == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SizeWidth(75/2), SizeHeigh(30))];
        lblTitle.font = SourceHanSansCNRegular(SizeWidth(18));
        lblTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    }else{
        lblTitle = (UILabel *) view;
    }
    
    lblTitle.text = ((SKU *)_datasource[pickerView.tag][row]).value;
    
    return lblTitle;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSArray *values = (NSArray *) _datasource[pickerView.tag];
    NSString *selectValue = (NSString *) values[row];

    _selectValue[pickerView.tag] = selectValue;
}

-(void) addTitleWithText:(NSString *) text withOffSet:(CGFloat) offset withIndex:(NSInteger) index{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithRed:62/255 green:123/255 blue:177/255 alpha:1];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = text;
    [self addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self).offset(offset);
        make.width.equalTo(@(SizeWidth(70)));
        make.height.equalTo(@(SizeHeigh(15)));
    }];
    
    UIPickerView *pickerView = [UIPickerView new];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.tag = index;
    
    NSArray *values = (NSArray *) _datasource[index];
    NSString *selectValue = (NSString *) _selectValue[index];
    NSInteger selectIndex = [values indexOfObject:selectValue];
    [pickerView selectRow:selectIndex inComponent:0 animated:NO];
    [_pickViews addObject:pickerView];
    
    [self addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(SizeHeigh(30));
        make.centerX.equalTo(lblTitle.mas_centerX);
        make.width.equalTo(@(SizeWidth(80)));
        make.height.equalTo(@(SizeHeigh(110)));
    }];
}

@end

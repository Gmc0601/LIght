//
//  PropertyPickView.m
//  BaseProject
//
//  Created by LeoGeng on 18/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "PropertyPickView.h"
#import "UIColor+BGHexColor.h"

@interface PropertyPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(retain,atomic) NSArray *datasource1;
@property(retain,atomic) NSArray *datasource2;
@property(retain,atomic) NSArray *datasource3;
@end

@implementation PropertyPickView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void) setDataSource:(NSArray *)datasource1 withSecond:(NSArray *)datasource2 withThird:(NSArray *)datasource3{
    if (datasource3 != nil) {
        
    }
}

-(void) addPickView{
    UIPickerView *pickerView = [UIPickerView new];
    pickerView.delegate = self;
    pickerView.dataSource = self;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return SizeHeigh(70/2);
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SizeWidth(100);
}

-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *lbl;
    
    if (view == nil){
        let frame:CGRect = pickerView.bounds
        lblText = UILabel(frame: frame);
        lblText.highlightedTextColor = UIColor.greenColor();
        lblText.textAlignment = NSTextAlignment.Center;
        lblText.backgroundColor = backColor;
        lblText.font = UIFont(name: fontName, size: fontSize);
        (pickerView.subviews[1] ).hidden = true;
        (pickerView.subviews[2] ).hidden = true;
        
    }else{
        lblText = view as! UILabel
    }
    lblText.text = items[row % items.count] ;
    
    return lblText;
}

-(void) addTitleWithText:(NSString *) text withOffSet:(CGFloat) offset{
    UILabel *lblTitle = [UILabel new];
    lblTitle.font = SourceHanSansCNMedium(SizeWidth(13));
    lblTitle.textColor = [UIColor colorWithRed:62/255 green:123/255 blue:177/255 alpha:1];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.text = text;
    [self addSubview:lblTitle];
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self).offset(offset);
        make.width.equalTo(@(SizeWidth(70)));
        make.height.equalTo(@(SizeHeigh(13)));
    }];
}

@end

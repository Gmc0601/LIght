//
//  PickerViewCustom.m
//  picker自定义选择器
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "PickerViewCustom.h"
#import "BasicView.h"
@interface PickerViewCustom()<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIWindow *keyWindow;
@property (nonatomic,strong) BasicView *basicView;
@property (nonatomic,strong) NSArray *data;
@property (nonatomic,copy) NSString *titleOne;
@property (nonatomic,copy) NSString *titleTwo;
@end
@implementation PickerViewCustom

-(void)show
{
    self.keyWindow = [UIApplication sharedApplication].keyWindow;
    
    self.frame = self.keyWindow.bounds;
    [self.keyWindow addSubview:self];

    /**
     *  backgroundView 背景
     */
    UIView *backgroundView = [UIView new];
    backgroundView.frame = self.keyWindow.bounds;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.3f;
    backgroundView.userInteractionEnabled = YES;

    [self addSubview:backgroundView];
    
    /**
     *  基底视图
     */
    BasicView *basicView = [[BasicView alloc]initWithFrame:backgroundView.bounds];
    basicView.center = self.center;
    basicView.userInteractionEnabled = YES;
    basicView.backgroundColor = [UIColor clearColor];
    [self addSubview:basicView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHide:)];
    [basicView addGestureRecognizer:tapGR];
    basicView.picker.dataSource = self;
    basicView.picker.delegate = self;
    
    NSArray *array1 = @[@"My",@"Your",@"He",@"She",@"His",@"Thier"];
    NSArray *array2 = @[@"我",@"你",@"他",@"它",@"她",@"他们"];
    self.data = @[array1,array2];

}
-(void)hide
{
    if(self.titleOne && self.titleTwo){
        [self removeFromSuperview];
    }else{
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两个都要选" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
        [alter show];
    }
}
-(void)tapHide:(UITapGestureRecognizer *)tap
{
    [self hide];
}

#pragma mark UIPickerView DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.data.count;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.data[component] count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.data[component][row];
}
#pragma mark UIPickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        self.titleOne = self.data[component][row];
    }else{
        self.titleTwo = self.data[component][row];
    }
    if(self.titleOne && self.titleTwo){
    if([self.delegate respondsToSelector:@selector(title:)]){
        [self.delegate title:[NSString stringWithFormat:@"%@ = %@",self.titleOne,self.titleTwo]];
    }
    }else{
    }
}


@end

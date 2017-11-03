//
//  PickerViewCustom.m
//  picker自定义选择器
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import "PickerViewCustom.h"
#import "BasicView.h"
#import "UIView+Frame.h"
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
    UIButton *btn = [[UIButton alloc] initWithFrame:FRAME(basicView.mainview.left + 10, basicView.mainview.bottom - 30, basicView.mainview.width - 20, 25)];
    btn.backgroundColor =MainBlue;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.titleLabel.font = NormalFont(13);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [basicView addSubview:btn];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHide:)];
    [basicView addGestureRecognizer:tapGR];
    basicView.picker.dataSource = self;
    basicView.picker.delegate = self;
    
    //   计算 时间 列表
    
    NSInteger dis = 3; //前后的天数
    
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    
    NSMutableArray *arr1 = [NSMutableArray new];
    NSMutableArray *arr2 = [NSMutableArray new];
    
    if(dis!=0)
    {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        
        
        for (int i = 0; i <= dis; i++) {
            theDate = [nowDate initWithTimeIntervalSinceNow: +oneDay*i ];
            NSString *str = [NSString stringWithFormat:@"%@", theDate];
            NSString *str2 = [str substringToIndex:10];
            NSString *str3 = [str2 substringFromIndex:5];
            [arr1 addObject:str3];
        }
        
        
        
    }
    else
    {
        theDate = nowDate;
    }

    NSArray *array1 = @[@"My",@"Your",@"He",@"She",@"His",@"Thier"];
    
    NSArray *arr = (NSArray *)[self gettimeArr:nil];
    
    NSArray *array2 = @[@"我",@"你",@"他",@"它",@"她",@"他们"];
    self.titleOne = arr1[0];
    self.titleTwo = arr[0];
    
    self.data = @[arr1,arr];

}

- (NSMutableArray *)gettimeArr:(NSString *)str {
    int time = 15;
    NSString *now_hour = @"9", *now_min = @"28";
    NSString *star_hour = @"8";
    NSString *end_hour = @"20";
    NSString *star_min = @"30";
    NSString *end_min = @"00";
    NSMutableArray *dataArr = [NSMutableArray new];
    NSMutableArray *hourArr = [NSMutableArray new];
    NSMutableArray *minteArr = [NSMutableArray new];
    NSString *hour, *minte;
    
    for (int i = [star_hour intValue]; i <= [end_hour intValue]; i++) {
        NSString *str = [NSString stringWithFormat:@"%.2d", i];
        [hourArr addObject:str];
    }
    
    for (int i = 0; i < 60 ; i+=time ) {
        NSString *str = [NSString stringWithFormat:@"%.2d", i];
        [minteArr addObject:str];
    }
    
    for (int i = 0 ; i < hourArr.count; i++) {
        NSString * str1 = hourArr[i];
        for ( int j = 0; j < minteArr.count; j++) {
          NSString * str2 =minteArr[j];
          NSString *timeStr = [NSString stringWithFormat:@"%@:%@", str1, str2];
         [dataArr addObject:timeStr];
        }
    }
    return dataArr;
    
}


- (void)btnClick:(UIButton *)sender {
    [self hide];
    if(self.titleOne && self.titleTwo){
        if([self.delegate respondsToSelector:@selector(title:)]){
            NSDate*nowDate = [NSDate date];
            NSDate* theDate;
            theDate = [nowDate initWithTimeIntervalSinceNow: 10 ];
            NSString *str = [NSString stringWithFormat:@"%@", theDate];
            NSString *first =  [str substringToIndex:4];
            NSString *backStr = [NSString stringWithFormat:@"%@-%@ %@%@", first, self.titleOne, self.titleTwo,@":00"];
            [self.delegate title:backStr];
        }
    }else{
    }
}

-(void)hide
{
    
    [self removeFromSuperview];
//    if(self.titleOne && self.titleTwo){
//        [self removeFromSuperview];
//    }else{
//        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两个都要选" delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil];
//        [alter show];
//    }
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
        
        NSDate*nowDate = [NSDate date];
        NSDate* theDate;
        theDate = [nowDate initWithTimeIntervalSinceNow: 10 ];
        NSString *str = [NSString stringWithFormat:@"%@", theDate];
        NSString *first =  [str substringToIndex:4];
        NSString *backStr = [NSString stringWithFormat:@"%@-%@ %@%@", first, self.titleOne, self.titleTwo,@":00"];
        
        
        
        [self.delegate title:backStr];
    }
    }else{
    }
}


@end

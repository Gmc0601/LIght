//
//  BaseTextField.m
//  BaseProject
//
//  Created by WeiYuLong on 2017/7/16.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "BaseTextField.h"
#import "AppDelegate.h"

@interface BaseTextField ()<UITextFieldDelegate>
{
    BOOL isChangeSupViewFrame;
}
@end

@implementation BaseTextField

- (id)initWithFrame:(CGRect)frame PlaceholderStr:(NSString *)placeholderStr isBorder:(BOOL)isBorder{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = UIColorFromHex(0x3e7bb1);
        self.font = [UIFont systemFontOfSize:18.0];
        self.tintColor = UIColorFromHex(0xcccccc);
        UIButton * userCleanButton = [self valueForKey:@"_clearButton"];
        [userCleanButton setImage:[UIImage imageNamed:@"wrong_btn"] forState:UIControlStateNormal];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.placeholder = placeholderStr;
        [self setValue:UIColorFromHex(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
        [self addTarget:self action:@selector(textFieldTextChange) forControlEvents:UIControlEventEditingChanged];
        self.leftView  = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 20.f, 0.f)];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.delegate = self;
        if (isBorder) {
            self.layer.borderWidth = .5f;
            self.layer.borderColor = UIColorFromHex(0xcccccc).CGColor;
        }
    }
    return self;
}
-(void)textFieldTextChange{
    if ([self.textDelegate respondsToSelector:@selector(textFieldTextChange:)]) {
        [self.textDelegate textFieldTextChange:self];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //增加监听，当键盘出现或改变时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    if (isChangeSupViewFrame == YES) {
//        isChangeSupViewFrame = NO;
//        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        // 初始化一个数组,UIWindow的所有子视图
//        NSArray *array = appDelegate.window.subviews;
//        // 获取当前Controller的view视图
//        UIView *view = appDelegate.window.subviews[array.count - 1];
//        // 初始化一个frame,大小为UIWindow的frame
//        CGRect windowFrame = appDelegate.window.frame;
//        windowFrame.origin.y = 0;
//        // 根据yOffset判断键盘是弹出还是收回
//        // 键盘弹出,改变当前Controller的view的frame
//        [UIView animateWithDuration:.2f animations:^{
//            view.frame = windowFrame;
//        }];
//    }
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyBoardHeight = keyboardRect.size.height;
    int textFieldBottomHeight = kScreenH - self.frame.origin.y - self.frame.size.height;
    if (textFieldBottomHeight < keyBoardHeight) {
        isChangeSupViewFrame = YES;
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        // 初始化一个数组,UIWindow的所有子视图
        NSArray *array = appDelegate.window.subviews;
        // 获取当前Controller的view视图
        UIView *view = appDelegate.window.subviews[array.count - 1];
        // 初始化一个frame,大小为UIWindow的frame
        CGRect windowFrame = appDelegate.window.frame;
        windowFrame.origin.y = textFieldBottomHeight-keyBoardHeight-30;
        // 根据yOffset判断键盘是弹出还是收回
        // 键盘弹出,改变当前Controller的view的frame
        [UIView animateWithDuration:.2f animations:^{
            view.frame = windowFrame;
        }];
    }
}


@end

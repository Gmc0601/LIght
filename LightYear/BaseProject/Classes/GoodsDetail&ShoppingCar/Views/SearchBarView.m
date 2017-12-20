//
//  SearchBarView.m
//  BaseProject
//
//  Created by LeoGeng on 15/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "SearchBarView.h"

@interface SearchBarView()<UITextFieldDelegate>
@property(retain,atomic) UIButton *imgDelete;

@end

@implementation SearchBarView

@synthesize enable = _enable;
-(void) setEnable:(BOOL)enable{
    _enable = enable;
    _txtSearch.enabled = _enable;
}

@synthesize keyword= _keyword;
-(void) setKeyword:(NSString *)keyword{
    _keyword = keyword;
    _txtSearch.text = _keyword;
    _imgDelete.hidden = [_keyword isEqualToString:@""];
    [self.delegate didSearch:keyword];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubViews];
    }
    
    return self;
}

-(void) addSubViews{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_nav_ss"]];
    [self addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeWidth(16)));
    }];
    
    _txtSearch = [UITextField new];
    _txtSearch.placeholder = @"输入商品名称";
    
    _txtSearch.font = SourceHanSansCNRegular(SizeWidth(14));
    _txtSearch.textColor = [UIColor lightGrayColor];
    _txtSearch.textAlignment = NSTextAlignmentLeft;
    _txtSearch.returnKeyType = UIReturnKeySearch;
    _txtSearch.delegate = self;
    [_txtSearch addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_txtSearch];
    
    [_txtSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(imgView.mas_right).offset(SizeWidth(10));
        make.height.equalTo(@(SizeHeigh(16)));
        make.right.equalTo(self).offset(-SizeWidth(32));
    }];
    
    _imgDelete = [UIButton new];
    [_imgDelete setImage:[UIImage imageNamed:@"icon_ss_qc"] forState:UIControlStateNormal];
    _imgDelete.hidden = YES;
    [_imgDelete addTarget:self action:@selector(deleteText) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_imgDelete];
    
    [_imgDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-SizeWidth(16));
        make.height.equalTo(@(SizeHeigh(16)));
        make.width.equalTo(@(SizeWidth(16)));
    }];
    
    self.backgroundColor = [UIColor whiteColor];
}

-(void) textValueChanged:(UITextField *) sender{
    if ([sender.text isEqualToString:@""]) {
        _imgDelete.hidden = YES;
    }else{
        _imgDelete.hidden = NO;
    }
}

-(void) deleteText{
    _txtSearch.text = @"";
    [self.delegate didClearKeyword];
    _imgDelete.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    _keyword = textField.text;
    [self.delegate didSearch:textField.text];
    return YES;
}

@end

//
//  OrderAlterView.m
//  BaseProject
//
//  Created by cc on 2017/9/8.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "OrderAlterView.h"
#import "UIView+Frame.h"

#define White_W SizeWidth(340)

@implementation OrderAlterView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createview];
    }
    return self;
}

- (void)update:(OrderModel *)model {
    self.codeLab.text = model.code;
    self.getTimeLab.text = model.drawtime;
    self.stroNameLab.text = model.shopInfo.shopname;
    self.addressLab.text = model.shopInfo.address;
    NSString *str1 = [NSString stringWithFormat:@"工作日：%@ - %@", model.shopInfo.startdate,model.shopInfo.enddate];
    NSString *str2 = [NSString stringWithFormat:@"节假日：%@ - %@", model.shopInfo.hstartdate, model.shopInfo.henddate];
    self.workTimeLab1.text = str1;
    self.workTimeLab2.text = str2;
}

- (void)createview {
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    [self.backView addSubview:self.whitView];
    
    [self.whitView addSubview:self.titleLab];
    [self.whitView addSubview:self.codeLab];
    [self.whitView addSubview:self.getTimeLab];
    [self.whitView addSubview:self.line];
    [self.whitView addSubview:self.stroNameLab];
    [self.whitView addSubview:self.addressLab];
    [self.whitView addSubview:self.workTimeLab];
    [self.whitView addSubview:self.workTimeLab1];
    [self.whitView addSubview:self.workTimeLab2];
    [self.whitView addSubview:self.closeBtn];
    [self.whitView addSubview:self.callBtn];
}

- (void)pop {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    
    self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
    self.backView.alpha = 1;
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.backView.alpha = 1;
    }];
}

- (void)dismiss {
    
    [UIView animateWithDuration:.35 animations:^{
        self.whitView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:FRAME(0, SizeHeigh(22), SizeWidth(340), SizeHeigh(15))];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = NormalFont(15);
        _titleLab.text = @"取货码";
    }
    return _titleLab;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:FRAME(White_W - SizeWidth(15 + 20), SizeHeigh(15), SizeWidth(20), SizeHeigh(20))];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn setImage:[UIImage imageNamed:@"sg_ic_quxiao"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void)closeBtnClick:(UIButton *)sender {
    [self dismiss];
}

- (UILabel *)codeLab {
    if (!_codeLab) {
        _codeLab = [[UILabel alloc] initWithFrame:FRAME(0, self.titleLab.bottom + SizeHeigh(20), White_W, SizeHeigh(50))];
        _codeLab.textAlignment = NSTextAlignmentCenter;
        _codeLab.font = Verdana(SizeHeigh(60));
        _codeLab.textColor = UIColorFromHex(0x3e7bb1);
        _codeLab.text = @"8872";
    }
    return _codeLab;
}

- (UILabel *)getTimeLab {
    if (!_getTimeLab) {
        _getTimeLab = [[UILabel alloc] initWithFrame:FRAME(0, self.codeLab.bottom + SizeHeigh(20), White_W, SizeHeigh(15))];
        _getTimeLab.textAlignment = NSTextAlignmentCenter;
        _getTimeLab.font = Verdana(15);
        _getTimeLab.textColor = UIColorFromHex(0x999999);
        _getTimeLab.text = @"06-26(周一) 13:30 取货";
    }
    return _getTimeLab;
}


- (UILabel *)line  {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(10), self.getTimeLab.bottom + SizeHeigh(22), White_W - SizeWidth(20), 1)];
        _line.backgroundColor = RGBColor(239, 240, 241);
    }
    return _line;
}

- (UILabel *)stroNameLab {
    if (!_stroNameLab) {
        _stroNameLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(20), self.line.bottom + SizeHeigh(20), White_W - SizeWidth(40), SizeHeigh(15))];
        _stroNameLab.font = SourceHanSansCNMedium(15);
        _stroNameLab.text = @"光年浙工店";
    }
    return _stroNameLab;
}

- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(20), self.stroNameLab.bottom + SizeHeigh(10), White_W - SizeWidth(40), SizeHeigh(15))];
        _addressLab.font = SourceHanSansCNRegular(13);
        _addressLab.textColor = UIColorFromHex(0x333333);
        _addressLab.text = @"浙江省杭州市下沙浙工工商大学商业街888号";
    }
    return _addressLab;
}

- (UILabel *)workTimeLab {
    if (!_workTimeLab) {
        _workTimeLab = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(20), self.addressLab.bottom + SizeHeigh(15), White_W - SizeWidth(40), SizeHeigh(15))];
        _workTimeLab.font = SourceHanSansCNMedium(15);
        _workTimeLab.text = @"营业时间";
    }
    return _workTimeLab;
}

- (UILabel *)workTimeLab1 {
    if (!_workTimeLab1) {
        _workTimeLab1 = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(20), self.workTimeLab.bottom + SizeHeigh(10), White_W - SizeWidth(40), SizeHeigh(15))];
        _workTimeLab1.font = SourceHanSansCNRegular(13);
        _workTimeLab1.textColor = UIColorFromHex(0x333333);
        _workTimeLab1.text = @"工作日：9：00 - 18：00";
    }
    return _workTimeLab1;
}

- (UILabel *)workTimeLab2 {
    if (!_workTimeLab2) {
        _workTimeLab2 = [[UILabel alloc] initWithFrame:FRAME(SizeWidth(20), self.workTimeLab1.bottom + SizeHeigh(10), White_W - SizeWidth(40), SizeHeigh(15))];
        _workTimeLab2.font = SourceHanSansCNRegular(13);
        _workTimeLab2.textColor = UIColorFromHex(0x333333);
        _workTimeLab2.text = @"节假日：9：00 - 18：00";
    }
    return _workTimeLab2;
}

- (UIButton *)callBtn {
    if (!_callBtn ) {
        _callBtn = [[UIButton alloc] initWithFrame:FRAME(White_W/2 -SizeWidth(50), self.workTimeLab2.bottom + SizeHeigh(20), SizeWidth(100), SizeHeigh(50))];
        _callBtn.backgroundColor = [UIColor clearColor];
        [_callBtn setTitle:@"联系门店" forState:UIControlStateNormal];
        [_callBtn setTitleColor:UIColorFromHex(0x3e7bb1) forState:UIControlStateNormal];
        _callBtn.titleLabel.font = SourceHanSansCNRegular(15);
        [_callBtn addTarget:self action:@selector(callbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callBtn;
}

- (void)callbtnClick:(UIButton *)sender {
    [self dismiss];
    if (self.callBtnBlock) {
        self.callBtnBlock();
    }
}

- (UIView *)whitView{
    if (!_whitView) {
        _whitView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW /2 - SizeWidth(170), kScreenH /2 - SizeHeigh(190), SizeWidth(340), SizeHeigh(380))];
        _whitView.backgroundColor = [UIColor whiteColor];
        [_whitView.layer setMasksToBounds: YES];
        [_whitView.layer setCornerRadius:SizeHeigh(15)];
    }
    return _whitView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backView.backgroundColor = RGBColorAlpha(74, 73, 74, 0.6);
    }
    return _backView;
}

@end

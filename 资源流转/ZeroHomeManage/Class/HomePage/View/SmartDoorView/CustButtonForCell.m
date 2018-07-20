//
//  CustButtonForCell.m
//  ZeroHome
//
//  Created by TW on 16/1/30.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "CustButtonForCell.h"

@implementation CustButtonForCell
{
    NSArray *images;
    NSArray *titles;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatBtn];
    }
    return self;
}


- (void)creatBtn
{
     CGFloat btnHeight = 92;
    images = [[NSArray alloc]initWithObjects:@"工单申请",@"申请记录",@"开锁记录",@"消息推送",@"授权管理",@"个人中心", nil];
    titles = [[NSArray alloc]initWithObjects:@"申请授权",@"授权记录",@"开锁记录",@"门禁状态",@"授权管理",@"个人中心", nil];
    
    float btnWidth = (SCREEN_WIDTH)/3;
    for(int i = 0;i<images.count;i++){
        _btn = [convenceBtn buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake((btnWidth+0.5)*(i%3), (btnHeight+0.5)*(i/3)+0.5, btnWidth, btnHeight);
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btn setTitleColor:COLOR_RGB(51, 51, 51) forState:UIControlStateNormal];
        [_btn setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        _btn.tag = i + 2000;
        [_btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
    }
//    UIView *topSeperaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    topSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
//    [self addSubview:topSeperaView];
//    
//    UIView *bottomSeperaView = [[UIView alloc]initWithFrame:CGRectMake(0, btnHeight*2+1, SCREEN_WIDTH, 0.5)];
//    bottomSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
//    [self addSubview:bottomSeperaView];
    
}

- (void)clickBtn:(UIButton *)btn
{
    if (_delegate &&[_delegate respondsToSelector:@selector(selectBtnTag:)]) {
        [_delegate selectBtnTag:btn.tag];
    }
}

@end

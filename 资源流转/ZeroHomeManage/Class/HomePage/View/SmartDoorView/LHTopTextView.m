//
//  LHTopTextView.m
//  LHPopTextView
//
//  Created by 刘旭辉 on 16/4/19.
//  Copyright © 2016年 刘旭辉. All rights reserved.
//

#import "LHTopTextView.h"

@interface LHTopTextView()<UITextViewDelegate>{
    CGFloat _space;
    NSString *_text;
    CGFloat _margin;
}
@end

@implementation LHTopTextView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        //设置两个控件之间的间距
        _space=10.0;
        
        //设置与边框的间距
        _margin=18.0;
        
        //设置圆角
        self.layer.cornerRadius=20;
        self.layer.borderColor = HexRGB(0xdddddd).CGColor;
        self.layer.borderWidth = 0.5;
//        self.layer.shouldRasterize = YES;
        [self.layer setMasksToBounds:YES];
        
        //设置背景色
        self.backgroundColor=HexRGB(0xf7f7f7);

        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 21,frame.size.width, 21)];
        self.titleLabel=titleLabel;
        [self addSubview:titleLabel];
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        titleLabel.textColor = HexRGB(0x333333);
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [titleLabel setText:@"说明"];
        
        UILabel *subLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(titleLabel.frame)+7,frame.size.width, 21)];
        [self addSubview:subLabel];
        [subLabel setFont:[UIFont systemFontOfSize:12]];
        subLabel.textColor = HexRGB(0x333333);
        subLabel.textAlignment=NSTextAlignmentCenter;
        [subLabel setText:@"请输入拒绝原因"];
        
        //输入框
        UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(16, CGRectGetMidY(subLabel.frame)+23, frame.size.width-32, 25)];
        textView.backgroundColor=[UIColor whiteColor];
        textView.layer.borderColor = HexRGB(0x241f19).CGColor;
        textView.layer.borderWidth = 0.5f;
        self.textView=textView;
        textView.font=[UIFont systemFontOfSize:12];
//        NSString *str=@"请您输入您拒绝的原因";
        textView.textColor=[UIColor lightGrayColor];
//        textView.text=str;
        textView.returnKeyType=UIReturnKeyDone;
        textView.delegate=self;
        [self addSubview:textView];
        
        //seperateLine
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+12, frame.size.width, 0.5)];
        lineView.backgroundColor=HexRGB(0xdadada);
        [self addSubview:lineView];
        
        //取消按钮
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(0, CGRectGetMaxY(lineView.frame), frame.size.width/2, 50);
        [cancelBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        self.cancelBtn=cancelBtn;
        [cancelBtn addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        //按钮分隔线
        UIView *seperateLine=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMinY(cancelBtn.frame), 0.5, CGRectGetHeight(cancelBtn.frame))];
        seperateLine.backgroundColor=HexRGB(0xdadada);
        [self addSubview:seperateLine];
    
        //确定按钮
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame=CGRectMake(CGRectGetMaxX(seperateLine.frame), CGRectGetMinY(cancelBtn.frame), CGRectGetWidth(cancelBtn.frame), 50);
        self.submitBtn=sureBtn;
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        
    }
    return self;
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor=[UIColor blackColor];
    textView.text=nil;
}
/**
 * 通过代理方法去设置不能超过128个字，但是可编辑
 */
#pragma mark -UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length>=128){
       textView.text=[textView.text substringToIndex:127];
    }
}


#pragma mark -return键弹回键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    return YES;    
    
}


#pragma mark -处理确定点击事件

-(void)clickSubmit:(id)sender{
    if(self.textView.editable){
        [self.textView resignFirstResponder];
    }
    if(self.textView.text.length>0){
        if([self.textView.textColor isEqual:[UIColor redColor]]||[self.textView.textColor isEqual:[UIColor whiteColor]]){
            [self.textView becomeFirstResponder];
        }else{
            if(self.submitBlock){
                self.submitBlock(self.textView.text);
            }
        }
    }else{
        self.textView.textColor=[UIColor redColor];
        self.textView.text=@"您输入的内容不能为空，请您输入内容";
    }
}

#pragma mark -处理取消点击事件

-(void)clickCancel:(id)sender{
    if(self.closeBlock){
        self.closeBlock();
    }
}


@end

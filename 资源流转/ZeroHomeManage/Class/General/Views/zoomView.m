//
//  zoomView.m
//  ZeroHome
//
//  Created by Dagan on 15/11/23.
//  Copyright © 2015年 deguang. All rights reserved.
//

#import "zoomView.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"

CGRect oldframe;
@implementation zoomView{
    NSMutableArray *imgViews;
    
    UIImageView *zoomImageView;
    UIImageView *longImageView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.9];
        //self.alpha = 0;
        _dataArray = [[NSArray alloc] init];
        imgViews = [[NSMutableArray alloc]init];
        _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollview.tag = 1000;
        _scrollview.pagingEnabled = YES;
        _scrollview.backgroundColor = [UIColor clearColor];
        _scrollview.delegate = self;
        [self addSubview:_scrollview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
        
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imglongTapClick:)];
        [self addGestureRecognizer:longTap];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)showImageWithImageViews:(NSMutableArray *)imageViews andimages:(NSMutableArray *)images andIndex:(NSInteger)index{
    for(UIView *view in _scrollview.subviews){
        [view removeFromSuperview];
    }
    _dataArray = images;
    imgViews = imageViews;
    _scrollview.contentSize =CGSizeMake(_dataArray.count*_scrollview.width, _scrollview.height);
    for(int i=0;i<_dataArray.count;i++){
        
    
        UIScrollView *subScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(_scrollview.width*i, 0, _scrollview.width, _scrollview.height)];
        subScroll.backgroundColor = [UIColor clearColor];
        subScroll.delegate = self;
        //最大缩放倍数
        subScroll.maximumZoomScale = 5.0;
        //最小
        subScroll.minimumZoomScale = 1.0;
        //当前缩放倍数
        subScroll.zoomScale = 1.0;
        //反弹效果
        subScroll.bouncesZoom = NO;
        subScroll.tag = i+10;
        [_scrollview addSubview:subScroll];
        
        UIImageView *imageV = [[UIImageView alloc]init];
        
        imageV.tag = i+50;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *path = [[images objectAtIndex:i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageV sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"加载图片-图标"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(i==index){
                //点击的imageview
                UIImageView *imgView = [imageViews objectAtIndex:index];
                //UIImage *image = imgView.image;
                //计算出在新视图上的初始位置
                oldframe = [imgView convertRect:imgView.bounds toView:nil];
                NSLog(@"%f,%f,%f,%f",oldframe.origin.x,oldframe.origin.y,oldframe.size.width,oldframe.size.height);
                imageV.frame = oldframe;
                
                zoomImageView = imageV;
            }else{
                imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
        }];
        [subScroll addSubview:imageV];
        
    }
    if(_index<_dataArray.count){
        _scrollview.contentOffset = CGPointMake(_scrollview.width*index, 0);
    }
    [UIView animateWithDuration:.3 animations:^{
        zoomImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)setDataArray:(NSArray *)dataArray{
    for(UIView *view in _scrollview.subviews){
        [view removeFromSuperview];
    }
    
    _dataArray = dataArray;
    _scrollview.contentSize =CGSizeMake(_dataArray.count*SCREEN_WIDTH, SCREEN_HEIGHT);
    if(_index<_dataArray.count){
        _scrollview.contentOffset = CGPointMake(SCREEN_WIDTH*_index, 0);
    }
    for(int i=0;i<_dataArray.count;i++){
        UIScrollView *subScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        subScroll.delegate = self;
        //最大缩放倍数
        subScroll.maximumZoomScale = 5.0;
        //最小
        subScroll.minimumZoomScale = 1.0;
        //当前缩放倍数
        subScroll.zoomScale = 1.0;
        //反弹效果
        subScroll.bouncesZoom = NO;
        subScroll.tag = i+10;
        [_scrollview addSubview:subScroll];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageV.tag = i+50;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *path = [_dataArray[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageV sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"加载图片-图标"]];
        [subScroll addSubview:imageV];
        
        
    }
    
}


#pragma mark --- UIActionSheetDelegate---
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex

{
    
    if (buttonIndex == 0) {
        //系统方法，保存图片到相册
        UIImageWriteToSavedPhotosAlbum(zoomImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        
    }
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if(scrollView == _scrollview){
        return nil;
    }
    int index = _scrollview.contentOffset.x/SCREEN_WIDTH;
    UIImageView *zoomImageV = [scrollView viewWithTag:index+50];
    
    return zoomImageV;
}
//开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"开始缩放");
}
//缩放中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"缩放中");
}
//结束缩放
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"结束缩放");
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView == _scrollview){
        int index = _scrollview.contentOffset.x/SCREEN_WIDTH;
        UIScrollView *scv = (UIScrollView *)[_scrollview viewWithTag:index+10];
        UIImageView *igv = (UIImageView *)[scv viewWithTag:index+50];
        zoomImageView = igv;
        
        UIImageView *oldImage = [imgViews objectAtIndex:index];
        oldframe = [oldImage convertRect:oldImage.bounds toView:nil];
        NSLog(@"%f,%f,%f,%f",oldframe.origin.x,oldframe.origin.y,oldframe.size.width,oldframe.size.height);
        
        
    }
}

#pragma mark - custMethod
-(void)tapClick{
    [self endEditing:YES];
    [UIView animateWithDuration:.3 animations:^{
        zoomImageView.frame = oldframe;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)imglongTapClick:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      
                                      initWithTitle:@"保存图片"
                                      
                                      delegate:self
                                      
                                      cancelButtonTitle:@"取消"
                                      
                                      destructiveButtonTitle:nil
                                      
                                      otherButtonTitles:@"保存图片到手机",nil];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        
        [actionSheet showInView:self];
        
    }
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存图片失败";
    
    if (!error) {
        
        message = @"成功保存到相册";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];

    }else
        
    {
        
        message = [error description];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
        
    }
    
}


@end

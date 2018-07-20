//
//  AdminPhtoView.m
//  ZeroHome
//
//  Created by TW on 16/12/29.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "AdminPhtoView.h"
#import "UIImageView+WebCache.h"
#import "UIViewExt.h"
#import "zoomView.h"

@implementation AdminPhtoView{
   NSMutableArray *_imageViewsArray;
    NSMutableArray *temp;
    
}


- (instancetype)initWithMaxItemsCount:(NSInteger)count
{
    if (self = [super init]) {
      self.maxItemsCount = count;
    }
    return self;
}


- (void)setPhotoNamesArray:(NSMutableArray *)photoNamesArray
{
    _photoNamesArray = photoNamesArray;
    
    if (!_imageViewsArray) {
        _imageViewsArray = [NSMutableArray new];
    }
    
    int needsToAddItemsCount = (int)(_photoNamesArray.count - _imageViewsArray.count);
    
    if (needsToAddItemsCount > 0) {
        for (int i = 0; i < needsToAddItemsCount; i++) {
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            [_imageViewsArray addObject:imageView];
        }
    }
    
      temp = [NSMutableArray new];
    
    [_imageViewsArray enumerateObjectsUsingBlock:^(UIImageView *imageView, NSUInteger idx, BOOL *stop) {
        if (idx < _photoNamesArray.count) {
            imageView.hidden = NO;
            imageView.tag = 90+idx;
            imageView.sd_layout.autoHeightRatio(1);
            [imageView sd_setImageWithURL:[NSURL URLWithString:_photoNamesArray[idx]]];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomClick:)];
            [imageView addGestureRecognizer:tap];
            [temp addObject:imageView];
        } else {
            [imageView sd_clearAutoLayoutSettings];
            imageView.hidden = YES;
        }
        
    }];
    
    [self setupAutoWidthFlowItems:[temp copy] withPerRowItemsCount:4 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:0 horizontalEdgeInset:0];
}


-(void)zoomClick:(UITapGestureRecognizer *)tap{
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    zoomView *zoomview = [[zoomView alloc]init];
    zoomview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [zoomview showImageWithImageViews:_imageViewsArray andimages:_photoNamesArray andIndex:tap.view.tag-90];
    [window addSubview:zoomview];

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickImage)]) {
        [_delegate clickImage];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

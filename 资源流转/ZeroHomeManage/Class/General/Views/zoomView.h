//
//  zoomView.h
//  ZeroHome
//
//  Created by Dagan on 15/11/23.
//  Copyright © 2015年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zoomView : UIView<UIScrollViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)UIScrollView *scrollview;

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)int index;//当前是第几页

/**
 *  imageViews是imageview的数组  images是图片链接的地址   index当前点击第几个
 *
 *  @param
 */

-(void)showImageWithImageViews:(NSMutableArray *)imageViews andimages:(NSMutableArray *)images andIndex:(NSInteger)index;
@end

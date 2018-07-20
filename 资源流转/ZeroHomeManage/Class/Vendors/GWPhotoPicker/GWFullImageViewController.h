//
//  FullImageViewController.h
//  Ming
//
//  Created by Apple on 9/29/14.
//  Copyright (c) 2014 Twilit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoveImageIndexDelegate <NSObject>
- (void)moveIndex:(NSInteger)index;
@end

typedef void(^ConfirmButtonAction)(void);

@interface GWFullImageViewController : UIViewController

@property (nonatomic,   copy) NSMutableArray *arrayMy_images;
@property (nonatomic,   copy) NSMutableArray *imageViews;
@property (nonatomic,   copy) UIScrollView *imvScrollerView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, assign) id<MoveImageIndexDelegate> delegate;

@property (nonatomic,   copy) ConfirmButtonAction confirmBlock;

- (void)layoutScrollViewSubviews;

@end

//
//  FullImageViewController.m
//  Ming
//
//  Created by Apple on 9/29/14.
//  Copyright (c) 2014 Twilit Labs. All rights reserved.
//
#import "GWFullImageViewController.h"
#import "ALAssetModel.h"
#import "SDWebImageManager.h"

@interface GWFullImageViewController () <UIScrollViewDelegate>
{
    UILabel *_lblTitle;
    UIView *_vBottmToolBar; /**< 屏幕最下方的Banner */
    UIButton *_btnConfirm;
}

@end

@implementation GWFullImageViewController

@synthesize pageIndex,imageViews,arrayMy_images,imvScrollerView,delegate;

- (id)initFrame:(CGRect)frame
{
    if (!self) {
        self = [self initFrame:frame];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(kSystemVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor blackColor];
    if (imvScrollerView == nil) {
        imvScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 44)];
        imvScrollerView.scrollEnabled = YES;
        imvScrollerView.pagingEnabled = YES;
        imvScrollerView.delegate = self;
        [self.view addSubview:imvScrollerView];
    }
    if (_lblTitle == nil) {
        _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60,40)];
        _lblTitle.textColor = [UIColor blueColor];//
        _lblTitle.textAlignment = NSTextAlignmentCenter;
        _lblTitle.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)arrayMy_images.count];
        self.navigationItem.titleView = _lblTitle;
    }
    
    UIEdgeInsets imageInsets = UIEdgeInsetsMake(5, 0, 5, 0);//上，左，下，右
    UIImage *imgBack = [UIImage imageNamed:@"back.png"];
    UIImage *imgBackFocus = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [[UIButton alloc] initWithSize:CGSizeMake(36, 36)];
    [backButton setImage:imgBack forState:UIControlStateNormal];
    [backButton setImage:imgBackFocus forState:UIControlStateHighlighted];
    backButton.imageEdgeInsets = imageInsets;
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStyleDone;
 
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tick"] style:UIBarButtonItemStylePlain target:self action:@selector(isSelectImage)];
    _vBottmToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 108, self.view.frameSizeWidth, 44)];
    _vBottmToolBar.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:_vBottmToolBar];
    [self.view bringSubviewToFront:_vBottmToolBar];
    
    
    _btnConfirm = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frameSizeWidth - 100, 7, 80, 30)];
    [_btnConfirm setTitle:[NSString stringWithFormat:@"%@(%lu)", @"确定", (unsigned long)arrayMy_images.count] forState:UIControlStateNormal];
    _btnConfirm.backgroundColor = RGB_B(35, 122, 222);
    _btnConfirm.layer.cornerRadius = 3;
    _btnConfirm.layer.masksToBounds = YES;
    _btnConfirm.titleLabel.font = Font(13);
    
    [_btnConfirm addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [_vBottmToolBar addSubview:_btnConfirm];
    
    
    [self initMy_images];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)confirmAction
{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kFullImageConfirmSelectedPhoto" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)closePhotoView
{
    if(!self.isPhoto){
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FullImage" object:[NSNumber numberWithInteger:pageIndex]];
    }];
}

- (void)initMy_images
{
    if (arrayMy_images.count > 0) {
        NSMutableArray *views = [[NSMutableArray alloc] init];
        for (NSUInteger i = 0; i < [arrayMy_images count]; i++) {
            [views addObject:[NSNull null]];
        }
        imageViews = views;
        imvScrollerView.contentSize = CGSizeMake(arrayMy_images.count * self.view.frame.size.width, imvScrollerView.frame.size.height);
        [self moveToImageAtIndex:pageIndex animated:NO];
    }
    else{
        imvScrollerView.scrollEnabled = NO;
    }
}

#pragma mark - ScrollerView 滑动处理

/**
 *  中间图片坐标
 *
 *  @return 返回中间图片坐标
 */
- (NSInteger)centerImageIndex
{
    CGFloat pageWidth = imvScrollerView.frame.size.width;
    return (NSInteger) (floor((imvScrollerView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
}

/**
 *  当前显示图片坐标
 *
 *  @return
 */
- (NSInteger)currentImageIndex
{
    return pageIndex;
}

/**
 *  从新设置 imageView 的位置
 */
- (void)layoutScrollViewSubviews {
    
    NSInteger index = [self currentImageIndex];
    
    for (NSInteger page = index - 1; page < index + 3; page++) {
        
        if (page >= 0 && page < [arrayMy_images count]) {
            
            CGFloat originX = imvScrollerView.bounds.size.width * page;
            
            if ([imageViews objectAtIndex:(NSUInteger) page] == [NSNull null] || !((UIView *) [imageViews objectAtIndex:(NSUInteger) page]).superview) {
                [self loadScrollViewWithPage:page];
            }
            
            UIImageView *imageView = [imageViews objectAtIndex:(NSUInteger) page];
            CGRect newFrame = CGRectMake(originX, 0.0f, imvScrollerView.bounds.size.width, imvScrollerView.bounds.size.height);
            
            if (!CGRectEqualToRect(imageView.frame, newFrame)) {
                [UIView animateWithDuration:0.1 animations:^{
                    imageView.frame = newFrame;
                }];
            }
        }
    }
}

/**
 *  加载图片
 *
 *  @param page 加载的图片坐标
 */
- (void)loadScrollViewWithPage:(NSInteger)page {
    
    if (page < 0) {
        return;
    }
    if (page >= [arrayMy_images count]) {
        return;
    }
    
    UIImageView *imageView = [imageViews objectAtIndex:(NSUInteger) page];
    if ((NSNull *) imageView == [NSNull null]) {
        imageView = [self dequeueImageView];
        if (imageView != nil) {
            [imageViews exchangeObjectAtIndex:(NSUInteger) imageView.tag withObjectAtIndex:(NSUInteger) page];
            imageView = [imageViews objectAtIndex:(NSUInteger) page];
        }
    }
    
    if (imageView == nil || (NSNull *) imageView == [NSNull null]) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imvScrollerView.bounds.size.width, imvScrollerView.bounds.size.height)];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePhotoView)];
        tapGesture.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tapGesture];
        [imageView setUserInteractionEnabled:YES];
        [imageViews replaceObjectAtIndex:(NSUInteger) page withObject:imageView];
    }
    
    ALAssetModel *alAsset = arrayMy_images[page];
    UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@",alAsset.alasset.defaultRepresentation.url]];
    if (cacheImage == nil) {
        [self getFullResolutionImage:alAsset ImageView:imageView];
    }else{
        imageView.image = cacheImage;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if (imageView.superview == nil) {
        [imvScrollerView addSubview:imageView];
    }
    
    CGRect frame = imvScrollerView.frame;
    NSInteger centerPageIndex = pageIndex;
    CGFloat xOrigin = (frame.size.width * page);
    if (page > centerPageIndex) {
        xOrigin = (frame.size.width * page) ;
    } else if (page < centerPageIndex) {
        xOrigin = (frame.size.width * page) ;
    }
    frame.origin.x = xOrigin;
    frame.origin.y = 0;
    imageView.frame = frame;
}

/**
 *  缓存图片
 *
 *  @param dvAlAsset <#dvAlAsset description#>
 *  @param imageView <#imageView description#>
 */
- (void)getFullResolutionImage:(ALAssetModel *)dvAlAsset ImageView:(UIImageView *)imageView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        [[SDImageCache sharedImageCache] storeImage:[UIImage imageWithCGImage:[[dvAlAsset.alasset defaultRepresentation] fullScreenImage]] forKey:[NSString stringWithFormat:@"%@",dvAlAsset.alasset.defaultRepresentation.url] toDisk:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@",dvAlAsset.alasset.defaultRepresentation.url]];
            if (cacheImage != nil) {
                imageView.image = cacheImage;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                
            }
            
        });
    });
}

- (UIImageView *)dequeueImageView
{
    NSInteger count = 0;
    for (UIImageView *view in imageViews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (view.superview == nil) {
                view.tag = count;
                return view;
            }
        }
        count++;
    }
    return nil;
}

- (void)enqueueImageViewAtIndex:(NSInteger)theIndex
{
    NSInteger count = 0;
    for (UIImageView *view in imageViews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            if (count > theIndex + 1 || count < theIndex - 1) {
                view.tag = -1;
                [view removeFromSuperview];
            } else {
                view.tag = 0;
            }
        }
        count++;
    }
}

- (void)moveToImageAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index < [arrayMy_images count] && index >= 0) {
        
        pageIndex = index;
        
        [self enqueueImageViewAtIndex:index];
        
        [self loadScrollViewWithPage:index - 1];
        [self loadScrollViewWithPage:index];
        [self loadScrollViewWithPage:index + 1];
        
        [imvScrollerView scrollRectToVisible:((UIImageView *) [imageViews objectAtIndex:(NSUInteger) index]).frame animated:animated];
        
        
        if (index + 1 < [arrayMy_images count] && (NSNull *) [imageViews objectAtIndex:(NSUInteger) (index + 1)] != [NSNull null]) {
            //[((UIImageView *) [_imageViews objectAtIndex:(NSUInteger) (index + 1)]) killScrollViewZoom];
        }
        if (index - 1 >= 0 && (NSNull *) [imageViews objectAtIndex:(NSUInteger) (index - 1)] != [NSNull null]) {
            //[((FSImageView *) [self.imageViews objectAtIndex:(NSUInteger) (index - 1)]) killScrollViewZoom];
        }
        [self.delegate moveIndex:index];
    }
}

#pragma mark - UIScrollerView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = [self centerImageIndex];
    if (index >= [arrayMy_images count] || index < 0) {
        return;
    }
    
    if (pageIndex != index) {
        pageIndex = index;
        if (![scrollView isTracking]) {
            [self layoutScrollViewSubviews];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = [self centerImageIndex];
    if (index >= [arrayMy_images count] || index < 0) {
        return;
    }
    
    [self moveToImageAtIndex:index animated:YES];
    _lblTitle.text = [NSString stringWithFormat:@"%ld/%lu",pageIndex + 1,(unsigned long)arrayMy_images.count];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self layoutScrollViewSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

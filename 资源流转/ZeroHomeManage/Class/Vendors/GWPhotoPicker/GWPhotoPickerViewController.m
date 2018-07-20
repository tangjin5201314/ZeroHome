//
//  GWPhotoPickerViewController.m
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/18.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "GWPhotoPickerViewController.h"
#import "GWFullImageViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "SDWebImageManager.h"

#import "GWMenuItemCell.h"
#import "GWPhotoLibraryCell.h"

#import "MenuItemModel.h"


#define CELLWEIGHT 104 //self.view.frame.size.width / 3 - 10
#define CELLHEIGHT 104 //self.view.frame.size.width / 3 - 10
#define CellEdgeInsets 4
#define ONEDAY (3600 *24)

@interface GWPhotoPickerViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIImageView *upDownImageView;     //上下箭头的
@property (nonatomic, strong) UIView *navTitleView;             //导航标题视图

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITableView *menuItemTable;

@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) UIView *bottmToolBarView;          //屏幕最下方的透明背景
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITextView *contentTextField;

@property (nonatomic, strong) ALAssetModel *firstAsset;

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
//@property (nonatomic,strong)PHPhotoLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *allAssetsArr;     //所有的照片
@property (nonatomic, strong) NSMutableArray *groupArr;         //所有的组
@property (nonatomic, strong) NSMutableArray *assetsArr;        //分组照片
@property (nonatomic, strong) NSMutableArray *menuItemArr;      //菜单项目数组
@property (nonatomic, strong) NSMutableArray *phoneNewPhotoArr; //

@property (nonatomic, strong) NSMutableArray *selectedItemArr;  //选中的照片

@end

@implementation GWPhotoPickerViewController

@synthesize maxSelectedItem, allowsEditing;
@synthesize menuButton, upDownImageView, navTitleView, bgView, menuItemTable;
@synthesize photoCollectionView, bottmToolBarView, confirmButton, contentTextField;
@synthesize firstAsset;
@synthesize assetsLibrary, allAssetsArr, groupArr, assetsArr, menuItemArr, phoneNewPhotoArr;
@synthesize selectedItemArr;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - initUI

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"";
    
    menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [menuButton setTitle:@"" forState:UIControlStateNormal];
    [menuButton setTitleColor:default_blue_color forState:UIControlStateNormal];
    //menuButton.titleLabel.textColor = default_blue_color;//[UIColor whiteColor];
    [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    upDownImageView=[[UIImageView alloc] initWithFrame:CGRectMake(56, 14, 12, 12)];
    [self updateUpDownImageViewPoint:menuButton];
    
    CGPoint point=upDownImageView.center;
    point.x = menuButton.center.x;
    upDownImageView.center=point;
    
    [self imageViewDown];
    
    navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [navTitleView addSubview:menuButton];
    [navTitleView addSubview:upDownImageView];
    navTitleView.backgroundColor=[UIColor clearColor];
    self.navigationItem.titleView = navTitleView;
    
    UIButton *leftNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    leftNavBtn.titleLabel.font = Font(17);
    [leftNavBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftNavBtn setTitleColor:RGB_B(68, 129, 210) forState:UIControlStateNormal];
    [leftNavBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [leftNavBtn addTarget:self action:@selector(closePhotoLibrary) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavBtn];
    
    UIEdgeInsets rightNavBtnEdgeInset = UIEdgeInsetsMake(0, 10, 0, 0);
    UIButton *rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    rightNavBtn.titleLabel.font = Font(17);
    [rightNavBtn setTitle:@"预览" forState:UIControlStateNormal];
//    [rightNavBtn setImage:[UIImage imageNamed:@"icon_camero"] forState:UIControlStateNormal];
//    [rightNavBtn setImage:[UIImage imageNamed:@"icon_camero"] forState:UIControlStateHighlighted];
    [rightNavBtn setTitleColor:RGB_B(68, 129, 210) forState:UIControlStateNormal];
    [rightNavBtn setTitleEdgeInsets:rightNavBtnEdgeInset];
    [rightNavBtn addTarget:self action:@selector(previewSelectedImage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavBtn];
    
    self.navigationItem.rightBarButtonItem.enabled = [selectedItemArr count] >0 ? YES : NO;
    confirmButton.backgroundColor=[selectedItemArr count] > 0 ? RGB_B(35, 122, 222) : [UIColor lightGrayColor];
    
    
    [self initAssetsGroup];
    
    
    //注册键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShown:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  初始化菜单
 */
- (void)initMenuItemTableView
{
    if (menuItemTable == nil) {
        bgView = [[UIView alloc] initWithFrame:self.view.frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0;
        menuItemTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame),(menuItemArr.count + 1) * 60)];
        menuItemTable.delegate = self;
        menuItemTable.dataSource = self;
        [self.view addSubview:bgView];
        [self.view addSubview:menuItemTable];
        
        menuItemTable.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            menuItemTable.alpha = 1.0;
            bgView.alpha = 0.4;
        }];
    }else{
        [self imageViewDown];
        [UIView animateWithDuration:0.25 animations:^{
            menuItemTable.alpha = 0;
            bgView.alpha = 0;
        }completion:^(BOOL finished){
            [menuItemTable removeFromSuperview];
            [bgView removeFromSuperview];
            menuItemTable = nil;
            bgView = nil;
        }];
    }
}

- (void)initCollecctionView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    photoCollectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:flowLayout];
    photoCollectionView.backgroundColor = [UIColor whiteColor];
    [photoCollectionView registerClass:[GWPhotoLibraryCell class] forCellWithReuseIdentifier:@"GWPhotoLibraryCell"];
    photoCollectionView.delegate = self;
    photoCollectionView.dataSource = self;
    [self.view addSubview:photoCollectionView];
    
    
    bottmToolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frameSizeHeight - 44, self.view.frameSizeWidth, 44)];
    bottmToolBarView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    [self.view addSubview:bottmToolBarView];
    [self.view bringSubviewToFront:bottmToolBarView];
    
    
    confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frameSizeWidth - 100, 7, 90, 30)];
    [confirmButton setTitle:@"确定(0)" forState:UIControlStateNormal]; //[NSString stringWithFormat:@"%@(0)",[CommenMethod localizationString:@"Confirm"]
//    confirmButton.titleLabel.font = FONT_SYSTEM(13);
    confirmButton.titleLabel.textColor = [UIColor whiteColor];
    confirmButton.backgroundColor = [UIColor lightGrayColor];
    confirmButton.layer.cornerRadius = 3;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    

    contentTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, 7, 200, 30)];
    contentTextField.backgroundColor = [UIColor whiteColor];
    contentTextField.layer.cornerRadius = 3;
    contentTextField.layer.masksToBounds = YES;
    contentTextField.delegate = self;

    if (self.showContentTextField) {
        [bottmToolBarView addSubview:contentTextField];
    }
    
    
    [bottmToolBarView addSubview:confirmButton];
}

-(void)updateUpDownImageViewPoint:(UIButton *)btn
{
    NSLog(@"____%@",btn.titleLabel.text);
    CGRect frame = menuButton.frame;
    CGSize size = [btn.titleLabel.text sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(200, 40) lineBreakMode:btn.titleLabel.lineBreakMode];
    if(size.width < 5)
        return;
    
    
    frame.size.width = size.width;
    menuButton.titleLabel.frame = frame;
    menuButton.frame = frame;

    
    CGRect upDownImageFrame = upDownImageView.frame;
    upDownImageFrame.origin.x = frame.size.width + 5;
    upDownImageView.frame=upDownImageFrame;
    
    frame.size.width=frame.size.width+17;
    navTitleView.frame=frame;
  
    self.navigationItem.titleView=nil;
    self.navigationItem.titleView=navTitleView;
}

-(void)imageViewDown
{
    upDownImageView.image=[UIImage imageNamed:@"icon_gwpicker_photo_choose_down"];
}

-(void)imageViewUp
{
    upDownImageView.image=[UIImage imageNamed:@"icon_gwpicker_photo_choose_up"];
}

#pragma mark - configData

//加载所有手机里的相册和相片
- (void)initAssetsGroup
{
    if (assetsLibrary == nil) {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
//        assetsLibrary = [[PHPhotoLibrary alloc]init];
    }
    
    menuItemArr = [[NSMutableArray alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group,BOOL *stop){
        
        if (groupArr == nil) {
            groupArr = [[NSMutableArray alloc] init];
        }
        if (group != nil) {
            
            MenuItemModel *model = [[MenuItemModel alloc] init];
            model.posterImage = [UIImage imageWithCGImage:group.posterImage];
            model.numberOfAssets = group.numberOfAssets;
            model.groupName = [group valueForProperty:ALAssetsGroupPropertyName];
            model.isSysLibrary = YES;
            if ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos) {
                [groupArr insertObject:group atIndex:0];
                [menuItemArr insertObject:model atIndex:0];
                [menuButton setTitle:[group valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
                [self updateUpDownImageViewPoint:menuButton];
                [self initAssets:[group valueForProperty:ALAssetsGroupPropertyName]];
                if (groupArr != nil && groupArr.count > 0 && phoneNewPhotoArr != nil) {
                    
                    ALAssetsGroup *group = [groupArr objectAtIndex:0];
                    if ([group isKindOfClass:[ALAssetsGroup class]]) {
                        
                        assetsArr = phoneNewPhotoArr;
                        if (assetsArr != nil && assetsArr.count > 0) {
                            MenuItemModel *model = [[MenuItemModel alloc] init];
                            model.posterImage = [UIImage imageWithCGImage:((ALAssetModel *)[assetsArr objectAtIndex:0]).alasset.thumbnail];
                            model.numberOfAssets = assetsArr.count;
                            model.isSysLibrary = NO;
                            model.groupName = @"最近照片"; //[CommenMethod localizationString:@"Recently" ];//国际化
                            [groupArr insertObject:@"最近照片" atIndex:0];//[groupArr insertObject:[CommenMethod localizationString:@"Recently" ] atIndex:0];
                            [menuItemArr insertObject:model atIndex:0];
                            [menuButton setTitle:@"最近照片" forState:UIControlStateNormal];
                            [self updateUpDownImageViewPoint:menuButton];
                            if (photoCollectionView == nil) {
                                [self initCollecctionView];
                            }
                            [photoCollectionView reloadData];
                        }
                    }
                }
                
            }else{
                [groupArr addObject:group];
                [menuItemArr addObject:model];
            }
            
        }
    } failureBlock:^(NSError *fail){
        NSLog(@"加载照片失败：%@",fail);
    }];
}

//初始化相册列表____所有片
- (void)initAssets:(NSString *)groupName
{
    allAssetsArr = [[NSMutableArray alloc]init];
    
    for (ALAssetsGroup *group in groupArr) {
        //判断相册组是否ALAssetsGroup类型。如果不是的话就是最新相册
        if ([group isKindOfClass:[ALAssetsGroup class]] &&
            [[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:groupName]) {
            
            [group enumerateAssetsUsingBlock:^(ALAsset *results, NSUInteger index, BOOL *stop) {
                
                if (results && [results isKindOfClass:[ALAsset class]]) {
                    ALAssetModel *dvALAsset = [[ALAssetModel alloc] init];
                    dvALAsset.image = [UIImage imageWithCGImage:results.thumbnail];
                    if ([self predicateSelectedImage:results.defaultRepresentation.url array:selectedItemArr]) {
                        dvALAsset.selected = YES;
                    }else{
                        dvALAsset.selected = NO;
                    }
                    dvALAsset.tickImgName = @"tick";
                    dvALAsset.alasset = results;
                    dvALAsset.assetUrl = results.defaultRepresentation.url;
                    [allAssetsArr insertObject:dvALAsset atIndex:0];
                    
                    NSDate *createdDate = [results valueForProperty:ALAssetPropertyDate];
                    if ([[NSDate date] timeIntervalSinceDate:createdDate] <= ONEDAY) {
                        if (phoneNewPhotoArr == nil) {
                            phoneNewPhotoArr = [[NSMutableArray alloc] init];
                        }
                        if (![self predicateSelectedImage:dvALAsset.assetUrl array:phoneNewPhotoArr]) {
                            [phoneNewPhotoArr insertObject:dvALAsset atIndex:0];
                        }
                        
                    }
                }
                if (results == nil && stop) {
                    
                    assetsArr = allAssetsArr;
                    if (assetsArr != nil && assetsArr.count > 0) {
                        ALAssetModel *model = [assetsArr objectAtIndex:0];
                        if (model.tickImgName != nil) {
                            firstAsset = [[ALAssetModel alloc] init];
                            firstAsset.image = [UIImage imageNamed:@"icon_gwpicker_camera"];
                            firstAsset.selected = NO;
                            firstAsset.tickImgName = nil;
                            [assetsArr insertObject:firstAsset atIndex:0];
                        }
                    }else{
                        if (assetsArr.count == 0) {
                            firstAsset = [[ALAssetModel alloc] init];
                            firstAsset.image = [UIImage imageNamed:@"icon_gwpicker_camera"];
                            firstAsset.selected = NO;
                            firstAsset.tickImgName = nil;
                            [assetsArr addObject:firstAsset];
                        }
                    }
                    
                    if (assetsArr != nil) {
                        if (photoCollectionView == nil) {
                            [self initCollecctionView];
                        }
                        [menuButton setTitle:[group valueForProperty:ALAssetsGroupPropertyName] forState:UIControlStateNormal];
                        [self updateUpDownImageViewPoint:menuButton];
                        [photoCollectionView reloadData];
                    }
                }
            }];
        }
    }
    
    
}

#pragma mark - actions

- (void)menuButtonAction
{
    [self imageViewUp];
    [self initMenuItemTableView];
}

- (void)confirmAction:(UIButton *)button
{
    if([selectedItemArr count] < 1)
    return ;
    
    //代理哦
    if ([self.photoLibrayDelegate respondsToSelector:@selector(DVPhotoLibrayViewController:didFinishPickingAssets:)]) {
        [self.photoLibrayDelegate DVPhotoLibrayViewController:self didFinishPickingAssets:self.selectedItemArr];
    }
    
    if ([self.photoLibrayDelegate respondsToSelector:@selector(DVPhotoLibrayViewController:didFinishPickingAssets: content:)]) {
        [self.photoLibrayDelegate DVPhotoLibrayViewController:self didFinishPickingAssets:self.selectedItemArr content:self.contentTextField.text];
    }
    
    //Block哦______不用客气随便用！！！
    if (self.finishPickingBlock)
        self.finishPickingBlock(selectedItemArr);
    
    if (self.finishPickingWithContentBlock) {
        self.finishPickingWithContentBlock(selectedItemArr, self.contentTextField.text);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//判断图片是否在其他的相册中已经被选择。 @param assetUrl 唯一标示符  返回判断结果
- (BOOL)predicateSelectedImage:(NSURL *)assetUrl array:(NSMutableArray *)predicateArray
{
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"assetUrl = %@",assetUrl];
    NSArray *array = [predicateArray filteredArrayUsingPredicate:pred];
    if (array.count > 0) {
        return YES;
    }
    return NO;
}


- (void)closePhotoLibrary
{
    void (^animations)(void) = ^{
        if(contentTextField && contentTextField.isFirstResponder){
            [contentTextField resignFirstResponder];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    void (^complete)(BOOL) = ^(BOOL finished) {
        
    };
    [UIView animateWithDuration:.3 animations:animations completion:complete];
    
}

//预览图片
- (void)previewSelectedImage
{
    GWFullImageViewController *vc = [[GWFullImageViewController alloc] init];
    vc.arrayMy_images = selectedItemArr;
    vc.confirmBlock = ^(){
        
//        [self confirmAction:nil];
    };
    [self.navigationController pushViewController:vc animated:YES ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(confirmSelectedPhoto:) name:@"kFullImageConfirmSelectedPhoto" object:nil];
    
}

#pragma mark - UITabelView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItemArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GWMenuItemCell *cell = (GWMenuItemCell *)[tableView dequeueReusableCellWithIdentifier:@"DVMenuItemCell"];
    if (cell == nil) {
        cell = [[GWMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DVMenuItemCell"];
    }
    
    MenuItemModel *model = [menuItemArr objectAtIndex:indexPath.row];
    [cell setContent:model IndexPath:indexPath tbv:tableView obj:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self imageViewDown];
    if (indexPath.row == 0) {
        if (!((MenuItemModel *)[menuItemArr objectAtIndex:indexPath.row]).isSysLibrary) {
            assetsArr = phoneNewPhotoArr;
            [menuButton setTitle:@"最近" forState:UIControlStateNormal];
            [self updateUpDownImageViewPoint:menuButton];
            if (photoCollectionView == nil) {
                [self initCollecctionView];
            }
            [photoCollectionView reloadData];
            
            [self initMenuItemTableView];
            return;
        }
    }
    
    NSString *groupName = ((MenuItemModel *)[menuItemArr objectAtIndex:indexPath.row]).groupName;
    [self initAssets:groupName];
    [self initMenuItemTableView];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [assetsArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GWPhotoLibraryCell";
    GWPhotoLibraryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    ALAssetModel *model = [assetsArr objectAtIndex:indexPath.row];
    for (ALAssetModel *dvAlAsset in selectedItemArr) {
        if ([dvAlAsset.alasset isEqual:model]) {
            model = dvAlAsset;
        }
    }
    [cell setContent:model IndexPath:indexPath CollectionView:collectionView obj:nil];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELLWEIGHT, CELLHEIGHT);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(CellEdgeInsets,0, CellEdgeInsets,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return CellEdgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return CellEdgeInsets;
}

#pragma mark - UICollectionView Delegate

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"deselect");
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(contentTextField){
        if(contentTextField.isFirstResponder){
            [contentTextField resignFirstResponder];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(contentTextField){
        if(contentTextField.isFirstResponder){
            [contentTextField resignFirstResponder];
        }
    }
    
    if (selectedItemArr == nil) {
        selectedItemArr = [[NSMutableArray alloc] init];
    }
    
    if (maxSelectedItem == selectedItemArr.count) {
        ALAssetModel *model = [assetsArr objectAtIndex:indexPath.row];
        if (model.tickImgName != nil) {
            
            if (model.selected) {
                model.selected = NO;
                [selectedItemArr removeObject:model];
                [photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
                [confirmButton setTitle:[NSString stringWithFormat:@"%@(%ld)",@"确定",(unsigned long)selectedItemArr.count] forState:UIControlStateNormal];
                if (selectedItemArr.count == 0) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                    confirmButton.backgroundColor=[selectedItemArr count] > 0 ?RGB_B(35, 122, 222) : [UIColor lightGrayColor];
                }
            }
            else{
                
                NSString *alertMessage=[NSString stringWithFormat:@"%@%ld%@%@", @"最多只能选择", (long)self.maxSelectedItem, @"张" , @"照片"];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else{
        ALAssetModel *model = [assetsArr objectAtIndex:indexPath.row];
        if (model.tickImgName != nil) {
            if (model.selected) {
                model.selected = NO;
                [[SDImageCache sharedImageCache] removeImageForKey:[NSString stringWithFormat:@"%@",model.alasset.defaultRepresentation.url] fromDisk:YES];
                [selectedItemArr removeObject:model];
            }
            else{
                model.selected = YES;
                [selectedItemArr addObject:model];
            }
            
            
            [photoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            [confirmButton setTitle:[NSString stringWithFormat:@"%@(%ld)",@"确定",(unsigned long)selectedItemArr.count] forState:UIControlStateNormal];
            //[_btnConfirm setTitle:[NSString stringWithFormat:@"%@(%d)", @"确定", selectedItemArr.count]];
            self.navigationItem.rightBarButtonItem.enabled = [selectedItemArr count] > 0 ? YES : NO;
            confirmButton.backgroundColor = [selectedItemArr count] > 0 ? RGB_B(35, 122, 222) : [UIColor lightGrayColor];
            
            UIImage *image = [UIImage imageWithCGImage:[[model.alasset defaultRepresentation] fullScreenImage]];
            model.fullScreenImage = image;
        }
        else{
            if (indexPath.row == 0) {
                
                AVAuthorizationStatus austatu = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (austatu == AVAuthorizationStatusRestricted || austatu == AVAuthorizationStatusDenied) {
                    NSString *message = nil;
                    if (kSystemVersion >= 8.0) {
                        
                        message = iOS8CameraNotice;
                    }
                    else{
                        
                        message = iOS7CameraNotice;
                    }
//                    GWAlertView *alert = [GWAlertView alertWithTitle:@"温馨提示" message:message AlertType:GWAlertOnlyMessage];
//                    [alert show];
                    [SVProgressHUD showWithStatus:message];
                    return;
                }
                UIImagePickerController *vc = [[UIImagePickerController alloc] init];
                vc.delegate = self;
                vc.allowsEditing = allowsEditing;
                if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
                    vc.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:vc animated:YES completion:nil];
                }
                
                return;
            }
        }
    }
}

#pragma mark - touches

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(contentTextField)
    {
        if(contentTextField.isFirstResponder)
        {
            [contentTextField resignFirstResponder];
        }
    }
}


#pragma mark - 通知回调

//在预览图片页面确认图片
- (void)confirmSelectedPhoto:(NSNotification *)notification
{
    //
    [self confirmButton];
    
    if ([self.photoLibrayDelegate respondsToSelector:@selector(DVPhotoLibrayViewController:didFinishPickingAssets:)]) {
        [self.photoLibrayDelegate DVPhotoLibrayViewController:self didFinishPickingAssets:selectedItemArr];
    }
    
    if ([self.photoLibrayDelegate respondsToSelector:@selector(DVPhotoLibrayViewController:didFinishPickingAssets: content:)]) {
        [self.photoLibrayDelegate DVPhotoLibrayViewController:self didFinishPickingAssets:selectedItemArr content:contentTextField.text];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard

- (void)keyboardDidShown:(NSNotification *)noti
{
    NSDictionary* info = [noti userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    
    NSNumber *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat duration=[animationDurationValue  floatValue];
    
    
    [UIView animateWithDuration:duration animations:^{
        
        bottmToolBarView.frameOriginY  = self.view.frameSizeHeight - keyboardH - bottmToolBarView.frameSizeHeight;
    }];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.25 animations:^{
        
        [bottmToolBarView bottomAlignForSuperView];
    }];
}

- (CGRect)keyboardFrameFromNoti:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardValue CGRectValue];
    return keyboardFrame;
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self.photoLibrayDelegate respondsToSelector:@selector(DVPhotoPickerViewController:didFinishPickingMediaWithInfo:)]) {
        [self.photoLibrayDelegate DVPhotoPickerViewController:picker didFinishPickingMediaWithInfo:info];
    }
    
    if (self.finishPickingPhotoPickerBlock) {
        self.finishPickingPhotoPickerBlock(picker, info);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

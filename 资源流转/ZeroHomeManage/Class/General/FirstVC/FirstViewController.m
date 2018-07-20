//
//  FirstViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 16/8/26.
//  Copyright (c) 2016年 TW. All rights reserved.
//

#import "FirstViewController.h"
#import "UIViewExt.h"
#import "LoginViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController{
    UIPageControl *pageControl;
    
    UIImage *image;
    UIButton *goBtn;
}

#define pageNum 3

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%f",SCREEN_HEIGHT);
    [self scrollview];
    [self animation];
}
-(void)scrollview{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mainScrollView.delegate = self;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*pageNum, SCREEN_HEIGHT);
    _mainScrollView.bounces = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.directionalLockEnabled = YES;
    [self.view addSubview:_mainScrollView];
    
    for(int i=0;i<pageNum;i++){
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageview.tag = i;
        imageview.userInteractionEnabled = YES;
        UIImage *image1;
        if(SCREEN_HEIGHT == 480){
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d_640_960",i+1]];
            
            
            image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_5",i+1]];
            if(i==1){
                image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_1_5",i+1]];
                image1 = [UIImage imageNamed:[NSString stringWithFormat:@"image%d_2_5",i+1]];
            }
        }else if (SCREEN_HEIGHT == 568){
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d_640_1138",i+1]];
            image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_5",i+1]];
            if(i==1){
                image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_1_5",i+1]];
                image1 = [UIImage imageNamed:[NSString stringWithFormat:@"image%d_2_5",i+1]];
            }
        }else if (SCREEN_HEIGHT == 667){
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d_640_1138",i+1]];
            image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_6",i+1]];
            if(i==1){
                image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_1_6",i+1]];
                image1 = [UIImage imageNamed:[NSString stringWithFormat:@"image%d_2_6",i+1]];
            }
        }else if (SCREEN_HEIGHT == 736){
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d_1242_2209",i+1]];
            
            image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_6p",i+1]];
            if(i==1){
                image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d_1_6p",i+1]];
                image1 = [UIImage imageNamed:[NSString stringWithFormat:@"image%d_2_6p",i+1]];
            }
        }
        
        [_mainScrollView addSubview:imageview];
        
        if(i==0){
            UIImageView *midImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT*0.24, image.size.width, image.size.height)];
            midImageView.tag = i+10;
            midImageView.image = image;
            [imageview addSubview:midImageView];
            midImageView.alpha = 0;
        }else if (i==1){
            UIImageView *midImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24, SCREEN_HEIGHT*0.18, image.size.width, image.size.height)];
            midImageView1.tag = i+10;
            midImageView1.image = image;
            [imageview addSubview:midImageView1];
            
            UIImageView *midImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.32, SCREEN_HEIGHT*0.54, image.size.width, image.size.height)];
            midImageView2.tag = i+20;
            midImageView2.image = image1;
            [imageview addSubview:midImageView2];
            
            midImageView1.alpha = 0;
            midImageView2.alpha = 0;
        }else{
            UIImageView *midImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.2, SCREEN_HEIGHT*0.58, 10, 10)];
            midImageView.tag = i+10;
            midImageView.center = CGPointMake(SCREEN_WIDTH/2, midImageView.center.y);
            midImageView.image = image;
            [imageview addSubview:midImageView];
            
            goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [goBtn setBackgroundImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
            goBtn.frame = CGRectMake((SCREEN_WIDTH-145)/2, SCREEN_HEIGHT-100, 145, 45);
            [goBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
            
            [imageview addSubview:goBtn];
            
        }
    }
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, goBtn.bottom+10, 0, 0)];
    pageControl.backgroundColor = [UIColor redColor];
    //pageControl.center = CGPointMake(50, pageControl.center.y);
    pageControl.numberOfPages=pageNum;
    pageControl.currentPage=0;
    pageControl.currentPageIndicatorTintColor= [UIColor whiteColor];
    pageControl.pageIndicatorTintColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    [self.view addSubview:pageControl];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark page跟随scrollview滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1{
    
    CGPoint offset=scrollView1.contentOffset;
    CGRect bounds=scrollView1.frame;
    [pageControl setCurrentPage:offset.x/bounds.size.width];
    [self animation];
}

-(void)animation{
    int index = _mainScrollView.contentOffset.x/SCREEN_WIDTH;
    if(index == 0){
        [UIView animateWithDuration:1 animations:^{
            UIImageView *imageview = (UIImageView *)[self.view viewWithTag:10];
            imageview.left = SCREEN_WIDTH*0.7;
            imageview.alpha = 1;
        }];
    }else if (index == 1){
        [UIView animateWithDuration:1 animations:^{
            UIImageView *imageview = (UIImageView *)[self.view viewWithTag:21];
            imageview.alpha = 1;
        } completion:^(BOOL finished) {
            UIImageView *imageview = (UIImageView *)[self.view viewWithTag:11];
            imageview.alpha = 1;
        }];
    }else if (index == 2){
        [UIView animateWithDuration:1 animations:^{
            UIImageView *imageview = (UIImageView *)[self.view viewWithTag:12];
            imageview.frame = CGRectMake(SCREEN_WIDTH*0.2, SCREEN_HEIGHT*0.27, image.size.width, image.size.height);
            imageview.center = CGPointMake(SCREEN_WIDTH/2, imageview.center.y);
            imageview.alpha = 1;
        }];
    }
    
    
}
-(void)login{
    if(_isSetPush){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        
        nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  TabBarMainViewController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/10.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "TabBarMainViewController.h"
#import "WorkOrderHomeController.h"
#import "HomePageViewController.h"
#import "ResourceHomeController.h"

@interface TabBarMainViewController ()

@end

@implementation TabBarMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setControllers];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        self.tabBarController.tabBar.subviews[0].subviews[1].hidden = YES;
    }
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [UITabBar appearance].translucent = NO;
}

- (void)setControllers
{
    //设置选中的tabitem，也可以使用selectedViewController
    //    tab.selectedIndex = 2;
    WorkOrderHomeController *workVC = [[WorkOrderHomeController alloc]init];
   [self controller:workVC Title:@"工单管理" tabBarItemImage:@"工单管理未选中" tabBarItemSelectedImage:@"工单管理选中"];
    ResourceHomeController *resourceVC = [[ResourceHomeController alloc]init];
    [self controller:resourceVC Title:@"资源管理" tabBarItemImage:@"端口管理未选中" tabBarItemSelectedImage:@"端口管理选中"];
    HomePageViewController *homeVC =[[HomePageViewController alloc]init];
     [self controller:homeVC Title:@"门锁管理" tabBarItemImage:@"门锁管理未选中" tabBarItemSelectedImage:@"门锁管理选中"];
    
   
//    self.viewControllers = @[workNav,resourceNav,homeNav];
}


/**
 * 抽取成一个方法
 * 传入控制器、标题、正常状态下图片、选中状态下图片
 * 直接调用这个方法就可以了
 */
- (void)controller:(UIViewController *)controller Title:(NSString *)title tabBarItemImage:(NSString *)image tabBarItemSelectedImage:(NSString *)selectedImage
{
    controller.title = title;
    UIImage *unSelectimage = [UIImage imageNamed:image];
    controller.tabBarItem.image = [unSelectimage imageWithRenderingMode:UIImageRenderingModeAutomatic];
    // 设置 tabbarItem 选中状态的图片(不被系统默认渲染,显示图像原始颜色)
    UIImage *imageHome = [UIImage imageNamed:selectedImage];
    imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [controller.tabBarItem setSelectedImage:imageHome];
    // 设置 tabbarItem 选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
    NSDictionary *dictHome = [NSDictionary dictionaryWithObject:HexRGB(0x4facf6) forKey:NSForegroundColorAttributeName];
    [controller.tabBarItem setTitleTextAttributes:dictHome forState:UIControlStateSelected];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:controller];
    [self addChildViewController:nav];
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

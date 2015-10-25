//
//  RootViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "RootTabViewController.h"

#import "HomeRootViewController.h"
#import "ClassifyRootViewController.h"
#import "ShoppingCartRootViewController.h"
#import "MeRootViewController.h"
#import "RDVTabBarItem.h"

#define BLUE_GREEN_COLOR @"72ded4"
@interface RootTabViewController ()

- (void)setupViewControllers;
- (void)customTabBarItemForController;
@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewControllers];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
//设置tarbarcontroller
- (void)setupViewControllers{
    HomeRootViewController *home = [[HomeRootViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    
    UIImage *normalImage = [UIImage imageNamed:@"home_icon2"];
    UIImage *selectedImage = [UIImage imageNamed:@"home_icon_selected"];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:normalImage selectedImage:selectedImage];
    
    ClassifyRootViewController *class = [[ClassifyRootViewController alloc] init];
    UINavigationController *classNav = [[UINavigationController alloc] initWithRootViewController:class];
    UIImage *normalImage2 = [UIImage imageNamed:@"分类_icon"];
    UIImage *selectedImage2 = [UIImage imageNamed:@"分类_icon2"];
    classNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"筛选" image:normalImage2 selectedImage:selectedImage2];
    
    ShoppingCartRootViewController *shop = [[ShoppingCartRootViewController alloc] init];
    UINavigationController *shopNav = [[UINavigationController alloc] initWithRootViewController:shop];
    UIImage *normalImage3 = [UIImage imageNamed:@"购物车_icon"];
    UIImage *selectedImage3 = [UIImage imageNamed:@"购物车_icon2"];
    shopNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车" image:normalImage3 selectedImage:selectedImage3];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Me" bundle:nil];
    MeRootViewController *me = sb.instantiateInitialViewController;
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:me];
    UIImage *normalImage4 = [UIImage imageNamed:@"我_icon"];
    UIImage *selectedImage4 = [UIImage imageNamed:@"我_icon2"];
    meNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:normalImage4 selectedImage:selectedImage4];
    
    self.tabBar.tintColor = [UIColor colorWithHexString:BLUE_GREEN_COLOR];
    [self setViewControllers:@[homeNav, classNav, shopNav, meNav]];
    
}

@end

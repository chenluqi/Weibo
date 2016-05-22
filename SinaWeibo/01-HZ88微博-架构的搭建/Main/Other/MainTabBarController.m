//
//  MainTabBarController.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/9.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "MainTabBarController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"

@interface MainTabBarController ()

@property (strong, nonatomic) ThemeImageView *selectImage;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载各导航控制器
    [self _loadSubViewCtrls];
    
    //自定义tabBar
    [self _createCustomTabBar];
    
    
}

- (void)_loadSubViewCtrls {
    
    NSArray *storyboardNames = @[@"Home", @"Message", @"Profile", @"Discover", @"More"];
    
    NSMutableArray *navs = [NSMutableArray array];
    
    for (NSString *name in storyboardNames) {
        
        //获取到故事板
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:name bundle:nil];
        
        //加载故事板中的导航控制器--initial Controller
        UINavigationController *nav = [storyBoard instantiateInitialViewController];
        
        [navs addObject:nav];
        
    }
    //将导航控制器交给标签控制器管理
    self.viewControllers = navs;
    
    
}

- (void)_createCustomTabBar {
    
    //移除系统自带的tabBar按钮
    for (UIView *view in self.tabBar.subviews) {
        
        //NSLog(@"%@", view);
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
        
            [view removeFromSuperview];
            
        }
        
    }
    
    CGFloat width = kScreenWidth / 5;
    //添加自定义按钮
    for (NSInteger i = 0; i < 5; i++) {
        
        
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(i * width, 0, width, kTabbarHeight)];
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i;
        
        
        NSString *imageName = [NSString stringWithFormat:@"home_tab_icon_%ld.png", i + 1];
        
        button.normalImgName = imageName;
        
        [self.tabBar addSubview:button];
        
        
    }
    
    //tabBar背景图片
    ThemeImageView *backImageView = [[ThemeImageView alloc] initWithFrame:self.tabBar.bounds];
    backImageView.imgName = @"mask_navbar.png";
    
    [self.tabBar insertSubview:backImageView atIndex:0];
    
    
    
    //选中图片
    _selectImage = [[ThemeImageView alloc] initWithFrame:CGRectMake(0, 0, width, kTabbarHeight)];
    _selectImage.imgName = @"home_bottom_tab_arrow.png";
    
    [self.tabBar addSubview:_selectImage];
    
    
}

- (void)clickButton:(UIButton *)button {
    
    self.selectedIndex = button.tag;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectImage.center = button.center;
        
    }];
    
    
    
    
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

//- (void)viewDidAppear:(BOOL)animated {
//    
//    [super viewDidAppear:animated];
//    
//    for (UIView *view in self.tabBar.subviews) {
//        
//        NSLog(@"%@", view);
//        
//        
//    }
//    
//}


@end

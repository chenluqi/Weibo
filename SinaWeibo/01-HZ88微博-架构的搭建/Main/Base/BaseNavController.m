//
//  BaseNavController.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/9.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "BaseNavController.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

//移除通知，避免内存泄漏
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}

//xib，代码创建controller会调用
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    //alloc init--->initWithNibName:bundle:
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self _observeThemeChangeNotification];
        
    }
    
    return self;
    
}

//storyboard创建controller会调用
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self _observeThemeChangeNotification];
    }
    
    return self;
}

//封装监听通知的方法
- (void)_observeThemeChangeNotification {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeChangeNotification object:nil];
    
    
}

- (void)loadImage {
    
    //加载导航栏背景图片
    UIImage *backImage = [[ThemeManager sharedManager] themeImageWithImageName:@"mask_titlebar64.png"];
    
    [self.navigationBar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    
    
    //更改导航栏标题字体颜色 iOS5.0之后可用
    UIColor *titleColor = [[ThemeManager sharedManager] themeColorWithColorName:@"Mask_Title_color"];
    
    NSDictionary *titleAttributes = @{
                                      NSForegroundColorAttributeName : titleColor
                                      
                                      };
    self.navigationBar.titleTextAttributes = titleAttributes;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //self.navigationBar.translucent = NO;
    
    [self loadImage];
    
    //[self.navigationBar setBackgroundImage:[UIImage imageNamed:@"mask_titlebar64.png"] forBarMetrics:UIBarMetricsDefault];
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

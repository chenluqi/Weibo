//
//  BaseViewController.m
//  88Weibo
//
//  Created by kangkathy on 16/5/12.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "MBProgressHUD.h"

@interface BaseViewController () {
    
    MBProgressHUD *_loadinghud;
}

@end

@implementation BaseViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:kThemeChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self themeChange];
}

- (void)themeChange{
    
    //先根据图片名加载UIImage
    //再把Image转成颜色
    self.view.backgroundColor = [UIColor colorWithPatternImage:[[ThemeManager sharedManager] themeImageWithImageName:@"bg_home.jpg"]];
}

//显示提示视图
- (void)showHUDCompleteView:(NSString *)text {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    [hud hide:YES afterDelay:2];
    
}

- (void)showHUDLoadingView {
    
    _loadinghud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
   _loadinghud.dimBackground = YES;
    
}

- (void)hideHUDLoadingView {
    
    [_loadinghud hide:YES];
    
}

@end

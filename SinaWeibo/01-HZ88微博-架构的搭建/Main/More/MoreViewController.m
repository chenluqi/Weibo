//
//  MoreViewController.m
//  88Weibo
//
//  Created by kangkathy on 16/4/26.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeLabel.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"更多";
    
    
    //设置根据主题切换的图片和Lable显示。
    //主题选择
    _selectedImgView.imgName = @"more_icon_theme";
    _selectedLabel.colorName = @"More_Item_Text_color";
    _themeNameLabel.colorName = @"More_Item_Text_color";
    //显示当前的主题名字
    _themeNameLabel.text = [ThemeManager sharedManager].themeName;
    
    //帐户管理
    _manageImgView.imgName = @"more_icon_account";
    _manageLabel.colorName = @"More_Item_Text_color";
    
    //用户反馈
    _feedBackImgView.imgName = @"more_icon_feedback";
    _feedBackLabel.colorName = @"More_Item_Text_color";
    
    //清空缓存
    _clearCacheImgView.imgName = @"more_icon_draft";
    _clearCacheLabel.colorName = @"More_Item_Text_color";
    //显示缓存大小
    _cacheCapacityLabel.colorName = @"More_Item_Text_color";
    
    //注销当前帐户
    _logoutLabel.colorName = @"More_Item_Text_color";
    
    
    [self themeChange];
    
}

//在initWithCoder方法中监听通知
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:kThemeChangeNotification  object:nil];
    }
    
    return self;
}

//主题改变后会调用的方法
- (void)themeChange{
    
    //表视图的背景颜色与分割线的颜色
    UIColor *backColor = [[ThemeManager sharedManager] themeColorWithColorName:@"More_Item_color"];
    self.tableView.backgroundColor = backColor;
    
    UIColor *lineColor = [[ThemeManager sharedManager] themeColorWithColorName:@"More_Item_Line_color"];
    self.tableView.separatorColor= lineColor;
    
    //切换主题后更多页面的第一个单元格显示的主题名要随之改变
    _themeNameLabel.text = [ThemeManager sharedManager].themeName;
    
}

//dealloc方法中移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
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

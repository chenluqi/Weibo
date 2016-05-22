//
//  ThemeTableViewController.m
//  88Weibo
//
//  Created by kangkathy on 16/5/3.
//  Copyright © 2016年 kangkathy. All rights reserved.
//



#import "ThemeTableViewController.h"
#import "ThemeManager.h"
#import "ThemeCell.h"

@interface ThemeTableViewController ()

//定义一个字典属性用来接收主题配置文件
@property(nonatomic, strong)NSDictionary *themeConfig;

@end

@implementation ThemeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取到主题配置信息
    _themeConfig = [ThemeManager sharedManager].themeConfig;
    
    [self themeChange];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:kThemeChangeNotification object:nil];
    }
    
    return self;
}

- (void)themeChange{
    
    //表视图的背景颜色与分割线的颜色随主题而改变
    UIColor *backColor = [[ThemeManager sharedManager] themeColorWithColorName:@"More_Item_color"];
    self.tableView.backgroundColor = backColor;
    UIColor *lineColor = [[ThemeManager sharedManager] themeColorWithColorName:@"More_Item_Line_color"];
    self.tableView.separatorColor= lineColor;
    
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //返回主题个数
    return _themeConfig.count;
}

//设置单元格显示内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell" forIndexPath:indexPath];
    
    //获取所有的主题名
    NSArray *keys = [_themeConfig allKeys];
    NSString *themeName = keys[indexPath.row];
    cell.themeLabel.text = themeName;
    
    //单元格上图片的显示
    NSString *themePath = [ThemeManager sharedManager].themeConfig[themeName];
    NSString *imgPath = [[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:themePath] stringByAppendingPathComponent:@"more_icon_theme.png"];
    cell.themeImageView.image = [UIImage imageWithContentsOfFile:imgPath];
    
    //选中时显示对勾
    if([[ThemeManager sharedManager].themeName isEqualToString:themeName]){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;

}


//单元格被点击时主题进行切换
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *keys = [_themeConfig allKeys];
    
    //切换主题
    [ThemeManager sharedManager].themeName = keys[indexPath.row];
    
    //刷新tableView
    [tableView reloadData];

}

@end

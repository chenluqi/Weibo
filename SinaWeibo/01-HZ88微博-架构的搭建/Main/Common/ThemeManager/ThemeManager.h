//
//  ThemeManager.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/10.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//主题切换通知名
#define kThemeChangeNotification @"kThemeChangeNotification"

//plist中保存主题名
#define kThemeName @"kThemeName"

@interface ThemeManager : NSObject


+ (instancetype)sharedManager;

//当前主题名
@property (copy, nonatomic) NSString *themeName;

//主题配置信息--Theme.plist文件保存主题名和主题路径的联系
@property (strong, nonatomic) NSDictionary *themeConfig;

//颜色配置信息，每个主题都有一套
@property (strong, nonatomic) NSDictionary *ColorConfig;



//根据图片名找到对应主题路径，加载图片
- (UIImage *)themeImageWithImageName:(NSString *)imageName;


//根据颜色名找到对应主题下config.plist文件中存储的此颜色名对应的颜色值
- (UIColor *)themeColorWithColorName:(NSString *)colorName;


@end

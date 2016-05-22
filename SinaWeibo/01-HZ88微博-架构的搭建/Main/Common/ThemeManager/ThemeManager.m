//
//  ThemeManager.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/10.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager


+ (instancetype)sharedManager {
    static ThemeManager *instance = nil;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        instance = [[[self class] alloc] init];
        
    });
    
    return instance;
    
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        //设置默认主题名
        _themeName = @"猫爷";
        
        //读取持久化文件中存储的主题名
        NSString *savedThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
        if (savedThemeName.length > 0) {
            _themeName = savedThemeName;
        }
        
        
        //读取主题配置信息
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Theme.plist" ofType:nil]];
        
        [self _loadColorConfigFile];
        
    }
    
    return self;
}

//加载config.plist文件
- (void)_loadColorConfigFile {
    
    NSString *themePath = [self themePath];
    NSString *configFilePath = [themePath stringByAppendingPathComponent:@"config.plist"];
    
    
    _ColorConfig = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    
}


- (UIImage *)themeImageWithImageName:(NSString *)imageName {
    
    
    //1.获取到当前主题包的路径 cat-->Skins/cat
    NSString *themePath = [self themePath];
    
    //2.拼接当前主题包中此图片的路径
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    
    //3.加载图片
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;

}

- (UIColor *)themeColorWithColorName:(NSString *)colorName {
    
    
    NSDictionary *rgbDic = _ColorConfig[colorName];
    
    //获取r,g,b和alpha
    CGFloat r = [rgbDic[@"R"] floatValue];
    CGFloat g = [rgbDic[@"G"] floatValue];
    CGFloat b = [rgbDic[@"B"] floatValue];
    
    CGFloat alpha = rgbDic[@"alpha"] ? [rgbDic[@"alpha"] floatValue] : 1;
    
    //NSLog(@"r:%f, g:%f, b:%f", r, g,b);
    
    return [UIColor colorWithRed: r/255 green:g/255 blue:b/255 alpha:alpha];

    
}

//获取到当前主题包的路径
- (NSString *)themePath {
    
    //1.根据主题名在字典中找到当前主题对应的路径
    NSString *path = self.themeConfig[_themeName];
    
    //2.程序包的根目录
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    //3.拼接主题包的完整路径
    NSString *themePath = [bundlePath stringByAppendingPathComponent:path];
    
    
    return themePath;
    
}

//重写Set方法，当主题名改变时发送通知
- (void)setThemeName:(NSString *)themeName {
    
    
    if (_themeName != themeName) {
        _themeName = [themeName copy];
        
        
        [self _loadColorConfigFile];
        
        //向持久化文件中写入设置的主题名
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangeNotification object:nil];
        
    }
    
}



@end

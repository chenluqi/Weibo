//
//  ThemeLabel.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/10.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"

@implementation ThemeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//代码创建ThemeImageView:重写init方法监听通知
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:kThemeChangeNotification object:nil];
    }
    return self;
}

//storyboard，xib创建ThemeImageView:监听通知
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:kThemeChangeNotification object:nil];
}

- (void)setColorName:(NSString *)colorName {
    
    if (_colorName != colorName) {
        _colorName = [colorName copy];
        
        [self loadColor];
    }
}


- (void)loadColor {
    
    //通过主题管家获取当前主题下颜色名对应的color
    UIColor *fontColor = [[ThemeManager sharedManager] themeColorWithColorName:_colorName];
    
    //设置Label的字体颜色
    self.textColor = fontColor;
}


- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}


@end

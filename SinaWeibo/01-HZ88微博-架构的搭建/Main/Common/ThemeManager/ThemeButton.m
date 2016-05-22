//
//  ThemeButton.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/10.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//移除通知，避免内存泄漏
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}

//代码创建ThemeButton会调用此方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //监听通知
        [self _observeThemeChangeNotification];
        
    }
    
    return self;
}

//xib或者storyboard创建ThemeButton会调用此方法
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    //监听通知
    [self _observeThemeChangeNotification];
}

//封装监听通知的方法
- (void)_observeThemeChangeNotification {
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction:) name:kThemeChangeNotification object:nil];
    
    
}

//接收到通知后响应的事件方法
- (void)themeChangeAction:(NSNotification *)notification {
    
    [self loadImage];
    
}

- (void)setNormalImgName:(NSString *)normalImgName {
    
    if (_normalImgName != normalImgName) {
        _normalImgName = [normalImgName copy];
        
        [self loadImage];
    }
    
}

- (void)setHighlightImgName:(NSString *)highlightImgName {
    
    if (_highlightImgName != highlightImgName) {
        _highlightImgName = [highlightImgName copy];
        
        [self loadImage];
    }
}

//重新加载图片:主题切换时要调用；图片名发生改变时要调用
- (void)loadImage {
    
    ThemeManager *manager = [ThemeManager sharedManager];
    
    //调用ThemeManager类的方法加载图片
    UIImage *normalImg = [manager themeImageWithImageName:self.normalImgName];
    
    UIImage *hilightImg = [manager themeImageWithImageName:self.highlightImgName];
    
    //给button设置新的图片
    [self setImage:normalImg forState:UIControlStateNormal];
    
    [self setImage:hilightImg forState:UIControlStateHighlighted];
}












@end

//
//  ThemeImageView.m
//  88Weibo
//
//  Created by kangkathy on 16/4/28.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"


@implementation ThemeImageView


//代码创建ThemeImageView:重写init方法监听通知
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeChangeNotification object:nil];
    }
    return self;
}

//storyboard，xib创建ThemeImageView:监听通知
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImage) name:kThemeChangeNotification object:nil];
}

//图片名发生改变时重新加载图片
- (void)setImgName:(NSString *)imgName {
    
    if (_imgName != imgName) {
        _imgName = [imgName copy];
        
        [self loadImage];
    }
    
}

//加载图片
- (void)loadImage {
    
    //通过主题管家获取当前图片
    UIImage *image = [[ThemeManager sharedManager] themeImageWithImageName:_imgName];
    
    //图片的拉伸
    image = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapWidth];
    
    //加载当前主题下的图片
    self.image = image;
}


- (void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeChangeNotification object:nil];
}



@end

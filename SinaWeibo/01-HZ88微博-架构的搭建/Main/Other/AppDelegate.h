//
//  AppDelegate.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/9.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SinaWeibo *sinaweibo;


@end


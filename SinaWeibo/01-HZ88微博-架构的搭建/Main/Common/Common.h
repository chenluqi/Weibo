//
//  Common.h
//  Weibo
//
//  Created by Kathy on 15-7-13.
//  Copyright (c) 2014年 www.huiwen.com 汇文教育无线学院. All rights reserved.
//

#ifndef HW_Common_h
#define HW_Common_h

//屏幕的宽、高
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabbarHeight 49


//新浪微博的key
#define kAppKey             @"559736808"
#define kAppSecret          @"3f0d32229862b61d0183c26de6615e5e"
#define kAppRedirectURI     @"http://weibo.com/5647272430/profile?topnav=1&wvr=6&is_all=1"


#define kiOS8Later ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#endif

//
//  ThemeButton.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/10.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//增加两个属性
@property(copy, nonatomic)NSString *normalImgName;

@property(copy, nonatomic)NSString *highlightImgName;



@end

//
//  MoreViewController.h
//  88Weibo
//
//  Created by kangkathy on 16/4/26.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeImageView;
@class ThemeLabel;

@interface MoreViewController : UITableViewController
@property (weak, nonatomic) IBOutlet ThemeImageView *selectedImgView;
@property (weak, nonatomic) IBOutlet ThemeLabel *selectedLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet ThemeImageView *manageImgView;
@property (weak, nonatomic) IBOutlet ThemeLabel *manageLabel;
@property (weak, nonatomic) IBOutlet ThemeImageView *feedBackImgView;

@property (weak, nonatomic) IBOutlet ThemeLabel *feedBackLabel;
@property (weak, nonatomic) IBOutlet ThemeImageView *clearCacheImgView;
@property (weak, nonatomic) IBOutlet ThemeLabel *clearCacheLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *cacheCapacityLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *logoutLabel;

@end

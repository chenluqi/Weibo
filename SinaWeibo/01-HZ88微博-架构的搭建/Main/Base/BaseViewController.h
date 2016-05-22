//
//  BaseViewController.h
//  88Weibo
//
//  Created by kangkathy on 16/5/12.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showHUDCompleteView:(NSString *)text;

- (void)showHUDLoadingView;

- (void)hideHUDLoadingView;

@end

//
//  HomeViewController.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/9.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboTableView.h"
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet WeiboTableView *weiboTableView;

@end

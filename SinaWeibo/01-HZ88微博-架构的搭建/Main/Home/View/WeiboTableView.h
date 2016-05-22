//
//  WeiboTableView.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

//数据源
@property(nonatomic, strong)NSMutableArray *weiboList;

@end

//
//  LocationTableViewController.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/17.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SelectedLocationBlock) (NSString *);

@interface LocationTableViewController : UITableViewController

@property(nonatomic, copy)SelectedLocationBlock locationBlock;


@end

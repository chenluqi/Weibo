//
//  ThemeCell.h
//  88Weibo
//
//  Created by kangkathy on 16/5/3.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeLabel.h"

@interface ThemeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *themeImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *themeLabel;

@end

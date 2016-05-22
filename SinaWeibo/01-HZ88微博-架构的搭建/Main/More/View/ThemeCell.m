//
//  ThemeCell.m
//  88Weibo
//
//  Created by kangkathy on 16/5/3.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "ThemeCell.h"


@implementation ThemeCell

- (void)awakeFromNib {
    
    //设置加载单元格时改变label的颜色
    self.themeLabel.colorName = @"More_Item_Text_color";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

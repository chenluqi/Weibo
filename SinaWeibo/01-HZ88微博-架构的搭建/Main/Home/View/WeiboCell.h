//
//  WeiboCell.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeLabel.h"
#import "WeiboCellLayout.h"
#import "ThemeImageView.h"

@class WXLabel;


@interface WeiboCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet ThemeLabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *publicTimeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel;

@property (nonatomic, strong)WXLabel *weiboTextLabel; //微博正文Label
@property (nonatomic, strong)UIImageView *weiboImgView; //微博配图（原微博或者转发微博配图）

@property (nonatomic, strong)NSMutableArray *weiboImgViewArr; //多图UIImageView数组

//转发微博相关的属性
@property (nonatomic, strong)WXLabel *reWeiboTextLabel; //转发微博的正文
@property (nonatomic, strong)ThemeImageView *reWeiboBgImgView; //转发微博背景视图





//一个单元格要绑定一个WeiboCellLayout
@property(nonatomic, strong)WeiboCellLayout *weiboLayout;

@end

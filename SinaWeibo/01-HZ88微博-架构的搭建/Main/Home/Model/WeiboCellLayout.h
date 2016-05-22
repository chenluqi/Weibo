//
//  WeiboCellLayout.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeiboModel.h"


#define kCellOriginHeight 60
#define kSpace 10
#define kImageGap 5
#define kImagesCountPerLine 3
#define kImagesCount 9

@interface WeiboCellLayout : NSObject


@property(strong, nonatomic)WeiboModel *weibo; //每个单元格都需要一个布局对象，每个布局对象需要绑定一条微博，对微博所包含的内容进行布局


@property (assign, nonatomic)CGRect weiboTextFrame; //微博正文Label的frame

@property(assign, nonatomic)CGRect weiboImgFrame; //微博配图的frame


@property(assign, nonatomic)CGRect reWeiboTextFrame; //转发微博正文的frame

@property(assign, nonatomic)CGRect reWeiboBgImgFrame; //转发微博背景的frame

@property(strong, nonatomic)NSMutableArray *weiboImgFrameArray; //存储9张图片的frame


@property(assign, nonatomic)CGFloat cellHeight; //单元格的高度






@end

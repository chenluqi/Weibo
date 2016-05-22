//
//  WeiboModel.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"


@interface WeiboModel : NSObject

@property(nonatomic,copy)NSString *created_at;       //微博创建时间
@property(nonatomic,copy)NSString  *idstr;           //微博ID
@property(nonatomic,copy)NSString  *text;              //微博的内容
@property(nonatomic,copy)NSString  *source;              //微博来源
@property(nonatomic,retain)NSNumber     *favorited;         //是否已收藏
@property(nonatomic,copy)NSString       *thumbnail_pic;     //缩略图片地址
@property(nonatomic,copy)NSString       *bmiddle_pic;     //中等尺寸图片地址
@property(nonatomic,copy)NSString       *original_pic;     //原始图片地址
@property(nonatomic,retain)NSDictionary *geo;               //地理信息字段
@property(nonatomic,retain)NSNumber     *reposts_count;      //转发数
@property(nonatomic,retain)NSNumber     *comments_count;      //评论数
@property(nonatomic,retain)NSArray *pic_urls; //表示多张图片信息


@property(nonatomic, strong)UserModel *user; //用户

@property(nonatomic, strong)WeiboModel *retweeted_status; //转发的微博

@end

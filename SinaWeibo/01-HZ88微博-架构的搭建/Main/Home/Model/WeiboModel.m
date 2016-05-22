//
//  WeiboModel.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"

@implementation WeiboModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    //把[哈哈]--》<image url = '010.png'>
    
    //self.text = @"WXHL";
    
    NSString *regex = @"\\[\\w+\\]";
    
    //查找到所有的表情名子字符串
    //@[[哈哈]，[兔子]，[大笑]];
    NSArray *faceArray = [self.text componentsMatchedByRegex:regex];
    
    //读取表情plist文件
    NSArray *facePlistArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emoticons.plist" ofType:nil]];
    
    //人数组   age    age < 30
    //表情信息数组  表情名  chs = '表情名'
    for (NSString *faceString in faceArray) {
        
        
        NSString *condition = [NSString stringWithFormat:@"chs = '%@'", faceString];
        
        NSArray *result = [facePlistArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:condition]];
        
        NSDictionary *faceDic = [result firstObject];
        
        //获取图片名
        NSString *imageName = faceDic[@"png"];
        
        //构造出<image url = '图片名'>
        NSString *imageURL = [NSString stringWithFormat:@"<image url = '%@'>", imageName];
        
        self.text = [self.text stringByReplacingOccurrencesOfString:faceString withString:imageURL];
        
    }
    
    return YES;
}

@end

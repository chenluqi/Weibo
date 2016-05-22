//
//  UserModel.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    
    return @{@"desc" : @"description"
             };
    
}

@end

//
//  DataService.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/18.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlock)(NSURLSessionDataTask *task, id result);
typedef void(^FailureBlock) (NSError *error);

@interface DataService : NSObject



+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url params:(NSDictionary *)params fileData:(NSDictionary *)fileDic httpMethod:(NSString *)httpMethod success:(SuccessBlock)successBlock failure:(FailureBlock)failBlock;



@end

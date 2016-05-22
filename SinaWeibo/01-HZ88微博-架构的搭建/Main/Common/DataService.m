//
//  DataService.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/18.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "DataService.h"
#import "AppDelegate.h"
#import "AFNetworking.h"


#define BaseURL @"https://api.weibo.com/2/"

@implementation DataService

//get GET
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url params:(NSDictionary *)params fileData:(NSDictionary *)fileDic httpMethod:(NSString *)httpMethod success:(SuccessBlock)successBlock failure:(FailureBlock)failBlock {
    
    
    //1.拼接URL
    url = [NSString stringWithFormat:@"%@%@", BaseURL, url];
    
    //2.设置完整的参数，自动加上token
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [mDic setObject:appDelegate.sinaweibo.accessToken forKey:@"access_token"];
    
    //3.对AFnetworking的二次封装
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //4.判断请求方式
    if ([httpMethod caseInsensitiveCompare:@"GET"] == NSOrderedSame) {
        
        //(1)在哪里发生事件，定义block属性，当事件发生时回调block
        //(2)在哪里响应事件，就在哪里定义一个block具体的内容，表示当事件发生时对此事件做出的响应。
        
        
        return [manager GET:url parameters:mDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            //网络请求成功我要做出的响应
            successBlock(task, responseObject);
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //网络请求失败我要做出的响应
            failBlock(error);
            
        }];
        
    } else if ([httpMethod caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        
        
        if (fileDic) { //@"pic" : NSData
           return [manager POST:url parameters:mDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
               
               //向formData上拼接上传的文本数据
               for (NSString *key in fileDic) {
                   [formData appendPartWithFileData:fileDic[key] name:key fileName:key mimeType:@"image/jpeg"];
               }
            
               
           } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
               successBlock(task, responseObject);
           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               failBlock(error);
           }];
            
            
        } else {
        
            return [manager POST:url parameters:mDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                successBlock(task, responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failBlock(error);
            }];
            
        }
        
        
        
    }
    
    return nil;
    

}

@end

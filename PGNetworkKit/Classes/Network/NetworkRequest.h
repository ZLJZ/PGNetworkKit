//
//  NetworkRequest.h
//  PanGu
//
//  Created by 吴肖利 on 16/7/3.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successRequestBlock)(id responseObject);
typedef void(^failureRequestBlock)(NSError *error);

@interface NetworkRequest : NSObject

// 行情 Get
+ (NSURLSessionDataTask *)getMarketRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;

//Get
+ (NSURLSessionDataTask *)getRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;
//POST
+ (NSURLSessionDataTask *)postRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;
// POST 加密
+ (NSURLSessionDataTask *)postRequestUrlString:(NSString *)url params:(NSDictionary *)params interfaceID:(NSString *)interfaceID token:(NSString *)token encryption:(BOOL)isEncryption success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;

//by------cwp
+ (NSURLSessionDataTask *)postHeadersRequestUrlString:(NSString *)url params:(NSDictionary *)params andHeaders:(NSDictionary *)headers success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;
//交易POST
+ (NSURLSessionDataTask *)postRequestUrlString:(NSString *)url params:(NSDictionary *)params interfaceID:(NSString *)interfaceID token:(NSString *)token success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;

//GzipPOST
+ (NSURLSessionDataTask *)postGzipRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;

@end

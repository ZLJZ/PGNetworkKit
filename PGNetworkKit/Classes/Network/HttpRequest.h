//
//  HttpRequest.h
//  NetWorking
//  网络请求封装
//  Created by 王玉 on 16/4/19.
//  Copyright © 2016年 王玉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reachability/Reachability.h>

#define K_VERSION_SHORT  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

@class AFHTTPSessionManager;

#define NetworkErrorCode 0x0000024B6

typedef enum : NSInteger {
    OrbYunHttp,//进行AFHttpRequestSerializer
    OrbYunJSON,
    OrbYunHttpJSON,
    OrbYunJSONHttp,
} OrbYuntSerializerType;

@class ORBNet;

@interface HttpRequest : NSObject
{
    @public
    AFHTTPSessionManager *_manager;
}

/*
 *  是否不检查网络(调取静态接口, 百度, 淘宝)
 */
@property (nonatomic, assign) BOOL isCheckNetwork;

//获取网络请求对象
+ (instancetype)getInstance;


/**
 当前网络状态
 */
@property (nonatomic, assign) NetworkStatus netStatus;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 
 */
- (NSURLSessionDataTask *)getWithURLString:(NSString *)URLString
                               headers:(NSDictionary *)headers
                            orbYunType:(OrbYuntSerializerType)type
                            parameters:(id)parameters
                               success:(void (^)(id responseObject,NSURLSessionDataTask * task)) success
                               failure:(void (^)(NSError *error,NSURLSessionDataTask *task))failure;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionDataTask *)postWithURLString:(NSString *)URLString
                                headers:(NSDictionary *)headers
                             orbYunType:(OrbYuntSerializerType)type
                             parameters:(id)parameters
                                success:(void (^)(id responseObject,NSURLSessionDataTask * task))success
                                failure:(void (^)(NSError *error, NSURLSessionDataTask *task))failure;


/**
 *  上传文件
 *
 *  @param URLString   上传文件的网址字符串
 *  @param headers     设置请求头
 *  @param type        设置请求类型Http or JSON
 *  @param parameters  上传文件的参数
 *  @param uploadParam 上传文件的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionDataTask *)uploadWithURLString:(NSString *)URLString
                                  headers:(NSDictionary *)headers
                               orbYunType:(OrbYuntSerializerType)type
                               parameters:(id)parameters
                            blockprogress:(void (^)(NSProgress *uploadProgress))prograss
                              filePathUrl:(NSString *)pathUrl
                                  success:(void (^)(id responseObject,NSURLSessionDataTask * task))success
                                  failure:(void (^)(NSError *error, NSURLSessionDataTask *task))failure;
/**
 *  下载文件
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionDataTask *)downLoadWithURLString:(NSString *)URLString
                                    headers:(NSDictionary *)headers
                                 orbYunType:(OrbYuntSerializerType)type
                                 parameters:(id)parameters
                              blockprogress:(void (^)(NSProgress *))prograss
                                    success:(void (^)(id responseObject,NSURLSessionDataTask *task))success
                                    failure:(void (^)(NSError *error, NSURLSessionDataTask *task))failure;

/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 
 */
- (NSURLSessionDataTask *)getNewWithURLString:(NSString *)URLString
                                  headers:(NSDictionary *)headers
                               orbYunType:(OrbYuntSerializerType)type
                               parameters:(id)parameters
                                  success:(void (^)(id, NSURLSessionDataTask *))success
                                  failure:(void (^)(NSError *error, NSURLSessionDataTask *task))failure;

/**
 *  发送post请求 含上传进度的
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */

- (NSURLSessionDataTask *)postProgressWithURLString:(NSString *)URLString
                                        headers:(NSDictionary *)headers
                                     orbYunType:(OrbYuntSerializerType)type
                                     parameters:(id)parameters
                                       progress:(void (^)(float pro))progress
                                        success:(void (^)(id responseObject, NSURLSessionDataTask *task))success
                                        failure:(void (^)(NSError *error, NSURLSessionDataTask *task))failure;


/**
 *  发送GzipPost请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionDataTask *)postGzipWithURLString:(NSString *)URLString
                                headers:(NSDictionary *)headers
                             orbYunType:(OrbYuntSerializerType)type
                             parameters:(id)parameters
                                success:(void (^)(id responseObject,NSURLSessionDataTask * task))success
                                failure:(void (^)(NSError *error,NSURLSessionDataTask *task))failure;

/**
 检查网络(调取静态接口, 百度, 淘宝)

 @param task 当前会话
 @param error 当前错误
 @param isCheck 是否不自查(NO 为自查)
 @param errorBlock 自查结果回调
 */
- (void)checkNetworkTask:(NSURLSessionDataTask *)task
                   error:(NSError *)error
                 isCheck:(BOOL)isCheck
              errorBlock:(void(^)(NSError *))errorBlock;

/**
 *  取消网络请求
 */
- (void)cancel;

@end

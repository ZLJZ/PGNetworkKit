//
//  HttpRequest.m
//  NetWorking
//  网络请求代理
//  Created by 王玉 on 16/4/19.
//  Copyright © 2016年 王玉. All rights reserved.
//

#import "HttpRequest.h"
#import "NetworkTool.h"
#import "AFNetworking.h"

#define REQUEST_TIMEOUT             @"requestTimeout"
#define REQUEST_TIMEOUT_INTERVAL    [[[NSUserDefaults standardUserDefaults] objectForKey:REQUEST_TIMEOUT] doubleValue]

NSString *const PanGuHttpErrorDomain = @"PanGuHttpErrorDomain";

@interface HttpRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, assign) BOOL isShow;// 无网络弹框是否已经显示, 如果显示就不再弹出

@property (nonatomic, assign) BOOL isShowChangeSite;// 是否已经弹出切换站点页面

@property (nonatomic, assign) BOOL isChecking;// 是否正在检查网络中, 如正在检查网络, 则不重复检查

@property (nonatomic, assign) BOOL isSuccessful;// 网络请求是否成功过

@property (nonatomic, assign) BOOL isCancel;//是否已取消网络请求

@end

@implementation HttpRequest

//创建单利
+ (instancetype)getInstance {
    
    static HttpRequest *managerRe;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        managerRe = [self new];
        
        managerRe.manager = [AFHTTPSessionManager manager];
        
        // 网络请求参数设置
        managerRe.manager.securityPolicy.allowInvalidCertificates = YES;
        // 判断requestSerializer, responseSerializer 请求和反馈类型
        
        managerRe.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        managerRe.manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain" ,@"application/octet-stream",@"multipart/form-data",@"application/x-www-form-urlencoded",@"text/json",@"text/xml",@"image/*"]];
        
        managerRe.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [managerRe.manager.requestSerializer setValue:K_VERSION_SHORT forHTTPHeaderField:@"VersionNum"];
        [managerRe.manager.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"AppType"];
        managerRe.manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
//        managerRe.manager.requestSerializer.timeoutInterval = PUBLIC_REQUEST_TIMEOUT;
        
        managerRe.manager.securityPolicy.allowInvalidCertificates = YES;
        managerRe.manager.securityPolicy.validatesDomainName = NO;
        
        managerRe.manager.operationQueue.maxConcurrentOperationCount = 5;
        
        //监控网络状态
        [managerRe netWorkChange];
    });
    
    return managerRe;

}

- (void)netWorkChange {
    Reachability *internetReachability = [Reachability reachabilityForInternetConnection];
    [internetReachability startNotifier];
    self.netStatus = [internetReachability currentReachabilityStatus];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkDidChange:) name:kReachabilityChangedNotification object:nil];
}

- (void)netWorkDidChange:(NSNotification *)notice {
    self.netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
}

- (void)dealloc {
    [[Reachability reachabilityForInternetConnection] stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark -- GET请求 --
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
                               success:(void (^)(id, NSURLSessionDataTask *))success
                               failure:(void (^)(NSError *, NSURLSessionDataTask *))failure{
    
    NSURLSessionDataTask *sessionTask;
    @try {
        _isCancel = NO;
        _manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
        BOOL isCheck = _isCheckNetwork;
        
        // 如果网络不可达 (回调错误 Blcok, 业务页面根据这个 error.code 去判断, 这时无 task)
        if ([NetworkTool internetReachability] == 1) {
            
            // 弹出无网络警示框
//            [self showNoNetworkWarning:isCheck];
            
            NSError *error = [self getNetworkUnreachableError];
            
            NSURLSessionDataTask *task = [[NSURLSessionDataTask alloc] init];
            
            !failure ? : failure(error, task);
            return task;
        }
        _isCheckNetwork = NO;
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //发送Get请求
        sessionTask = [_manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            
            _isSuccessful = YES;
            
            if (success) {
                !success ? : success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败,返回错误信息
            if (error.code != NSURLErrorCancelled) {
                if (error.code != NSURLErrorCancelled) {
                    if ([NetworkTool internetReachability] == 1) {
                        !failure ? : failure([self getNetworkUnreachableError],task);
                    } else {
                        !failure ? : failure(error,task);
                    }
                }
            }
        }];

    } @catch (NSException *exception) {
        
        
    } @finally {
        return sessionTask;
    }
}

#pragma mark -- POST请求 --
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
                                success:(void (^)(id, NSURLSessionDataTask *))success
                                failure:(void (^)(NSError *, NSURLSessionDataTask *))failure {
    NSURLSessionDataTask *sessionTask;
    @try{
        _isCancel = NO;
        _manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_INTERVAL;
        BOOL isCheck = _isCheckNetwork;
        
        // 如果网络不可达 (回调错误 Blcok, 业务页面根据这个 error.code 去判断, 这时无 task)
        if ([NetworkTool internetReachability] == 1) {
            
            // 弹出无网络警示框
//            [self showNoNetworkWarning:isCheck];
            
            NSError *error = [self getNetworkUnreachableError];
            
            NSURLSessionDataTask *task = [[NSURLSessionDataTask alloc] init];
            
            !failure ? : failure(error, task);
            return task;
        }
        _isCheckNetwork = NO;
        
        //设置请求头
        for (NSString * key in headers) {
            [_manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //发送Post请求
        sessionTask = [_manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _isSuccessful = YES;

            //请求成功,返回数据
            if (success) {
                success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code != NSURLErrorCancelled) {
                if (error.code != NSURLErrorCancelled) {
                    if ([NetworkTool internetReachability] == 1) {
                        !failure ? : failure([self getNetworkUnreachableError],task);
                    } else {
                        !failure ? : failure(error,task);
                    }
                }
            }
            
        }];
    }@catch(NSException *exception){
    }
    @finally{
        return sessionTask;
    }
    
    
}

//取消请求
- (void)cancel {
    _isCancel = YES;
    NSLog(@"manager.operationQueue.operationCount == %zd", [HttpRequest getInstance].manager.operationQueue.operationCount);
    NSArray *arr = [[HttpRequest getInstance].manager dataTasks];
    [arr enumerateObjectsUsingBlock:^(NSURLSessionDataTask * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}

// 获取无网络的 Error
- (NSError *)getNetworkUnreachableError {
    
    NSInteger errorCode = NetworkErrorCode;
    
    NSError *error = [[NSError alloc] initWithDomain:PanGuHttpErrorDomain code:errorCode userInfo:nil];
    
    return error;
}

@end

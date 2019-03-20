//
//  NetworkTool.m
//  OrbyunInfo
//
//  Created by 吴肖利 on 2019/3/20.
//  Copyright © 2019 com. All rights reserved.
//

#import "NetworkTool.h"
#import "HttpRequest.h"
#import "Reachability.h"

@implementation NetworkTool

//判断网络状态
+(NSInteger)internetReachability{
    NSInteger num = 0;
    //判断网络状态
    //    Reachability *internetReachability=[Reachability reachabilityForInternetConnection];
    //    [internetReachability startNotifier];
    NetworkStatus netStatus = [HttpRequest getInstance].netStatus;
    
    switch (netStatus) {
        case NotReachable:
            num=1;
            break;
        case ReachableViaWiFi:
            num=2;
            break;
        case ReachableViaWWAN:
            num=3;
            break;
    }
    return num;
}


@end

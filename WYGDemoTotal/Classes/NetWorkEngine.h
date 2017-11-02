//
//  NetWorkEngine.h
//  shenlun
//
//  Created by Agoni on 16/7/22.
//  Copyright © 2016年 Agon Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkEngine : NSObject

+ (NetWorkEngine *)getInstance;

/**
 *  异步请求post接口
 *
 *  @param urlString       接口地址
 *  @param params          请求参数
 *  @param requestCallback 请求回调
 */
- (void)asyRequestByPost:(NSString *)urlString params:(NSDictionary*)params callback:(void(^)(id responseObject, NSError *error))requestCallback;
/**
 *  异步请求get接口
 *
 *  @param urlString       接口地址
 *  @param params          请求参数
 *  @param requestCallback 请求回调
 */

- (void)asyRequestByGet:(NSString *)urlString params:(NSDictionary *)params callback:(void(^)(id responseObject, NSError *error))requestCallback;

/**
 *  异步已登录请求get接口
 *
 *  @param urlString       接口地址
 *  @param params          请求参数
 *  @param requestCallback 请求回调
 */
- (void)asyRequestByGetWithToken:(NSString *)urlString params:(NSDictionary *)params callback:(void (^)(id responseObject, NSError *error))requestCallback;

/**
 *  异步已登录请求post接口
 *
 *  @param urlString       接口地址
 *  @param params          请求参数
 *  @param requestCallback 请求回调
 */
- (void)asyRequestByPostWithToken:(NSString *)urlString params:(NSDictionary*)params callback:(void(^)(id responseObject, NSError *error))requestCallback;
/**
 *  上传图片
 *
 *  @param        接口地址
 *  @param params          请求参数
 *  @param requestCallback 请求回调
 */

- (void)upLoadMethod:(NSString *)url Image:(NSArray *)imageArr params:(NSDictionary *)params
            callback:(void(^)(BOOL isOk,id responceObject,NSError *error))requestCallback;

@end

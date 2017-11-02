//
//  NetWorkEngine.m
//  shenlun
//
//  Created by Agoni on 16/7/22.
//  Copyright © 2016年 Agon Wu. All rights reserved.
//

#import "NetWorkEngine.h"
#import "AFNetworking.h"

#define LocalStr_None           @""
#define baseUrl @"https://interface.meiriyiwen.com"
#define     screenW       [UIScreen mainScreen].bounds.size.width
#define     screenH      [UIScreen mainScreen].bounds.size.height

static AFHTTPSessionManager *manager;


@interface NetWorkEngine()

//@property (nonatomic,strong) AFHTTPSessionManager *AFmanager;

@end

@implementation NetWorkEngine

+ (NetWorkEngine *)getInstance {
    __strong static NetWorkEngine *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[NetWorkEngine alloc] init];
        manager = [AFHTTPSessionManager manager];
        //请求头设置
        //        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        manager.requestSerializer.timeoutInterval = 10.0f;
        //response设置
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript", @"text/plain", nil];
    });
    return shareInstance;
}

- (void)asyRequestByPost:(NSString *)urlString params:(NSDictionary *)params callback:(void (^)(id, NSError *))requestCallback {
    NSString *url = [self appendingUrl:urlString];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        requestCallback([self dictionaryToJson:responseObject],nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestCallback(nil,error);
        NSLog(@"%@",error);
    }];
}

- (void)asyRequestByGet:(NSString *)urlString params:(NSDictionary *)params callback:(void (^)(id, NSError *))requestCallback {
    NSString *url = [self appendingUrl:urlString];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
   requestCallback([self dictionaryToJson:responseObject],nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestCallback(nil,error);
        NSLog(@"%@",error);
    }];
}

- (void)asyRequestByGetWithToken:(NSString *)urlString params:(NSDictionary *)params callback:(void (^)(id, NSError *))requestCallback {
    NSString *url = [self appendingUrl:urlString];
    NSLog(@"%@",url);
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        requestCallback([self dictionaryToJson:responseObject],nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestCallback(nil,error);
        NSLog(@"%@",error);
    }];
}

- (void)asyRequestByPostWithToken:(NSString *)urlString params:(NSDictionary*)params callback:(void(^)(id responseObject, NSError *error))requestCallback {
    NSString *url = [self appendingUrl:urlString];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        requestCallback(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestCallback(nil,error);
        NSLog(@"%@",error);
    }];
}

#pragma mark -- 工具

- (NSDictionary *)reponseObjectDecyptWithBase64:(NSData *)responceObject {
    //json串解密
    NSString *getJsonStr = [[NSString alloc] initWithData:responceObject encoding:NSUTF8StringEncoding];
    NSDictionary *json = [self dictionaryWithJsonString:[self textFromBase64String:getJsonStr]];
    return json;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    //json 解析成字典
    if (jsonString == nil) {
        
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    return dic;
    
}



- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


- (NSString *)base64StringFromText:(NSString *)text
{
    if (text && ![text isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY  改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        //IOS 自带DES加密 Begin  改动了此处
        //data = [self DESEncrypt:data WithKey:key];
        //IOS 自带DES加密 End
        
        return [data base64EncodedStringWithOptions:0];
    }
    else {
        return LocalStr_None;
    }
}

- (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *base64Data = [base64 dataUsingEncoding:NSUTF8StringEncoding];
        NSData *data = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
        //IOS 自带DES解密 Begin    改动了此处
        //data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}
//拼接接口Url

- (NSString *)appendingUrl:(NSString *)url {
    return [NSString stringWithFormat: @"%@%@",baseUrl,url];
    
}

#pragma mark - 图片上传 -

//多图上传 File
- (void)upLoadMethod:(NSString *)url Image:(NSArray *)imageArr params:(NSDictionary *)params
            callback:(void(^)(BOOL isOk,id responceObject,NSError *error))requestCallback {
    NSString *appendUrl = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    [manager POST:appendUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < imageArr.count ; i++) {
            UIImage *img = imageArr[0];
            NSData *data =[self compressionImageDataFromImage:img];
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:[NSString stringWithFormat:@"%@.jpg",[self uuid]]
                                    mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        requestCallback(YES,[self dictionaryWithJsonString:string],nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


- (NSData *)compressionImageDataFromImage:(UIImage *)image {
    //直接压缩
    NSData *imageData1 = UIImageJPEGRepresentation(image, 0);
    
    //用截图方法压缩
    NSInteger imgHeight = screenW * image.size.height / image.size.width;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenW, imgHeight)];
    [imgView setImage:image];
    UIGraphicsBeginImageContextWithOptions(imgView.frame.size, NO, 0.0);
    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData2 = UIImageJPEGRepresentation(viewImage, 0);
    
    //比较两种压缩方法，将压缩得小的返回
    return imageData1.length < imageData2.length ? imageData1 : imageData2;
}
#pragma mark -- 图片转NSdata
- (NSData *)compressionDataFromImage:(UIImage*)image
                        scaledToSize:(CGSize)newSize;
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0);
    
}

- (NSString*) uuid {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil,uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

//- (AFHTTPSessionManager *)AFmanager{
//    if(!manager){
//
//    }
//    return manager;
//}


@end

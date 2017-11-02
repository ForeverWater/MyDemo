//
//  ViewController.m
//  WYGDemoTotal
//
//  Created by Agoni on 2017/11/2.
//  Copyright © 2017年 吴运根. All rights reserved.
//

#import "ViewController.h"
#import "NetWorkEngine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (int i =0 ;i<100;i++){
    [[NetWorkEngine getInstance] asyRequestByGet:@"/article/today?dev=1" params:nil callback:^(id responseObject, NSError *error) {
          NSLog(@"%@",responseObject);
    }];
}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

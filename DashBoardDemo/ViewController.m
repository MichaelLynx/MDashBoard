//
//  ViewController.m
//  DashBoardDemo
//
//  Created by lynx on 2020/7/21.
//  Copyright © 2020 lynx. All rights reserved.
//

#import "ViewController.h"
#import "MDashBoard.h"

#import <Masonry.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MDashBoard *dashBoard = [[MDashBoard alloc] init];
    [self.view addSubview:dashBoard];
    
    [dashBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(300);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dashBoard.currentValue = 70;
        dashBoard.circleType = MDashBoardTypeAll;
        dashBoard.strokeColor = [UIColor purpleColor];
        dashBoard.lineWidth = 20;
        [dashBoard setupInterface];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [dashBoard resetInterface];
            [dashBoard setupInterfaceWithValue:80];
        });
    });
}


@end

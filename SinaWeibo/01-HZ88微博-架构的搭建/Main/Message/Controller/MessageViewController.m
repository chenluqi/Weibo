//
//  MessageViewController.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/9.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "MessageViewController.h"
#import "FaceView.h"
#import "UIViewExt.h"
#import "MMDrawerController.h"
#import "FacePannel.h"

@interface MessageViewController ()

@end

@implementation MessageViewController


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    MMDrawerController *drawCtrl = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [drawCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    MMDrawerController *drawCtrl = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [drawCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"消息";
    
    //self.navigationController.navigationBar.translucent = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO; //滑动视图是否向下自动偏移
    
    FacePannel *facePannel = [[FacePannel alloc] initWithFrame:CGRectMake(0, 100, 0, 0)];
    
    [self.view addSubview:facePannel];
    
//    FaceView *faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    
//    //NSLog(@"faceViewSize:%@",NSStringFromCGSize(faceView.frame.size));
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, faceView.height)];
//    
//    scrollView.pagingEnabled = YES;
//    
//    scrollView.contentSize = CGSizeMake(4 * kScreenWidth, faceView.height);
//    
//    [scrollView addSubview:faceView];
//    
//    [self.view addSubview:scrollView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

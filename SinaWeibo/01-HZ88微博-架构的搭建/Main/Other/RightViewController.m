//
//  RightViewController.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/13.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "SendViewController.h"
#import "BaseNavController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    
    for (NSInteger i = 0; i < 5; i++) {
        ThemeButton *btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.normalImgName = [NSString stringWithFormat:@"newbar_icon_%li.png", i+1];
        btn.frame = CGRectMake(100 - 40 - 20, 60 + i * 50, 40, 40);
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    

}

- (void)clickAction:(UIButton *)btn{
    
    if (btn.tag == 100) {
        SendViewController *ctrl = [[SendViewController alloc] init];
        BaseNavController *nav = [[BaseNavController alloc] initWithRootViewController:ctrl];
        //弹出
        [self presentViewController:nav animated:YES completion:NULL];
    }
   
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

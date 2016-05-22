//
//  HomeViewController.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/9.
//  Copyright © 2016年 kangkathy. All rights reserved.
//
/*
 1.下拉刷新和上拉加载的实现
 2.微博的时间和来源的显示
 3.未读微博的提示
 4.正则表达式
 
 */
#import "HomeViewController.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "ThemeLabel.h"
#import "WeiboModel.h"
#import "YYModel.h"
#import "WeiboCellLayout.h"
#import "WXRefresh.h"
#import "ThemeImageView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"

@interface HomeViewController () <SinaWeiboDelegate, SinaWeiboRequestDelegate>

@property (nonatomic, strong)NSMutableArray *weiboList;

@property (nonatomic, strong)ThemeImageView *notifyImgView;

@end

@implementation HomeViewController


- (ThemeImageView *)notifyImgView {
    
    if (_notifyImgView == nil) {
        _notifyImgView = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, -40, kScreenWidth - 20, 40)];
        _notifyImgView.imgName = @"timeline_notify.png";
        
        [self.view addSubview:_notifyImgView];
        
        ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:_notifyImgView.bounds];
        
        label.colorName = @"Mask_Notice_color";
        
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 1001;
        
        [_notifyImgView addSubview:label];
        
        
    }
    
    return _notifyImgView;
    
}

//懒加载获取weiboList
- (NSMutableArray *)weiboList {
    
    if (_weiboList == nil) {
        _weiboList = [NSMutableArray array];
    
    }
    
    return _weiboList;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"首页";
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    //监听上拉和下拉的事件
    [_weiboTableView addPullDownRefreshBlock:^{
        NSLog(@"下拉刷新");
        //请求最新的微博数据
        [self _loadNewWeiboData];
        
    }];
    
    [_weiboTableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉加载");
        
        [self _loadNextPageWeiboData];
    }];
    
    //微博登录
    //判断是否授权
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
    
    //如果没有授权则调用登录方法进行授权
    if (!(sinaweibo.isAuthValid)) {
        
        [sinaweibo logIn];

    }
    
    else { //如果授权直接申请微博列表
        
        NSDictionary *params = @{
                                 @"count" : @"20"
                                 
                                 };
        
        //发送网络请求获取到微博列表
        SinaWeiboRequest *request = [sinaweibo requestWithURL:@"statuses/home_timeline.json" params:[params mutableCopy] httpMethod:@"GET" delegate:self];
        request.weiboTag = WeiboRequestNormal;
        
        //显示加载视图
        [self showHUDLoadingView];
        
        self.weiboTableView.hidden = YES;

        
    }
    
}

//下拉刷新方法
- (void)_loadNewWeiboData {
    
    //1.获取当前的最新一条微博
    WeiboCellLayout *newLayout = [self.weiboList firstObject];
    
    NSString *sinceId = newLayout.weibo.idstr;
    
    NSDictionary *params = @{
                             @"since_id" : sinceId
                             
                             };
    
    //发送网络请求获取到微博列表
    SinaWeiboRequest *request = [[self sinaweibo] requestWithURL:@"statuses/home_timeline.json" params:[params mutableCopy] httpMethod:@"GET" delegate:self];
    request.weiboTag = WeiboRequestNew;
    
}

//上拉加载方法
- (void)_loadNextPageWeiboData{
    
    //取得当前显示的最后一条微博的 id
    WeiboCellLayout *layout = [self.weiboList lastObject];
    NSString *weibID = layout.weibo.idstr;
    
    SinaWeiboRequest *request = [[self sinaweibo] requestWithURL:@"statuses/home_timeline.json"params:[@{@"max_id" : weibID} mutableCopy] httpMethod:@"GET" delegate:self];
    
    request.weiboTag = WeiboRequestNextPage;
    
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SinaWeiboDelegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    
    //存储Oauth认证的相关信息
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"%@", error);
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    
    //NSLog(@"%@", result);
    //将网络请求获取的数据映射成WeiboModel
    NSArray *statuses = result[@"statuses"];
    
//临时保存加载下来的微博数据
    NSMutableArray *tempArr = [NSMutableArray array];

    
    for (NSDictionary *status in statuses) {
    
    
        //字典到model的映射
        WeiboModel *weibo = [WeiboModel yy_modelWithDictionary:status];
        
        WeiboCellLayout *layout = [[WeiboCellLayout alloc] init];
        layout.weibo = weibo;
        
        [tempArr addObject:layout];
        
    
        
    }
    
    //区分加载模式：普通，最新，下一页
    if (request.weiboTag == WeiboRequestNormal) {
        
        //隐藏提示视图
        [self hideHUDLoadingView];
        
        self.weiboTableView.hidden = NO;

        
        self.weiboList = tempArr;
        
    }
    else if (request.weiboTag == WeiboRequestNew) {
        
        [self showNotifyView:tempArr.count];
        
        //将未读微博插入到数组中
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempArr.count)];
        
        [self.weiboList insertObjects:tempArr atIndexes:set];
        
        //收起下拉刷新控件
        [self.weiboTableView.pullToRefreshView stopAnimating];
        
    } else if (request.weiboTag == WeiboRequestNextPage) {
        
        WeiboCellLayout *firstLayout = [tempArr firstObject];
        WeiboCellLayout *lastLayout = [self.weiboList lastObject];
        
        //如果出现重复的weibo则删除其中一条
        if ([firstLayout.weibo.idstr isEqualToString:lastLayout.weibo.idstr]) {
            
            [tempArr removeObjectAtIndex:0];
        }
        
    
        //将下一页微博添加到数组末尾
        [self.weiboList addObjectsFromArray:tempArr];
        
        //收起上拉加载控件
        [self.weiboTableView.infiniteScrollingView stopAnimating];
        
    }
    
    //设置tableView显示的数据源，并刷新tableView
    self.weiboTableView.weiboList = self.weiboList;
    
    [self.weiboTableView reloadData];
    
    
}

#pragma  mark - 显示未读微博视图
- (void)showNotifyView:(NSInteger)count {
    
    if (count <= 0) {
        return;
    }
    
    //设置label的显示内容
    ThemeLabel *label = (ThemeLabel *)[self.notifyImgView viewWithTag:1001];
    
    label.text = [NSString stringWithFormat:@"%ld 条新微博", count];
    
    //加动画效果
    [UIView animateWithDuration:0.3 animations:^{
        self.notifyImgView.transform = CGAffineTransformMakeTranslation(0, 50);
    } completion:^(BOOL finished) {
        
        [UIView animateKeyframesWithDuration:0.3 delay:1.5 options:UIViewKeyframeAnimationOptionLayoutSubviews  animations:^{
            self.notifyImgView.transform = CGAffineTransformIdentity;
        } completion:NULL];
        
        
    }];
    
    //播放声音-->注册成系统声音
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome.wav" ofType:nil];
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundID);
    
    AudioServicesPlaySystemSound(soundID);
    
}

@end

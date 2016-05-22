//
//  SendViewController.m
//  WXWeibo
//
//  Created by liuwei on 16/1/26.
//  Copyright (c) 2016年 baidu. All rights reserved.
//

#import "SendViewController.h"
#import "ThemeButton.h"
#import "ThemeLabel.h"
#import "UIViewExt.h"
#import "MMDrawerController.h"
#import "LocationTableViewController.h"
#import "BaseNavController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "AFNetworking.h"
#import "ThemeImageView.h"
#import "DataService.h"
#import "UIProgressView+AFNetworking.h"

@interface SendViewController () <SinaWeiboRequestDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic,strong)UIView *addressView;

@property (nonatomic,strong)UIImageView *selectImgView; //选择的图片


@end


@implementation SendViewController{

    //1.编辑输入框
    UITextView *_textView;
    //2.工具栏
    UIView *_editorBar; //五个按钮的父视图
    
    UIWindow *_progressWindow; //显示图片上传进度的window
    
  
}

- (UIImageView *)selectImgView{
    
    if (_selectImgView == nil) {
        
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
        _selectImgView.contentMode = UIViewContentModeScaleAspectFill;
        _selectImgView.clipsToBounds = YES;

        _selectImgView.bottom = _editorBar.top;
        [self.view addSubview:_selectImgView];
    }
    
    return _selectImgView;
}

- (UIView *)addressView{
    
    if (_addressView == nil) {
        
        _addressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        [_editorBar addSubview:_addressView];
        
        //compose_toolbar_5.png
        ThemeLabel *addressLable = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        addressLable.font = [UIFont systemFontOfSize:12];
        addressLable.colorName = @"More_Item_Text_color";
        addressLable.tag = 101;
        [_addressView addSubview:addressLable];
        
        ThemeImageView *addressImg = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        addressImg.imgName = @"compose_toolbar_5.png";
        [_addressView addSubview:addressImg];
        
        addressLable.left = addressImg.right;
    }
    return _addressView;
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听键盘弹出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self _createNavigationViews];
    [self _loadEditorViews];
    
    
    
}

//界面显示时自动弹出键盘
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [_textView becomeFirstResponder];
}

#pragma mark - 键盘弹出的方法
- (void)keyboardShow:(NSNotification *)notification {
    
    //NSLog(@"%@", notification.userInfo);
    
    CGRect keyBoardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat keyBoradHeight = keyBoardFrame.size.height;
    
    //求出textView和工具栏的高度
    _textView.height = kScreenHeight - keyBoradHeight - _editorBar.height;
    
    //NSLog(@"@%f,%f,%f", _textView.height,kScreenHeight,_editorBar.height);
    _editorBar.top = _textView.bottom;
    
    NSLog(@"@%f", _editorBar.top);
    
}

#pragma mark - create UI  创建子视图
//1.创建导航栏上的视图
- (void)_createNavigationViews {
    
    //1.关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.normalImgName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    //2.发送按钮
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    sendButton.normalImgName = @"button_icon_ok.png";
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    [self.navigationItem setRightBarButtonItem:sendItem];
    
}
//2.创建编辑工具栏的视图
- (void)_loadEditorViews {
    
    //1.创建输入框视图
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    _textView.font = [UIFont systemFontOfSize:16.0f];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.editable = YES;
    [self.view addSubview:_textView];

    //2.创建编辑工具栏,五个按钮的父视图
    _editorBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    
    _editorBar.backgroundColor = [UIColor clearColor
                                  ];
    [self.view addSubview:_editorBar];
    
    //3.创建多个编辑按钮
    NSArray *imgs = @[
                      @"compose_toolbar_1.png",
                      @"compose_toolbar_4.png",
                      @"compose_toolbar_3.png",
                      @"compose_toolbar_5.png",
                      @"compose_toolbar_6.png"
                      ];
    for (int i=0; i<imgs.count; i++) {
        NSString *imgName = imgs[i];
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(15+(kScreenWidth/5)*i, 20, 40, 33)];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10+i;
        button.normalImgName = imgName;
        [_editorBar addSubview:button];
    }
}

- (void)sendWeibo {
    
    //对AFNetworking的二次封装，实现网络请求类
    NSString *url = nil;
    NSDictionary *fileDic = nil;
    NSDictionary *params = @{@"status":_textView.text};
    if (self.selectImgView.image != nil) { //如果带图片
        
        url = @"statuses/upload.json";
        fileDic = @{@"pic" : UIImageJPEGRepresentation(self.selectImgView.image, 1)};
    }else { //如果不带图片
        
        url = @"statuses/update.json";
    }
    
    __weak SendViewController *weakSelf = self;
    
    NSURLSessionDataTask *task = [DataService requestWithURL:url params:params fileData:fileDic httpMethod:@"post" success:^(NSURLSessionDataTask *task, id result) {
        
        NSLog(@"发送成功");
        
        // 封装一个方法，抽取出来具有通用性。放到BaseViewController中。
        __strong SendViewController *strongSelf = weakSelf;
        
        [strongSelf showHUDCompleteView:@"发送成功"];
        
        //在发送微博成功后再跳回到主页上。
        [strongSelf closeAction];
        
    } failure:^(NSError *error) {
        NSLog(@"发送失败");
    }];
    
    //如果有图片，则显示上传图片进度
    if (fileDic) {
        
        
        _progressWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        
        _progressWindow.windowLevel = UIWindowLevelAlert;
        
        _progressWindow.backgroundColor = [UIColor blackColor];
        
        _progressWindow.hidden = NO; //显示window
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        lable.text = @"正在发送...";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = [UIColor whiteColor];
        
        [_progressWindow addSubview:lable];
        
        //创建进度条
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 3)];
        
        [progressView setProgressWithUploadProgressOfTask:(NSURLSessionUploadTask *)task animated:YES];
        
        [_progressWindow addSubview:progressView];
        
        
    }
    
    
    
    

    
    
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSLog(@"发送成功");
}


#pragma mark - 按钮事件
//关闭
- (void)closeAction {
    
    //获取到容器类控制器,并关闭右侧控制器
    MMDrawerController *drawerCtrl = (MMDrawerController *)self.view.window.rootViewController;
    
    [drawerCtrl closeDrawerAnimated:YES completion:NULL];
 
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

//发送微博
- (void)sendAction:(UIButton *)btn{
    
    
    NSString *notify = nil;
    //内容判断，不能发送空微博和超过140个汉字的微博
    if (_textView.text.length <= 0) {
        
        notify = @"微博内容不能为空";
        
        
    } else if (_textView.text.length > 140) {
        
        notify = @"微博内容不能超过140个字";
    }
    
    if (notify) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:notify delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        return;
        
    }
    
    
    [self sendWeibo];
    

    
    
    
}



//textView下方五个按钮的点击事件
- (void)clickAction:(UIButton *)btn {
    
    
    if (btn.tag == 13) { //定位
        
     
        LocationTableViewController *locationCtrl = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"locationCtrl"];
        
        
        //传递block
        //防止循环引用
        __weak SendViewController *weakSelf = self;
        locationCtrl.locationBlock = ^(NSString *address){
            
            //将位置信息显示在界面上
            __strong SendViewController *strongSelf = weakSelf;

            UILabel *addressLable = (UILabel *)[strongSelf.addressView viewWithTag:101];
            addressLable.text = address;
        };
        
        
        
        BaseNavController *navCtrl = [[BaseNavController alloc] initWithRootViewController:locationCtrl];
        
        [self presentViewController:navCtrl animated:YES completion:NULL];
        
        
        
    } else if (btn.tag == 10) { //拍照或者从相册获取图片实现带图片的微博发送
        
        //UIActionSheet UIAlertView --- >
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        __weak SendViewController *weakSelf = self;
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //弹出UIImagePickerController
            __strong SendViewController *strongSelf = weakSelf;
            //弹出相册
            UIImagePickerController *imgPickerCtrl = [[UIImagePickerController alloc] init];
            imgPickerCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imgPickerCtrl.delegate = strongSelf;
            [strongSelf presentViewController:imgPickerCtrl animated:YES completion:NULL];
            
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //取消
            [alertCtrl dismissViewControllerAnimated:YES completion:NULL];
            
        }];
        
        [alertCtrl addAction:cameraAction];
        [alertCtrl addAction:photoLibraryAction];
        [alertCtrl addAction:cancelAction];
        
        [self presentViewController:alertCtrl animated:YES completion:NULL];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //取得用户选择的照片
    UIImage *selectImg = info[UIImagePickerControllerOriginalImage];
    self.selectImgView.image = selectImg;
}


@end

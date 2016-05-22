//
//  WeiboCell.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+TimeAgo.h"
#import "WXLabel.h"
#import "ThemeManager.h"
#import "WXPhotoBrowser.h"

@interface WeiboCell() <WXLabelDelegate,PhotoBrowerDelegate>



@end



@implementation WeiboCell

- (NSMutableArray *)weiboImgViewArr {
    
    if (_weiboImgViewArr == nil) {
        
        _weiboImgViewArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 9; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            
            //图片正常显示，超出imageView的部分切割
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            
            imgView.clipsToBounds = YES;
            
            
            //给九张配图添加手势，实现单击后放大
            imgView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imgView addGestureRecognizer:tap];
            
            imgView.tag = i;
            
            
            [self.contentView addSubview:imgView];
            
            [_weiboImgViewArr addObject:imgView];
        }
    }
    
    return _weiboImgViewArr;
    
}


- (UILabel *)reWeiboTextLabel {
    
    if (_reWeiboTextLabel == nil) {
        
        _reWeiboTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        
        //设置代理
        _reWeiboTextLabel.wxLabelDelegate = self;
        _reWeiboTextLabel.font = [UIFont systemFontOfSize:15];
        _reWeiboTextLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_reWeiboTextLabel];


    }
    
    return _reWeiboTextLabel;
}

- (ThemeImageView *)reWeiboBgImgView {
    
    if (_reWeiboBgImgView == nil) {
        
        _reWeiboBgImgView = [[ThemeImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView insertSubview:_reWeiboBgImgView atIndex:0];
    }
    
    return _reWeiboBgImgView;
}


- (UILabel *)weiboTextLabel {
    
    if (_weiboTextLabel == nil) {
        
        _weiboTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero]; //先不设定label的frame,根据微博正文内容动态计算
        
        _weiboTextLabel.wxLabelDelegate = self;
        _weiboTextLabel.font = [UIFont systemFontOfSize:16];
        _weiboTextLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_weiboTextLabel];
        
    }
    
    return _weiboTextLabel;
    
}

- (UIImageView *)weiboImgView {
    
    if (_weiboImgView == nil) {
        
        _weiboImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_weiboImgView];
        
    }
    
    return _weiboImgView;
    
    
}

- (void)awakeFromNib {
    
    //用户头像圆角和边框设置
    self.iconImgView.layer.cornerRadius = 5;
    self.iconImgView.layer.borderColor = [UIColor grayColor].CGColor;
    self.iconImgView.layer.borderWidth = 0.5;
    self.iconImgView.layer.masksToBounds = YES;
    
    //设置各ThemeLabel显示的颜色名
    _nickNameLabel.colorName = @"Timeline_Name_color";
    _publicTimeLabel.colorName = @"Timeline_Time_color";
    _sourceLabel.colorName = @"Timeline_Time_color";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:kThemeChangeNotification object:nil];
    
}

- (void)themeChange {
    
    //当属性改变时会自动调用setNeedsDisplay通知系统使用drawRect:重新绘制WXLabel
    self.weiboTextLabel.textColor = [[ThemeManager sharedManager] themeColorWithColorName:@"Timeline_Content_color"];
    
    self.reWeiboTextLabel.textColor = [[ThemeManager sharedManager] themeColorWithColorName:@"Detail_Content_color"];
    
    //改变超链接的颜色
    //[self.weiboTextLabel setNeedsDisplay];
    
}

- (void)setWeiboLayout:(WeiboCellLayout *)weiboLayout {
    
   
    _weiboLayout = weiboLayout;
    
    //根据微博Model的内容来设置当前单元格所有子视图的显示内容和frame
    
    //呢称
    _nickNameLabel.text = _weiboLayout.weibo.user.name;
    
    //时间 后续做转化
    _publicTimeLabel.text = [self parseWeiboDate:_weiboLayout.weibo.created_at];
    //NSLog(@"%@", _weiboLayout.weibo.created_at);
    
    //来源 字符串的提取处理
    _sourceLabel.text = [self parseSource:_weiboLayout.weibo.source];
    //<a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>

    //NSLog(@"来源：%@", _weiboLayout.weibo.source);
    
    //头像
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_weiboLayout.weibo.user.profile_image_url]];
    
    
    //微博正文
    self.weiboTextLabel.text = _weiboLayout.weibo.text;
    self.weiboTextLabel.textColor = [[ThemeManager sharedManager] themeColorWithColorName:@"Timeline_Content_color"];
    
    //设置微博配图的显示内容
    if (_weiboLayout.weibo.thumbnail_pic != nil) {
        
        //[self.weiboImgView sd_setImageWithURL:[NSURL URLWithString:_weiboLayout.weibo.thumbnail_pic]];
        [self showImgsWithUrls:_weiboLayout.weibo.pic_urls];
    
    }
    
    
    
    
    if (_weiboLayout.weibo.retweeted_status != nil) {
        
        //设置拉伸图片的左顶盖和上顶盖
        self.reWeiboBgImgView.leftCapWidth = 25;
        self.reWeiboBgImgView.topCapWidth = 25;
        
        self.reWeiboBgImgView.imgName = @"timeline_rt_border_9";
        self.reWeiboTextLabel.text = _weiboLayout.weibo.retweeted_status.text;
        self.reWeiboTextLabel.textColor = [[ThemeManager sharedManager] themeColorWithColorName:@"Detail_Content_color"];
        
        if (_weiboLayout.weibo.retweeted_status.thumbnail_pic != nil) {
            
            //[self.weiboImgView sd_setImageWithURL:[NSURL URLWithString:_weiboLayout.weibo.retweeted_status.thumbnail_pic]];
            [self showImgsWithUrls:_weiboLayout.weibo.retweeted_status.pic_urls];
            
        }
    }
    
    
    //计算微博正文Label的frame
    self.weiboTextLabel.frame = _weiboLayout.weiboTextFrame;
    
    //获取微博多张配图的frame
    //self.weiboImgView.frame = _weiboLayout.weiboImgFrame;
    for (NSInteger i = 0; i < kImagesCount; i++) {
        
        UIImageView *imageView = self.weiboImgViewArr[i];
        imageView.frame = [_weiboLayout.weiboImgFrameArray[i] CGRectValue];
        
        
        
    }
    
    self.reWeiboTextLabel.frame = _weiboLayout.reWeiboTextFrame;
    self.reWeiboBgImgView.frame = _weiboLayout.reWeiboBgImgFrame;
    
   

    
}

//设置多张图片的显示内容
- (void)showImgsWithUrls:(NSArray *)urls {
    
    for (NSInteger i = 0; i < urls.count; i++) {
        
        
        UIImageView *imgView = self.weiboImgViewArr[i];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:urls[i][@"thumbnail_pic"]]];
        
    }
    
    
    
}


#pragma mark - 时间的解析方法
- (NSString *)parseWeiboDate:(NSString *)dateStr {
    
    //1.字符串按照新浪微博提供的格式转化成NSDate
    //Sat May 14 13:43:58 +0800 2016
    
    NSString *formatter = @"E M d HH:mm:ss Z yyyy";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = formatter;
    
    //NSLog(@"%@", [NSLocale currentLocale].localeIdentifier);
    
    //当前环境为中文为时，新浪提供的为英文，因此在作时间转化时将转化的本地化环境设置成英文，否则转化失败
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"]; //zh_CN
    
    NSDate *publicDate = [dateFormatter dateFromString:dateStr];

    //2.计算发布微博时的时间戳
    //NSDate *currentDate = [NSDate date];
    
    //3.和当前时间比较计算出差值，再转成字符串输出
    //NSTimeInterval timerInterval = [currentDate timeIntervalSince1970] - [publicDate timeIntervalSince1970];
    
    return [publicDate timeAgo];
    
    
}

#pragma mark - 来源的提取方法 
//<a href="http://weibo.com/" rel="nofollow">微博 weibo.com</a>
- (NSString *)parseSource:(NSString *)sourceStr {
    
    if (sourceStr.length <= 0) {
        return nil;
    }
    
    //1.定位>
    NSInteger start = [sourceStr rangeOfString:@">"].location;
    //2.定位<
    NSInteger end = [sourceStr rangeOfString:@"<" options:NSBackwardsSearch].location;
    //3.截取字符串
    
    return [sourceStr substringWithRange:NSMakeRange(start + 1, end - start - 1)];
    
    
}

#pragma mark - WXLabelDelegate 

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    
    return @"(@[\\w-]{2,30}[\\s:])|(#[^#]+#)|(http(s)?://([A-Za-z0-9._-]+(/)?)*)";
    
    
}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [[ThemeManager sharedManager] themeColorWithColorName:@"Link_color"];
}

#pragma mark - 图片的点击事件
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    //第一个参数：图片显示的父视图
    //第二个参数：当前显示的图片索引
    //第三个参数：delegate来监听显示的相关事件
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:tap.view.tag delegate:self];
    
    
    
    
    
    
}

#pragma mark - WXPhotoBrowser delegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser {
    
    if (_weiboLayout.weibo.pic_urls.count > 0) {
        
        return _weiboLayout.weibo.pic_urls.count;
    } else {
        
        return _weiboLayout.weibo.retweeted_status.pic_urls.count;
    }
    
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    
    WXPhoto *photo = [[WXPhoto alloc] init];
    
    //拿到原图
    photo.srcImageView = self.weiboImgViewArr[index];
    
    //获取到大图的url
    
    NSArray *urls = nil;
    
    if (_weiboLayout.weibo.pic_urls.count > 0) {
        
        urls = _weiboLayout.weibo.pic_urls;
    } else {
        
        urls = _weiboLayout.weibo.retweeted_status.pic_urls;
    }

    NSLog(@"%@",urls[index][@"thumbnail_pic"]);
    
    NSString *imgURLString = urls[index][@"thumbnail_pic"];
    
    //大图的url
    imgURLString = [imgURLString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    
    photo.url = [NSURL URLWithString:imgURLString];
    
    return photo;
    
    
}





@end

//
//  WeiboCellLayout.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WXLabel.h"



@implementation WeiboCellLayout

- (NSMutableArray *)weiboImgFrameArray {
    
    if (_weiboImgFrameArray == nil) {
        _weiboImgFrameArray = [NSMutableArray array];
    }
    
    return  _weiboImgFrameArray;
    
}

- (void)setWeibo:(WeiboModel *)weibo {
    
    
    _weibo = weibo;
    
    self.cellHeight += kCellOriginHeight;
    
    //确定单元格中每个需要动态确定frame的子视图
    
    //微博正文
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:16]
                                 };
    //1.根据正文内容来计算正文高度
//    CGRect weiboTextRect = [_weibo.text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    
    CGFloat weiboTextHeight = [WXLabel getTextHeight:16 width:kScreenWidth - 20 text:self.weibo.text];
    //根据高度来设定正文label的frame
    self.weiboTextFrame = CGRectMake(kSpace, kCellOriginHeight + kSpace, kScreenWidth - 20, weiboTextHeight);
    
    
    //2.根据微博正文的高度来计算单元格的高度
    self.cellHeight += CGRectGetHeight(self.weiboTextFrame) + kSpace * 2;
    

    //3.确定多个微博配图的frame
    CGFloat imgsHeight = [self weiboMultiImagesFrame:self.weiboTextFrame picUrls:self.weibo.pic_urls];
    
    self.cellHeight += imgsHeight;
    
    //5.确定转发微博相关控件的frame
    [self reWeiboFrames];
    
    //6.将没有图片的imgView的frame要设置成0
    for (NSInteger i = self.weiboImgFrameArray.count; i < kImagesCount; i++) {
        
        [self.weiboImgFrameArray addObject:[NSValue valueWithCGRect:CGRectZero]];
        
    }
    
    

}

//确定多图的Frame
- (CGFloat)weiboMultiImagesFrame:(CGRect)imgRefFrame picUrls:(NSArray *)urls {
    
    //1.确定第一张图片的X,Y
    CGFloat imgX = CGRectGetMinX(imgRefFrame);
    CGFloat imgY = CGRectGetMaxY(imgRefFrame) + kSpace;
    
    //2.确定图片的宽高
    CGFloat imgSize = (CGRectGetWidth(imgRefFrame) - 2 * kImageGap) / kImagesCountPerLine;
    
    //3.计算多个图片的frame
    
    NSInteger row = 0;
    NSInteger column = 0;
    
    for (NSInteger i = 0; i < urls.count; i++) {
        
        //当前图的X坐标：第一张图的x坐标 + 列数 *（图片宽度+空隙)
        //当前图的Y坐标：第一张图的Y坐标 + 行数 *（图片高度+空隙）
        row = i / kImagesCountPerLine;
        column = i % kImagesCountPerLine;
        
        CGRect imgFrame = CGRectMake(imgX + column * (imgSize + kImageGap), imgY + row *(imgSize + kImageGap), imgSize, imgSize);
        
        //4.加入到数组中
        [self.weiboImgFrameArray addObject:[NSValue valueWithCGRect:imgFrame]];
        
    }
    

    //5.根据图片的个数来计算单元格的高度
    //    和单元格高度有关的项：
    //    （1）图片有几行：0-3
    NSInteger line = (urls.count + kImagesCountPerLine - 1)/  kImagesCountPerLine;
    //    （2）图片间有几个空隙：0-2
    NSInteger imgGap = MAX(line - 1, 0);
    //    （3）图片与微博正文之间的空隙：0-1
    NSInteger imgTextGap = MIN(1, MAX(0, line));
    
    CGFloat imgsHeight = line * imgSize + imgGap * kImageGap + imgTextGap * kSpace;
    
  
    
    return imgsHeight;
    
    

    
}

- (void)reWeiboFrames {
    
    self.reWeiboBgImgFrame = CGRectZero;
    self.reWeiboTextFrame = CGRectZero;
    
    if (_weibo.retweeted_status != nil) {
        
        //1.转发微博的背景frame
        self.reWeiboBgImgFrame = CGRectMake(CGRectGetMinX(self.weiboTextFrame), CGRectGetMaxY(self.weiboTextFrame) + kSpace, CGRectGetWidth(self.weiboTextFrame), 0);
        
        //2.转发微博正文的frame
        //CGRect reWeiboTextRect = [_weibo.retweeted_status.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.reWeiboBgImgFrame) - 2 *kSpace, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:NULL];
        CGFloat reWeiboTextHeight = [WXLabel getTextHeight:15 width:CGRectGetWidth(self.reWeiboBgImgFrame) - 2 *kSpace text:self.weibo.retweeted_status.text];
        
        self.reWeiboTextFrame = CGRectMake(CGRectGetMinX(self.reWeiboBgImgFrame) + kSpace, CGRectGetMinY(self.reWeiboBgImgFrame) + kSpace,CGRectGetWidth(self.reWeiboBgImgFrame) - 2 *kSpace, reWeiboTextHeight);
        
        CGFloat bgHeight = reWeiboTextHeight + kSpace;
        
        
        //3.如果转发微博有图片
        CGFloat reweetWeibImgsHeight = [self weiboMultiImagesFrame:self.reWeiboTextFrame picUrls:self.weibo.retweeted_status.pic_urls];
        bgHeight += reweetWeibImgsHeight;
            
        
        
        bgHeight += kSpace;
        
        //4.重新设置背景图片的高度
        self.reWeiboBgImgFrame = CGRectMake(CGRectGetMinX(self.weiboTextFrame), CGRectGetMaxY(self.weiboTextFrame) + kSpace, CGRectGetWidth(self.weiboTextFrame), bgHeight);
        
        self.cellHeight += CGRectGetHeight(self.reWeiboBgImgFrame) + kSpace;
        
    }
    
}

@end

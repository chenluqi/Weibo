//
//  FacePannel.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/20.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "FacePannel.h"

@implementation FacePannel


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self _createSubviews];
    }
    
    return self;
}

- (void)_createSubviews {
    
    _faceView = [[FaceView alloc] initWithFrame:CGRectZero];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
    
    _scrollView.pagingEnabled = YES;
    
    _scrollView.contentSize = CGSizeMake(4 * kScreenWidth, _faceView.height);
    
    [_scrollView addSubview:_faceView];
    [self addSubview:_scrollView];
    

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _faceView.bottom, kScreenWidth, 30)];
    
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    

    
    [self addSubview:_pageControl];
    
    
    self.autoresizesSubviews = NO; //子视图不随父视图而改变。

    //改变FacePannel的width, height
    self.width = kScreenWidth;
    self.height = _faceView.height + _pageControl.height;
    
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIImage *backgroundImage = [UIImage imageNamed:@"emoticon_keyboard_background.png"];
    
    [backgroundImage drawInRect:rect];
    
}


@end

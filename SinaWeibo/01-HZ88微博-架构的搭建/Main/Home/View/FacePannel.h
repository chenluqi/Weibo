//
//  FacePannel.h
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/20.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface FacePannel : UIView


@property(strong, nonatomic)FaceView *faceView;

@property(strong, nonatomic)UIScrollView *scrollView;

@property(strong, nonatomic)UIPageControl *pageControl;


@end

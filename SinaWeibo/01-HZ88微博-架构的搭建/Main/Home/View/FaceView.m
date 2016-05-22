//
//  FaceView.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/20.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "FaceView.h"
#import "UIViewExt.h"



#define kItemSize 45  //表情视图的size
#define kFaceImageSize 30 //表情图片的size

#define kLinesPerPage 4 //每页显示的表情行数
//#define kColumnsPerLine (kScreenWidth/kItemSize) //每行显示的图片个数

@interface FaceView ()

@property(nonatomic, strong)UIImageView *selectImgView; //放大镜视图

@end


@implementation FaceView

- (UIImageView *)selectImgView {
    
    if (_selectImgView == nil) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
       
        _selectImgView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
        
        //宽高自适应
        [_selectImgView sizeToFit];
        
        [self addSubview:_selectImgView];
        
        UIImageView *faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake((_selectImgView.width - kFaceImageSize)/2, 15, kFaceImageSize, kFaceImageSize)];
        
        faceImgView.tag = 100;
        
        [_selectImgView addSubview:faceImgView];
   
    }
    
    return _selectImgView;
    
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //构造二维数组，提供显示信息
        [self _createData];
    }
    
    return self;
    
}

- (void)_createData {
    
    //1.创建一个空的二维数组
    _items2D = [NSMutableArray array];
    
    //2.读取plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    //3.对二维数组进行数据填充
    NSMutableArray *item1D = nil;
    
    NSInteger columnsPerLine =  kScreenWidth / kItemSize; //每行有多少列
    
    NSUInteger count = kLinesPerPage * columnsPerLine; //当前页有多少表情元素
    

    //NSLog(@"count:%li, columnsPerLine:%li", count, columnsPerLine);
    
    for (NSInteger i = 0; i < emoticons.count; i++) {
        
        if (item1D == nil || item1D.count == count) {
            
            item1D = [NSMutableArray arrayWithCapacity:count];
            

            [_items2D addObject:item1D]; //把标识一页信息的一维数组添加到二维数组中。
            
        
        }
        
        
        //把表情字典添加到一维数组中
        [item1D addObject:emoticons[i]];
        
        //NSLog(@"%@", item1D);
        
    }
//    
//    NSRange range1 = NSMakeRange(0, 32);
//    NSRange range2 = NSMakeRange(32, 32);
//    NSRange range3 = NSMakeRange(64, 32);
//    
//    [emoticons subarrayWithRange:range1];
    
    //计算当前faceView的宽高
    CGRect frame = self.frame;
    
    frame.size.width = _items2D.count * kScreenWidth;
    frame.size.height = kItemSize * kLinesPerPage;

    self.frame = frame;
    
    
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //绘制表情图片
    NSInteger row = 0;
    NSInteger column = 0;
    
    NSInteger columnsPerLine =  kScreenWidth / kItemSize; //列数
    
    for (NSInteger i = 0; i < _items2D.count; i++) {
        
        //取出当前页上的一维数组
        NSArray *item1D = _items2D[i];
        
        for (NSInteger j = 0; j < item1D.count; j++) {
            
            
            //取得某张图片
            NSDictionary *item = item1D[j];
            NSString *imgName = item[@"png"];
            UIImage *image = [UIImage imageNamed:imgName];
            
            //计算此张图片应该显示的坐标
            CGFloat x = column * kItemSize + (kItemSize - kFaceImageSize)/2 + i * kScreenWidth;
            
            CGFloat y = row * kItemSize + (kItemSize - kFaceImageSize)/2;
            
            
            //将图片画在图形上下文上
            [image drawInRect:CGRectMake(x, y, kFaceImageSize, kFaceImageSize)];
            
            
            //更新行和列
            column++;
            if (column % columnsPerLine == 0) { //一行已完成
                column = 0;
                row++;
            }
            //异常处理
            if (row == kLinesPerPage) {
                row = 0;
            }
  
            
        }
        
    }
    

    
}

//给定x,y-->转成row,column-->定位到数组中的某个元素-->获取到表情名
- (void)touchFace:(CGPoint)point {
    
    //计算当前表情所在的页数
    NSInteger page = point.x / kScreenWidth;
    
    if (page >= _items2D.count || page < 0) {
        
        return;
        
    }
    
    //计算当前表情的行和列
    NSInteger column = (point.x - ((kItemSize - kFaceImageSize)/2 + page * kScreenWidth))/kItemSize;

    NSInteger row = (point.y - (kItemSize - kFaceImageSize)/2)/kItemSize;
    
    NSLog(@"row:%li, column:%li", row, column);
    //容错处理 7列 0-6
    NSInteger columnsPerLine =  kScreenWidth / kItemSize; //每行有多少列
    if (column > columnsPerLine - 1) {
        column = columnsPerLine - 1;
    }
    
    if (column < 0) {
        column = 0;
    }
    
    if (row > kLinesPerPage - 1) {
        row = kLinesPerPage - 1;
    }
    
    if (row < 0) {
        row = 0;
    }
    
    
    //根据行和列计算中表情在当前页中的索引值
    //row ＝ 1 column = 2;  index = row * 每行有多少列 + column
    NSInteger index = row * columnsPerLine + column;
    
    //通过索引值获取到数组中的表情信息字典
    NSArray *item1D = _items2D[page];
    
    if (index >= item1D.count || index < 0) {
        return;
    }
    
    NSDictionary *faceInfo = item1D[index];
    
    NSString *imageName = faceInfo[@"png"];
    NSString *faceName = faceInfo[@"chs"];
    

    NSLog(@"%@:%@",faceName,imageName);
    
    //显示放大镜视图以及其子视图
    UIImageView *faceImageView = (UIImageView *)[self.selectImgView viewWithTag:100];
    faceImageView.image = [UIImage imageNamed:imageName];
    
    
    //根据选中图片中心点的坐标计算放大镜视图的坐标
    CGFloat x = column * kItemSize + kItemSize/2 + page * kScreenWidth;
    CGFloat y = row * kItemSize + kItemSize/2;
    
    self.selectImgView.center = CGPointMake(x, 0);
    self.selectImgView.bottom = y;
    
    
}


#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.selectImgView.hidden = NO;
    
    //禁用scrollView的滑动
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;

    }
    
    
    //获取触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //根据触摸点的x,y坐标计算行和列，并查找表情图片相应的表情名
    [self touchFace:point];
    
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //获取触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //根据触摸点的x,y坐标计算行和列，并查找表情图片相应的表情名
    [self touchFace:point];
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.selectImgView.hidden = YES;
    
    //开启ScrollView的滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
        
    }
    
    
}












@end

//
//  WeiboTableView.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/11.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboCellLayout.h"

@implementation WeiboTableView 

//代码创建
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        
    }
    
    return self;
}


//xib，storyboard创建
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    
    self.dataSource = self;
    self.delegate = self;
    

}

#pragma mark - WeiboTabelView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.weiboList.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //复用单元格
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    
    //给cell绑定一个WeiboCellLayout进行显示。
    cell.weiboLayout = self.weiboList[indexPath.row];
    
    return cell;
    

    
}

//单元格高度的协议方法，因为单元格高度自定义，因此与storyboard中的设置保持一致。
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //如何获取单元格
    
    //下面方法会引发死循环
    //WeiboCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //return cell.weiboTextLabel.frame.size.height + 60;
    
    //获取到WeiboModel再去计算一次微博正文的高度
    WeiboCellLayout *weiboLayout = self.weiboList[indexPath.row];
    
    return weiboLayout.cellHeight;
    
}




@end

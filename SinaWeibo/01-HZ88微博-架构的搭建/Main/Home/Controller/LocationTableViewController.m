//
//  LocationTableViewController.m
//  01-HZ88微博-架构的搭建
//
//  Created by kangkathy on 16/5/17.
//  Copyright © 2016年 kangkathy. All rights reserved.
//

#import "LocationTableViewController.h"
#import "ThemeButton.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "SinaWeibo.h"

@interface LocationTableViewController () <CLLocationManagerDelegate, SinaWeiboRequestDelegate>

@end

@implementation LocationTableViewController {
      CLLocationManager *_locationManager;
    
      NSMutableArray *_locations; //存储位置反编码信息
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _locations = [NSMutableArray array];
    
    //1.关闭按钮
    ThemeButton *closeButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    closeButton.normalImgName = @"button_icon_close.png";
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [self.navigationItem setLeftBarButtonItem:closeItem];
    
    
    //定位：
//        1.调用手机的定位功能获取到当前用户所在位置的经纬度
//        2.根据经纬度进行位置反编码（sinaAPI）

    _locationManager = [[CLLocationManager alloc] init];

    //iOS8以后需要询问用户是否授予访问其位置信息的权限
//        「永不」
//        「使用应用程序期间」NSLocationWhenInUseUsageDescription
//         「始终」NSLocationAlwaysUsageDescription
    


    if (kiOS8Later) {
        //请求用户授予我定位的权限
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //设置定位的精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //设置代理
    _locationManager.delegate = self;
    
    //开始定位
    [_locationManager startUpdatingLocation];

}

#pragma mark - CLLocationManagerDelegate 
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //NSLog(@"定位成功");
    
    //停止定位
    [_locationManager stopUpdatingLocation];
    
    
    //NSLog(@"%@", locations);
    
    //获取经度和纬度
    CLLocation *location = [locations lastObject];
    
    CGFloat longitude = location.coordinate.longitude;
    CGFloat latitude = location.coordinate.latitude;
    
    
    
    NSDictionary *params = @{
                             @"lat" : [NSString stringWithFormat:@"%f", latitude],
                             @"long" : [NSString stringWithFormat:@"%f", longitude]
                             
                             };
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //发送网络请求获取到微博列表
     [delegate.sinaweibo requestWithURL:@"place/nearby/pois.json" params:[params mutableCopy] httpMethod:@"GET" delegate:self];
    
    
    //苹果自带的控件也可以实现位置反编码
//    CLGeocoder *coder = [[CLGeocoder alloc] init];
//    
//    [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        
//        CLPlacemark *mark = [placemarks lastObject];
//        
//        //NSLog(@"%@", mark.addressDictionary);
//        
//        [mark.addressDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            
//            NSLog(@"%@:%@", key, obj);
//            
//        }];
//        
//    }];
    
    
    
}


#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    NSLog(@"%@", result);
    
    NSArray *poisArray = result[@"pois"];
    
    
    //数据源的过滤，因有时新浪提供的数据会为NSNull
    for (NSDictionary *poisDic in poisArray) {
    
        NSString *address = poisDic[@"address"];
        
        if ([address isKindOfClass:[NSString class]] && address.length > 0) {
            [_locations addObject:poisDic];
        }
        
    }
    

    [self.tableView reloadData];
    
    
}

#pragma mark - 按钮事件
//关闭
- (void)closeAction {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _locations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell" forIndexPath:indexPath];
    
    
    NSDictionary *locationDic = _locations[indexPath.row];
    //获取到地址信息
    

    NSString *address = locationDic[@"address"];
    

    cell.textLabel.text = address;

    
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *locationDic = _locations[indexPath.row];
    
    
    NSString *address = locationDic[@"address"];
    
    //回调block
    if (self.locationBlock) {
        self.locationBlock(address);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

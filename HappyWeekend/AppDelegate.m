//
//  AppDelegate.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoverViewController.h"
#import "MineViewController.h"
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
//1.引入定位所需的框架
#import <CoreLocation/CoreLocation.h>
//5.遵循定位代理协议
@interface AppDelegate ()<WeiboSDKDelegate, CLLocationManagerDelegate>
{
    //2.创建定位所需要的类的实例对象
    CLLocationManager *_locationManager;
    //创建地理编码对象
    CLGeocoder *_geocoder;
    MainViewController *_mainV;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    //注册微信id
    [WXApi registerApp:@"wxdf5b03f317f665da" withDescription:@"微信id"];
    //注册bmob
    [Bmob registerWithAppKey:kBmobKey];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //3.初始化定位对象
    _locationManager = [[CLLocationManager alloc] init];
    //初始化地理编码对象
    _geocoder = [[CLGeocoder alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NXXLog(@"用户位置服务不可用");
    }
    //4.如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //设置代理
        _locationManager.delegate = self;
        //设置定位精度,定位精度越高越耗电
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 100.0;
        _locationManager.distanceFilter = distance;
        //启动定位服务
        [_locationManager startUpdatingLocation];
    }
    
    
    //UITabBarController
    self.tabBarController = [[UITabBarController alloc] init];
    //创建被tabBarVC管理的视图控制器
    //主页
    //欢乐周末
    UIStoryboard *mainStroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *mainNav = mainStroyBoard.instantiateInitialViewController;
    mainNav.tabBarItem.image = [UIImage imageNamed:@"ft_home_normal_ic"];
    UIImage *selectedImage = [UIImage imageNamed:@"ft_home_selected_ic"];
    mainNav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //调整tabBar显示位置 (上,左,下,右)的顺序设置
    mainNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //发现
    UIStoryboard *discoverStroyBoard = [UIStoryboard storyboardWithName:@"Discover" bundle:nil];
    UINavigationController *discoverNav = discoverStroyBoard.instantiateInitialViewController;
    discoverNav.tabBarItem.image = [UIImage imageNamed:@"ft_found_normal_ic"];
    UIImage *discoverImage = [UIImage imageNamed:@"ft_found_selected_ic"];
    discoverNav.tabBarItem.selectedImage = [discoverImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoverNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    //我的
    UIStoryboard *mineStroyBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    UINavigationController *mineNav = mineStroyBoard.instantiateInitialViewController;
    mineNav.tabBarItem.image = [UIImage imageNamed:@"ft_person_normal_ic"];
    //选中的图片效果
    UIImage *mineImage = [UIImage imageNamed:@"ft_person_selected_ic"];
    mineNav.tabBarItem.selectedImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //添加被管理的视图控制器
    self.tabBarController.viewControllers = @[mainNav, discoverNav, mineNav];
    self.tabBarController.tabBar.barTintColor = [UIColor whiteColor];
    self.window.rootViewController = self.tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark  -------- CLLocationManagerDelegate
/*
 定位协议代理方法
 manager 返回当前使用的定位对象
 locations 返回定位的数据,是一个数组对象,数组里边元素是CLLocation类型
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NXXLog(@"%@", locations);
    //从数组中取出一个定位的信息
    CLLocation *location = [locations lastObject];
    //从CLLocation中取出坐标
    //CLLocationCoordinate2D 坐标系 里边包含经度和纬度
    CLLocationCoordinate2D coordinate = location.coordinate;
    NXXLog(@"纬度:%f 经度:%f 海拔:%f 航向:%f 行走速度:%f", coordinate.latitude, coordinate.longitude, location.altitude, location.course, location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks lastObject];
        NSLog(@"%@", placeMark.addressDictionary);
    }];
    //如果不需要使用定位服务的时候,及时关闭定位服务
    [manager stopUpdatingLocation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
}

@end

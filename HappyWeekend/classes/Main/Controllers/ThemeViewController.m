//
//  ThemeViewController.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/6.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "ThemeViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ActivityThemeView.h"

@interface ThemeViewController ()
@property(nonatomic, strong) ActivityThemeView *themeView;
@end

@implementation ThemeViewController
- (void)loadView{
    [super loadView];
    self.themeView = [[ActivityThemeView alloc] initWithFrame:self.view.frame];
    self.view = self.themeView;
    [self getModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"热门专题";
    self.tabBarController.tabBar.hidden = YES;
    [self showBackButtonWithImage:@"back"];
}
#pragma mark   -----------  CustomMethod
- (void)getModel{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManager GET:[NSString stringWithFormat:KActivityTheme, self.themeId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        NXXLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            self.themeView.dataDic = dic[@"success"];
            self.themeView.title = dic[@"success"][@"title"];
        } else {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NXXLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

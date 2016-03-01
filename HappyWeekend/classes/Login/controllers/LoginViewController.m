//
//  LoginViewController.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/15.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>

@interface LoginViewController ()
- (IBAction)openWY:(id)sender;
- (IBAction)addAction:(id)sender;
- (IBAction)deleteData:(id)sender;
- (IBAction)modeifyData:(id)sender;
- (IBAction)QueryData:(id)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = defaultColor;
    [self showBackButtonWithImage:@"back"];
}
- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)openWY:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"myapp://"]];
}

- (IBAction)addAction:(id)sender {
    //往User表添加一条user_name，user_age,user
    BmobObject *user = [BmobObject objectWithClassName:@"MemberUser"];
    [user setObject:@"小明" forKey:@"user_Name"];
    [user setObject:@18 forKey:@"user_Age"];
    [user setObject:@"女" forKey:@"user_Gender"];
    [user setObject:@"18860255643" forKey:@"user_cellPhone"];
    [user setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
        NXXLog(@"恭喜注册成功!");
    }];
}

- (IBAction)deleteData:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"GameScore"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"0c6db13c" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];
}

- (IBAction)modeifyData:(id)sender {
}

- (IBAction)QueryData:(id)sender {
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"MemberUser"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"0c6db13c" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *userName = [object objectForKey:@"user_Name"];
                NSString *cellPhone = [object objectForKey:@"user_cellPhone"];
                NSLog(@"%@----%@",userName,cellPhone);
            }
        }
    }];
}
@end

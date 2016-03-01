//
//  MineViewController.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MineViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <UIImageView+WebCache.h>
#import "ProgressHUD.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "ShareView.h"
#import "LoginViewController.h"


@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) ShareView *shareView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *headImageButton;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) UILabel *nikeNameLabel;

@end

@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //每次当页面要出现的时候重新计算图片缓存大小
    //计算图片缓存
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.02fM)", (double)cacheSize / 1024 / 1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = defaultColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.tableView];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存",  @"用户反馈", @"当前版本1.0", @"给我评分", @"分享给朋友", nil];
    self.imageArray = @[@"clear",@"user", @"banben",@"value", @"share"];
    [self setUpTableViewHeaderView];
    
}

#pragma mark      ------------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageArray.count;
}
#pragma mark      ------------ UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //清除缓存
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case 1:
        {
            //发送邮件
            [self sendEmail];
        }
            break;
        case 2:
        {
            //检测新版本
            [ProgressHUD show:@"正在为你检测"];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
            
        }
            break;
        case 3:
        {
            //appStore评分
            NSString *str = [NSString stringWithFormat:
                             @"itms-apps://itunes.apple.com/app"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
        {
            [self share];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark      ------------ Custom Method
- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"恭喜你!当前已是最新版本"];
}
- (void)setUpTableViewHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 210)];
    headView.backgroundColor = defaultColor;
    [headView addSubview:self.headImageButton];
    [headView addSubview:self.nikeNameLabel];
    self.tableView.tableHeaderView = headView;
}
- (void)login{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UINavigationController *nav = storyBoard.instantiateInitialViewController;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
//分享到微博
- (void)share{
    self.shareView = [[ShareView alloc] initWithFrame:self.view.frame];
}

- (void)sendEmail{
    //初始化
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //设置代理
    picker.mailComposeDelegate = self;
    //设置主题
    [picker setSubject:@"用户反馈"];
    //设置收件人
    NSArray *recive = [NSArray arrayWithObjects:@"1498146887@qq.com", nil];
    [picker setToRecipients:recive];
    //设置发送内容
    NSString *text = @"请留下您宝贵的意见";
    [picker setMessageBody:text isHTML:NO];
    //推出视图
    [self presentViewController:picker animated:YES completion:nil];
}
//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"用户取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"用户成功保存邮件";
            break;
        case MFMailComposeResultSent:
            msg = @"用户点击发送，将邮件放到队列中，还没发送";
            break;
        case MFMailComposeResultFailed:
            msg = @"用户试图保存或者发送邮件失败";
            break;
        default:
            msg = @"";
            break;
    }
}

#pragma mark      ------------ Lazy Loading
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHieght - 64 - 44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (UIButton *)headImageButton{
    if (_headImageButton == nil) {
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.frame = CGRectMake(30, 40, 130, 130);
        self.headImageButton.layer.borderWidth = 10;
        self.headImageButton.layer.borderColor = [UIColor colorWithRed:96 / 255.0 green:185 / 255.0 blue:191 / 255.0 alpha:0.6].CGColor;
        [self.headImageButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [self.headImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
        self.headImageButton.imageView.image = [UIImage imageNamed:@""];
        self.headImageButton.backgroundColor = [UIColor whiteColor];
        [self.headImageButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        self.headImageButton.layer.cornerRadius = 65;
    }
    return _headImageButton;
}
- (UILabel *)nikeNameLabel{
    if (_nikeNameLabel == nil) {
        self.nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 75, kScreenWidth - 200, 60)];
        self.nikeNameLabel.numberOfLines = 0;
        self.nikeNameLabel.text= @"欢迎来到欢乐周末!";
        self.nikeNameLabel.textColor = [UIColor whiteColor];
    }
    return _nikeNameLabel;
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

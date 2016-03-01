//
//  DiscoverViewController.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "ActivityDetailViewController.h"

@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *likeArray;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView launchRefreshing];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark --------UITableViewDatasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.discoverModel = self.likeArray[indexPath.row];
    //M_PI 180°
    //cell.transform = CGAffineTransformMakeRotation(M_PI / 2);
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.likeArray.count;
}

#pragma mark --------UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActivityDetailViewController *activityDetailVC = [storyBoard instantiateViewControllerWithIdentifier:@"activityDetail"];
    Discover *model = self.likeArray[indexPath.row];
    activityDetailVC.activityId = model.activityId;
    [self.navigationController pushViewController:activityDetailVC animated:YES];
}

#pragma mark --------  PullingRefreshTableViewDelegate
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}
#pragma mark --------  Custom Method
- (void)loadData{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [ProgressHUD show:@"拼命加载中..."];
    [sessionManager GET:kDiscover parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *array = successDic[@"like"];
            if (self.likeArray.count > 0) {
                [self.likeArray removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                [self.likeArray addObject:[[Discover alloc] initWithDictionary:dic]];
            }
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"数据被怪兽吃了"];
    }];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
#pragma mark --------  Lazy Loading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHieght - 64) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        //设置只能下拉刷新
        self.tableView.headerOnly = YES;
        self.tableView.rowHeight = 128;
    }
    return _tableView;
}
- (NSMutableArray *)likeArray{
    if (_likeArray == nil) {
        self.likeArray = [NSMutableArray new];
    }
    return _likeArray;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
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

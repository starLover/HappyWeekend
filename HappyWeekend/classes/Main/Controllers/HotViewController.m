//
//  HotViewController.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/6.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "HotViewController.h"
#import "PullingRefreshTableView.h"
#import "HotActivityTableViewCell.h"
#import "ThemeViewController.h"
#import <AFHTTPSessionManager.h>

@interface HotViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) HotActivityTableViewCell *hotActivityCell;
@property(nonatomic, strong) NSMutableArray *acArray;

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"热门专题";
    [self showBackButton];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 190;
    [self.tableView registerNib:[UINib nibWithNibName:@"HotActivityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self loadData];
}
#pragma mark      --------TableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.hotActivityCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    self.hotActivityCell.dataDic = self.acArray[indexPath.row];
    return self.hotActivityCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.acArray.count;
}
#pragma mark   -----------   UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ThemeViewController *themeVC = [[ThemeViewController alloc] init];
    themeVC.themeId = self.acArray[indexPath.row][@"id"];
    [self.navigationController pushViewController:themeVC animated:YES];
}
#pragma mark    ----------- PullingRefreshDelegate
//tableView下拉刷新开始的时候调用
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//tableView上拉加载开始的时候使用
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
}
//刷新完成时间
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [HWTools getSystemNowDate];
}
- (void)loadData{
    AFHTTPSessionManager *sessionManger = [AFHTTPSessionManager manager];
    sessionManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionManger GET:[NSString stringWithFormat:KHotActivity, _pageCount] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSString *status = dic[@"status"];
        NSInteger code = [dic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *array = successDic[@"rcData"];
            for (NSDictionary *dic in array) {
                [self.acArray addObject:dic];
            }
        }
        [self.tableView reloadData];
    } failure:nil];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}


#pragma mark   ------------    LazyLoading
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHieght - 64) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}
- (NSMutableArray *)acArray{
    if (_acArray == nil) {
        self.acArray = [NSMutableArray new];
    }
    return _acArray;
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

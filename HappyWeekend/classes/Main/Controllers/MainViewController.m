//
//  MainViewController.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "MainModel.h"
#import "SearchViewController.h"
#import "SelectCityViewController.h"
#import "ThemeViewController.h"
#import "ClassifyViewController.h"
#import "ActivityDetailViewController.h"
#import "GoodViewController.h"
#import "HotViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "AppDelegate.h"

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *TableView;
//全部列表数据
@property(nonatomic, strong) NSMutableArray *listArray;
//推荐活动数据
@property(nonatomic, strong) NSMutableArray *activityArray;
//推荐专题数据
@property(nonatomic, strong) NSMutableArray *themeArray;
@property(nonatomic, strong) NSMutableArray *adArray;
@property(nonatomic, strong) UIScrollView *carouseView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UIButton *activityBtn;
@property(nonatomic, strong) UIButton *themeBtn;
//定时器用于图片滚动播放
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    //     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:96.0 / 255.0f green:185.0 / 255.0f blue:191.0 / 255.0f alpha:1.0];
    
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"北京" style:UIBarButtonItemStylePlain target:self action:@selector(selectCityAction:)];
    leftBarBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    //right
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn setImage:[UIImage imageNamed:@"btn_search"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(searchCityAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    //注册cell
    [self.TableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self configTableViewHeadView];
    //网络请求
//    [self request];
    //启动定时器
    [self startTimer];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

#pragma mark -------  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.activityArray.count;
    }
    return self.themeArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*另外要注意的：
     1、dequeueReuseableCellWithIdentifier:与dequeueReuseableCellWithIdentifier:forIndexPath:的区别：
     前者不必向tableView注册cell的Identifier，但需要判断获取的cell是否为nil；
     后者则必须向table注册cell，可省略判断获取的cell是否为空，因为无可复用cell时runtime将使用注册时提供的资源去新建一个cell并返回
     
     2、自定义cell时，记得将其他内容加到self.contentView 上，而不是直接添加到 cell 本身上
     */
    MainTableViewCell *mainCell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *array = self.listArray[indexPath.section];
    mainCell.model = array[indexPath.row];
    return mainCell;
}
#pragma mark -------  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 203;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
//自定义分区头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    UIImageView *sectionView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 160, 5, 320, 16)];
    if (section == 0) {
        sectionView.image = [UIImage imageNamed:@"home_recommed_ac"];
    } else {
        sectionView.image = [UIImage imageNamed:@"home_recommd_rc"];
    }
    [view addSubview:sectionView];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MainModel *mainModel = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        ActivityDetailViewController *activityVC = [storyBoard instantiateViewControllerWithIdentifier:@"activityDetail"];
        activityVC.activityId = mainModel.activityId;
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        ThemeViewController *themrVC = [[ThemeViewController alloc] init];
        //当推出的时候隐藏
//        themrVC.hidesBottomBarWhenPushed = YES;
        themrVC.themeId = mainModel.activityId;
        [self.navigationController pushViewController:themrVC animated:YES];
    }
}

#pragma mark  ----------CityCustom
//选择城市
- (void)selectCityAction:(UIBarButtonItem *)btn{
    SelectCityViewController *selectCityVC = [[SelectCityViewController alloc] init];
    [self.navigationController presentViewController:selectCityVC animated:YES completion:nil];
}
//搜索关键字
- (void)searchCityAction:(UIBarButtonItem *)btn{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
//自定义tableView头部
- (void)configTableViewHeadView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 343)];
    self.TableView.tableHeaderView = view;
    [view addSubview:self.carouseView];
    for (int i = 0; i < self.adArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, 186)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.adArray[i][@"url"]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        [self.carouseView addSubview:imageView];
        
        //
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 100 + i;
        [touchBtn addTarget:self action:@selector(touchAdvertiseMent:) forControlEvents:UIControlEventTouchUpInside];
        [self.carouseView addSubview:touchBtn];
    }
    self.pageControl.numberOfPages = self.adArray.count;
    [view addSubview:self.pageControl];
    
    
    //按钮
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * kScreenWidth / 4, 186, kScreenWidth / 4, kScreenWidth / 4);
        NSString *imageStr = [NSString stringWithFormat:@"home_icon_%d", i + 1];
        [btn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(mainActivityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    //精选活动&热门专题
    [view addSubview:self.activityBtn];
    [view addSubview:self.themeBtn];
}
#pragma mark     -------网络请求
- (void)request{
    NSString *urlString = kMainDatalist;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NXXLog(@"%lld", downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NXXLog(@"%@", responseObject);
        NSDictionary *resultDic = responseObject;
        NSString *status = resultDic[@"status"];
        NSInteger code = [resultDic[@"code"] integerValue];
        if ([status isEqualToString:@"success"] && code == 0) {
            NSDictionary *dic = resultDic[@"success"];
            //推荐活动
            NSArray *acDataArray = dic[@"acData"];
            for (NSDictionary *dic in acDataArray) {
                MainModel *model = [MainModel getDictionary:dic];
                [self.activityArray addObject:model];
            }
            [self.listArray addObject:self.activityArray];
            //推荐专题
            NSArray *rcDataArray = dic[@"rcData"];
            for (NSDictionary *dic in rcDataArray) {
                MainModel *model = [MainModel getDictionary:dic];
                [self.themeArray addObject:model];
            }
            [self.listArray addObject:self.themeArray];
            //刷新tableView数据
            [self.TableView reloadData];
            //广告
            NSArray *adDataArray = dic[@"adData"];
            for (NSDictionary *dic in adDataArray) {
                NSDictionary *dict = @{@"url" : dic[@"url"], @"type" : dic[@"type"], @"id" : dic[@"id"]};
                [self.adArray addObject:dict];
            }
            //拿到数据之后重新刷新headView
            [self configTableViewHeadView];
            //以请求回来的城市作为导航栏按钮标题
            NSString *cityName = dic[@"cityname"];
            self.navigationItem.leftBarButtonItem.title = cityName;
        } else {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NXXLog(@"%@", error);
    }];
}
#pragma mark --------   轮播图
//启动定时器
- (void)startTimer{
    //防止定时器重复创建
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(rollAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
//每2秒执行一次,图片自动轮播
- (void)rollAnimation{
    //self.adArray.count数组元素个数可能为0,当对0取于的时候没有意义
    if (self.adArray.count > 0) {
        //把page当前页加1
        NSInteger page = (self.pageControl.currentPage + 1) % self.adArray.count;
        self.pageControl.currentPage = page;
        //计算出scrollView应该滚动的x轴坐标
        CGFloat offsetX = page * kScreenWidth;
        [self.carouseView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        
    }
}

//当手动滑动scrollView的时候,定时器依然在计算时间,可能我们刚刚滑动到下一页,定时器时间刚好有触发,导致在当前页停留的时间不够2秒
//解决方案  在scrollView开始移动的时候结束定时器
//在scrollView移动完毕的时候再启动定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器
    [_timer invalidate], _timer = nil;//停止定时器后并置为nil,重新启动定时器才能保证正常执行
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
//分类列表
- (void)mainActivityButtonAction:(UIButton *)btn{
    ClassifyViewController *classify = [[ClassifyViewController alloc] init];
    [self.navigationController pushViewController:classify animated:YES];
}
//精选活动
- (void)goodActivityButton{
    GoodViewController *goodVC = [[GoodViewController alloc] init];
    [self.navigationController pushViewController:goodVC animated:YES];
}
//热门专题
- (void)hotActivityButton{
    HotViewController *hotVC = [[HotViewController alloc] init];
    [self.navigationController pushViewController:hotVC animated:YES];
}
//点击广告
- (void)touchAdvertiseMent:(UIButton *)adButton{
    //从数组中的字典里取出type类型
    NSString *type = self.adArray[adButton.tag - 100][@"type"];
    if ([type integerValue] == 1) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActivityDetailViewController *activityVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"activityDetail"];
        //活动id
        activityVC.activityId = self.adArray[adButton.tag - 100][@"id"];
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        ThemeViewController *themeVC = [[ThemeViewController alloc] init];
        themeVC.themeId = self.adArray[adButton.tag - 100][@"id"];
        [self.navigationController pushViewController:themeVC animated:YES];
    }
}

#pragma mark   ---------  ArrayLoading
//懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (NSMutableArray *)activityArray{
    if (_activityArray == nil) {
        self.activityArray = [NSMutableArray new];
    }
    return _activityArray;
}
- (NSMutableArray *)themeArray{
    if (_themeArray == nil) {
        self.themeArray = [NSMutableArray new];
    }
    return _themeArray;
    
}
- (NSMutableArray *)adArray{
    if (_adArray == nil) {
        self.adArray = [NSMutableArray new];
    }
    return _adArray;
}
- (UIScrollView *)carouseView{
    if (_carouseView == nil) {
        //添加轮播图
        self.carouseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
        self.carouseView.contentSize = CGSizeMake(kScreenWidth * self.adArray.count, 186);
        //整平滑动
        self.carouseView.pagingEnabled = YES;
        //到边界是否能继续滑动
        self.carouseView.bounces = NO;
        //不显示水平方向滚动条
        self.carouseView.showsHorizontalScrollIndicator = NO;
        self.carouseView.delegate = self;
    }
    return _carouseView;
}
- (UIButton *)themeBtn{
    if (_themeBtn == nil) {
        self.themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.themeBtn.frame = CGRectMake(kScreenWidth / 2, 186, kScreenWidth / 2, 343 - 186 + kScreenWidth / 4);
        [self.themeBtn setImage:[UIImage imageNamed:@"home_zhuanti@2x(1)"] forState:UIControlStateNormal];
        self.themeBtn.tag = 105;
        [self.themeBtn addTarget:self action:@selector(hotActivityButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _themeBtn;
}
- (UIButton *)activityBtn{
    if (_activityBtn == nil) {
        self.activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.activityBtn.frame = CGRectMake(0, 186, kScreenWidth / 2, 343 - 186 + kScreenWidth / 4);
        [self.activityBtn setImage:[UIImage imageNamed:@"home_huodong@2x(1)"] forState:UIControlStateNormal];
        self.activityBtn.tag = 104;
        [self.activityBtn addTarget:self action:@selector(goodActivityButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityBtn;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        //创建小圆点
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 186 - 30, kScreenWidth, 30)];
        self.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
        [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pageControl;
}

#pragma mark  -------  首页轮播图
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //第一步：获取scrollView页面的宽度
    CGFloat pageWidth = self.carouseView.frame.size.width;
    //第二步：获取scrollView停止时的偏移量
    //contentOffset是当前scrollView距离原点偏移的位置
    CGPoint offset = scrollView.contentOffset;
    //第三步：通过偏移量和页面宽度计算出当前页数
    NSInteger pageNumber = offset.x / pageWidth;
    self.pageControl.currentPage = pageNumber;
}

- (void)pageSelectAction:(UIPageControl *)pageControl{
    //第一步：获取pageControl当前页
    NSInteger pageNumber = self.pageControl.currentPage;
    //第二步：获取页面的宽度
    CGFloat pageWidth = self.carouseView.frame.size.width;
    //第三步：让scrollView滚动到第几页
    self.carouseView.contentOffset = CGPointMake(pageNumber * pageWidth, 0);
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

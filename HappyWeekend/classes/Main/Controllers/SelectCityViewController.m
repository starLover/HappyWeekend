//
//  SelectCityViewController.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/6.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "SelectCityViewController.h"
#import "headerView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"


static NSString *itemIdentifier = @"itemIdentifier";
static NSString *headIdentifier = @"headIdentifier";

@interface SelectCityViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, retain) NSMutableArray *cityListArray;
@property(nonatomic, retain) headerView *headView;
@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.title = @"切换城市";
    [self showBackButtonWithImage:@"camera_cancel_up"];
    self.navigationController.navigationBar.barTintColor = defaultColor;
    [self.view addSubview:self.collectionView];
    [self loadData];
}


#pragma mark     ------ Custom Method
- (void)backButtonAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadData{
    AFHTTPSessionManager *sessionmangager = [AFHTTPSessionManager manager];
    sessionmangager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [sessionmangager GET:kCityList parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"数据已为您加载"];
        NSDictionary *dic = responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *status = dic[@"status"];
        if (code == 0 && [status isEqualToString:@"success"]) {
            NSDictionary *successDic = dic[@"success"];
            NSArray *listArray = successDic[@"list"];
            for (NSDictionary *dict in listArray) {
                [self.cityListArray addObject:dict[@"cat_name"]];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
    }];
}
#pragma mark  -------- collectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.cityListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = self.cityListArray[indexPath.row];
    [cell addSubview:titleLabel];
    return cell;
}

//header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];
        self.headView.cityName = self.city;
        reusableView = self.headView;
    }
    return reusableView;
}
//选择
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.headView.cityName = self.cityListArray[indexPath.row];
    [self.delegate changeCity:self.cityListArray[indexPath.row]];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark   --------   Lazyloading
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //创建一个layout布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向(默认垂直方向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每一行的间距
        layout.minimumLineSpacing = 1;
        //设置item的间距
        layout.minimumInteritemSpacing = 1;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //设置每个item的大小
        layout.itemSize = CGSizeMake((kScreenWidth - 12) / 3, kScreenWidth / 6 - 10);
        //通过一个layout布局来创建一个collectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHieght) collectionViewLayout:layout];
        
        layout.headerReferenceSize = CGSizeMake(kScreenWidth, 137);
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
        //注册item类型
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIdentifier];
        //header
        [self.collectionView registerNib:[UINib nibWithNibName:@"headerView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier];
    }
    return _collectionView;
}
- (NSMutableArray *)cityListArray{
    if (_cityListArray == nil) {
        self.cityListArray = [NSMutableArray new];
    }
    return _cityListArray;
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

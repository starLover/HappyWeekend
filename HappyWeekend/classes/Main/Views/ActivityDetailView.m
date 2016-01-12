//
//  ActivityDetailView.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/7.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "ActivityDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityDetailView ()
{
    //保存上一个图片底部的高度
    CGFloat PreviousImageBottom;
}
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *favourateLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityPlaceLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityPhoneLabel;

@end

@implementation ActivityDetailView
//set方法赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    //活动图片
    NSArray *urls = dataDic[@"urls"];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urls[0]] placeholderImage:nil];
    //活动标题
    self.activityLabel.text = dataDic[@"title"];
    //多少人已经收藏
    self.favourateLabel.text = [NSString stringWithFormat:@"%@人已收藏", dataDic[@"fav"]];
    //活动价格
    self.activityPriceLabel.text = dataDic[@"price"];
    //活动地址
    self.activityPlaceLabel.text = dataDic[@"address"];
    //活动电话
    self.activityPhoneLabel.text = dataDic[@"tel"];
    //活动起始时间
    NSString *startTime = [HWTools getDateFromString: dataDic[@"new_start_date"]];
    NSString *endTime = [HWTools getDateFromString:dataDic[@"new_end_date"]];
    self.activityTimeLabel.text = [NSString stringWithFormat:@"正在进行：%@-%@", startTime, endTime];
    //
    [self drawContentWithArray:dataDic[@"content"]];
    
}
- (void)drawContentWithArray:(NSArray *)contentArray{
    PreviousImageBottom = 500;
    for (NSDictionary *dic in contentArray) {
        //如果标题存在,标题的高度应该是上次图片底部的高度
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, PreviousImageBottom, kScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候,高度的坐标应该再加30,也就是标题的高度
            PreviousImageBottom += 30;
        }
        PreviousImageBottom += 10;
        CGFloat height = [HWTools getTextHeightWithBigSize:dic[@"description"] bigSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, PreviousImageBottom, kScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        
        PreviousImageBottom += height + 10;
        
        NSArray *urlArray = dic[@"urls"];
        //        if (urlArray == nil) {
        //            //当某一个段落中没有图片的时候,上次图片的高度用上次label的底部高度+10
        //            PreviousImageBottom = label.bottom + 10;
        //        } else {
        for (NSDictionary *dic in urlArray) {
            CGFloat width = [dic[@"width"] integerValue];
            CGFloat imageHeight = [dic[@"height"] integerValue];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, PreviousImageBottom, kScreenWidth - 20, (kScreenWidth - 20) / width * imageHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]] placeholderImage:nil];
            [self.mainScrollView addSubview:imageView];
            //每次都保留最新的图片底部高度
            PreviousImageBottom = imageView.bottom + 10;
        }
    }
    //    }
    [self awakeFromNib];
}



- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(0, PreviousImageBottom + 20);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

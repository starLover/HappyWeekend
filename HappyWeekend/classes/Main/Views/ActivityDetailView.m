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
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    self.activityLabel.text = dataDic[@"title"];
    self.favourateLabel.text = [NSString stringWithFormat:@"%@人已收藏", dataDic[@"fav"]];
    self.activityPriceLabel.text = dataDic[@"price"];
    self.activityPlaceLabel.text = dataDic[@"address"];
    self.activityPhoneLabel.text = dataDic[@"tel"];
}
- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(0, 1000);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

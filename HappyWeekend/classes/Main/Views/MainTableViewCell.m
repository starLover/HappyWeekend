//
//  MainTableViewCell.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/4.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MainTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableViewCell ()
//活动图片
@property (strong, nonatomic) IBOutlet UIImageView *activityImageView;
//活动名字
@property (strong, nonatomic) IBOutlet UILabel *activityNameLabel;
//活动价格
@property (strong, nonatomic) IBOutlet UILabel *activityPriceLabel;
//活动地址
@property (strong, nonatomic) IBOutlet UIButton *activityDistaneBtn;

@end
@implementation MainTableViewCell
//获取cell时若无可重用cell，将创建新的cell并调用其中的awakeFromNib方法，可通过重写这个方法添加更多页面内容
- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(MainModel *)model{
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:model.image_big] placeholderImage:nil];
    self.activityNameLabel.text = model.title;
    self.activityPriceLabel.text = model.price;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

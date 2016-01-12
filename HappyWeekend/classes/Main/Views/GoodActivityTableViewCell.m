//
//  GoodActivityTableViewCell.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "GoodActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GoodActivityTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *loveCountButton;
@property (strong, nonatomic) IBOutlet UIImageView *ageImageView;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@end

@implementation GoodActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kScreenWidth, 90);
}
- (void)setGoodModel:(GoodModel *)goodModel{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:goodModel.image] placeholderImage:nil];
    self.headImageView.layer.cornerRadius = 20;
    self.activityTitleLabel.text = goodModel.title;
    self.activityPriceLabel.text = goodModel.price;
    self.activityDistanceLabel.text = goodModel.address;
    [self.loveCountButton setTitle:[NSString stringWithFormat:@"%@", goodModel.counts] forState:UIControlStateNormal];
    self.ageLabel.text = goodModel.age;
    self.ageLabel.layer.borderWidth = 1.0;
    self.ageLabel.layer.cornerRadius = 12.5;
    self.ageLabel.layer.borderColor = [UIColor blueColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

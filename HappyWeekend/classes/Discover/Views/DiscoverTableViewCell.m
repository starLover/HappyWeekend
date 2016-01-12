//
//  DiscoverTableViewCell.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/12.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "DiscoverTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface DiscoverTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DiscoverTableViewCell

- (void)setDiscoverModel:(Discover *)discoverModel{
    self.headImage.layer.cornerRadius = 20;
    self.headImage.clipsToBounds = YES;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:discoverModel.image] placeholderImage:nil];
    self.titleLabel.text = discoverModel.title;
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

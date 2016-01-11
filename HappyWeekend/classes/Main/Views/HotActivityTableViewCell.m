//
//  HotActivityTableViewCell.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/9.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "HotActivityTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface HotActivityTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UIButton *loveCountBtn;

@end

@implementation HotActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"img"]] placeholderImage:nil];
    [self.loveCountBtn setTitle:[NSString stringWithFormat:@"%@", dataDic[@"counts"]] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

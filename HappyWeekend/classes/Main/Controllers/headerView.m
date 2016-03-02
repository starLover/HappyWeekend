//
//  headerView.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/3/1.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "headerView.h"

@interface headerView ()
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@end
@implementation headerView
- (void)setCityName:(NSString *)cityName{
    self.locationLabel.text = cityName;
}

@end

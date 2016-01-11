//
//  HWTools.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/7.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "HWTools.h"

@implementation HWTools
+ (NSString *)getDateFromString:(NSString *)timeStamp{
    NSTimeInterval timeInterval = [timeStamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *time = [formatter stringFromDate:date];
    return time;
}
+ (CGFloat)getTextHeightWithBigSize:(NSString *)text bigSize:(CGSize)bigSize textFont:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}
+ (NSDate *)getSystemNowDate{
    //创建一个NSDataFormatter显示刷新时间
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}
@end

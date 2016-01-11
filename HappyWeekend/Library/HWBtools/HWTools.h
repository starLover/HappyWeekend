//
//  HWTools.h
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/7.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWTools : NSObject

#pragma mark   ------    时间转换相关的方法
//根据指定时间戳返回字符串类型时间
+ (NSString *)getDateFromString:(NSString *)timeStamp;
//获取系统当前时间
+ (NSDate *)getSystemNowDate;

#pragma mark   ------    根据文字最大显示宽高和文字内容返回文字高度
+ (CGFloat)getTextHeightWithBigSize:(NSString *)text bigSize:(CGSize)bigSize textFont:(CGFloat)font;
@end

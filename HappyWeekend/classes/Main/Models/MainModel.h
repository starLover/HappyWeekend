//
//  MainModel.h
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/5.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    RecomendTypeActivity = 1,          //推荐活动
    RecomendTypeTheme                  //推荐专题
}RecomendType;

@interface MainModel : NSObject
@property(nonatomic, copy) NSString *image_big;   //首页大图
@property(nonatomic, copy) NSString *title;       //标题
@property(nonatomic, copy) NSString *price;       //价格
@property(nonatomic, assign) CGFloat lat;         //经纬度
@property(nonatomic, assign) CGFloat lng;         //经纬度
@property(nonatomic, copy) NSString *address;     //地点
@property(nonatomic, copy) NSString *counts;      //总数
@property(nonatomic, copy) NSString *startTime;   //开始时间
@property(nonatomic, copy) NSString *endTime;     //结束时间
@property(nonatomic, copy) NSString *activityId;  //活动id
@property(nonatomic, copy) NSString *type;        //类型
@property(nonatomic, copy) NSString *activityDescription; //描述
+ (MainModel *)getDictionary:(NSDictionary *)dic;
@end

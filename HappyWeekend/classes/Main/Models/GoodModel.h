//
//  GoodModel.h
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodModel : NSObject
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *price;       //价格
@property(nonatomic, copy) NSString *address;     //地点
@property(nonatomic, copy) NSString *counts;      //总数
@property(nonatomic, copy) NSString *type;        //类型
@property(nonatomic, copy) NSString *activityId;
- (instancetype)initWithDicticionary:(NSDictionary *)dict;
@end

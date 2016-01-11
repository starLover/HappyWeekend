//
//  GoodModel.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "GoodModel.h"

@implementation GoodModel

- (instancetype)initWithDicticionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.image = dict[@"image"];
        self.age = dict[@"age"];
        self.counts = dict[@"counts"];
        self.price = dict[@"price"];
        self.activityId = dict[@"id"];
        self.address = dict[@"address"];
    }
    return self;
}
@end

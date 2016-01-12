//
//  Discover.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/12.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "Discover.h"

@implementation Discover
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.activityId = dict[@"id"];
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.type = dict[@"type"];
    }
    return self;
}
@end

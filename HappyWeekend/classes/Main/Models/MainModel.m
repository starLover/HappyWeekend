//
//  MainModel.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/5.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "MainModel.h"

@implementation MainModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        //如果是推荐活动
        self.type = dic[@"type"];
        if ([self.type integerValue] == RecomendTypeActivity) {
            self.price = dic[@"price"];
            self.lat = [dic[@"lat"] floatValue];
            self.lng = [dic[@"lng"] floatValue];
            self.address = dic[@"address"];
            self.counts = dic[@"counts"];
            self.startTime = dic[@"startTime"];
            self.endTime = dic[@"endTime"];
        } else {
            //如果是推荐专题
            self.activityDescription = dic[@"description"];
        }
        self.image_big = dic[@"image_big"];
        self.title = dic[@"title"];
        self.activityId = dic[@"id"];
    }
    return self;
}
+ (MainModel *)getDictionary:(NSDictionary *)dic{
    MainModel *mainModel = [[MainModel alloc] initWithDictionary:dic];
    return mainModel;
}
@end

//
//  Discover.h
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/12.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Discover : NSObject
@property(nonatomic, copy) NSString *activityId;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *type;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

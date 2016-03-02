//
//  SelectCityViewController.h
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/6.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeCity <NSObject>

- (void)changeCity:(NSString *)cityName;

@end

@interface SelectCityViewController : UIViewController
@property(nonatomic, copy) NSString *city;
@property(nonatomic, assign) id<changeCity>delegate;
@end

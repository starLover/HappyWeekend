//
//  ActivityDetailView.h
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/7.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailView : UIView
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) IBOutlet UIButton *makeCallButton;
@property(nonatomic, strong) NSDictionary *dataDic;
@end

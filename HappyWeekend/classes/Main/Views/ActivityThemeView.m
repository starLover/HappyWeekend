//
//  ActivityThemeView.m
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/8.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#import "ActivityThemeView.h"
#import <UIImageView+WebCache.h>

@interface ActivityThemeView ()
{
    CGFloat PreviousImageBottom;
}
@property(nonatomic, strong) UIScrollView *mainScrollView;
@property(nonatomic, strong) UIImageView *headImageView;
@end

@implementation ActivityThemeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    [self addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headImageView];

}
//在set方法中赋值
- (void)setDataDic:(NSDictionary *)dataDic{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"image"]] placeholderImage:nil];
    [self drawContentWithArray:dataDic[@"content"]];
}
- (void)drawContentWithArray:(NSArray *)contentArray{
    if (self.headImageView) {
        PreviousImageBottom = 186;
    }
    for (NSDictionary *dic in contentArray) {
        //如果标题存在,标题的高度应该是上次图片底部的高度
        NSString *title = dic[@"title"];
        if (title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, PreviousImageBottom, kScreenWidth - 20, 30)];
            titleLabel.text = title;
            [self.mainScrollView addSubview:titleLabel];
            //下边详细信息label显示的时候,高度的坐标应该再加30,也就是标题的高度
            PreviousImageBottom += 30;
        }
        PreviousImageBottom += 10;
        CGFloat height = [HWTools getTextHeightWithBigSize:dic[@"description"] bigSize:CGSizeMake(kScreenWidth, 1000) textFont:15.0];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, PreviousImageBottom, kScreenWidth - 20, height)];
        label.text = dic[@"description"];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:15.0];
        [self.mainScrollView addSubview:label];
        
        PreviousImageBottom += height + 10;
        
        NSArray *urlArray = dic[@"urls"];
        //        if (urlArray == nil) {
        //            //当某一个段落中没有图片的时候,上次图片的高度用上次label的底部高度+10
        //            PreviousImageBottom = label.bottom + 10;
        //        } else {
        for (NSDictionary *dic in urlArray) {
            CGFloat width = [dic[@"width"] integerValue];
            CGFloat imageHeight = [dic[@"height"] integerValue];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, PreviousImageBottom, kScreenWidth - 20, (kScreenWidth - 20) / width * imageHeight)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]] placeholderImage:nil];
            [self.mainScrollView addSubview:imageView];
            //每次都保留最新的图片底部高度
            PreviousImageBottom = imageView.bottom + 10;
        }
    }
    //    }
    [self awakeFromNib];
}

- (void)awakeFromNib{
    self.mainScrollView.contentSize = CGSizeMake(0, PreviousImageBottom + 20);
}

- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    }
    return _mainScrollView;
}
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 186)];
    }
    return _headImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

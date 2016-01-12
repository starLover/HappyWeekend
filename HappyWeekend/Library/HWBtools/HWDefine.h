//
//  HWDefine.h
//  HappyWeekend
//
//  Created by wanghongxiao on 16/1/6.
//  Copyright © 2016年 聂欣欣. All rights reserved.
//

#ifndef HWDefine_h
#define HWDefine_h
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ClassifyListType) {
    ClassifyListTypeShowRepertoire = 1,         //演出剧目
    ClassifyListTypeTouristPlace,               //旅游景点
    ClassifyListTypeStudyPuz,                   //学习益智
    ClassifyListTypeFamilyTravel                //亲子旅游
};

#define kMainDatalist @"http://e.kumi.cn/app/v1.3/index.php?_s_=02a411494fa910f5177d82a6b0a63788&_t_=1451307342&channelid=appstore&cityid=1&lat=34.62172291944134&limit=30&lng=112.4149512442411&page=1"
//活动详情接口
#define kActicityDetail @"http://e.kumi.cn/app/articleinfo.php?_s_=6055add057b829033bb586a3e00c5e9a&_t_=1452071715&channelid=appstore&cityid=1&lat=34.61356779156581&lng=112.4141403843618"

#define KActivityTheme @"http://e.kumi.cn/app/positioninfo.php?_s_=1b2f0563dade7abdfdb4b7caa5b36110&_t_=1452218405&channelid=appstore&cityid=1&id=%@&lat=34.61349052974207&limit=30&lng=112.4139739846577&page=1"
#define KGoodActivity @"http://e.kumi.cn/app/articlelist.php?_s_=a9d09aa8b7692ebee5c8a123deacf775&_t_=1452236979&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=%ld&type=1"
#define KHotActivity @"http://e.kumi.cn/app/positionlist.php?_s_=e2b71c66789428d5385b06c178a88db2&_t_=1452237051&channelid=appstore&cityid=1&lat=34.61351314785497&limit=30&lng=112.4140755658942&page=%ld"
#define kClassifyList @"http://e.kumi.cn/app/v1.3/catelist.php?_s_=23525abd1e9cfbf2abdcc7c2449f582a&_t_=1452495137&channelid=appstore&cityid=1&lat=34.61356398594803&limit=30&lng=112.4140434532402"
#define kDiscover @"http://e.kumi.cn/app/found.php?_s_=a82c7d49216aedb18c04a20fd9b0d5b2&_t_=1451310230&channelid=appstore&cityid=1&lat=34.62172291944134&lng=112.4149512442411"
#endif /* HWDefine_h */

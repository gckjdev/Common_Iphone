//
//  CategoryManager.m
//  groupbuy
//
//  Created by qqn_pipi on 11-8-28.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CategoryManager.h"

#define LIFE        @"生活服务"
#define TRAVEL      @"旅游"
#define SHOPPING    @"购物"
#define FUN         @"休闲娱乐"
#define HOTEL       @"酒店"
#define FOOD        @"美食"
#define SPORTS      @"运动健身"
#define FACE        @"丽人"
#define BUY2        @"服装鞋袜"


CategoryManager*    manager;

@implementation CategoryManager

@synthesize categories;
@synthesize subCateogriesDict;

- (void)initData
{
	NSArray* food = [NSArray arrayWithObjects:
                     @"粤菜", @"川菜", @"东北菜",
                     @"湘菜", @"寿司", @"韩国料理",
                     @"火锅", @"西餐", @"自助餐", nil];
    
	NSArray* shopping = [NSArray arrayWithObjects:
                         @"代金券", @"抽奖秒杀", @"食品",
                         @"酒",@"茶",@"相机",
                         @"家电",@"电脑",@"手机",                         
                         nil];
    
	NSArray* fun = [NSArray arrayWithObjects:
                    @"KTV",@"电影票",@"游戏币",
                    @"咖啡厅",@"酒吧",@"桌游",
                    @"棋牌", @"足疗按摩", @"桑拿水疗",
                    nil];
    
	NSArray* travel = [NSArray arrayWithObjects:
                       @"北京游",@"云南游",@"九寨沟",
                       @"海南游",@"香港游",@"欧洲游",
                       @"日本游",@"澳大利亚",@"马尔代夫",
                       nil];
    
	NSArray* hotel = [NSArray arrayWithObjects:
                      @"经济型",@"公寓",@"度假村",
                      @"三星级",@"四星级",@"五星级",
                      @"七天",nil];
    
//	NSArray* luckyDraw = [NSArray arrayWithObjects:
//                          @"iPhone",@"iPad",@"小米手机",
//                          @"HTC",@"摩托罗拉",@"MacBook",
//                          nil];
    
	NSArray* sport = [NSArray arrayWithObjects:
                      @"健身",@"游泳",@"瑜伽",
                      @"羽毛球",@"乒乓球",@"网球",
                      @"桌球",@"保龄球", @"篮球",
                      nil];
	
	NSArray* life = [NSArray arrayWithObjects:
                     @"美发", @"照片冲印", @"洗车",
                     @"摄影写真", @"儿童写真", @"口腔护理",
                     @"体检", @"培训", @"报刊杂志",
                     nil];
    
    NSArray* face = [NSArray arrayWithObjects:
                     @"化妆品", @"美发", @"美容SPA", 
                     @"瘦身纤体", @"美甲", @"艺术写真",
                     @"瑜伽", @"舞蹈",
                     nil];
    
    NSArray* buy2 = [NSArray arrayWithObjects:
                     @"T恤", @"衬衫", @"裤子",
                     @"内裤", @"文胸", @"裙子", 
                     @"连衣裙", @"鞋", @"袜子", 
                     nil];
    
	//self.subCategories = [[NSArray alloc] initWithObjects:foods,nil];
	//[NSDictionary alloc] initWithObjects:
	categories = [[NSArray alloc] initWithObjects:
                       FOOD, BUY2, FUN,
                       TRAVEL, HOTEL, SPORTS,
                       FACE, SHOPPING, LIFE,
                       nil ];
	
	subCateogriesDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                              food, FOOD,
                              shopping, SHOPPING,
							  fun, FUN,
                              travel, TRAVEL,
                              hotel, HOTEL,
                              sport, SPORTS,
                              life, LIFE,
                              face, FACE,
                              buy2, BUY2,                              
                              nil];
    
}

+ (CategoryManager*)getManager
{
    if (manager == nil){
        manager = [[CategoryManager alloc] init];

        [manager initData];
    }
    
    return manager;
}

+ (NSArray*)getAllCategories
{
    return [[CategoryManager getManager] categories];
}

+ (NSArray*)getSubCategoriesByCategory:(NSString*)category
{
    return [[[CategoryManager getManager] subCateogriesDict] objectForKey:category];
}

+ (NSString*)refineSubCategoryNames:(NSString*)categoryName subCategoryNames:(NSString*)subCategoryNames
{
    if ([categoryName isEqualToString:HOTEL]){
        return [subCategoryNames stringByAppendingFormat:@" %@", categoryName];
    }
    
    return subCategoryNames;
}

- (void)dealloc
{
    [subCateogriesDict release];
    [categories release];
    [super dealloc];
}

@end

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
@synthesize groupbuyCatories;
@synthesize groupbuyCatoriesDict;

- (void)initData
{
	NSArray* food = [NSArray arrayWithObjects:
                     @"粤菜", @"东北菜", @"川菜", @"湘菜", 
                     @"寿司", @"自助餐", @"韩国料理",@"火锅", @"西餐", 
                     nil];
    
	NSArray* shopping = [NSArray arrayWithObjects:
                                @"食品", @"代金券",@"酒",
                         @"电脑", @"相机",@"抽奖秒杀", @"茶",
                         @"手机",@"家电",nil];
    
	NSArray* fun = [NSArray arrayWithObjects:
                           @"电影票",@"桑拿水疗",@"KTV", 
                    @"桌游",@"游戏币",@"足疗按摩",@"酒吧",  
                    @"棋牌",@"咖啡厅",
                    nil];
    
	NSArray* travel = [NSArray arrayWithObjects:
                       @"北京游",@"澳大利亚",@"云南游",@"九寨沟",
                       @"海南游",@"马尔代夫",@"香港游",@"欧洲游",
                       @"日本游",
                       nil];
    
	NSArray* hotel = [NSArray arrayWithObjects:
                             @"三星级",@"四星级",@"五星级",
                      @"七天",@"经济型",@"度假村",@"公寓",nil];
    
//	NSArray* luckyDraw = [NSArray arrayWithObjects:
//                          @"iPhone",@"iPad",@"小米手机",
//                          @"HTC",@"摩托罗拉",@"MacBook",
//                          nil];
    
	NSArray* sport = [NSArray arrayWithObjects:
                               @"羽毛球",@"健身",@"游泳",
                      @"瑜伽", @"乒乓球",@"网球",@"桌球",
                      @"篮球", @"保龄球", 
                      nil];
	
	NSArray* life = [NSArray arrayWithObjects:
                            @"摄影写真", @"照片冲印", @"体检",  
                     @"洗车",@"口腔护理",@"报刊杂志", @"美发", 
                     @"培训",@"儿童写真",
                     nil];
    
    NSArray* face = [NSArray arrayWithObjects:
                            @"美容SPA", @"化妆品", @"美发",
                     @"瑜伽", @"瘦身纤体",  @"艺术写真",@"美甲", 
                     @"舞蹈",
                     nil];
    
    NSArray* buy2 = [NSArray arrayWithObjects:
                            @"T恤", @"衬衫", @"裤子",
                     @"内裤", @"文胸", @"裙子", @"连衣裙",
                     @"袜子", @"鞋", 
                     nil];
    
	//self.subCategories = [[NSArray alloc] initWithObjects:foods,nil];
	//[NSDictionary alloc] initWithObjects:
	categories = [[NSArray alloc] initWithObjects:
                       FOOD, BUY2, FUN, HOTEL,
                       TRAVEL,  SPORTS,LIFE,
                       FACE, SHOPPING, 
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
    
    groupbuyCatories = [[NSArray alloc] initWithObjects:
                            @"美食", 
                            @"娱乐", 
                            @"女人", 
                            @"网购", 
                            @"电影票",
                            @"代金券",
                            @"旅游",
                            @"酒店",
                            @"写真",
                            @"生活", 
                            @"其他", nil];
    
    groupbuyCatoriesDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                            @"1", @"美食", 
                            @"2", @"娱乐", 
                            @"3", @"女人", 
                            @"4", @"网购",                              
                            @"6", @"生活", 
                            @"7", @"电影票",
                            @"8", @"代金券",
                            @"9", @"旅游",
                            @"10", @"酒店",
                            @"11", @"写真",
                            @"0", @"其他",                             
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

+ (NSArray*)getAllGroupBuyCategories
{
    return [[CategoryManager getManager] groupbuyCatories];
}

+ (NSString*)getGroupBuyCategoryIdByName:(NSString*)name
{
    return [[[CategoryManager getManager] groupbuyCatoriesDict] objectForKey:name];
}


- (void)dealloc
{
    [groupbuyCatories release];
    [groupbuyCatoriesDict release];
    [subCateogriesDict release];
    [categories release];
    [super dealloc];
}

@end

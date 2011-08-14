//
//  MobClick.h
//  MobClick
//
//  Created by Aladdin on 3/25/10.
//  Copyright 2010 Umeng.com . All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum{
	BATCH = 0,
	REALTIME
}ReportPolicy;

@protocol MobClickDelegate;
@interface MobClick : NSObject <UIAlertViewDelegate>{
@private
	id _internal;
}
#pragma mark basics


/*方法名:
 *		setDelegate:(id<MobClickDelegate>)delegate
 *		setDelegate:(id<MobClickDelegate>)delegate reportPolicy:(ReportPolicy)rp;
 *介绍:
 *		类方法设置MobClick代理，并初始化MobClick实例，请在调用appLaunched方法前，调用本方法
 *参数说明:
 *		delegate:实现了MobClickDelegate协议的实例
 *		ReportPolicy:发送统计信息的策略设置，有两种可选的发送策略
 *					1.BATCH		:批量发送。每次发送的时机在软件开启的时候进行发送
 *					2.REALTIME	:实时发送。每当有事件（event）产生时，进行发送
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
+ (void)setDelegate:(id<MobClickDelegate>)delegate;
+ (void)setDelegate:(id<MobClickDelegate>)delegate reportPolicy:(ReportPolicy)rp;

/*方法名:
 *		appLaunched
 *介绍:
 *		类方法，记录启动时间，模块开始启用。请在调用本方法前，调用setDelegate:或 setDelegate: reportPolicy: 方法
 *参数说明:
 *		无
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */

+ (void)appLaunched;
/*方法名:
 *		appTerminated
 *介绍:
 *		类方法，记录软件终止时间，模块终止。
 *参数说明:
 *		无
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
+ (void)appTerminated;

#pragma mark event logs
/*方法名:
 *		event:(NSString *)eventId
 *		event:(NSString *)eventId label:(NSString *)label
 *		event:(NSString *)eventId acc:(NSInteger)accumulation
 *		event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation
 *介绍:
 *       使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID即可 
 *		类方法，生成一条事件记录，并保存到本地缓存
 *参数说明:
 *		无参数版本可以方便的生成一条事件记录，并将分类标签设为空，计数设为1
 *		label:为某事件ID添加该事件的分类标签统计。在友盟的统计后台中，可以通过同一事件ID进行统计和整理。同一事件ID的不同的标签，也会分别进行统计，方便同一事件的不同标签的对比。
 *		accumulation:为某一事件的某一分类进行累加统计。为减少网络交互，可以自行对某一事件ID的某一分类标签进行累加，再传入次数作为参数即可。
 *		
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
+ (void)event:(NSString *)eventId;
+ (void)event:(NSString *)eventId label:(NSString *)label;
+ (void)event:(NSString *)eventId acc:(NSInteger)accumulation;
+ (void)event:(NSString *)eventId label:(NSString *)label acc:(NSInteger)accumulation;

#pragma mark feedback Default GUI
/*方法名:
 *		showFeedback:(UIViewController *)rootViewcontroller
 *介绍:
 *		类方法，弹出一个默认的反馈界面，生成一条事件记录，并保存到本地缓存
 *参数说明:
 *		rootViewController:会用来弹出presentModalViewController方法来展示反馈界面
 *		请确保rootViewController非空
 *		
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
+ (void)showFeedback:(UIViewController *)rootViewController;


#pragma mark feedback data api
/*方法名:
 *		feedbackWithDictionary:(NSDictionary * )feedbackDict
 *介绍:
 *		类方法，生成一条事件记录，并保存到本地缓存。这是自定义事件的数据接口，视图方面请自己定义，调用该接口传送数据即可。
 *参数说明:
 *		Dictionary中应该有以下三个键名:
 *      @"UMengFeedbackGender" @"UMengFeedbackAge" @"UMengFeedbackContent"
 *		键值部分:
 *		都是NSString类型的，其中性别和年龄是填写数字代表
 *		对应关系是 1=>男 2=>女
 *		年龄部分的对应关系是 
 *		1=>18岁以下(不含18岁),2=>18-24岁,3=>25-30岁,
 *		4=>31-35岁,5=>36-40岁,6=>41-50岁,7=>51-59岁,8=>60岁及60岁以上
 *
 *       请在调用该方法之前自行判断键值的完整性和正确性，否则会保存失败
 *       这些键值会保存到本地中，并在下次提交数据时上传到服务器
 *返回值:
 *      BOOL 保存失败或者成功的状态。
 *
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
+ (BOOL)feedbackWithDictionary:(NSDictionary * )feedbackDict;
#pragma mark helper
/*方法名:
 *		isJailbroken
 *介绍:
 *		类方法，判断设备是否越狱，判断方法根据 apt和Cydia.app的path来判断
 *参数说明:
 *		无
 *		
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
+ (BOOL)isJailbroken;
/*方法名:
 *		isPirated
 *介绍:
 *		类方法，判断软件是否破解
 *参数说明:
 *		无
 *		
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
+ (BOOL)isPirated;

@end

@protocol MobClickDelegate <NSObject>
@required
/*方法名:
 *		- (NSString *)appKey;
 *介绍:
 *		返回Appkey，如果Appkey错误，统计后台不会对log进行记录
 *参数说明:
 *		请确保您的Appkey是从友盟后台注册新App得到的
 *		
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
- (NSString *)appKey;
@optional
/*方法名:
 *		- (NSString *)channelId;
 *介绍:
 *		返回ChannelID
 *参数说明:
 *		返回的是渠道名，例如@"Apple Store",或者@"产品主页"等
 *       注意：服务器端对设备只进行一次统计，以后更改渠道名对该设备并不进行更新。所以再测试不同的渠道的时候，请使用不同的设备来分别测试。
 *       如果需要另外的机器来测试新渠道，可以联系aladdin@umeng.com
 *		
 *文档地址: http://www.umeng.com/doc/home.html#op_con_kfzn/iossdk_syzn
 */
- (NSString *)channelId;
@end
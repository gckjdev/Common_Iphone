//
//  GroupBuyNetworkConstants.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

extern NSString* GlobalGetServerURL();

#define SERVER_URL                  (GlobalGetServerURL())


#define SHARE_KEY @"NetworkRequestShareKey"

// method name

#define METHOD @"m"
#define METHOD_TEST @"test"
#define METHOD_ONLINESTATUS @"srpt"
#define METHOD_REGISTRATION @"reg"
#define METHOD_CREATEPOST @"cp"
#define METHOD_CREATEPLACE @"cpl"
#define METHOD_GETUSERPLACES @"gup"
#define METHOD_GETPLACEPOST @"gpp"
#define METHOD_GETNEARBYPLACE @"gnp"
#define METHOD_USERFOLLOWPLACE @"ufp"
#define METHOD_USERUNFOLLOWPLACE @"unfp"
#define METHOD_GETUSERFOLLOWPOSTS @"guf"
#define METHOD_GETNEARBYPOSTS @"gne"
#define METHOD_GETUSERFOLLOWPLACES @"gufp"
#define METHOD_DEVICELOGIN @"dl"
#define METHOD_GETPOSTRELATEDPOST @"gpr"
#define METHOD_BINDUSER @"bu"

#define METHOD_SENDMESSAGE @"sm"
#define METHOD_GETMYMESSAGE @"gmm"
#define METHOD_DELETEMESSAGE @"dmm"
#define METHOD_GETMEPOST @"gmep"
#define METHOD_UPDATEUSER @"uu"
#define METHOD_UPDATEPLACE @"up"
#define METHOD_GETPLACE @"gtp"
#define METHOD_GETPUBLICTIMELINE @"gpt"
#define METHOD_ACTIONONPOST @"aop"	

#define METHOD_GETAPPUPDATE @"gau"
#define METHOD_UPDATEKEYWORD @"uk"
#define METHOD_ACTIONONPRODUCT @"ap"

#define METHOD_REGISTERDEVICE @"rd"
#define METHOD_FINDPRODUCTWITHPRICE @"fpp"
#define METHOD_FINDPRODUCTWITHREBATE @"fpd"
#define METHOD_FINDPRODUCTWITHBOUGHT @"fpb"
#define METHOD_FINDPRODUCTWITHLOCATION @"fpl"
#define METHOD_FINDPRODUCTSGROUPBYCATEGORY @"fgc"
#define METHOD_FINDPRODUCTS @"fp"
#define METHOD_FINDPRODUCTSBYKEYWORD @"fpk"

#define METHOD_ADDSHOPPINGITEM @"asi"
#define METHOD_UPDATESHOPPINGITEM @"usi"
#define METHOD_DELETESHOPPINGITEM @"dsi"
#define METHOD_GETSHOPPINGITEM @"gsi"


// request parameters

#define PARA_USERID @"uid"
#define PARA_LOGINID @"lid"
#define PARA_LOGINIDTYPE @"lty"
#define PARA_USERTYPE @"uty"
#define PARA_PASSWORD @"pwd"

#define PARA_SINAID @"sid"
#define PARA_QQID @"qid"
#define PARA_FACEBOOKID @"fid"
#define PARA_RENRENID @"rid"
#define PARA_TWITTERID @"tid"

#define PARA_DEVICEID @"did"
#define PARA_DEVICETYPE @"dty"
#define PARA_DEVICEMODEL @"dm"
#define PARA_DEVICEOS @"dos"
#define PARA_DEVICETOKEN @"dto"
#define PARA_NICKNAME @"nn"

#define PARA_MOBILE @"mb"
#define PARA_EMAIL @"em"

#define PARA_TO_USERID @"tuid"
#define PARA_MESSAGE_ID @"mid"

#define PARA_COUNTRYCODE @"cc"
#define PARA_LANGUAGE @"lang"
#define PARA_APPID @"app"

#define PARA_NEED_RETURN_USER           @"r"
#define PARA_AVATAR                     @"av"
#define PARA_ACCESS_TOKEN               @"at"
#define PARA_ACCESS_TOKEN_SECRET        @"ats"
#define PARA_PROVINCE                   @"pro"
#define PARA_CITY                       @"ci"
#define PARA_LOCATION                   @"lo"
#define PARA_GENDER                     @"ge"
#define PARA_BIRTHDAY                   @"bi"
#define PARA_SINA_NICKNAME              @"sn"
#define PARA_SINA_DOMAIN                @"sd"
#define PARA_QQ_NICKNAME                @"qn"
#define PARA_QQ_DOMAIN                  @"qd"
#define PARA_GPS                        @"gps"

#define PARA_RADIUS @"ra"
#define PARA_POSTTYPE @"pt"
#define PARA_NAME @"na"
#define PARA_DESC @"de"
#define PARA_AFTER_TIMESTAMP @"at"
#define PARA_BEFORE_TIMESTAMP @"bt"
#define PARA_MAX_COUNT @"mc"

#define PARA_TOTAL_VIEW     @"tv"
#define PARA_TOTAL_FORWARD  @"tf"
#define PARA_TOTAL_QUOTE    @"tq"
#define PARA_TOTAL_REPLY    @"tr"
#define PARA_TOTAL_RELATED  @"trl"
#define PARA_CREATE_DATE    @"cd"

#define PARA_SEQ            @"sq"

#define PARA_POSTID         @"pi"
#define PARA_IMAGE_URL      @"iu"
#define PARA_CONTENT_TYPE   @"ct"
#define PARA_TEXT_CONTENT   @"t"
#define PARA_USER_LATITUDE  @"ula"
#define PARA_USER_LONGITUDE @"ulo"
#define PARA_SYNC_SNS @"ss"
#define PARA_PLACEID @"pid"
#define PARA_SRC_POSTID @"spi"
#define PARA_EXCLUDE_POSTID @"epi"
#define PARA_REPLY_POSTID @"rpi"
#define PARA_POST_ACTION_TYPE @"pat"

#define PARA_CREATE_USERID @"cuid"

#define PARA_STATUS @"s"

#define PARA_TIMESTAMP @"ts"
#define PARA_MAC @"mac"

#define PARA_DATA @"dat"

#define PARA_LONGTITUDE @"lo"
#define PARA_LATITUDE @"lat"
#define PARA_MESSAGETEXT @"t"

#define PARA_VERSION @"v"

#define PARA_KEYWORD @"kw"

// response parameters

#define RET_MESSAGE @"msg"
#define RET_CODE @"ret"
#define RET_DATA @"dat"

#define PARA_SINA_ACCESS_TOKEN          @"sat"
#define PARA_SINA_ACCESS_TOKEN_SECRET   @"sats"
#define PARA_QQ_ACCESS_TOKEN            @"qat"
#define PARA_QQ_ACCESS_TOKEN_SECRET     @"qats"

// app related info

#define PARA_APPURL @"au"
#define PARA_ICON @"ai"
#define PARA_SINA_APPKEY @"sak"
#define PARA_SINA_APPSECRET @"sas"
#define PARA_QQ_APPKEY @"qak"
#define PARA_QQ_APPSECRET @"qas"
#define PARA_RENREN_APPKEY @"rak"
#define PARA_RENREN_APPSECRET @"ras"
#define PARA_MESSAGE_TYPE @"mt"

#define PRAR_START_OFFSET @"so"

//response parameters
#define PARA_LOC @"loc"
#define PARA_IMAGE @"img"
#define PARA_TITLE @"tt"
#define PARA_START_DATE @"sd"
#define PARA_END_DATE @"ed"
#define PARA_PRICE @"pr"
#define PARA_VALUE @"val"
#define PARA_REBATE @"rb"
#define PARA_BOUGHT @"bo"
#define PARA_SITE_ID @"si"
#define PARA_SITE_NAME @"sn"
#define PARA_SITE_URL @"su"
#define PARA_ID @"_id"
#define PARA_ADDRESS @"add"
#define PARA_DETAIL @"dt"
#define PARA_WAP_URL @"wu"
#define PARA_TEL @"te"
#define PARA_SHOP @"sh"

#define PARA_PRODUCT @"p"
#define PARA_CATEGORY_NAME @"na"
#define PARA_CATEGORY_ID @"ci"
#define PARA_CATEGORIES @"ctg"
#define PARA_START_OFFSET @"so"
#define PARA_MAX_DISTANCE @"md"
#define PARA_TODAY_ONLY @"to"
#define PARA_SORT_BY @"sb"

#define PARA_ACTION_NAME @"an"
#define PARA_ACTION_VALUE @"av"

#define PARA_ITEMID @"ii"
#define PARA_CATEGORY_NAME @"na"
#define PARA_SUB_CATEGORY_NAME @"scn"
#define PARA_CATEGORY_ID @"ci"


#define SORT_BY_START_DATE 0
#define SORT_BY_PRICE 1
#define SORT_BY_REBATE 2
#define SORT_BY_BOUGHT 3



#define ERROR_DEVICE_NOT_BIND   20003




extern NSString* GlobalGetServerURL();

#define SERVER_URL                  (GlobalGetServerURL())

//#define SERVER_URL                  @"http://192.168.1.161:8000/api/i?"
//#define SERVER_URL                  @"http://127.0.0.1:8000/api/i?"
//#define SERVER_URL                  @"http://192.168.1.188:8000/api/i?"

//#define SERVER_URL                  @"http://192.168.1.101/place/api/i?"

#define CURRENT_VERSION             @"0090"

#define OS_IOS                      1


#define LOGINID_OWN                 1
#define LOGINID_SINA                2
#define LOGINID_QQ                  3
#define LOGINID_RENREN              4
#define LOGINID_FACEBOOK            5
#define LOGINID_TWITTER             6

    
#define DEFAULT_PLACE_RADIUS        500

#define PLACE_POST_TYPE_OPEN        0


#define CONTENT_TYPE_TEXT           1
#define CONTENT_TYPE_TEXT_PHOTO     2

#define PROVINCE_UNKNOWN            (0)
#define CITY_UNKNOWN                (0)

#define kMaxCount                   3
#define kMaxCountForPostRelatedPost 200
#define kMaxMessageCount            100

#define GENDER_MALE                 @"m"
#define GENDER_FEMALE               @"f"

#define USER_DEFAULT_SINA_KEY       @"sinaAccessTokenKey"
#define USER_DEFAULT_SINA_SECRET    @"sinaAccessTokenSecret"
#define USER_DEFAULT_QQ_KEY       @"qqAccessTokenKey"
#define USER_DEFAULT_QQ_SECRET    @"qqAccessTokenSecret"
#define USER_DEFAULT_RENREN_SECRET    @"renrenAccessTokenSecret"
#define USER_DEFAULT_RENREN_KEY       @"renrenAccessTokenKey"

#define IMAGE_POST_MAX_BYTE  720000
#define IMAGE_DEFAULT_COMPRESS_QUALITY 0.7

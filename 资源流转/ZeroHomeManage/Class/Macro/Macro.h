//
//  Macro.h
//  NewKnowledgeSystem
//
//  Created by xiangming on 14-9-7.
//  Copyright (c) 2014年 JunePartner. All rights reserved.
//

#ifndef NewKnowledgeSystem_Macro_h
#define NewKnowledgeSystem_Macro_h

typedef NS_ENUM(NSInteger, NSTypeBlueViewControllerStyle) {
    NSBlueViewControllerRepairStyle,
    NSBlueViewControllerComplainStyle,
    NSBlueViewControllerPraiseStyle,
};

typedef NS_ENUM(NSInteger, ShareViewControllerStyle) {
    ShareViewControllerPraiseStyle,
    NSBlueViewControllerComplationStyle,
};


typedef NS_ENUM(NSInteger, NSTypePayForStyle) {
    NSShoppingPayForStyle,
    NSManageFeePayForStyle,
};
/**
 *
 * 方法简化名
 *
 **/
#pragma mark - 方法简化名

#define Version                         [[[UIDevice currentDevice] systemVersion] floatValue]       //获取当前设备的版本
#define DefaultValueForKey(key)         [[NSUserDefaults standardUserDefaults] valueForKey:key]     //从defaults中取值
#define SetValueForKey(dic,value,key)   [dic setValue:value forKey:key];                            //给字典设置键值对
#define DoubleToString(x)               [NSString stringWithFormat:@"%f",x]                         //double类型转string类型
#define IntToString(x)                  [NSString stringWithFormat:@"%d",x]                         //int类型转string类型
#define ObjToString(obj)                [NSString stringWithFormat:@"%@",obj]                       //id类型转string类型

#define IOS5                            [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0
#define IOS6                            [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0
#define IOS7                            [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define COLOR_RGB(r,g,b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]                //获取颜色的方法

#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define GrayTextColor UIColorFromRGB(0x878787)      //灰色字体
#define GrayLineColor UIColorFromRGB(0xd7d7d7)      //灰色线条

#define default_blue_color [UIColor colorWithRed:68/255.0 green:129/255.0 blue:210/255.0 alpha:1.0] //系统默认蓝色


#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define kBackgroundColor    RGBA(226, 226, 226, 1)
/**
 *
 * 适配使用的常量、通用颜色
 *
 **/
#pragma mark - 常量

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kToolBarHeight  44
#define KStateBarHeight 20
#define kTabBarHeight   49
#define kShowHeight kHeight - kToolBarHeight - KStateBarHeight

#define kSideViewControllerWidth 220

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define kTextAlignmentLeft IOS6 ? NSTextAlignmentLeft : UITextAlignmentLeft
#define kTextAlignmentRight IOS6 ? NSTextAlignmentRight : UITextAlignmentRight
#define kTextAlignmentCenter IOS6 ? NSTextAlignmentCenter : UITextAlignmentCenter

/*************手机型号**************/
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
/*************手机型号**************/

#define IS_4_INCH_SCREEN  (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)

#define IS_PLUS_INCH_SCREEN  (([[UIScreen mainScreen] bounds].size.height == 10) ? YES : NO)

#define IS_IOS_8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) ? YES : NO)

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height - ((IS_IOS_7) ? 0 : 20))

#define STATUS_HIGHT (IS_IOS_7) ? 20 : 0//状态栏高度

#define IS_IOS_7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? YES : NO)

#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define BUNDLE_IDENTIFIER [[NSBundle mainBundle] bundleIdentifier]

#define BUNDLE_DISPLAY_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define MAIN_GRAY_COLOR COLOR_RGBA(152,152,152,1) //主色调-灰色
#define MAIN_BLUE_COLOR COLOR_RGBA(233,79,18,1) //主色调-橘色
#define MAIN_ORANGE_COLOR COLOR_RGBA(240,133,25,1) //主色调-橘黄色
#define MAIN_BLACK_COLOR COLOR_RGBA(68,71,80,1) //主色调-黑色


#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a]

//判断字符串是否为nil,如果是nil则设置为空字符串
#define CHECK_STRING_IS_NULL(txt) txt = !txt ? @"" : txt

#define CHECK_IS_NULL(txt) (txt.length == 0 || [txt isEqualToString:@"(null)"] || [txt isEqualToString:@"<null>"]) ? @"" : txt

#define CHECK_ISNULL(txt) (txt.length == 0 || [txt isEqualToString:@"(null)"] || [txt isEqualToString:@"<null>"]) ? @"匿名" : txt

//判断Server返回数据是否为NSNull 类型 txt为参数 type为类型,like NSString,NSArray,NSDictionary
#define CHECK_DATA_IS_NSNULL(param,type) param = [param isKindOfClass:[NSNull class]] ? [type new] : param

#define NAV_BAR_HEIGHT (IS_IOS_7 ? 64 : 44)

#define TAB_BAR_HEIGHT 49

#define DEFAULT_REQUEST_PAGE_SIZE @"20"

#define NUMBERS @"0123456789\n"

#define DECIMAL_NUMBERS @"0123456789,.\n"

//设备版本
#define IOS_VERSION [[UIDevice currentDevice].systemVersion floatValue]

//系统版本
#define BUNDLE_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//标题字号大小
#define TITLELABEL_FONT 20

#define TITLEMEDIUM_FONT 16
#define TITLESMALL_FONT 13
#define TITLEBIG_FONG 20

#define SUBTITLE_MEDIUM_FONT 14
#define SUBTITLE_SMALL_FONT 11
#define SUBTITLE_BIG_FONT 18
//绿色 #72B240;R114 G178 B64
#define GREENCOLOR  COLOR_RGBA(114,178,64,1)
//蓝色
#define BLUECOLOR   COLOR_RGBA(52,209,231,1)
//新设计蓝色
#define NEWBLUECOLOR COLOR_RGBA(40,188,220,1)

//橘红色
#define ORANGECOLOR  COLOR_RGBA(240,133,25,1)
//最深灰色 #666666；R102 G102 B102
#define BESTGRAYCOLOR  COLOR_RGBA(102,102,102,1)
//普通灰色背景 #eeeceb R238 G236 B235
#define NORMALGRAYCOLOR COLOR_RGBA(219,219,219,1)
//背景-最浅灰色 #f5f4f4 R245 G244 B244
#define  FRENCHGRAYCOLOR COLOR_RGBA(245,245,245,1)
//统一边框灰色 #968c87 R150 G140 B135
#define  BORDERGRAYCOLOR COLOR_RGBA(150,140,135,1)

//百度poi搜素ak
#define kPoiSearchAK     @"4q4eFYkmHqGaN1pD1fYS5p1t"
/**
 *
 * 第三方Key
 *
 **/
#pragma mark - Key Value






//#define KWeiChatAppID      @"wx44bfe877c54dbefd"
//#define KWeiChatAppSecret  @"911838868d6b0cb7da4cc2dd574a69db"
//
//#define KTencentQQAppID      @"QQ41A2F110"
//#define KTencentQQTenAppID      @"1101197584"
//
//#define KTencentWeiboAppID      @"801544505"
//#define KTencentWeiboSecret     @"51774ffd7d064eeec9d05cc2bdadc647"
//
//#define KTencentQQAppKey  @"2nOZnzqBzhL9Zl78"
//
//#define KUMAppID      @"5433f1c7fd98c5297f002624"


/**
 *
 * 保存文件的文件名
 *
 **/
#pragma mark - 保存文件的文件名







/**
 *
 * 保存数据等键/值
 *
 **/
#pragma mark - 保存数据等键/值




/**
 *
 * 通知名称
 *
 **/
#pragma mark- 通知名称


/**
 * 网络数据接口
 * 接口基于HTTP协议，客户端以普通的GET/POST向服务端发起请求，
 * 服务端以JSON的格式返回数据。
 * 服务器地址：http://mobile.xinzhishi.hk
 * 客户端的UserAgent中需增加"Xinzhishi"字符串，客户端需将Cookie发回服务端。
 *http://192.168.1.174:8082
 *外网：http://api.ldhome.com.cn
 内网：http://pms.ldhome.com.net
 **/
//@""
//http://192.168.1.97:8080/api
//http://api.ldhome.com.cn/

#pragma mark - 网络数据接口
#define kBaseAppUrl                @"http://api.ldhome.com.cn"

//获取短信 完成
#define kIdentifyCode                @"/smscaptcha"

//注册接口 完成
#define Register                  @"/account/register"

//用户签到
#define kSign                      @"/account/signin"

//用户登录 完成
#define Login                     @"/account/login"

//个推绑定
#define kGeTui                     @"/devicer/register"

//城市 完成
#define kcites                     @"/comntiys"

//保存城市 完成
#define kChangeCid                 @"/changeCid"

//e团购 完成
#define kc2clist                   @"/product/c2clist"

//安心商城 完成
#define kb2clist                   @"/product/b2clist"

//商家列表 完成
#define kshoplist                   @"/shop/list"

//商家商品列表 完成
#define kshopProductlist            @"/shop/product/list"

//三公里商圈 完成
#define kgrouplist                @"/product/grouplist"

//商品详情 完成
#define kdetail                   @"/product/detail"

//评价 完成
#define kevaluate                  @"/evaluate/list"

//购买列表 完成
#define kPurchase                   @"/product/list"

//提交订单 完成
#define kOrder                      @"/order/create"

//收货地址列表  完成
#define kAddressList                @"/ship/list"

//新增收货地址  完成
#define kAddressEdit                @"/ship/edit"

//删除收货地址  完成
#define kAddressDelete                @"/ship/del"

//修改密码   完成
#define kupdatePwd                @"/account/updatePwd"

//忘记密码
#define kforgotPwd                @"/account/forgetPwd"

//个人中心  完成
#define  kInfo                    @"/account/info"

//上传头像  完成
#define   kUploadIcon             @"/account/uploadIcon"

//修改昵称   完成
#define   kUpdateName            @"/account/updateName"


//我的订单  完成
#define   kOrderList            @"/order/list"

//我的订单详情 完成
#define   kOrderDetail           @"/order/detail"


//我的修改订单状态 完成
#define   kOrderUpdate            @"/order/update"

//我的商品评价 完成
#define   kOrderCreate            @"/evaluate/create"

//小区通知 完成
#define   kAdvise                @"/advise/list"

//小区通知详情 完成
#define   kDetailAdvise          @"/advise/detail"

//小区广告 完成
#define  kBanner                 @"/banner/list"

//报修提交 完成
#define kRepairs                 @"/repairs/create"

//报修列表 完成
#define kRepairsList             @"/repairs/list"

//报修详情 完成
#define kRepairsDetail           @"/repairs/detail"

//物业投诉提交 完成
#define kComplaintCreate         @"/complaint/create"

//物业投诉列表 完成
#define kComplaintList           @"/complaint/list"

//物业投诉详情 完成
#define kComplaintDetail       @"/complaint/detail"

//物业表扬提交
#define kPariseCreate        @"api/praise/create"

//物业表扬列表
#define kPariseList     @"api/praise/list"

//分享随手拍 完成
#define kShareCreate    @"/share/create"

//分享记录
#define kShareMy     @"/share/my"

//分享主界面 完成
#define kShareList    @"/share/list"

//分享帖子详情 完成
#define kShareDetailList   @"/share/detail"

//分享评价
#define kShareComment   @"/share/comment/create"

//分享点赞
#define kShareAdd    @"/share/praise/add"

//分享评价 完成
#define kEvaluate    @"/share/evaluate/list"

//物业查看楼栋  完成
#define kBuildings     @"/buildings"

//物业查看楼栋  完成
#define kRooms     @"/rooms"

//物业费列表  完成
#define  kBills    @"/fees/bills"

//物业费详情  完成
#define  kBillsDetail    @"/fees/detail"

//邀请码  完成
#define kInvitCode   @"/account/getInviteCode"

//查询物业公司支付宝帐户信息 完成
#define kComnityAlipayInfo   @"/comnityAlipayInfo/queryAlipayByComnityId"

//摇一摇
#define kPrize @"/prize/acquirePrize"

#define kManageUrl   @"http://192.168.1.97:8080/api"

#endif

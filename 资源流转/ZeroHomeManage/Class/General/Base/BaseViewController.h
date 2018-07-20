//
//  BaseViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 16/1/26.
//  Copyright (c) 2016年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest.h"
#import "UserDefalut.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "YDGHUB.h"


//com.wangtong.wtshopping      真机测试
//com.wangtong.wtshoppingcite  发布
//com.tongwang.resourceAndLockMange 管理和门锁三端

//外网  阿里云
//#define klAppBaseURL  @"http://twapi.twldhome.com:8280/api-web/"
//#define KShareToTentURL @"http://twadmin.twldhome.com:8180/admin-web"
//测试 阿里云
#define klAppBaseURL @"http://twapi2.twldhome.com:8480/api-web/"
#define KShareToTentURL @"http://admin-web8.ldhome.com.cn:80/admin-web"

//外网 南山机房
//#define klAppBaseURL @"http://api2.ldhome.com.cn:82/api-web"
//#define KShareToTentURL @"http://admin.ldhome.com.cn/admin-web"

//测试 南山机房
//#define klAppBaseURL @"http://api8.ldhome.com.cn:88/api-web"
//#define KShareToTentURL @"http://admin-web8.ldhome.com.cn:80/admin-web"

//小郑服务器
//#define klAppBaseURL @"http://192.168.1.240:80/api-web"
//#define KShareToTentURL @"http://192.168.1.121:8080/admin-web"


//http://www.ldhome.com.cn/download/bapp.html
#define ShareToWeixinURL @"https://itunes.apple.com/cn/app/ling-dian-jia-yuan/id954684084?mt=8&uo=4" //分享到微信，qq


//com.tongwang.ZoreHome

#define kLogin @"/user/login"//登录
#define kThirdLogin @"/user/otherLogin"//第三方登陆
#define kGetbanben @"/user/checkVersions"//获取最新版本
#define kRegister @"/user/register"//注册
#define kFixPassWord @"/user/forget"//修改密码
#define kSendSms @"/user/sendSms"//发送短信
#define kSendEmail @"/user/sendEmail"//发送邮箱
#define kCheckTel @"/user/checkTel" //验证手机是否存在
#define kQuiLogin @"/user/fastLogin"//快速注册
#define kPerfectData @"/user/perfectOtherLogin"//完善资料

#define kADDRESSMANAGER @"/address/query"//查询收货地址
#define kADDADDRESSMANAGER @"/address/add"//添加收货地址
#define kDelectAddress @"/address/remove"//删除收货地址
#define kUPDATAADDRESS @"/address/update"//更新收货地址
#define kADDRESSSetDefault @"/address/setDefault"//地址设为默认
#define kQueryArea @"/community/queryCommunity"//查询小区

#define kCarManager @"/car/query"//查询车辆信息
#define kADDCarManager @"/car/add"//添加车辆信息
#define kDelectedCar @"/car/remove"//删除车辆信息
#define kUpDataCar @"/car/update"//更新车辆信息
#define kSetDefault @"/car/setDefault"//车辆设为默认

#define kMine @"/user/mine"//我的
#define kchangePassWord @"/user/changePassword"//个人中心修改密码

#define kPersonCenter @"/user/personalCenter"//个人中心信息
#define kChangeImage @"/user/changeAvatar"//修改个人头像
#define kChangeEmail @"/user/changeEmail"//修改邮箱
#define kChangeIphone @"/user/changeTel"//修改手机
#define kUserCommunity @"/community/userCommunity"//查询我的小区
#define kCustomCommunity @"/community/customCommunity"//自定义我的小区
#define kListCommunity @"/community/listCommunity"//列表修改小区
#define KgetHomeImage @"/community/getCommunityPics"//获取小区图片

#define ChengOldIphone @"/user/chcekVerificationByTel"//校验旧手机验证码
#define CheckOldEmail @"/user/chcekVerificationByEmaill"//校验旧邮箱验证码
#define kCheckOldPassWord @"/user/checkPwd"//查询旧密码

#define kWEIZHANG @"/peccancy/queryPeccancy"//违章查询
#define kCreateOrder @"/peccancy/createPeccancyOrder"//创建订单
#define kWeiZhangOrder  @"/peccancy/peccancyOrderList"//违章订单列表
#define kDelectOrder @"/peccancy/deletePeccancyOrder"//删除订单
#define kdetailOrder @"/peccancy/peccancyList"//查询订单详情
#define KWEIZHANGBack @"/peccancy/peccancyOrderCallback"//违章回调

#define kItems @"/noticeType/list"//物业通知item查询
#define kNews @"/notice/query"//物业通知查询
#define kNewsDetail @"/notice/detail"//通知详情

#define kREPAIRNOTE @"/repairs/query"//报修记录
#define kADDPERAIR @"/repairs/add"//添加报修
#define kRepairDetail @"/repairs/detail"//报修详情
#define kEvaluation @"/repairs/confirm"//评价
//分享
#define KGroupLables @"/groupShare/getGroupLables" //获取标签列表
#define KgetBarnchID @"/community/queryCommunityId"//获得小区ID
#define KShareByBranchId @"/share/queryByBranchId"//社区分享
#define KGroupShareList  @"/groupShare/getGroupShareList" //圈子分享
#define KqueryNoBranch @"/share/queryNoBranch"//大圈分享
#define KmyShare @"/share/queryByUserId"//我的分享
#define KcommitShare @"/share/saveShare"//提交分享
#define KCircleCommitShare @"/groupShare/saveGroupShare"   //提交圈子分享
#define KshareDetail @"/share/shareInfo"//分享详情
#define KGroupShareDetail @"/groupShare/shareInfo" //圈子分享详情
#define KComment @"/comment/saveComment"//评论
#define KGroupComment @"/groupShare/addGroupShareComment" //圈子评论
#define KdelectShare @"/share/deleteShareByUserId"//删除自己的分享
#define KGroupDelectShare @"/groupShare/removeShareByUserId" //删除圈子分享
#define KLove @"/share/updateSharePraiseNumber"//点赞
#define KGroupLove @"/groupShare/updateSharePraiseNumber" //圈子点赞
#define KReport @"/share/reportShare"//举报分享
#define KGroupReportShare @"/groupShare/reportShare" //圈子举报分享
#define KdelectedComment @"/comment/removeComment"//删除评论
#define KGroupDelectedComment @"/groupShare/removeGroupShareComment" //圈子删除评论
#define KRportComment @"/comment/reportComment"//举报评论
#define KGroupReport @"/groupShare/reportGroupShareComment" //圈子举报评论
#define KQueryArticleList @"/article/queryArticleList" //文章列表
#define KQueryArticleById @"/article/queryArticleById" //文章详情
#define KSendToVisitRequest @"/visitorPass/getVisitorPassPage"  //发送访客请求

#define KUserShareInfo  @"/user/userShareInfo"   //用户主页
//充值
#define kDenomination @"/rechargeOrder/queryDenomination"//面值
#define KRatePruductList @"/fscg/getProductList"//流量
#define KDenominationOrder @"/rechargeOrder/createOrder"//创建充值订单
#define KOrderPayCallback @"/rechargeOrder/rechargerOrderPayCallback"//充值回调
#define KDenominiOrder @"/rechargeOrder/queryRechargeList"//订单列表

#define KGetVoteList @"/vote/getVoteList"  //投票列表
#define KGetVoteDetail @"/vote/getVoteDetail"   //投票详情
#define KAdviseVote @"/vote/adviseVote"   //用户意见
#define KVotingOption @"/vote/votingOption"  //用户投票
#define KUserSingn @"/userSignin/signin"    //签到接口
#define KQueryUserSingn @"/userSignin/queryUserSignin"  //查询是否已签到
#define KPointByShareUrl @"/userPoint/earnPointByShareUrl" //分享加积分
#define KGetGroupShareInfo @"/groupShare/getGroupShareInfo" //分享圈子URL
#define KGetShareInfo @"/share/getShareInfo"  //分享动态URL
#define KGetVoteInfo @"/vote/getVoteInfo" //分享投票URL
#define KGetAeticleInfo @"/article/getArticleInfo" //分享活动咨询
#define KWeixinCreatOrder @"/weixin/createOrder" //微信充值订单
#define KQueryRechargeStatus @"/weixin/queryRechargeStatus" //查询微信订单
#define KEarnPointByOrderId @"/userPoint/earnPointByOrderId" //充值与违章代办获取积分接口

#define KQueryAllCity @"/broadbandBusiness/queryAllCity"  //获取城市列表
#define KQueryBusinessArea  @"/broadbandBusiness/queryArea" //查询宽带业务
#define KCommunityList   @"/community/getCommunityList"  //获取小区联动列表
#define KBrodBandBusinessSaveOrder  @"/broadbandBusiness/saveOrder" //提交宽带信息订单
#define KBroadBandQueryAlllModule   @"/broadbandBusiness/queryAllModule"  //查询宽带办理模块
#define KGetAddressById  @"/community/getAddressById" //查询地址
#define KSaveMaintian    @"/maintain/saveMaintian"   //提交故障维修
#define KBroadBandBusiness   @"/broadbandBusiness/queryByUserId" //查询进度列表
#define KMaintainQueryByUserId  @"/maintain/queryByUserId"  //查询报修列表

#define KMaintainQueryAllModule  @"/maintain/commentMaintain" //故障维修评论提交
#define KBroadBandComment   @"/broadbandBusiness/orderComment" //办理评论提交

#define KQueryCheckUser  @"/constructionUser/queryConstructionUser"  //查询用户是否为管理员
#define KQueryRoomByUser  @"/lock/queryRooomByUser" //获取可申请权限的机房
#define KQueryViableRoomByUser   @"/lock/queryViableRooomByUser"  //获取申请过权限的机房
#define KSaveCheckUser    @"/lock/saveUserLock"  //提交审核信息
#define KAllUserlockByTel   @"/lock/queryAllUserLockByTel"  //获取机房时限列表
#define KQueryOpenHis    @"/lock/queryOpenHis"  //获取开锁列表
#define KQueryCheckOrder @"/lock/checkHaveOrder"  //查询是否有提交申请
#define KLockPushList    @"/lock/lockPushList"  //获取消息推送记录
#define KLockFaildNotification    @"/lock/saveOpenLockHisError"  //开锁失败反馈

#define klAppSmartWringURL @"http://120.77.212.148:8888/api-web"

#define KIsConnectWebService   @"/isConnectWebService"   //是否能连接服务器
#define KDownLoadWorkList   @"/downloadWorkList"   //下载工单列表

//MIFI模块
#define KMifiComboList   @"/mifi/queryMiFiCombo"   //获取套餐列表跟设备价格
#define KQueryMifiOrderByOrderNo   @"/mifi/queryMifiOrderByOrderNo"            //根据编号查询订单
#define KAddMifiUser      @"/mifi/addMiFiUser"  //添加用户实名制信息
#define KUpDateMifiOrder  @"/mifi/updateMiFiOrder"   //网上购买激活提交订单
#define KWeixinOrderMifiOrder  @"/mifi/createOrderMiFiWX" //微信订单提交
#define KZhifubaoOrderMifiOrder  @"/mifi/createOrderMiFi" //支付宝订单提交
#define KRepairsMiFiSuggest  @"/mifi/addMiFiSuggest" //故障报修
#define KCallBackMifiNotify  @"http://twapi.twldhome.com:8280/api-web/mifi/notifyUrlMiFi"    //支付宝回调接口
#define KQueryUserVerify    @"/mifi/queryMiFiUserByUserId" //查询用户是否认证
#define KQueryMifiUserByUserID  @"/mifi/queryMiFiUserByUserId" //查询SIM集合
#define KUpdateMifiUser         @"/mifi/updateMiFiUser"
#define KShoppingProductList    @"/shop/productList"   //获取产品列表
#define KAddProductToCar        @"/shop/saveCart"      //添加到购物车
#define KProductDetailInfo      @"/shop/product"       //产品详情信息
#define KShoppingCartList       @"/shop/cartList"      //获取购物车列表
#define KDeleteCart             @"/shop/deleteCart"    //删除购物车
#define KBuyNowForCreatOrder    @"/shop/createOrder"   //生成订单  （点击立即购买）
#define KBuyShoppingCarCreatOrder  @"/shop/createOrders" //生成订单（购物车）
#define KListKeyByUserId           @"/shop/keyListByUserId"  //获取激活码列表
#define KListByOrderId             @"/shop/keyListByOrderId"  //通过orderid获取激活码列表
#define KUpdateKeySimCard        @"/shop/updateKey"   //激活套餐
#define KCreatOrderWX            @"/shop/createOrderWX"  //微信支付订单
#define KUpdateAddessOrder             @"/shop/updateOrder"     //提交用户信息（姓名，地址）
#define KOrderShopList           @"/shop/orderList"  //获取订单列表
#define KOrderActionCard           @"http://twapi.twldhome.com:8280/api-web/shop/order"  //获取订单详情
#define KZFBCallBack             @"http://twapi.twldhome.com:8280/api-web/shop/notifyUrlZFB"
#define  KMIFIBanner             @"/mifi/miFiBanner"  //获取mifibanner图
#define  KMIFIDELETUser             @"/mifi/deleteMiFiUser"  //删除实名认证
//http://twzwx.tunnel.qydev.com/api-web

//资源管理
#define  KQueryRoomForUserPort             @"/lock/queryRoomByUserPort"  //获取机房列表
#define  KManageRoomById             @"/room/roomById"  //获取机房详细信息
#define  KManageEquipmentList         @"/room/equipmentList" //获取机柜列表
#define  KManageRoomTrayList          @"/room/roomTrayList"  //获取托盘端口号
#define  KUpdatePort                 @"/room/updatePort"  //修改端口信息
#define  KQueryClienteleBy          @"/room/queryClienteleBy" //查看端口用户信息
#define  KSaveClienteInfomation    @"/room/saveClientele" //保存端口下用户信息
#define  KUpdateShift              @"/room/updateShift"   //端口转移

//工单流转
#define KRoomSaveWorkOrder         @"/room/saveRoomOrder" //提交工单
#define KRoomOrderListByTel        @"/room/roomOrderListByTel"  //查询工单
#define KRoomUpdateWorkOrderTwo    @"/room/updateRoomOrder2" //工单流转 营销
#define KRoomUpdateWokeOrderThrd   @"/room/updateRoomOrder1" //管理员流转
#define KRoomUpdateWokeOrderFour   @"/room/updateRoomOrder3" //管理员反馈
#define KRoomQueryMarketingByRoomId  @"/room/queryMarketByRoomId" //查询该机房营销人员
#define KRoomWorkOderRecoderList   @"/room/roomOrderListByRoom" //工单记录
#define KRoomOrderListByState  @"/room/roomOrderListByState" //授权管理
#define KQueryPordAndRoomadress @"/room/queryPordAndClienteByRoomIdAddress"

@interface BaseViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic,strong)HttpRequest *http;
@property(nonatomic,strong)UserDefalut *user;
@property(nonatomic,strong)AppDelegate *app;


@property(nonatomic,strong)YDGHUB *hub;
@property (nonatomic,strong)UILabel *title_lbl;
@property (nonatomic,strong)UIButton *navLeftBtn;


-(void)netWorkState;

//设置左边的按钮(文字按钮)
- (void)setLeftButtonWithTitle:(NSString*)title
                        action:(SEL)selector;
- (void)setLeftButtonWithTitle:(NSString*)title
                        action:(SEL)selector
                    titleColor:(UIColor*)color;

//设置左边的按钮(图片按钮)
- (void)setLeftButtonWithImageName:(NSString*)imageName
                            action:(SEL)selector;
- (void)setLeftButtonWithNormarlImageName:(NSString*)normarName
                     highlightedImageName:(NSString *)highlightedName
                                   action:(SEL)selector;

//设置左边的按钮(通用按钮)
- (void)setLeftButton:(UIButton*)button
               action:(SEL)selector;


//设置右边的按钮(文字按钮)
- (void)setRightButtonWithTitle:(NSString*)title
                         action:(SEL)selector;
- (void)setRightButtonWithTitle:(NSString*)title
                         action:(SEL)selector
                     titleColor:(UIColor*)color;

//设置右边的按钮(图片按钮)
- (void)setRightButtonWithImageName:(NSString*)imageName
                             action:(SEL)selector;
- (void)setRightButtonWithNormarlImageName:(NSString*)normarName
                      highlightedImageName:(NSString *)highlightedName
                                    action:(SEL)selector;

//设置右边的按钮(通用按钮)
- (void)setRightButton:(UIButton*)button
                action:(SEL)selector;


/** 让滑动返回可以使用 */
- (void)enanblePopGobackGesture;
/** 让滑动返回不可以使用 */
- (void)unEnanblePopGobackGesture;
@end

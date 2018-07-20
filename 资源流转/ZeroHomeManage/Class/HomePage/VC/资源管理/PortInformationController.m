//
//  PortInformationController.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/26.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "PortInformationController.h"
#import "PanelInfoMationController.h"
#import "PortUserInfoModel.h"
#import "MJExtension.h"
#import "NSString+category.h"
#import "MHDatePicker.h"
#import "CustPickerView.h"
#import "DataUtility.h"
#import "Macro.h"

@interface PortInformationController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UILabel *headTitle_lbl;
@property (weak, nonatomic) IBOutlet UITextField *oldAddress_field;
@property (weak, nonatomic) IBOutlet UITextField *nowAddress_field;
@property (weak, nonatomic) IBOutlet UITextField *userName_field;
@property (weak, nonatomic) IBOutlet UITextField *photo_field;
@property (weak, nonatomic) IBOutlet UIButton *yunyinBtn;

//@property (weak, nonatomic) IBOutlet UITextField *yunyin_field;
@property (weak, nonatomic) IBOutlet UITextField *jieruhao_field;
@property (weak, nonatomic) IBOutlet UITextField *taocan_field;
@property (weak, nonatomic) IBOutlet UILabel *startTime_lbl;
@property (weak, nonatomic) IBOutlet UILabel *expresTime_lbl;
@property (weak, nonatomic) IBOutlet UILabel *installTime_lbl;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewConstWidth;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressconstWidth;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameconstWidth;
@property (weak, nonatomic) IBOutlet UIView *yunyingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yunyingconstWidth;

@property (weak, nonatomic) IBOutlet UIView *jieruView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jieruconstWidth;
@property (weak, nonatomic) IBOutlet UIView *taocanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taocanconstWidth;

@property (weak, nonatomic) IBOutlet UIView *openTimeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openTimeconstWidth;
@property (weak, nonatomic) IBOutlet UIView *installView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *installconstWidth;


@property (strong, nonatomic) MHDatePicker *startDatePicker;
@property (strong, nonatomic) MHDatePicker *expresDatePicker;
@property (strong, nonatomic) MHDatePicker *installDatePicker;

@property (nonatomic,assign) NSInteger selectNum;
@end

@implementation PortInformationController
{
    NSInteger portID; //用户信息ID
    NSInteger operatorType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title_lbl.text = @"端口信息";
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    
    if (IS_IPHONE5) {
        self.backViewConstWidth.constant = 320;
    }else if (IS_IPhone6){
        self.backViewConstWidth.constant = 375;
    }else if (IS_IPhone6plus){
         self.backViewConstWidth.constant = 414;
    }
    
//    _backScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
//    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 420);
    NSDictionary *dic = [APP_DELEGATE.portCache objectForKey:@"equipDic"];
    self.headTitle_lbl.text = [NSString stringWithFormat:@"%@ ->机柜-%@ -> 第%ld行,第%ld列",dic[@"roomName"],dic[@"equipmentCode"],(long)self.section,(long)self.row+1];
    self.oldAddress_field.text = self.roomPortModel.oldA;
    self.nowAddress_field.text = self.roomPortModel.nowA;
    //查看端口下用户信息
    [self requestQueryPortClienteUserInfo];
    
    UITapGestureRecognizer *startTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTimeTap:)];
    startTap.numberOfTapsRequired = 1;
    [self.startTime_lbl addGestureRecognizer:startTap];
    
    UITapGestureRecognizer *expresTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expresTap:)];
    expresTap.numberOfTapsRequired = 1;
    [self.expresTime_lbl addGestureRecognizer:expresTap];
    
    UITapGestureRecognizer *installTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(installTap:)];
    installTap.numberOfTapsRequired = 1;
    [self.installTime_lbl addGestureRecognizer:installTap];
    
    if (areaType == 8) { //营销人员
        self.addressView.hidden = YES   ;
        self.addressconstWidth.constant = 0.0;
        self.nameView.hidden = YES;
        self.nameconstWidth.constant = 0.0;
        self.yunyingView.hidden = YES;
        self.yunyingconstWidth.constant = 0.0;
        self.installView.hidden = YES;
        self.installconstWidth.constant = 0.0;
    }else if (areaType>0&&areaType<6){ //装维人远
        self.taocanView.hidden = YES;
        self.taocanconstWidth.constant = 0.0;
        self.openTimeView.hidden = YES;
        self.openTimeconstWidth.constant = 0.0;
    }else if (areaType == 9) //领导权限
    {
        self.editBtn.enabled = NO;
        [self setRightButtonWithTitle:@"" action:nil];
    }
}

-(void)configerDataToUIWithModel:(PortUserInfoModel *)model
{
    self.userName_field.text = model.clientele_name;
    self.photo_field.text = model.clientele_tel;
    switch (model.operatorType) {
        case 1:
            [self.yunyinBtn setTitle:@"电信" forState:UIControlStateNormal];
            break;
        case 2:
            [self.yunyinBtn setTitle:@"移动" forState:UIControlStateNormal];
            break;
            case 3:
            [self.yunyinBtn setTitle:@"联通" forState:UIControlStateNormal];
            break;
            case 4:
            [self.yunyinBtn setTitle:@"长宽" forState:UIControlStateNormal];
            break;
            case 5:
            [self.yunyinBtn setTitle:@"通网" forState:UIControlStateNormal];
            break;
            case 6:
            [self.yunyinBtn setTitle:@"备" forState:UIControlStateNormal];
            break;
            case 7:
            [self.yunyinBtn setTitle:@"无" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    self.jieruhao_field.text = model.wordOrder;
    self.taocan_field.text = model.combo;
    self.startTime_lbl.text = [NSString dateToStringWithString:model.openTime];
    self.expresTime_lbl.text = [NSString dateToStringWithString:model.expireTime];
    self.installTime_lbl.text = [NSString dateToStringWithString:model.installaTime];
     portID = model.ID; //用户信息ID
    self.selectNum = model.operatorType;
    
}

#pragma mark - 查看端口下的用户信息

- (void)requestQueryPortClienteUserInfo
{
    NSDictionary *parameters = @{@"token":usertoken,@"portId":[NSNumber numberWithInteger:self.roomPortModel.ID]};
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryClienteleBy];
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        
        NSLog(@"获取端口下用户信息==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSDictionary *portDic = jsonObj[@"message"][@"clientelePublicVO"];
            PortUserInfoModel *model = [PortUserInfoModel mj_objectWithKeyValues:portDic];
            [self configerDataToUIWithModel:model];
        
                [self setRightButtonWithTitle:@"改迁端口" action:@selector(clickRightBtn:)];
        }else{
            [self setRightButtonWithTitle:@"" action:nil];
           
            self.saveBtn.enabled = NO;
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark ---- 修改端口信息
- (void)requestChangePort
{

    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KUpdatePort];
    NSDictionary *parameters = @{@"token":usertoken,@"id":[NSNumber numberWithInteger:self.roomPortModel.ID],@"newA":self.nowAddress_field.text,@"portType":[NSNumber numberWithInteger:self.selectNum],@"roomId":portRoomID};
        NSLog(@"xxxx==%@",parameters);
        [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
            NSLog(@"修改端口信息==:%@",jsonObj);
            if([[jsonObj objectForKey:@"success"]boolValue]){
//                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                
            }else{
                [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
            }
            
        } Error:^(NSString *errMsg, id jsonObj) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
    
}


#pragma mark -- 保存用户信息
- (void)requestSaveUserInfomation
{
    NSString *startNum = [self stringConversionDateTime:self.startTime_lbl.text];
     NSString *expreNum = [self stringConversionDateTime:self.expresTime_lbl.text];
    NSString *installNum = [self stringConversionDateTime:self.installTime_lbl.text];
    
    //如果有ID 保存用户信息   没有ID 添加用户信息
    NSDictionary *parameters;
    if (portID != 0) {
      parameters = @{@"token":usertoken,@"clientele_name":self.userName_field.text,@"clientele_tel":self.photo_field.text,@"operatorType":[NSNumber numberWithInteger:self.selectNum],@"wordOrder":self.jieruhao_field.text,@"combo":self.taocan_field.text,@"openTimeS":startNum,@"expireTimeS":expreNum,@"installaTimeS":installNum,@"portId":[NSNumber numberWithInteger:self.roomPortModel.ID],@"id":[NSNumber numberWithInteger:portID]};
    }else{
        parameters = @{@"token":usertoken,@"clientele_name":self.userName_field.text,@"clientele_tel":self.photo_field.text,@"operatorType":[NSNumber numberWithInteger:self.selectNum],@"wordOrder":self.jieruhao_field.text,@"combo":self.taocan_field.text,@"openTimeS":startNum,@"expireTimeS":expreNum,@"installaTimeS":installNum,@"portId":[NSNumber numberWithInteger:self.roomPortModel.ID]};
    }
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KSaveClienteInfomation];
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"保存用户信息==:%@",jsonObj);
        
        if([[jsonObj objectForKey:@"success"]boolValue]){

            if (portID != 0) {
            [SVProgressHUD showSuccessWithStatus:@"信息修改成功"];
                
            }else{
            [SVProgressHUD showSuccessWithStatus:@"用户信息添加成功"];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark -- 编辑----
- (IBAction)editBtn:(UIButton *)sender {
    if ([DataUtility isBlankObject:self.roomPortModel.oldA]||[self.roomPortModel.oldA isEqualToString:@"备用"]) {
        [SVProgressHUD showInfoWithStatus:@"端口无原地址,请联系管理员"];
    }else{
        self.nowAddress_field.enabled = YES;
        self.userName_field.enabled = YES;
        self.photo_field.enabled = YES;
        self.yunyinBtn.enabled = YES;
        [self.yunyinBtn setBackgroundImage:[UIImage imageNamed:@"搜索选择时间.png"] forState:UIControlStateNormal];
        self.jieruhao_field.enabled = YES;
        self.taocan_field.enabled = YES;
        self.startTime_lbl.userInteractionEnabled = YES;
        self.expresTime_lbl.userInteractionEnabled = YES;
        self.installTime_lbl.userInteractionEnabled = YES;
        self.arrowImage.hidden = NO;
        self.backView.backgroundColor = HexRGB(0xffffff);
        self.saveBtn.enabled = YES;
    }
    
}

#pragma mark -- 保存-----
- (IBAction)saveBtn:(UIButton *)sender {
    self.backView.backgroundColor = [UIColor lightGrayColor];
    self.nowAddress_field.enabled = NO;
    self.userName_field.enabled = NO;
    self.photo_field.enabled = NO;
    self.yunyinBtn.enabled = NO;
    [self.yunyinBtn setBackgroundImage:nil forState:UIControlStateNormal];
    self.jieruhao_field.enabled = NO;
    self.taocan_field.enabled = NO;
    self.startTime_lbl.userInteractionEnabled = NO;
    self.expresTime_lbl.userInteractionEnabled = NO;
    self.installTime_lbl.userInteractionEnabled = NO;
    self.arrowImage.hidden = YES;
    
    [self requestSaveUserInfomation]; //保存用户信息
     [self requestChangePort];        //修改端口信息
    
    self.saveBtn.enabled = NO;
    
}


#pragma  mark --- SelectTimeTap
- (void)startTimeTap:(UITapGestureRecognizer *)tap
{
    _startDatePicker = [[MHDatePicker alloc] init];
    _startDatePicker.isBeforeTime = YES;
    _startDatePicker.datePickerMode = UIDatePickerModeDate;
    __weak typeof(self) weakSelf = self;
    [_startDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        weakSelf.startTime_lbl.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
    }];
}

- (void)expresTap:(UITapGestureRecognizer *)tap
{
    _expresDatePicker = [[MHDatePicker alloc] init];
    _expresDatePicker.isBeforeTime = YES;
    _expresDatePicker.datePickerMode = UIDatePickerModeDate;
    __weak typeof(self) weakSelf = self;
    [_expresDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        weakSelf.expresTime_lbl.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
    }];
}

- (void)installTap:(UITapGestureRecognizer *)tap
{
    _installDatePicker = [[MHDatePicker alloc] init];
    _installDatePicker.isBeforeTime = YES;
    _installDatePicker.datePickerMode = UIDatePickerModeDate;
    __weak typeof(self) weakSelf = self;
    [_installDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        weakSelf.installTime_lbl.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.backView endEditing:YES];
}

- (IBAction)clickYunyinBtn:(UIButton *)sender {
    [self.photo_field resignFirstResponder];
    [self.userName_field resignFirstResponder];
    [self.nowAddress_field resignFirstResponder];
    NSArray *operatorArray = @[@"无接入",@"电信",@"移动",@"联通",@"长宽",@"通网"];
        self.arrowImage.image = [UIImage imageNamed:@"上拉"];
        CustPickerView *custpickerView = [[CustPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndDataSouce:operatorArray];
        __weak typeof (self)weakSealf = self;
        [custpickerView didFinishSelectedDate:^(NSString *selectedDate,NSInteger num) {
            [weakSealf.yunyinBtn setTitle:selectedDate forState:UIControlStateNormal];
            weakSealf.arrowImage.image = [UIImage imageNamed:@"下拉"];
            _selectNum = num; //从0开始计算
            
        }];
}

#pragma mark --- textFieldDelegate --------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark --- 端口改迁------
- (void)clickRightBtn:(UIButton *)btn
{
    
    //修改为pop 利用delegate传值
    /*
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    NSArray *portArray = [app.portCache objectForKey:@"infoArray"];
    NSArray *indicator = [app.portCache objectForKey:@"indicatorArray"];
    PanelInfoMationController *vc = [[PanelInfoMationController alloc]init];
    vc.changePort = YES;
//    vc.savePortArray = portArray;
    vc.indicatorArray = indicator;
    vc.userId = self.infoModel.ID;
    vc.oldPortId = self.roomPortModel.ID;
    vc.operatorType = self.selectNum;
    [self.navigationController pushViewController:vc animated:YES];
    */
    self.callBackBlock(self.selectNum, self.roomPortModel.ID, portID, YES);
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

//字符串转时间戳
- (NSString *)stringConversionDateTime:(NSString *)dateStr
{
    if (![DataUtility isBlankObject:dateStr]) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//指定转date得日期格式化形式
        //    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/shanghai"];
        [dateFormatter setTimeZone:timeZone];
        
        NSDate *date = [dateFormatter dateFromString:dateStr];
        
        NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
        
        NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
        //   NSInteger dateInt = [timeString integerValue];
        return timeString;
    }else{
      return @"";
    }
    
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  WorkApplyViewController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/10.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "WorkApplyViewController.h"
#import "MHDatePicker.h"
#import "commitPhoto.h"
#import "CustPickerView.h"
#import "UpYun.h"
#import "DataUtility.h"
#import "MotoRoomModel.h"
#import "MJExtension.h"

@interface WorkApplyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (weak, nonatomic) IBOutlet UITextField *MotorRoom_field;

@property (weak, nonatomic) IBOutlet UITextField *startData_Field;
@property (weak, nonatomic) IBOutlet UITextField *startTime_Field;
@property (weak, nonatomic) IBOutlet UITextField *endData_Field;
@property (weak, nonatomic) IBOutlet UITextField *endTime_Field;

@property (nonatomic,strong)NSString *startTime_str;
@property (nonatomic,strong)NSString *endTime_str;

@property (strong, nonatomic) MHDatePicker *startTimePicker;
@property (strong, nonatomic) MHDatePicker *startDatePicker;
@property (strong, nonatomic) MHDatePicker *endTimePicker;
@property (strong, nonatomic) MHDatePicker *endDatePicker;
@property(nonatomic,strong)NSString *imageStr;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *reasonBtnArray;

@end

@implementation WorkApplyViewController
{
    UILabel *jieru_lbl;
    UITextField *jieru_field;
    
    UIButton *submit_btn;
    commitPhoto *photoView;
    NSMutableArray *roomName_arry;    //机房名称
    NSMutableArray *imageArray;       //工单照片数组
    NSMutableArray *roomID_arry;      //机房ID数组
    NSNumber *numId;                  //机房id
    NSMutableArray *roomLockNo_arry;  //机房编号数组
    
    NSString *phoneNum;
    NSString *roomName;              //选择的机房
    NSString *lock_noStr;            //机房编号
    NSInteger openType;              //开锁方式
    NSString *reason_messge;        //原因说明
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [jieru_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_phto_view.mas_left).offset(18);
        make.bottom.equalTo(_phto_view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 21));
    }];
    
    [jieru_field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jieru_lbl.mas_right).offset(10);
        make.centerY.equalTo(jieru_lbl.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatNavigation];
    [self creatBottomViewMessage];
    [self creatBottmBtn];
    
    roomName_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomID_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomLockNo_arry  = [[NSMutableArray alloc]initWithCapacity:0];
    //添加手势
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateImageVAction:)];
    [_backScrollView setUserInteractionEnabled:YES];
    [self.bottom_view addGestureRecognizer:tapGestureR];
    
    /*创建相册选择*/
    photoView = [[commitPhoto alloc]initWith:self];
    photoView.frame = CGRectMake(0, 34, SCREEN_WIDTH, (SCREEN_WIDTH-100)/4+10);
    _phto_view.height = (SCREEN_WIDTH-100)/4+20+29+40;
    jieru_lbl = [[UILabel alloc]init];
    jieru_lbl.text = @"接入号:";
    jieru_lbl.font = Font(16);
    jieru_lbl.textColor = HexRGB(0x333333);
//    jieru_lbl.frame = CGRectMake(18,CGRectGetMaxY(photoView.frame)+10 ,65 , 21);
   
    
    jieru_field = [[UITextField alloc]init];
    jieru_field.centerY = jieru_lbl.centerY;
    jieru_field.font = Font(14);
    jieru_field.placeholder = @"请输入接入号";
    jieru_field.borderStyle = UITextBorderStyleRoundedRect;
   
    
//    _phto_view.backgroundColor = [UIColor greenColor];
    _mtorRoom_view.top = _phto_view.bottom;
    _authenTime_view.top = _mtorRoom_view.bottom;
    _bottom_view.top = _authenTime_view.bottom;
    
    [_phto_view addSubview:photoView];
    [_phto_view addSubview:jieru_lbl];
     [_phto_view addSubview:jieru_field];
    
    /*手机号码*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    phoneNum = [ud objectForKey:@"iphoneNumber"];
    [self requestQueryRoomByUserWithTel:phoneNum]; //获取可申请权限的机房
    
    /*默认设置授权时间*/
    //[NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]]
    _startData_Field.text = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    _startTime_Field.text = [self dateStringWithDate:[NSDate date] DateFormat:@"HH:mm"];
    _startTime_str = [self dateStringWithDate:[NSDate date] DateFormat:@"HH:mm:ss"];
    
    //默认时间+5天
    NSDate *endDate = [[NSDate date]dateByAddingTimeInterval:24*60*60*5];
    _endData_Field.text = [self dateStringWithDate:endDate DateFormat:@"yyyy-MM-dd"];
    //默认的时间+2
    NSDate *timeDate = [NSDate dateWithTimeInterval:24*60*60*5 sinceDate:[NSDate date]];
    _endTime_Field.text = [self dateStringWithDate:timeDate DateFormat:@"HH:mm"];
    _endTime_str = [self dateStringWithDate:timeDate DateFormat:@"HH:mm:ss"];
    
    UIButton *btn = self.reasonBtnArray[0];
    btn.selected = YES;
    reason_messge = btn.currentTitle;
    
    for(UIView *view in self.diliviView)
    {
        view.height = 0.5f;
    }
}

#pragma mark ----创建授权申请按钮-------
- (void)creatBottmBtn
{
    submit_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
    [submit_btn setTitle:@"提交授权申请" forState:UIControlStateNormal];
    [submit_btn setBackgroundImage:[UIImage imageNamed:@"底部按钮1"] forState:UIControlStateNormal];
    submit_btn.titleLabel.font = Font(16);
    [submit_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit_btn addTarget:self action:@selector(submit_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submit_btn];
}


#pragma mark ------导航栏-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    self.title_lbl.text = @"装机授权申请";
}

#pragma mark ------底部信息-------------
- (void)creatBottomViewMessage
{
    NSString *message = @"授权说明:\n1.每张工单照片和接入号必须上传成功,后台才会跳纤成功;\n2.申请装机的时间必须大于四小时以上;\n3.申请提交后，请在申请记录中机房管理员会反馈结果。";
    
    UIView *topSeperaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
    [_bottom_view addSubview:topSeperaView];
    
    UILabel *explain_lbl = [[UILabel alloc]init];
    explain_lbl.font = Font(12);
    explain_lbl.textColor = HexRGB(0x999999);
    explain_lbl.numberOfLines = 0;
    [_bottom_view addSubview:explain_lbl];
    explain_lbl.text = message;
    
    /*设置行间距*/
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8];
    UIColor *color = HexRGB(0x999999);
    NSAttributedString *noticeStr = [[NSAttributedString alloc]initWithString:message attributes:@{NSForegroundColorAttributeName:color,NSParagraphStyleAttributeName:paragraphStyle}];
    explain_lbl.attributedText = noticeStr;
    
    
    [explain_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottom_view.mas_left).offset(18);
        make.top.equalTo(_bottom_view.mas_top).offset(10);
        make.right.equalTo(_bottom_view.mas_right).offset(-18);
    }];
    NSDictionary *attributes = @{NSFontAttributeName:Font(12), NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect_lbl = [explain_lbl.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-36, MAXFLOAT)
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:attributes
                                             context:nil];
    _bottom_view.height = rect_lbl.size.height +20;
    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _bottom_view.bottom);
    
}

#pragma mark - 获取可申请权限的机房
- (void)requestQueryRoomByUserWithTel:(NSString *)tel
{
    [roomName_arry removeAllObjects];
    [roomID_arry removeAllObjects];
    [roomLockNo_arry removeAllObjects];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryRoomByUser];
    
    NSDictionary *parameters = @{@"token":usertoken,@"tel":tel};
    NSLog(@"yyyyyy==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获取可申请权限的机房==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSArray *lockRoomArray = jsonObj[@"message"][@"LockRoomVOs"];
            if (lockRoomArray.count>0) {
                for(NSDictionary *dic in lockRoomArray)
                {
                    MotoRoomModel *model = [MotoRoomModel mj_objectWithKeyValues:dic];
                    
                    [roomName_arry addObject:model.room_name];
                    
                    [roomID_arry addObject:[NSNumber numberWithInteger:model.ID]];
                    [roomLockNo_arry addObject:model.lock_no];
                }
                if (roomName_arry.count>0) {
                    _MotorRoom_field.text = roomName_arry[0];
                    roomName = roomName_arry[0];
                    numId = roomID_arry[0];
                    lock_noStr = roomLockNo_arry[0];
                }
            }
            
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

//提交工单信息
- (void)requestSubmitData
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomSaveWorkOrder];
    NSMutableString *imagePath = [NSMutableString string];
    if(imageArray.count>0){
        for(int i=0;i<imageArray.count;i++){
            NSString *path = [imageArray objectAtIndex:i];
            [imagePath appendString:@","];
            [imagePath appendString:path];
        }
        imagePath = (NSMutableString *)[imagePath substringFromIndex:1];
    }
    
    NSString *startTime = [NSString stringWithFormat:@"%@ %@",_startData_Field.text,_startTime_str];
    NSString *startNum = [self stringConversionDateTime:startTime];
    
    NSString *endTime = [NSString stringWithFormat:@"%@ %@",_endData_Field.text,_endTime_str];
    NSString *endNum = [self stringConversionDateTime:endTime];

    NSDictionary *parament = @{@"token":usertoken,@"workerTel":phoneNum,@"roomId":numId,@"startTimeS":startNum,@"endTimeS":endNum,@"workerReason":reason_messge,@"imageOrder":imagePath,@"roomName":roomName,@"workerName":realName,@"type":[NSNumber numberWithInteger:areaType],@"workOrder":jieru_field.text};
    NSLog(@"commitxxxxx====>>%@",parament);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"%@",jsonObj);
        if([jsonObj[@"success"] boolValue]){
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];

            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
    } byUrl:urlStr parameters:parament IsSava:NO delegate:self isRefresh:NO];
    
    
}


#pragma mark ---选择申请说明
- (IBAction)selectReason:(UIButton *)sender {
    for (int i = 0;i<self.reasonBtnArray.count;i++) {
        if (sender.tag == 100+i) {
            sender.selected = YES;
            [sender setTitleColor:HexRGB(0x4facf6) forState:UIControlStateSelected];
            reason_messge = sender.currentTitle;
             continue;
        }
       
        UIButton *btn = [(UIButton *)self.view viewWithTag:i+100];
         btn.selected = NO;
        [btn setTitleColor:HexRGB(0x333333) forState:UIControlStateSelected];
    }
   
}



#pragma mark ----textFieldDelegate------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _startData_Field) {
        [_startData_Field resignFirstResponder];
        _startDatePicker = [[MHDatePicker alloc] init];
        _startDatePicker.isBeforeTime = NO;
        _startDatePicker.datePickerMode = UIDatePickerModeDate;
        __weak typeof(self) weakSelf = self;
        [_startDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
            weakSelf.startData_Field.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
            //默认的年月日
            weakSelf.endData_Field.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
        }];
        
    }else if (textField == _startTime_Field){
        [_startTime_Field resignFirstResponder];
        _startTimePicker = [[MHDatePicker alloc] init];
        if (_startDatePicker.selectDate>[NSDate date]) {
            _startTimePicker.isBeforeTime = YES;
        }else{
            _startTimePicker.isBeforeTime = NO;
        }
        
        _startTimePicker.datePickerMode = UIDatePickerModeTime;
        __weak typeof(self) weakSelf = self;
        [_startTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
            weakSelf.startTime_Field.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"HH:mm"];
            weakSelf.startTime_str = [weakSelf dateStringWithDate:selectedDate DateFormat:@"HH:mm:ss"];
            
            NSDate *endDate = [[NSDate date]dateByAddingTimeInterval:24*60*60*5];
            weakSelf.endData_Field.text = [self dateStringWithDate:endDate DateFormat:@"yyyy-MM-dd"];
            weakSelf.endTime_Field.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"HH:mm"];
            weakSelf.endTime_str = [weakSelf dateStringWithDate:selectedDate DateFormat:@"HH:mm:ss"];
        }];
        
    }else if (textField == _endData_Field){
        [_endData_Field resignFirstResponder];
        _endDatePicker = [[MHDatePicker alloc] init];
        _endDatePicker.isBeforeTime = NO;
        _endDatePicker.datePickerMode = UIDatePickerModeDate;
        __weak typeof(self) weakSelf = self;
        [_endDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
            weakSelf.endData_Field.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
        }];
        
    }else if (textField == _endTime_Field){
        [_endTime_Field resignFirstResponder];
        _endTimePicker = [[MHDatePicker alloc] init];
        _endTimePicker.isBeforeTime = YES;
        _endTimePicker.datePickerMode = UIDatePickerModeTime;
        __weak typeof(self) weakSelf = self;
        [_endTimePicker didFinishSelectedDate:^(NSDate *selectedDate) {
            weakSelf.endTime_Field.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"HH:mm"];
            weakSelf.endTime_str = [weakSelf dateStringWithDate:selectedDate DateFormat:@"HH:mm:ss"];
        }];
    }else if (textField == _MotorRoom_field)
    {
        [_MotorRoom_field resignFirstResponder];
        _arrowImage.image = [UIImage imageNamed:@"上拉"];
        if (roomName_arry.count>0) {
            CustPickerView *custpickerView = [[CustPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndDataSouce:roomName_arry];
            [custpickerView didFinishSelectedDate:^(NSString *selectedDate,NSInteger row) {
                _MotorRoom_field.text = selectedDate;
                _arrowImage.image = [UIImage imageNamed:@"下拉"];
                roomName = selectedDate;
                numId = [roomID_arry objectAtIndex:row];
//                lock_noStr = [roomLockNo_arry objectAtIndex:row];
            }];
            
        }
    }
}




#pragma mark -----CustomMethod------
- (void)todoSomething:(id)sender
{
    imageArray = [[NSMutableArray alloc]init];
    if (areaType>5) {
        if (photoView.dataArray.count == 1&&jieru_field.text.length == 0) {
            
                    [self postSubmit];
                return;

        }else if(photoView.dataArray.count==1&&jieru_field.text.length != 0){
            if ([DataUtility isBlankObject:numId]) {
                [SVProgressHUD showInfoWithStatus:@"您暂未绑定机房，请联系管理员授权"];
                return;
            }
            [self postSubmit];
            return;
        }
    }else{
        if (jieru_field.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请填写接入号"];

        }else if (photoView.dataArray.count==1){
            [SVProgressHUD showInfoWithStatus:@"请上传工单照片"];
        }
        
    }
    
    
    
    //取名。
    int i=0;
    //记录上传个数
    __block int count = 0;
    UpYun *uy = [[UpYun alloc] init];
    //取得images
    NSMutableArray *postImages = [NSMutableArray arrayWithCapacity:0];
    for(int j=0;j<photoView.dataArray.count-1;j++){
        id item = photoView.dataArray[j];
        UIImage *image;
        
        image = (UIImage *)item;
        
        if (image != nil) {
            [postImages addObject:image];
        }
        
    }
    //    @brief    根据 UIImage 上传
    
    for (UIImage *image in postImages) {
        
        //    @brief    根据 UIImage 上传
        UIImage *img = image;
        if (image.size.width>720)
        {
            float scale = 720.0/image.size.width ;
            img = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(720, image.size.height*scale)];
        }
        
        NSData *lastData = UIImageJPEGRepresentation(img, 0.5);
        
        //上传到又拍云
        [uy uploadFile:lastData saveKey:[self getSaveKey:i++]];
        uy.successBlocker = ^(id data)
        {
            count++;
            NSDictionary *dic = (NSDictionary *)data;
            NSLog(@"返回图片数据：%@",dic);
            NSString *strName = [NSString stringWithFormat:@"http://%@.b0.upaiyun.com%@",DEFAULT_BUCKET,[dic objectForKey:@"url"]];
            [imageArray addObject:strName];
            if(count == postImages.count){
                if ([DataUtility isBlankObject:numId]) {
                    [SVProgressHUD showInfoWithStatus:@"您暂未绑定机房，请联系管理员授权"];
                }else{
                    if (jieru_field.text.length != 0) {
                        [self postSubmit];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"请填接入号"];
                    }
                    
                }
            }
        };
        
        uy.failBlocker = ^(NSError * error)
        {
            count++;
            if(count == postImages.count){
                [SVProgressHUD showErrorWithStatus:@"上传失败"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            NSLog(@"%@",error);
        };
    }
    
}




- (void)submit_btn:(id)sender {
    [self.view endEditing:YES];
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(todoSomething:) object:sender];
    [self performSelector:@selector(todoSomething:) withObject:sender afterDelay:0.3f];
    
}

-(void)postSubmit{
    NSString *startTime = [NSString stringWithFormat:@"%@ %@",_startData_Field.text,_startTime_str];
    NSString *startNum = [self stringConversionDateTime:startTime];
    
    NSString *endTime = [NSString stringWithFormat:@"%@ %@",_endData_Field.text,_endTime_str];
    NSString *endNum = [self stringConversionDateTime:endTime];
    
    
    NSString *start = [startNum substringToIndex:10];
    NSTimeInterval startVal = [start doubleValue]+28800; //转成北京时间要加8小时
    NSDate *startDate=[NSDate dateWithTimeIntervalSince1970:startVal];
    
    NSString *end = [endNum substringToIndex:10];
    NSTimeInterval endVal = [end doubleValue]+28800;
    NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:endVal];
    NSDate *lastDate = [endDate laterDate:startDate];
    if ([lastDate isEqual:startDate]) {
        [SVProgressHUD showInfoWithStatus:@"申请结束时间不得小于开始时间"];
        return;
    }
    NSTimeInterval aTime = [endDate timeIntervalSinceDate:startDate];
    int hour = (int)(aTime / 3600);

    if (hour<4) {
        /*小于24个小时，不可以申请*/
        /*不能申请*/
        [SVProgressHUD showInfoWithStatus:@"提示:申请时间不能小于4小时"];
        return;
    }
    
    [self requestSubmitData];
}



-(NSString * )getSaveKey:(NSInteger)imageCount{
    /**
     *    @brief    方式1 由开发者生成saveKey
     //http://twshare.b0.upaiyun.com/18666224968/18666224968_1420530610093_s.jpg
     */
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"iphoneNumber"];
    NSString *imageName;
    
    imageName = [NSString stringWithFormat:@"%ld",(long)imageCount];
    
    NSString* date;
    NSString* timeNow;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY_MM_dd_hh_mm_ss_SSS"];
    date = [formatter stringFromDate:[NSDate date]];
    timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    
    self.imageStr = [NSString stringWithFormat:@"/%@/%@_%@.jpg",phoneNum,timeNow,imageName];
    return self.imageStr;
    
}

#pragma mark - 压缩图片
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
    
}

//手势执行的方法
-(void)updateImageVAction:(UITapGestureRecognizer *)tapGR
{
   
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//字符串转时间戳
- (NSString *)stringConversionDateTime:(NSString *)dateStr
{
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

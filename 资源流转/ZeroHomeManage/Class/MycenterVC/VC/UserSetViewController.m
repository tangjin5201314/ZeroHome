//
//  UserSetViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "UserSetViewController.h"
#import "CenterUserTableViewCell.h"
#import "FixPassWordViewController.h"
#import "UpYun.h"
#import "UIUtility.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
@interface UserSetViewController ()<MJRefreshBaseViewDelegate>

@end

@implementation UserSetViewController{
    NSMutableArray *content;
    UIActionSheet *sheet;
    
    UIImagePickerController *pickerView;
    
    MJRefreshHeaderView *headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_lbl.text = @"修改资料";
    // Do any additional setup after loading the view from its nib.
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back:)];
    
    _dataArray = [[NSMutableArray alloc]initWithObjects:@"头像",@"",@"昵称",@"性别",@"",@"密码",@"邮箱",@"手机号", nil];
    content = [[NSMutableArray alloc]initWithObjects:@"点击编辑头像",@"",@"未知姓名",@"",@"",@"********",@"没有设置邮箱",@"没有设置手机", nil];
    UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:view];
    
    _CenterTableView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];

    
    UIView *foot = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5 )];
    foot.backgroundColor = COLOR_RGB(200, 199, 204);
    _CenterTableView.tableFooterView = foot;
    
    headView = [[MJRefreshHeaderView alloc]initWithScrollView:_CenterTableView];
    headView.delegate = self;
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:COLOR_RGB(0, 0, 0)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
-(void)loadData{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kPersonCenter];
    
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                usertoken,@"token",
                                nil];
    NSLog(@"%@----%@",URLStr,parameters);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"个人中心:%@",jsonObj);
        if([[jsonObj  objectForKey:@"success"] boolValue]){
            //[UIUtility showAlertViewWithTitle:@"提示" messsge:@"添加成功"];
            NSDictionary *message = [jsonObj objectForKey:@"message"];
            [content replaceObjectAtIndex:7 withObject:[message objectForKey:@"PhoneNumber"]];
            [content replaceObjectAtIndex:6 withObject:[message objectForKey:@"email"]];
//            [content replaceObjectAtIndex:10 withObject:[message objectForKey:@"address"]];

//            [content replaceObjectAtIndex:8 withObject:[message objectForKey:@"branchAddress"]];
//            [content replaceObjectAtIndex:9 withObject:[message objectForKey:@"carNumber"]];
            [content replaceObjectAtIndex:2 withObject:[message objectForKey:@"nickname"]];
            [content replaceObjectAtIndex:3 withObject:[[message objectForKey:@"sex"] intValue]?@"女":@"男"];
            if([message objectForKey:@"headPortrait"]){
                [_dataArray replaceObjectAtIndex:0 withObject:[message objectForKey:@"headPortrait"]];
            }else{
                
            }
            [_CenterTableView reloadData];
        }else{
            
        }
        if([headView isRefreshing]){
            [headView endRefreshing];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        
        if([headView isRefreshing]){
            [headView endRefreshing];
        }
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"CenterUserTableViewCell";
    CenterUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"CenterUserTableViewCell" owner:self options:nil][0];
        
    }
    cell.LeftLabel.text = [_dataArray objectAtIndex:indexPath.row];
     cell.RightLabel.text = [content objectAtIndex:indexPath.row];
    if(indexPath.row!=0){
        [cell.ImageView removeFromSuperview];
        if(indexPath.row==1||indexPath.row==4){
            for(UIView *view in cell.contentView.subviews){
                [view removeFromSuperview];
                cell.contentView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
            }
            
        }
    }else if (indexPath.row == 0){
        [cell.LeftLabel removeFromSuperview];

        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 60, 60)];

        NSString *path = [[_dataArray objectAtIndex:indexPath.row] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imgView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"person.png"]];
        imgView.tag = 2050;
        [imgView.layer setMasksToBounds:YES];
        [imgView.layer setCornerRadius:30];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [cell addSubview:imgView];
    }
    if (indexPath.row == 2||indexPath.row == 3||indexPath.row == 6){
        cell.rightJianTou.hidden = YES;
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1||indexPath.row==4){
        return 17;
    }else if (indexPath.row == 0)
    {
        return 87;
    }
    return 48.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            //修改头像
            [self PickImage];
            break;
            case 2:
//             [SVProgressHUD showInfoWithS tatus:@"此功能暂未开通"];
            break;
            case 3:
//             [SVProgressHUD showInfoWithStatus:@"此功能暂未开通"];
            break;
         case 5:
            //修改密码
            [self fixPassWord];
            break;
        case 6:
            //修改邮箱
           
            break;
        case 7:
            //修改手机
          
            break;

        default:
            break;
    }
}
-(void)PickImage{
    sheet  =[[UIActionSheet alloc]init];
    sheet.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}
-(void)fixPassWord{
    FixPassWordViewController *FixPassWord = [[FixPassWordViewController alloc]initWithNibName:@"FixPassWordViewController" bundle:nil];
    [self.navigationController pushViewController:FixPassWord animated:YES];
}


#pragma mark - sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 0://相机
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;//相册
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    }
    else {
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            
        } else {
            return;
        }
    }
    // 跳转到相机或相册页面
    
    pickerView = [[UIImagePickerController alloc] init];
    pickerView.delegate = self;
    pickerView.allowsEditing = YES;
    pickerView.sourceType = sourceType;
    [self.view addSubview:pickerView.view];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    /*添加处理选中图像代码*/
    [pickerView.view removeFromSuperview];
    NSLog(@"%@",editingInfo);
    NSLog(@"image:%f,%f",image.size.width,image.size.height);
    [self uploadFile:image];
}
- (void)uploadFile:(UIImage *)image{
    [self.view addSubview:self.hub];
    UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(id data)
    {
        [self.hub removeFromSuperview];
        NSString *strName = [NSString stringWithFormat:@"http://%@.b0.upaiyun.com%@",DEFAULT_BUCKET,self.imageURL];
        [self changImage:strName];
        
        [_dataArray replaceObjectAtIndex:0 withObject:strName];
        [_CenterTableView reloadData];
        NSLog(@"%@",data);
    };
    
    uy.failBlocker = ^(NSError * error)
    {
        [self.hub removeFromSuperview];
        NSString *message = [error.userInfo objectForKey:@"message"];
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"error" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        NSLog(@"%@",error);
    };
    
    //	@brief	根据 UIImage 上传
    
    UIImage* img = image;
    if (image.size.width>500)
    {
        float scale = 500.0/image.size.width ;
        img = [self imageWithImageSimple:image scaledToSize:CGSizeMake(500, image.size.height*scale)];
        //img = [self imageWithImageSimple:img scaledToSize:CGSizeMake(60, 60)];
    }
    [uy uploadFile:img saveKey:[self getSaveKey]];
    
}
-(void)changImage:(NSString *)path{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kChangeImage];
    
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                usertoken,@"token",
                                path,@"headPortrait",
                                nil];
    NSLog(@"%@----%@",URLStr,parameters);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"修改头像:%@",jsonObj);
        if([[jsonObj  objectForKey:@"success"] boolValue]){
            NSString *point = [[jsonObj objectForKey:@"message"]objectForKey:@"point"];
            [SVProgressHUD showSuccessWithStatus:@"修改头像成功"];
            if ([point integerValue]>0) {
              [ShowSignHUB showSignInfo:[NSString stringWithFormat:@"积分 +%@",point]];
            
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"REFRESHFIXHEAD" object:nil];
            
            [_dataArray replaceObjectAtIndex:0 withObject:path];
            [_CenterTableView reloadData];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, newSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(newSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(NSString * )getSaveKey {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    NSDate *d = [NSDate date];
    self.imageURL = [NSString stringWithFormat:@"/%d/%d/%.0f.jpg",[self getYear:d],[self getMonth:d],[[NSDate date] timeIntervalSince1970]];
    return self.imageURL;
    
}

- (int)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year=[comps year];
    return year;
}

- (int)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps month];
    return month;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    /*添加代码，处理选中图像又取消的情况*/
    NSLog(@"取消");
    [pickerView.view removeFromSuperview];
    
}
//退出登陆
-(void)Quit{
    [self dismissViewControllerAnimated:YES completion:^{
        self.user.token = nil;
        self.user.loginPassWord = nil;
        self.user.isLogin = NO;
        self.user.isThirdLogin = NO;
        self.user.BranchID = nil;
        self.user.branchName = nil;
    }];
    
}
//MJRefresh
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [self loadData];
}
-(void)dealloc{
    [headView free];
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

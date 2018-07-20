//
//  DelegateViewController.m
//  ZeroHome
//
//  Created by Dagan on 15/12/7.
//  Copyright © 2015年 deguang. All rights reserved.
//

#import "DelegateViewController.h"

@interface DelegateViewController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSString *text;
@end

@implementation DelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title_lbl.text = @"服务条款";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _text = @"         零点家园智能手机应用平台服务条款\n\n一、服务条款的确认和接纳\n零点家园智能手机应用平台涉及的产品、相关软件的所有权和运作权归深圳市通网技术股份有限公司所有，用户一旦注册并勾选同意本服务条款，即表示用户与深圳市通网技术股份有限公司已达成协议，自愿接受本服务条款的所有内容和相关使用流程.\n二、用户账户的安全性\n1、用户注册成为零点家园智能手机应用平台的用户，必须满足以下条件：\n (1) 用户必须是所在小区的业主或租客；\n (2) 用户所在小区的物业公司与深圳市通网技术股份有限公司已经签订了使用零点家园智能手机应用平台的合作协议；\n (3) 用户有其所在物业公司或零点家园系统发送给他/她的小区验证码。\n2、用户一旦注册成功，成为零点家园智能手机应用平台的用户，将得到一个用户名和密码，并有权利使用自己的用户名及密码随时登陆零点家园智能手机应用平台。\n3、用户对用户名和密码的安全负全部责任，同时对以其用户名进行的所有活动和事件负全责。\n4、用户不得以任何形式擅自转让或授权他人使用自己的零点家园智能手机应用平台用户名。\n三、用户声明与保证\n 1、用户承诺其为具有完全民事行为能力的民事主体，具有达成交易履行其义务的能力。\n 2、用户有义务在注册时提供自己的真实资料，并保证诸如联系电话等内容的有效性及安全性，保证零点家园智能手机应用平台工作人员可以通过上述联系方式与用户取得联系。同时，用户也有义务在相关资料实际变更时及时更新有关注册资料。\n 3、用户同意其所在小区物业公司及深圳市通网技术股份有限公司通过零点家园智能手机应用平台向其发送信息，包含但不限于：\n (1) 小区的通知、宣传活动、调查表等信息；\n (2) 用户自己的物业管理账单及水电费账单等收费凭证；\n (3) 广告、便民商家信息、团购等商家信息；\n (4) 其他用户向其发送的信息等。\n4、用户通过零点家园智能手机应用平台发布的内容不得违反国家相关法律制度，包含但不限于如下原则：\n (1) 反对宪法所确定的基本原则的；\n (2) 危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n (3) 损害国家荣誉和利益的；\n (4) 煽动民族仇恨、民族歧视，破坏民族团结的；\n (5) 破坏国家宗教政策，宣扬邪教和封建迷信的；\n (6) 散布谣言，扰乱社会秩序，破坏社会稳定的；\n (7) 散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n (8) 侮辱或者诽谤他人，侵害他人合法权益的；\n (9) 含有法律、行政法规禁止的其他内容的。\n四、 零点家园智能手机应用平台提供的服务内容\n1、用户通过零点家园智能手机应用平台可获得如下主要服务：\n 1） 查收其所在小区物业公司发出的通知、账单等信息;\n 2） 查看小区周围的便民商家电话、参加团购；\n 3）在线提交反馈意见给物业公司；\n 4）向小区邻居发送私信进行互动交流等。\n2、零点家园智能手机应用平台有权随时审核或者删除用户发布的涉嫌违法，或违反社会主义精神文明，或者被零点家园智能手机应用平台认为不妥当的广告或者应用程序信息。\n五、 服务的终止\n在下列情况下，零点家园智能手机应用平台有权终止向用户提供服务：\n1、在用户违反本服务协议相关规定时，零点家园智能手机应用平台有权终止向该用户提供服务。如该用户再一次直接或间接或以他人名义注册为用户的，一经发现，零点家园智能手机应用平台有权直接单方面终止向该用户提供服务；\n2、一旦零点家园智能手机应用平台发现用户提供的数据或信息中含有虚假内容的，零点家园智能手机应用平台有权随时终止向该用户提供服务；\n3、本服务条款终止或更新时，用户明示不愿接受新的服务条款的；\n4、其它零点家园智能手机应用平台认为需终止服务的情况。\n服务终止后，零点家园智能手机应用平台没有义务为用户保留原账号中或与之相关的任何信息，或转发任何未曾阅读或发送的信息给用户或第三方。\n六、 服务的变更、中断\n1、鉴于网络服务的特殊性，用户需同意零点家园智能手机应用平台会变更、中断部分或全部的网络服务，并删除（不再保存）用户在使用服务中提交的任何资料，而无需通知用户，也无需对任何用户或任何第三方承担任何责任。\n2、零点家园智能手机应用平台需要定期或不定期地对提供网络服务的平台或相关的设备进行检修或者维护，如因此类情况而造成网络服务在合理时间内的中断，零点家园智能手机应用平台无需为此承担任何责任。\n七、 服务条款修改\n1、零点家园智能手机应用平台有权随时修改本服务条款的任何内容，一旦本服务条款的任何内容发生变动，零点家园智能手机应用平台将会通过适当方式向用户提示修改内容。\n2、如果不同意零点家园智能手机应用平台对本服务条款所做的修改，用户有权停止使用网络服务。\n3、如果用户继续使用网络服务，则视为用户接受零点家园智能手机应用平台对本服务条款所做的修改。\n八、 免责与赔偿声明\n1、若零点家园智能手机应用平台已经明示其服务提供方式发生变更并提醒用户应当注意事项，用户未按要求操作所产生的一切后果由用户自行承担。\n2、用户明确同意其使用零点家园智能手机应用平台服务所存在的风险将完全由其自己承担；因其使用零点家园智能手机应用平台服务而产生的一切后果也由其自己承担。\n3、用户同意保障和维护零点家园智能手机应用平台及其他用户的利益，由于用户发布内容违法、不真实、不正当、侵犯第三方合法权益，或用户违反本协议项下的任何条款而给深圳市通网技术股份有限公司、所在小区物业公司或其他第三人造成损失的，用户同意承担由此造成的全部赔偿责任。\n九、 隐私声明\n1、适用范围：\n(1)在用户注册零点家园智能手机应用平台账户时，根据要求提供的个人注册信息；\n(2)在用户使用零点家园智能手机应用平台服务时，零点家园智能手机应用平台自动接收并记录的信息或数据。v2、信息使用：\n(1) 零点家园智能手机应用平台不会向任何人出售或出借用户的个人信息，除非事先得到用户的许可。\n(2) 零点家园智能手机应用平台亦不允许任何第三方以任何手段收集、编辑、出售或者无偿传播用户的个人信息。任何用户如从事上述活动，一经发现，零点家园智能手机应用平台有权立即终止与该用户的服务协议，查封其账号。\n(3)为服务用户的目的，零点家园智能手机应用平台可能通过使用用户的个人信息，向用户提供服务，包括但不限于向用户发出产品和服务信息，或者与零点家园智能手机应用平台合作伙伴共享信息以便他们向用户发送有关其产品和服务的信息。\n3、信息披露--用户的个人信息将在下述情况下部分或全部被披露：\n(1)经用户同意，向第三方披露；\n(2)根据法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露；\n(3)如果用户出现违反中国有关法律或者网站政策的情况，需要向第三方披露；\n(4)为提供用户所要求的产品和服务，而必须和第三方分享用户的个人信息；\n(5)其它零点家园智能手机应用平台根据法律或者网站政策认为合适的披露；\n 以上条款的解释权归深圳市通网技术股份有限公司所最终所有.";
    
    UITableView *textTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH-20 ,SCREEN_HEIGHT-64)  style:UITableViewStylePlain];
    textTableView.dataSource = self;
    textTableView.delegate = self;
    textTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:textTableView];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        UILabel *textLabel = [self createLabelWithFrame:CGRectMake(0, 0, kWidth-20 ,kHeight-64) text:@"" font:14.0 textAli:NSTextAlignmentLeft textColor:MAIN_BLACK_COLOR];
        //        textLabel.numberOfLines = 0;
        //        textLabel.tag = 1000;
        //        [cell.contentView addSubview:textLabel];
    }
    cell.backgroundColor = [UIColor colorWithRed:0.85f green:0.85f blue:0.85f alpha:1.00f];
    cell.textLabel.text = _text;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    //    UILabel *textLabel = (UILabel *)[cell.contentView viewWithTag:1000];
    //
    //    textLabel.text = _text;
    //
    //    CGFloat height = [UIUtility getHeightOfString:textLabel.text withFont:[UIFont systemFontOfSize:15.0f] withWidth:kWidth-20];
    //    textLabel.height = height;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //CGFloat height = [UIUtility getHeightOfString:_text withFont:[UIFont systemFontOfSize:14.0f] withWidth:kWidth-20];
    CGSize size;
    if(SCREEN_WIDTH==375){
        size = [_text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    }else if (SCREEN_WIDTH==320){
        size = [_text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH-20, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    }else{
        size = [_text sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(SCREEN_WIDTH, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return size.height;
}


- (IBAction)back:(UIButton *)sender {
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

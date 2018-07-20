//
//  PanelInfoMationController.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "PanelInfoMationController.h"
#import "SelectItemCollectionViewCell.h"
#import "PortInformationController.h"
#import "ManageRoomListController.h"
#import "IndicatorDataSource.h"
#import "DataUtility.h"
#import "PortInfoModel.h"
#import "RoomPortModel.h"
#import "MJExtension.h"
#import "Macro.h"


@interface PanelInfoMationController ()<UIScrollViewDelegate>
{
     IndicatorDataSource *_dataSource;
}
@property (weak, nonatomic) IBOutlet UICollectionView *indicatorView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *headTitleName;


@property (weak, nonatomic) IBOutlet UILabel *count_lbl;
@property (weak, nonatomic) IBOutlet UILabel *allUseCount_lbl;
@property (weak, nonatomic) IBOutlet UILabel *contDX_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateDX_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countYD_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateYD_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countLT_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateLT_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countCK_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateCK_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countTW_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateTW_lbl;
@property (weak, nonatomic) IBOutlet UILabel *beIyong_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateBY_lbl;

@property (nonatomic,strong)NSMutableArray *portInfoArray;
@property (nonatomic,strong)NSMutableArray *roomPortArray;
@property (nonatomic,strong)NSMutableArray *indicatorNumberArray;
@property (nonatomic,strong)NSArray *listArray;

@property (nonatomic,assign)NSInteger userId; //用户ID
@property (nonatomic,assign)NSInteger oldPortId; //原端口ID;
@property (nonatomic,assign)NSInteger operatorType; //原运营商类型
@end

@implementation PanelInfoMationController
{
    PortInfoModel *portModel;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if (self.isChangePort == NO) {
//    [self requestroomTrayListWithEquipId:self.infoModel.ID];
//
//    }
    
   NSNumber *equpmentNumber = [APP_DELEGATE.portCache objectForKey:@"equipmentID"];
    NSInteger equpmentID = [equpmentNumber integerValue];
    [self requestroomTrayListWithEquipId:equpmentID];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_lbl.text = @"面板信息";
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
//    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
     [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    self.portInfoArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.indicatorNumberArray = [[NSMutableArray alloc]initWithCapacity:0];
    _dataSource = [[IndicatorDataSource alloc]init];
    UICollectionViewFlowLayout *indicatorLayout = [[UICollectionViewFlowLayout alloc]init];
    indicatorLayout.minimumLineSpacing = 1.0f;
    indicatorLayout.minimumInteritemSpacing = 1.0f;
    indicatorLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.indicatorView setCollectionViewLayout:indicatorLayout];
    self.indicatorView.delegate = _dataSource;
    self.indicatorView.dataSource = _dataSource;
    [self.indicatorView registerNib:[UINib nibWithNibName:@"IndicatorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"IndicatorCollectionViewCell"];
    
    UICollectionViewFlowLayout *selectFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    selectFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    selectFlowLayout.minimumLineSpacing = 0.0f;
    selectFlowLayout.minimumInteritemSpacing = 1.0f;
    [self.collectionView setCollectionViewLayout:selectFlowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SelectItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SelectItemCollectionViewCell"];
     NSLog(@"qqqqqqq-------qqqqqqqq%f",self.topView.bounds.size.width);
    
    
//     NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:self.savePortArray];
//    NSMutableArray *indicatorArray = [[NSMutableArray alloc]initWithArray:self.indicatorArray];
    if (self.isChangePort) {
        // self.portInfoArray = mutableArray;
//        _dataSource.dataArray = indicatorArray;
//        AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//        EquipMentListModel *model = [app.portCache objectForKey:@"equitListModel"];
//        [self configeDataWithModel:model];
//        [self requestroomTrayListWithEquipId:self.userId];
    }
//    }else{
//        [self configeDataWithModel:_infoModel];
//
//    }
    
    for (int i=1; i<13; i++) {
        CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width-11-24)/12;
        CGFloat item_X = (itemWidth+1)*(i-1);
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(item_X, 0, itemWidth, self.topView.bounds.size.height);
        label.text = [NSString stringWithFormat:@"%d",i];
        label.backgroundColor = HexRGB(0x4facf6);
        label.font = FONT_SYSTEM(15);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HexRGB(0xffffff);
        [self.topView addSubview:label];
    }
   
    
}

#pragma mark ---- 配置数据-----
- (void)configeDataWithModel:(EquipMentListModel *)model
{
    self.count_lbl.text = [NSString stringWithFormat:@"总端口数:%ld 户",(long)model.count];
    NSInteger allCount = model.countDX + model.countYD +model.countLT + model.countCK +model.countTW;
    self.allUseCount_lbl.text = [NSString stringWithFormat:@"总装机数:%ld 户",(long)allCount];
    self.contDX_lbl.text = [NSString stringWithFormat:@"电信:%ld 户",(long)model.countDX];
    self.rateDX_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateDX];
    
    self.countYD_lbl.text = [NSString stringWithFormat:@"移动:%ld 户",(long)model.countYD];
    self.rateYD_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateYD];
    
    self.countLT_lbl.text = [NSString stringWithFormat:@"联通:%ld 户",(long)model.countLT];
    self.rateLT_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateLT];
    
    self.countCK_lbl.text = [NSString stringWithFormat:@"长宽:%ld 户",(long)model.countCK];
    self.rateCK_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateCK];
    
    self.countTW_lbl.text = [NSString stringWithFormat:@"通网:%ld 户",(long)model.countTW];
    self.rateTW_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateTW];
    self.beIyong_lbl.text = [NSString stringWithFormat:@"备用:%ld 户",(long)model.countBY];
    self.rateBY_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateBY];
    
//    if (self.isChangePort) {
     NSDictionary *dic = [APP_DELEGATE.portCache objectForKey:@"equipDic"];
     self.headTitleName.text = [NSString stringWithFormat:@"%@ ->机柜 -> %@",dic[@"roomName"],dic[@"equipmentCode"]];
//    }else{
//      self.headTitleName.text = [NSString stringWithFormat:@"%@ ->机柜 -> %@",model.roomName,model.equipmentCode];
//    }
    
    
}

#pragma mark - 获取托盘端口
- (void)requestroomTrayListWithEquipId:(NSInteger )equipmentId
{
    [self.portInfoArray removeAllObjects];
    [self.indicatorNumberArray  removeAllObjects];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KManageRoomTrayList];
    
        NSDictionary *parameters = @{@"token":usertoken,@"roomId":portRoomID,@"equipmentId":[NSNumber numberWithInteger:equipmentId]};
        NSLog(@"xxxx==%@",parameters);
        [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
            
            NSLog(@"获取托盘端口==:%@",jsonObj);
            if([[jsonObj objectForKey:@"success"]boolValue]){
                NSArray *roomTrayArray = jsonObj[@"message"][@"roomTrayList"];
                if (roomTrayArray.count >0) {
                    NSDictionary *roomPortDic = jsonObj[@"message"][@"roomTrayList"][0];
                    NSString *roomName = roomPortDic[@"roomName"];
                    NSString *equipmentCode = roomPortDic[@"equipmentCode"];
                    NSDictionary *equipDic = @{@"roomName":roomName,@"equipmentCode":equipmentCode};
                    [APP_DELEGATE.portCache setObject:equipDic forKey:@"equipDic"];//保存数据
                }
                
                NSDictionary *equipmentDic = jsonObj[@"message"][@"equipmentVO"];
                EquipMentListModel *equipmentModel = [EquipMentListModel mj_objectWithKeyValues:equipmentDic];
                 [self configeDataWithModel:equipmentModel];//更新机柜信息
                
            _listArray = jsonObj[@"message"][@"roomTrayList"];
                NSInteger inditorNum = 1;
                for(NSDictionary *dic in _listArray)
                {
                    self.roomPortArray = [[NSMutableArray alloc]initWithCapacity:0];
                    portModel = [PortInfoModel mj_objectWithKeyValues:dic];
                   
                    for(RoomPortModel *model in portModel.roomPortVOs)
                    {
                        [self.roomPortArray addObject:model];

                    }
                    NSNumber *inditorNumber = [NSNumber numberWithInteger:inditorNum];
                    [self.indicatorNumberArray addObject:inditorNumber];
                     [self.portInfoArray addObject:self.roomPortArray];
                    inditorNum ++;
                }
                
                self.indicatorNumberArray =(NSMutableArray *)[[self.indicatorNumberArray reverseObjectEnumerator]allObjects];
             _dataSource.dataArray = self.indicatorNumberArray;
                
                /*把数组保存在文件夹里，用的时候再取*/
                AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                [app.portCache setObject:self.portInfoArray forKey:@"infoArray"];
                [app.portCache setObject:self.indicatorNumberArray forKey:@"indicatorArray"];
             [self.indicatorView reloadData];
             [self.collectionView reloadData];
        }
            
        } Error:^(NSString *errMsg, id jsonObj) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
    
}

#pragma mark ---- 转移端口信息
- (void)requestChangePortWithIndexpath:(NSIndexPath *)indexpath
{
    RoomPortModel *model = self.portInfoArray[indexpath.section][indexpath.row];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KUpdateShift];
    NSDictionary *parameters = @{@"token":usertoken,@"id":[NSNumber numberWithInteger:self.userId],@"portIdOld":[NSNumber numberWithInteger:self.oldPortId],@"portIdNew":[NSNumber numberWithInteger:model.ID],@"operatorType":[NSNumber numberWithInteger: self.operatorType]};
    NSLog(@"xxxx==%@",parameters);
    __weak typeof (self)weakSelf = self;
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"转移端口信息==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            [SVProgressHUD showInfoWithStatus:@"端口转移成功"];
            weakSelf.changePort = NO;
            NSNumber *equpmentNumber = [APP_DELEGATE.portCache objectForKey:@"equipmentID"];
            NSInteger equpmentID = [equpmentNumber integerValue];
            [weakSelf requestroomTrayListWithEquipId:equpmentID];
        }else{
            [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
    
}


#pragma mark ---两个collection联动-----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    self.indicatorView.contentOffset = contentOffset;
}
#pragma mark - UICollectionViewDataSource
//2: 设置section间的大小

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    return UIEdgeInsetsMake(1, 0, 0, 0);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"====%f ===%f",(self.collectionView.bounds.size.width-12)/12,self.collectionView.bounds.size.width);
    return CGSizeMake((self.collectionView.bounds.size.width-12)/12, 40);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //    return self.flowLayout.potisions.count;
    return [self.portInfoArray[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.portInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectItemCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger row = indexPath.section%2;
    if (row == 0) {
        cell.backgroundColor = HexRGB(0xffffff);
    }else{
        cell.backgroundColor = HexRGB(0xeef7ff);
    }
   RoomPortModel *model = self.portInfoArray[indexPath.section][indexPath.row];
   cell.model = model;
    return cell;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isChangePort) {
        RoomPortModel *model = self.portInfoArray[indexPath.section][indexPath.row];
        if (model.portType == 6 || model.portType == 7) {
          NSInteger sectionNum = self.indicatorNumberArray.count-indexPath.section;
            NSString *message = [NSString stringWithFormat:@"您选择的是第%ld行,第%ld列",(long)sectionNum,(long)indexPath.row+1];
            UIAlertController *alect = [UIAlertController alertControllerWithTitle:@"更改端口" message:message preferredStyle:UIAlertControllerStyleAlert];
            // 2.创建并添加按钮
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestChangePortWithIndexpath:indexPath];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            
            [alect addAction:okAction];
            [alect addAction:cancelAction];
            [self presentViewController:alect animated:YES completion:nil];

        }else{
          [SVProgressHUD showErrorWithStatus:@"端口已被占用"];
        }
        
    }else{
        RoomPortModel *model = self.portInfoArray[indexPath.section][indexPath.row];
        PortInformationController *vc = [[PortInformationController alloc]init];
        vc.roomPortModel = model;
        vc.infoModel = self.infoModel;
        vc.indexPath = indexPath;
        vc.section = self.indicatorNumberArray.count-indexPath.section;
        vc.row = indexPath.row;
        vc.callBackBlock = ^(NSInteger operateType, NSInteger oldPortID, NSInteger userID, BOOL isChangePort) {
            self.operatorType = operateType;
            self.oldPortId = oldPortID;
            self.userId = userID;
            self.changePort = isChangePort;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)back
{
//    if (self.isChangePort) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//
//    }
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

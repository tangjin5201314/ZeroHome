//
//  ManageRoomListController.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "ManageRoomListController.h"
#import "MangeRoomListCell.h"
#import "PanelInfoMationController.h"
#import "DataUtility.h"
#import "EquipMentListModel.h"
#import "MJExtension.h"
#import "Macro.h"
static NSString *const ManageRoomList = @"MangeRoomListCell";
@interface ManageRoomListController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *equipListArray;
@property (nonatomic,strong)UICollectionView *collect;
@end

@implementation ManageRoomListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_lbl.text = @"机柜信息";
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    _equipListArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 1.0f;
    
    _collect = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collect.backgroundColor = HexRGB(0xe5e5e5);
    _collect.delegate = self;
    _collect.dataSource = self;
    [_collect registerNib:[UINib nibWithNibName:ManageRoomList bundle:nil] forCellWithReuseIdentifier:ManageRoomList];
    [self.view addSubview:_collect];
    
    [self requestEquipmentList];
}

#pragma mark - 获取机柜列表
- (void)requestEquipmentList
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KManageEquipmentList];
    
    if (![DataUtility isBlankObject:self.lockRoomId]) {
        NSDictionary *parameters = @{@"token":usertoken,@"roomId":portRoomID};
        NSLog(@"xxxx==%@",parameters);
        [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
            
            NSLog(@"获取机柜列表==:%@",jsonObj);
            if([[jsonObj objectForKey:@"success"]boolValue]){
            NSArray *ListArray = jsonObj[@"message"][@"equipmentList"];
                if (ListArray.count != 0) {
                    for(NSDictionary *dic in ListArray)
                    {
                        EquipMentListModel *model = [EquipMentListModel mj_objectWithKeyValues:dic];
                        [_equipListArray addObject:model];
                    }
                    [_collect reloadData];
                }else{
                   [SVProgressHUD showInfoWithStatus:@"暂无机柜信息"];
                }   
            }else{
                [SVProgressHUD showInfoWithStatus:@"暂无机柜信息"];
            }
            
        } Error:^(NSString *errMsg, id jsonObj) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
    }
    
}



#pragma mark ----CollectionViewDelegate-----
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    return UIEdgeInsetsMake(1, 0, 0, 1);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(self.view.bounds.size.width-2)/2,176};
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.equipListArray.count;
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MangeRoomListCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:ManageRoomList forIndexPath:indexPath];
    EquipMentListModel *equitModel = self.equipListArray[indexPath.row];
    cell.model = equitModel;
    
    return cell;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EquipMentListModel *equitModel = self.equipListArray[indexPath.row];
   
    PanelInfoMationController *vc = [[PanelInfoMationController alloc]init];
    vc.infoModel = equitModel;
    [APP_DELEGATE.portCache setObject:[NSNumber numberWithInteger:equitModel.ID] forKey:@"equipmentID"];
//    vc.roomId = self.lockRoomId;
    [self.navigationController pushViewController:vc animated:YES];
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

//
//  SelectRoomViewController.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "SelectRoomViewController.h"
#import "RoomCollectionViewCell.h"
#import "MotoRoomModel.h"
#import "MJExtension.h"

static NSString *const RoomLockCell = @"RoomCollectionViewCell";
@interface SelectRoomViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)NSMutableArray *modelArray;
@end

@implementation SelectRoomViewController
{
    UICollectionView *collect;
    NSIndexPath *_oldIndexPath;
    NSMutableArray *roomName_arry;    //机房名称
    NSMutableArray *roomID_arry;      //机房ID数组
    
    NSString *name;
    NSNumber *roomId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_lbl.text = @"选择机房";
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    roomName_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomID_arry = [[NSMutableArray alloc]initWithCapacity:0];
    self.modelArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 1.0f;
    layout.minimumInteritemSpacing = 0.0f;
    collect = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    collect.backgroundColor = HexRGB(0xececec);
    collect.delegate = self;
    collect.dataSource = self;
    [collect registerNib:[UINib nibWithNibName:RoomLockCell bundle:nil] forCellWithReuseIdentifier:RoomLockCell];
    [self.view addSubview:collect];
    
    [self requestQueryRoomByUser];
}

#pragma mark - 获取机房列表

- (void)requestQueryRoomByUser
{
    /*手机号码*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
   NSString *phoneNum = [ud objectForKey:@"iphoneNumber"];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryRoomForUserPort];
    NSDictionary *parameters;
        if (self.isSelectProvince) {
            if ([self.province isEqualToString:@"全部省"]) {
                self.province = @"";
            }
            if ([self.city isEqualToString:@"全部市"]) {
                self.city = @"";
            }
            if ([self.area isEqualToString:@"全部区"]) {
                self.area = @"";
            }
        parameters = @{@"token":usertoken,@"tel":phoneNum,@"province":self.province,@"city":self.city,@"county":self.area};
            NSLog(@"xxxx==%@",parameters);
    }else{
        parameters = @{@"token":usertoken,@"tel":phoneNum};
        NSLog(@"xxxx==%@",parameters);

    }
        [self.http Post1NewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获取机房列表==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSArray *lockRoomArray = jsonObj[@"message"][@"LockRoomVOs"];
            if (lockRoomArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"该区域暂未绑定机房"];
            }
            for(NSDictionary *dic in lockRoomArray)
            {
                MotoRoomModel *model = [MotoRoomModel mj_objectWithKeyValues:dic];
                NSString *name = model.room_name;
                [roomName_arry addObject:name];
                [roomID_arry addObject:[NSNumber numberWithInteger:model.ID]];
                [self.modelArray addObject:model];
            }
            [collect reloadData];
            
        }else{
            
        }
    } Error:^(NSString *errMsg, id jsonObj) {
       [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


#pragma mark ----CollectionViewDataSouce-----
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    return UIEdgeInsetsMake(1, 0, 0, 0);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(self.view.bounds.size.width)/2,35};
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return roomID_arry.count;
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RoomCollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:RoomLockCell forIndexPath:indexPath];
    MotoRoomModel *model = self.modelArray[indexPath.row];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.roomName_lbl.text = model.room_name;
   if (model.selected == YES)  {
    cell.circle_image.image = [UIImage imageNamed:@"ic_selected"];
   }else{
    cell.circle_image.image = [UIImage imageNamed:@"ic_circle"];
   }
    return cell;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    name = roomName_arry[indexPath.row];
    roomId = roomID_arry[indexPath.row];
    MotoRoomModel *model = self.modelArray[indexPath.row];
    RoomCollectionViewCell *oldcell =(RoomCollectionViewCell *) [collectionView cellForItemAtIndexPath:_oldIndexPath];
    RoomCollectionViewCell *Cell =(RoomCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];

    if (indexPath.item == _oldIndexPath.item) {
        _oldIndexPath = nil;
        oldcell.circle_image.image = [UIImage imageNamed:@"ic_circle"];
        Cell.circle_image.image = [UIImage imageNamed:@"ic_selected"];
        model.selected = NO;
        
    }else{
        Cell.circle_image.image = [UIImage imageNamed:@"ic_selected"];
        oldcell.circle_image.image = [UIImage imageNamed:@"ic_circle"];
        model.selected = YES;
    }
    _oldIndexPath = indexPath;
    NSDictionary *dic = @{@"name":name,@"roomId":roomId};
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(callBackRoomInfomationWithDic:)]) {
        [self.delegate callBackRoomInfomationWithDic:dic];
    }
    
}

- (void)back
{
//    __weak typeof (self)weaSelf = self;
//    if (self.block) {
//        self.block(name, roomId);
//    }
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

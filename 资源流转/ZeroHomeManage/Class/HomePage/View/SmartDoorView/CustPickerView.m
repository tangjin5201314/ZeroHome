//
//  CustPickerView.m
//  ZeroHome
//
//  Created by TW on 16/11/30.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "CustPickerView.h"

#define kWinH [[UIScreen mainScreen] bounds].size.height
#define kWinW [[UIScreen mainScreen] bounds].size.width

// pickerView高度
#define kPVH (kWinH*0.35>230?230:(kWinH*0.35<200?200:kWinH*0.35))

@interface CustPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) UIButton *bgButton;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *toolBarView;
@property (nonatomic,strong) NSArray *dataAarray;
@property (strong, nonatomic) MotoRoomSelect selectBlock;
@property (nonatomic,strong)NSString *roomName;
@property (nonatomic,assign)NSInteger roomRow;
@end

@implementation CustPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame AndDataSouce:(NSArray *)soucerArray
{
    if (self = [super initWithFrame:frame]) {
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        _dataAarray = soucerArray;
        [self setupUI];
        
        [self pushDatePicker];
    }
    return self;
}

- (void)setupUI
{
    //半透明背景按钮
    _bgButton = ({
        _bgButton = [[UIButton alloc] init];
        [self addSubview:_bgButton];
        [_bgButton addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.backgroundColor = [UIColor blackColor];
        _bgButton.alpha = 0.0;
        _bgButton.frame = CGRectMake(0, 0, kWinW, kWinH);
        _bgButton;
    });
    
    _pickerView = ({
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kWinH, kWinW, kPVH)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerView];
        _pickerView;
        
    });
    _toolBarView = ({
        _toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, kWinH, kWinW, kPVH)];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_toolBarView];
        _toolBarView;
    });
    
        UIButton *left_btn = [[UIButton alloc]initWithFrame:CGRectMake(18, 10, 30, 31)];
        [left_btn setImage:[UIImage imageNamed:@"icon_cross"] forState:UIControlStateNormal];
        [left_btn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:left_btn];
  
    
        UIButton *right_btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 48, 10, 30, 31)];
        [right_btn setImage:[UIImage imageNamed:@"icon_tick"] forState:UIControlStateNormal];
        [right_btn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:right_btn];

}

#pragma mark - pickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _dataAarray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component
{
    return [_dataAarray objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _roomName = [_dataAarray objectAtIndex:row];
    _roomRow = row;
}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = UITextAlignmentCenter;
        [pickerLabel setTextColor:HexRGB(0x2e2e2e)];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)didFinishSelectedDate:(MotoRoomSelect)selectMotoRoom
{
    _selectBlock = selectMotoRoom;
}

#pragma mark - Custmethod
- (void)clickLeftBtn:(UIButton *)sender
{
    if (_selectBlock) {
        _selectBlock(_roomName,_roomRow);
    }
    [self dismissDatePicker];
}

- (void)clickRightBtn:(UIButton *)sender
{
    if (_selectBlock) {
        _selectBlock(_roomName,_roomRow);
    }
    [self dismissDatePicker];
}



//出现
- (void)pushDatePicker
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerView.frame = CGRectMake(0, kWinH - kPVH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.2;
        weakSelf.toolBarView.frame = CGRectMake(0, kWinH - kPVH-44, kWinW, 44);
        
        _roomName = [_dataAarray objectAtIndex:0];
    }];
}

//消失
- (void)dismissDatePicker
{
    if (_selectBlock) {
        _selectBlock(_roomName,_roomRow);
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.pickerView.frame = CGRectMake(0, kWinH, kWinW, kPVH);
        weakSelf.bgButton.alpha = 0.0;
         weakSelf.toolBarView.frame = CGRectMake(0, kWinH , kWinW, kWinH);
    } completion:^(BOOL finished) {
        [weakSelf.pickerView removeFromSuperview];
        [weakSelf.bgButton removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}


@end

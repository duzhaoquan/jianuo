//
//  ChoseTableView.m
//  WMS_APP_IOS
//
//  Created by jp123 on 16/8/5.
//  Copyright © 2016年 jp. All rights reserved.
//

#import "ChoseTableView.h"
#define CellID @"CellID"
#import "UIView+Extension.h"
#import "ChoseCell.h"
#import "ChoseCellModel.h"
#import "EquipmentModel.h"
#import "EquipidModel.h"
@interface ChoseTableView ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@end

@implementation ChoseTableView

#pragma mark - 初始化方法创建
//不让多选时用这个方法创建
- (instancetype)initWithFrame:(CGRect)frame ItemName:(NSString *)itemName DataArray:(NSArray*)dataArray canNotMulSelected:(BOOL)canNotMulSelected{
    
    _canNotMulSelected = canNotMulSelected;
    
    self =  [self initWithFrame:frame ItemName:itemName DataArray:dataArray];
    
    
    return self;
}
//可以多选时用这个方法创建
- (instancetype)initWithFrame:(CGRect)frame ItemName:(NSString *)itemName DataArray:(NSArray*)dataArray{
    
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app_back"]];
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[ChoseCell class] forCellReuseIdentifier:CellID];
        
        
        _selectedValues = [NSMutableArray array];
        _itemName = itemName;
        _dataArr = dataArray;
        
        _models = [NSMutableArray array];
        
        //创建记录UI选中状态的model数组
        for (int i = 0; i<_dataArr.count; i++) {
            ChoseCellModel *model = [[ChoseCellModel alloc]init];
            [_models addObject:model];
        }
        
        
        
//        //浮动的windows
//        _window = [[UIWindow alloc]initWithFrame:CGRectMake(self.x, self.y +self.height - 50, self.width, 50)];
//        _window.windowLevel = UIWindowLevelAlert+1;
//        
//        [_window addSubview:allSelect];
//        [_window addSubview:sureButton];
//        [_window setBackgroundColor:[UIColor orangeColor]];
        
        
        //[_window makeKeyAndVisible];//关键语句,显示window
        //_window.hidden = YES;
        
        
        
        //self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
        
        //self.tableHeaderView = headerView;
        
        //if (_canNotMulSelected) {
            self.isAllSelected = NO;
        //}else{
         //   self.isAllSelected = YES;
        //}
       
        
        //self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

        
        
    }
    return self;
}

- (void)sureButtonAction:(UIButton*)button{
    //self.hidden = YES;
    
    [self.choseDelegate choseTableViewsureButtonclick];
}

- (void)buttonAction:(UIButton*)button{
    
    self.isAllSelected = !_isAllSelected;
    
    [self reloadData];
}

- (void)setIsAllSelected:(BOOL)isAllSelected{
    _isAllSelected = isAllSelected;
    
    //处理选择结果
    if (_isAllSelected) {
        _selectedValues = [NSMutableArray arrayWithArray:_dataArr];
    }else{
        [_selectedValues removeAllObjects];
    }
    //处理UI显示
    if (!_canNotMulSelected) {//可以多选的情况下
        
        for (ChoseCellModel *model  in _models) {
            //是否全选
            if (_isAllSelected == YES) {
                model.isChose = YES;
            }else{
                model.isChose = NO;
            }
            
        }
    }
    
    [self reloadData];
}

-(void)setCanNotMulSelected:(BOOL)canNotMulSelected{
    _canNotMulSelected = canNotMulSelected;
}

#pragma mark-tableView代理
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    //全选按钮
    UIButton *allSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    allSelect.frame = CGRectMake(self.width - 140, 5, 60, 30);
    [allSelect setTitle:@"全选" forState:UIControlStateNormal];
    
    [allSelect setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    allSelect.layer.cornerRadius = 10;
    allSelect.layer.borderWidth = 1;
    allSelect.layer.borderColor = [UIColor blueColor].CGColor;
    allSelect.layer.backgroundColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1].CGColor;
    [allSelect addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_canNotMulSelected) {
        allSelect.hidden = YES;
    }
    //确定按钮
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 70, 5, 60, 30)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 10;
    sureButton.layer.borderWidth = 1;
    sureButton.layer.borderColor = [UIColor blueColor].CGColor;
    sureButton.layer.backgroundColor = [UIColor colorWithRed:237.0/255 green:237.0/255 blue:237.0/255 alpha:1].CGColor;
    [sureButton addTarget:self action:@selector(sureButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor orangeColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.width - 40, 30)];
    label.text = _itemName;
    //[label sizeToFit];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    [headerView addSubview:label];
    [headerView addSubview:allSelect];
    [headerView addSubview:sureButton];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _dataArr.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoseCell *cell = [self dequeueReusableCellWithIdentifier:CellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _models[indexPath.row];

    
    if (_canNotMulSelected) {//不能多选的情况下
        if (indexPath.row == _selectedIndex) {
            cell.model.isChose = YES;
            [_selectedValues addObject:_dataArr[indexPath.row]];
        }
    }
    
    //如果是数据是model
    if ([_dataArr[indexPath.row] isKindOfClass:[EquipmentModel class]]) {
        //EquipmentModel *model = _dataArr[indexPath.row];
        //cell.textLabel.text = [NSString stringWithFormat:@"%@-%@", model.equipment_name,model.equipment_id];
    }else if ([_dataArr[indexPath.row] isKindOfClass:[EquipidModel class]]){
        EquipidModel *model = _dataArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", model.equipment_uniqid];
    }else{
        NSString *str = _dataArr[indexPath.row];
        cell.textLabel.text = str;
    }
    
    return cell;
}

//选中时执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChoseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _selectedIndex = indexPath.row;
   
    //不让多选的情况
    if (_canNotMulSelected) {
        //让当前显示的cell全无对号
        for (ChoseCell *visibleCell in tableView.visibleCells) {
            visibleCell.accessoryType  = UITableViewCellAccessoryNone;
        }
        //把所有model的选择改为no
        for (ChoseCellModel *model in _models) {
            model.isChose = NO;
        }
        //把选中结果全部移除
        [_selectedValues removeAllObjects];

    }
    
    //选中哪个改变哪个
    if (cell.accessoryType == UITableViewCellAccessoryNone ) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        cell.model.isChose = YES;
        
        [_selectedValues addObject:_dataArr[indexPath.row]];
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.model.isChose = NO;
        
        [_selectedValues removeObject:_dataArr[indexPath.row]];
        
    }
    
    if (_canNotMulSelected) {
        self.hidden = YES;
    }
}


- (void)resignWindow
{
    
    [_window resignKeyWindow];
    _window = nil;
    
}


- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    _window.hidden = hidden;
    
    if (_canNotMulSelected) {
        _window.hidden = YES;
    }

}

- (void)dealloc
{
    [self resignWindow];
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    
    [_models removeAllObjects];
    for (int i = 0; i<_dataArr.count; i++) {
        ChoseCellModel *model = [[ChoseCellModel alloc]init];
        [_models addObject:model];
        if ([_dataArr[i] isKindOfClass:[EquipidModel class]]){
            EquipidModel *equipidmodel = _dataArr[i];
            model.isChose = equipidmodel.isselected;
            if (model.isChose) {
                [_selectedValues addObject:equipidmodel];
            }
            
        }
    }
    [self reloadData];
}


@end

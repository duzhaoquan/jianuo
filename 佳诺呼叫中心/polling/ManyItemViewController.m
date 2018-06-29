//
//  ManyItemViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/7.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "ManyItemViewController.h"
#import "TextFieldTableViewCell.h"
#import "UIResponder+FirstResponder.h"

@interface ManyItemViewController ()<UITableViewDelegate,UITableViewDataSource,TextFieldCellDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong)NSArray<NSString*>*values;
@property (nonatomic,strong)NSArray<NSString*>*rowStrs;
@property (nonatomic,strong)NSArray<NSString*>*keys;
@property (nonatomic,strong)NSMutableArray<NSMutableDictionary*>*dataArray;
@property (nonatomic,strong)NSArray<NSString*>*LastRowStrs;
@property (nonatomic,strong)NSArray<NSString*>*LastKeys;

@property (nonatomic,strong)NSMutableDictionary *datasDic;

@end

@implementation ManyItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _formName;
    [self setupTableView];
    _datasDic = [NSMutableDictionary dictionaryWithDictionary:_headerData];
    
    
    
    
    if ([self.title isEqualToString:@"标准溶液核查结果记录表"]) {
        _rowStrs =@[@"测试项目:",@"自动监测仪测定结果:",@"配置值:",@"相对误差:",@"备注:"];
        _keys = @[@"determination_project",@"determination_result",@"config_velue",@"relative_error",@"remarks"];
        _values = @[@"",@"",@"",@"",@""];
        _LastRowStrs = @[@"运营方代表:",@"日期:",@"企业方代表:",@"日期:"];
        _LastKeys = @[@"maintenance_representative",@"maintenance_date",@"enterprise_representative",@"enterprise_date"];
    }else if ([_formName isEqualToString:@"比对试验结果记录表"]){
        _rowStrs =@[@"测试项目:",@"单位:",@"自动监测仪测定结果:",@"对比方法测定结果1:",@"对比方法测定结果2:",@"对比检测结果平均值:",@"测定误差(%):"];
        _keys = @[@"test_project",@"test_unit",@"determination_result",@"contrast_result1",@"contrast_result2",@"contrast_average",@"determination_error"];
        _values = @[@"",@"",@"",@"",@"",@"",@""];
        _LastRowStrs = @[@"运营方代表:",@"日期:",@"企业方代表:",@"日期:"];
        _LastKeys = @[@"maintenance_representative",@"maintenance_date",@"enterprise_representative",@"enterprise_date"];
    }else if ([_formName isEqualToString:@"易耗品更换记录表"]){
        _rowStrs =@[@"易耗品名称:",@"规格型号:",@"单位:",@"数量:",@"更换时间:",@"更换原因说明(备注):"];
        _keys = @[@"consumables_name",@"consumables_model",@"consumables_unit",@"consumables_number",@"replacement_time",@"replacement_reason"];
        _values = @[@"",@"",@"",@"",@"",@""];
        
    }else if ([_formName isEqualToString:@"标准物质更换记录表"]){
        _rowStrs =@[@"标准物质名称:",@"规格型号:",@"单位:",@"数量:",@"更换时间:",@"供应商:"];
        _keys = @[@"standard_substance_name",@"standard_specifications",@"unit",@"number",@"change_time",@"supplier"];
        _values = @[@"",@"",@"",@"",@"",@""];
    }
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:[NSMutableDictionary dictionaryWithObjects:_values forKeys:_keys]];
    }
    
    [_tableView reloadData];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyBoard)];  
    gestureRecognizer.numberOfTapsRequired = 1;    
    gestureRecognizer.cancelsTouchesInView = NO;  
    [_tableView addGestureRecognizer:gestureRecognizer];
    [_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextCellID"];
    [self.view addSubview:_tableView];
    
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [button setTitle:@"提交表格" forState:UIControlStateNormal];
    
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}


-(void)buttonDidClick{
    if ( [ZQ_CommonTool isEmpty:_datasDic[@"order_sn"]]) {
        
        [WCAlertView showAlertWithTitle:@"提示" message:@"订单号不存在" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    if ([_formName isEqualToString:@"标准物质更换记录表"]||[_formName isEqualToString:@"易耗品更换记录表"]) {
        for (NSDictionary *dic in _dataArray) {
            NSScanner* scan;
            if ([_formName isEqualToString:@"易耗品更换记录表"]) {
                scan = [NSScanner scannerWithString:dic[@"consumables_number"]];
            }else{
                scan = [NSScanner scannerWithString:dic[@"number"]];
            }
            int val;
            if (!([scan scanInt:&val] && [scan isAtEnd])) {
                [WCAlertView showAlertWithTitle:@"提示" message:@"请填写正确的数量(整数)" customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            
        }
    }
    __weak ManyItemViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URL = @"";
    //转化成json
    NSData *afterData =  [NSJSONSerialization dataWithJSONObject:_dataArray options:0 error:nil];
    NSString *check_result = [[NSString alloc]initWithData:afterData encoding:NSUTF8StringEncoding];
    if ([_formName isEqualToString:@"标准溶液核查结果记录表"]) {
        _datasDic[@"check_result"] = check_result;
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/water_check_result"];
    }else if ([_formName isEqualToString:@"比对试验结果记录表"]){
        _datasDic[@"contrast_test"] = check_result;
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/smoke_contrast_test"];
    }else if ([_formName isEqualToString:@"易耗品更换记录表"]){
        _datasDic[@"consumables_replace"] = check_result;
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/smoke_consumables_replace"];
    }else if ([_formName isEqualToString:@"标准物质更换记录表"]){
        _datasDic[@"standard_replacement"] = check_result;
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/smoke_standard_replacement"];
    }
    
    NSMutableDictionary *params = _datasDic;
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        NSLog(@"responseObject = %@",responseObject);
        [weakSelf showHint:responseObject[@"msg"]];
        [weakSelf.navigationController popToViewController:self.formChoseVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count + 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < _dataArray.count) {
        return _rowStrs.count;
    }else if(section == _dataArray.count){
        return 0;
    }else{
        return _LastRowStrs.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCellID"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    cell.textField.enabled = YES;
    if (indexPath.section < _dataArray.count) {
        NSMutableDictionary *dic = _dataArray[indexPath.section];
        
        cell.firstLableText = _rowStrs[indexPath.row];
        cell.textField.text = dic[_keys[indexPath.row]];
        if([_formName isEqualToString:@"比对试验结果记录表"]){
            if (indexPath.row == 2 ||indexPath.row == 3||indexPath.row == 4) {
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            }else if (indexPath.row == 5){
                cell.textField.enabled = NO;
            }
        }
        if ([_formName isEqualToString:@"标准物质更换记录表"]||[_formName isEqualToString:@"易耗品更换记录表"]) {
            if (indexPath.row == 4) {
                cell.textFieldCellType = TextFieldCellTypeDatePiker;
                cell.datePicker.datePickerMode = UIDatePickerModeDate;
                NSDate *now = [NSDate date];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                cell.textField.text =  [formatter stringFromDate:now];
                dic[_keys[indexPath.row]] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
            }else if (indexPath.row == 3){
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
    }else{
        cell.firstLableText = _LastRowStrs[indexPath.row];
        if ([_formName isEqualToString:@"标准溶液核查结果记录表"]||[_formName isEqualToString:@"比对试验结果记录表"]) {
            if (indexPath.row % 2 == 1) {
                cell.textFieldCellType = TextFieldCellTypeDatePiker;
                cell.datePicker.datePickerMode = UIDatePickerModeDate;
                cell.textField.enabled = NO;
                NSDate *now = [NSDate date];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                cell.textField.text =  [formatter stringFromDate:now];
                _datasDic[_LastKeys[indexPath.row]] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
            }
        }
    }
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section<=_dataArray.count) {
        return 40;
    }else{
        return 0;
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section<_dataArray.count) {
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 40)];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = [NSString stringWithFormat:@"序号%ld",section+1];
        return lable;
    }else if(section == _dataArray.count){
        UIView *headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 40)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(kScreenwidth/2 - 100,0, 200, 40);
        [headview addSubview:button];
        [button setTitle:@"添加一条" forState:UIControlStateNormal];
        button.layer.cornerRadius = 10;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blueColor].CGColor;
        
        button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
        
        [button addTarget:self action:@selector(addItemAcion) forControlEvents:UIControlEventTouchUpInside];
        return headview;
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

-(void)addItemAcion{
    [_dataArray addObject:[NSMutableDictionary dictionaryWithObjects:_values forKeys:_keys]];
    [_tableView reloadData];
    
}

-(void)cellTextEndEdit:(NSString *)cellText IndexPath:(NSIndexPath *)indexPath{
    if ([ZQ_CommonTool isEmpty:cellText]) {
        return;
    }
    
    if (indexPath.section < _dataArray.count) {
        NSMutableDictionary *dic = _dataArray[indexPath.section];
        dic[_keys[indexPath.row]] = cellText;
        
        if([_formName isEqualToString:@"比对试验结果记录表"]){
            if (indexPath.row == 3||indexPath.row == 4) {
                if (![ZQ_CommonTool isEmpty:dic[_keys[3]]] && ![ZQ_CommonTool isEmpty:dic[_keys[4]]]){
                    float average = ([dic[_keys[3]] floatValue] + [dic[_keys[4]] floatValue])/2;
                    dic[_keys[5]] = [NSString stringWithFormat:@"%.2f",average];
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }
        
        if ([_formName isEqualToString:@"标准物质更换记录表"]||[_formName isEqualToString:@"易耗品更换记录表"]) {
            if (indexPath.row == 4) {
                dic[_keys[indexPath.row]] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
            }
        }
        
    }else{
        _datasDic[_LastKeys[indexPath.row]] = cellText;
        if ([_formName isEqualToString:@"标准溶液核查结果记录表"]||[_formName isEqualToString:@"比对试验结果记录表"]) {
            if (indexPath.row % 2 == 1) {
                _datasDic[_LastKeys[indexPath.row]] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
            }
        }
        
    }
    
    
}

-(void)hidekeyBoard{
    [self.view endEditing:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //取得第一响应者
    UIView *activeField = [UIResponder currentFirstResponder]; 
    //除去键盘后的页面显示区域
    CGRect aRect = self.view.frame;
    aRect.size.height =  aRect.size.height - keyBoardRect.size.height - 64;
    //判断cell底部是否在显示范围内
    CGPoint cellBottomPoint = CGPointMake(0.0, activeField.superview.superview.frame.origin.y +activeField.superview.superview.frame.size.height);
    if (!CGRectContainsPoint(aRect, cellBottomPoint) ) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
        CGPoint scrollPoint = CGPointMake(0.0, cellBottomPoint.y-aRect.size.height -44);
        [_tableView setContentOffset:scrollPoint animated:YES];
        
    }
    
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    
    [UIView animateWithDuration:.35 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end

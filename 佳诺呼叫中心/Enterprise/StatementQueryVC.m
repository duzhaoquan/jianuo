//
//  StatementQueryVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "StatementQueryVC.h"
#import "TaskListTableViewCell.h"
#import "TxetViewController.h"
#import "TaskModel.h"
#import "TaskfollowVC.h"
#import "StatementQueryDetailVC.h"

@interface StatementQueryVC ()<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *thereLabel;
@property (nonatomic,strong)NSMutableArray *taskList;
@property (nonatomic,strong)UITextField *customerNameTextField;
@property (nonatomic,strong)UIDatePicker *datePicker;


@property (nonatomic,strong)UITextField *beginDate;
@property (nonatomic,strong)UITextField *endDate;
@property (nonatomic,assign)BOOL isbeginDate;
@property (nonatomic,assign)BOOL isclear;

@end

@implementation StatementQueryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报表查询";
    _taskList = [NSMutableArray array];
    
    
    UIView *headerVIew =[[UIView alloc]initWithFrame: CGRectMake(0, 0, kScreenwidth, 90)];
    
    headerVIew.backgroundColor = [UIColor grayColor];
    [self setdatepicker];
    //textField
    if (_customerNameTextField == nil) {
        _customerNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5,(kScreenwidth - 20)*2/3, 30)];
        _customerNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        
        _customerNameTextField.placeholder = @"请输入客户名称...";
        _customerNameTextField.delegate = self; 
        _customerNameTextField.returnKeyType = UIReturnKeyDone;
        
        //_customerNameTextField.inputView = _datePicker;
    }
    
    if (_beginDate == nil) {
        _beginDate = [[UITextField alloc]initWithFrame:CGRectMake(10, 40, 148, 30)];
        _beginDate.borderStyle = UITextBorderStyleRoundedRect;
        _beginDate.tag = 700;
        _beginDate.placeholder =@"起始时间...";
        _beginDate.delegate = self; 
        
        _beginDate.textAlignment = NSTextAlignmentLeft;
        _beginDate.inputView = _datePicker;
        _beginDate.font = [UIFont systemFontOfSize:15];
        _beginDate.clearButtonMode = UITextFieldViewModeAlways;
    }
    if (_endDate == nil) {
        _endDate = [[UITextField alloc]initWithFrame:CGRectMake(162, 40, 148, 30)];
        _endDate.borderStyle = UITextBorderStyleRoundedRect;
        _endDate.tag = 701;
        _endDate.placeholder =@"结束时间...";
        _endDate.delegate = self; 
        
        _endDate.font = [UIFont systemFontOfSize:15];
        _endDate.inputView = _datePicker;
        _endDate.textAlignment = NSTextAlignmentLeft;
        _endDate.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    _beginDate.frame = CGRectMake(10, 40, 160, 30);
    [headerVIew addSubview:_beginDate];
    
    _endDate.frame = CGRectMake(175, 40, 160, 30);
    [headerVIew addSubview:_endDate];
    if (kScreenwidth <= 320) {
        _beginDate.frame = CGRectMake(1, 40, 159, 30);
        _endDate.frame = CGRectMake(160, 40, 159, 30);
    }
    
    _customerNameTextField.frame = CGRectMake(10, 5,(kScreenwidth - 20)*2/3,30);
    [headerVIew addSubview:_customerNameTextField];
    
    // 添加键盘上方的子视图  
    UIButton *keybutton = [UIButton buttonWithType:UIButtonTypeCustom];  
    keybutton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 40.0);  
    keybutton.backgroundColor = [UIColor greenColor];  
    [keybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];  
    [keybutton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];  
    [keybutton setTitle:@"确定" forState:UIControlStateNormal];  
    [keybutton addTarget:self action:@selector(hiddenKeyboard:) forControlEvents:UIControlEventTouchUpInside];  
    self.beginDate.inputAccessoryView = keybutton; 
    self.endDate.inputAccessoryView = keybutton;
    
    
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(_customerNameTextField.frame)+5, 5, (kScreenwidth - 20)/3, 30);
    [headerVIew addSubview:button];
    [button setTitle:@"查询" forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 10;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    
    button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
    
    [button addTarget:self action:@selector(searchAcion:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = headerVIew;
    
    [self getdata];
}

#pragma mark - 时间选择器
-(void)setdatepicker{
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _datePicker.locale = locale;
    
    _datePicker.maximumDate = [NSDate date];//可选的时间最大是当前时间
    [ _datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
}

-(void)dateChanged:(id)sender{  
    UIDatePicker *control = (UIDatePicker*)sender;  
    NSDate *date = control.date;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    
    if (_isbeginDate) {
       _beginDate.text =  confromTimespStr;
    }else{
        _endDate.text = confromTimespStr;
    }
    NSLog(@"date = %@",confromTimespStr);
    /*添加你自己响应代码*/  
}  
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_isclear) {
        _isclear = NO;
        return NO;
    }
    if (textField.tag == 700) {
        _isbeginDate = YES;
        if (![ZQ_CommonTool isEmpty:_beginDate.text]) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd日"];
            _datePicker.date = [formatter dateFromString:_beginDate.text];
        }
        _datePicker.minimumDate = nil;
        
    }else if(textField.tag == 701){
        _isbeginDate = NO;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *confromTimespStr = [formatter dateFromString:_beginDate.text];
        _datePicker.minimumDate = confromTimespStr;
        
        if (![ZQ_CommonTool isEmpty:_beginDate.text]) {
            _datePicker.date = [formatter dateFromString:_beginDate.text];
        }
        
    }
    
    return YES;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    _isclear = YES;
    return YES;
}

- (void)hiddenKeyboard:(UIButton*)button{
    
    [self.beginDate resignFirstResponder];
    [self.endDate resignFirstResponder];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *confromTimespStr = [formatter stringFromDate:_datePicker.date];
    
    //_datePicker.date.timeIntervalSince1970
    
    if (_isbeginDate) {
        _beginDate.text =  confromTimespStr;
    }else{
        _endDate.text = confromTimespStr;
    }
    
}
-(void)searchAcion:(UIButton*)butten{
    [self.beginDate resignFirstResponder];
    [self.endDate resignFirstResponder];
    [self.customerNameTextField resignFirstResponder];
    [self getdata];
}

-(void)getdata{
    __weak StatementQueryVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"group_id"] = [USERDEFALUTS objectForKey:@"group_id" ];
    params[@"customer_name"] = _customerNameTextField.text;
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    if (![ZQ_CommonTool isEmpty:_beginDate.text]) {
        NSTimeInterval begintime = [formatter dateFromString:_beginDate.text].timeIntervalSince1970;
        params[@"start"] = [NSString stringWithFormat:@"%f",begintime];
    }
    
    if (![ZQ_CommonTool isEmpty:_endDate.text]) {
        NSTimeInterval endtime = [formatter dateFromString:_endDate.text].timeIntervalSince1970;
        params[@"end"] = [NSString stringWithFormat:@"%f",endtime];
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_report_form"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"listData"];
        if (list.count == 0) {
            [_taskList removeAllObjects];
            [self.tableView.tableHeaderView addSubview: self.thereLabel];
        }else{
            [_taskList removeAllObjects];
            [self.thereLabel removeFromSuperview];
            for (NSDictionary *dic in list) {
                TaskModel *model = [[TaskModel alloc]init];
                [model setKeyValues:dic];
                [_taskList addObject:model];
            }
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}
- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 150)];
        _thereLabel.text = @"没有符合条件的任务";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
#pragma mark-tableViewDelegate
//头视图高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//        return 40;
//    
//
//}
//
////头视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *headerVIew =[[UIView alloc]initWithFrame: CGRectMake(0, 0, kScreenwidth, 50)];
//    
//    headerVIew.backgroundColor = [UIColor grayColor];
//    
//    //textField
//    if (_customerNameTextField == nil) {
//        _customerNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5,(kScreenwidth - 20)*2/3, 30)];
//        _customerNameTextField.borderStyle = UITextBorderStyleRoundedRect;
//        
//        _customerNameTextField.placeholder =@"请输入客户名称...";
//        _customerNameTextField.delegate = self; 
//        _customerNameTextField.returnKeyType = UIReturnKeyDone;
//        
//    }
//    _customerNameTextField.frame = CGRectMake(10, 5,(kScreenwidth - 20)*2/3, 30);
//    [headerVIew addSubview:_customerNameTextField];
//    
//    //按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.frame = CGRectMake(CGRectGetMaxX(_customerNameTextField.frame)+5, 5, (kScreenwidth - 20)/3, 30);
//    [headerVIew addSubview:button];
//    [button setTitle:@"查询" forState:UIControlStateNormal];
//    
//    button.layer.cornerRadius = 10;
//    button.layer.borderWidth = 1;
//    button.layer.borderColor = [UIColor blueColor].CGColor;
//    
//    button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
//    
//    [button addTarget:self action:@selector(searchAcion:) forControlEvents:UIControlEventTouchUpInside];
//    return headerVIew;
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    TaskModel *model = _taskList[indexPath.row];
//    NSString *text = [NSString stringWithFormat:@"客户名称:%@ \n设备类型: %@ \n故障类型: %@ \n上报时间:%@ \n任务状态: %@",model.customer_name,model.equipment_name,model.fault_name,model.dt,model.status_name];
//    cell.textLabel.text = text;
//    cell.textLabel.numberOfLines = 0;
    cell.cellType = 4;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    StatementQueryDetailVC *taskInfoVC = [[StatementQueryDetailVC alloc]init];
    taskInfoVC.model = _taskList[indexPath.row];
    [self.navigationController pushViewController:taskInfoVC animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskModel *model = _taskList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"客户名称: %@ \n设备类型: %@ \n故障类型: %@ \n上报时间: %@ \n任务状态: %@",model.customer_name,model.equipment_name,model.fault_name,model.dt,model.status_name];
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    NSString *remarks = [NSString stringWithFormat:@"状态备注: %@",model.remarks];
    CGSize remarkSize = [remarks sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    CGFloat height = size.height + remarkSize.height + 10;
    //NSLog(@"s = %f,r = %f,h = %f",size.height,remarkSize.height,height);
    return height;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_customerNameTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.beginDate resignFirstResponder];
    [self.endDate resignFirstResponder];
    [self.customerNameTextField resignFirstResponder];
}




@end

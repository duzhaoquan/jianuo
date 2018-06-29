//
//  PollingTaskQuryVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/24.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "PollingTaskQuryVC.h"
#import "PollingTaskReciveCell.h"
#import "PollingTaskModel.h"
#import "PollingTaskEquipsVC.h"
#import "DropDown.h"

@interface PollingTaskQuryVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UILabel *thereLabel;
@property (nonatomic,strong)NSMutableArray *taskList;
@property (nonatomic,strong)UITextField *customerNameTextField;
@property (nonatomic,strong)UIDatePicker *datePicker;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITextField *beginDate;
@property (nonatomic,strong)UITextField *endDate;
@property (nonatomic,assign)BOOL isbeginDate;
@property (nonatomic,assign)BOOL isclear;
@property (nonatomic,strong)DropDown *status;
@property (nonatomic,copy)NSString *statusId;
@property (nonatomic,assign)float cellWild;

@property (nonatomic,strong)UIView *headerVIew;

@end

@implementation PollingTaskQuryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检查询";
    _taskList = [NSMutableArray array];
    self.view.backgroundColor = [UIColor grayColor];
    //CGRectMake(0, CGRectGetMinY(headerVIew.frame)+ 50 +35,kScreenwidth, kScreenheight/2 - 50)
    _status = [[DropDown alloc]initWithFrame:CGRectMake(0,SafeAreaTopHeight+5,kScreenwidth,100)];
    _status.frameHeight = 120;
    _status.tabheight = 120;
    _status.textField.placeholder = @"状态不限";
    _status.name = @"status";
    _status.textField.frame = CGRectMake(10, 0, 300,30);
    NSArray *arr = @[@"未完成",@"已完成"];
    _status.tableArray = arr;
    [self.view addSubview:_status];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectInfo:) name:@"status" object:nil];
    UIView *headerVIew =[[UIView alloc]initWithFrame: CGRectMake(0, CGRectGetMaxY(_status.frame)+5, kScreenwidth, 80)];
    [self.view addSubview:headerVIew];
    headerVIew.backgroundColor = [UIColor grayColor];
    [self setdatepicker];
    //textField
    if (_customerNameTextField == nil) {
        _customerNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 40,(kScreenwidth - 20)*2/3, 30)];
        _customerNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        
        _customerNameTextField.placeholder = @"请输入查询关键字...";
        _customerNameTextField.delegate = self; 
        _customerNameTextField.returnKeyType = UIReturnKeyDone;
        
        //_customerNameTextField.inputView = _datePicker;
    }
    
    if (_beginDate == nil) {
        _beginDate = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 148, 30)];
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
        _endDate = [[UITextField alloc]initWithFrame:CGRectMake(162, 5, 148, 30)];
        _endDate.borderStyle = UITextBorderStyleRoundedRect;
        _endDate.tag = 701;
        _endDate.placeholder =@"结束时间...";
        _endDate.delegate = self; 
        
        _endDate.font = [UIFont systemFontOfSize:15];
        _endDate.inputView = _datePicker;
        _endDate.textAlignment = NSTextAlignmentLeft;
        _endDate.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    _beginDate.frame = CGRectMake(10, 5, 160, 30);
    [headerVIew addSubview:_beginDate];
    
    _endDate.frame = CGRectMake(175, 5, 160, 30);
    [headerVIew addSubview:_endDate];
    if (kScreenwidth <= 320) {
        _beginDate.frame = CGRectMake(1, 5, 159, 30);
        _endDate.frame = CGRectMake(160, 5, 159, 30);
    }
    
    _customerNameTextField.frame = CGRectMake(10, 40,(kScreenwidth - 20)*2/3,30);
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
    button.frame = CGRectMake(CGRectGetMaxX(_customerNameTextField.frame)+5, 40, (kScreenwidth - 20)/3, 30);
    [headerVIew addSubview:button];
    [button setTitle:@"查询" forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 10;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    
    button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
    
    [button addTarget:self action:@selector(searchAcion:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headerVIew = headerVIew;
    
    [self setupTableView];
    [self getdata];
}
-(void)selectInfo:(NSNotification*)not{
    NSDictionary *dictionary = not.userInfo;
    NSInteger index = [dictionary[@"index"] integerValue];
    if ([not.name isEqualToString:@"status"]) {
        if (index == -1) {
            _status.textField.text = @"";
            _statusId = @"";
        }else{
            if (index == 0) {
                _statusId = @"0";
            }else{
                _statusId = @"1";
            }
            
        }
        
    }
}
- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headerVIew.frame), kScreenwidth, kScreenheight-SafeAreaTopHeight-120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidelist)];  
//    gestureRecognizer.numberOfTapsRequired = 1;    
//    gestureRecognizer.cancelsTouchesInView = NO;  
//    [self.tableView addGestureRecognizer:gestureRecognizer];
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
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
    __weak PollingTaskQuryVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
//    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"status"] = _statusId;
    params[@"keywords"] = _customerNameTextField.text;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    
    if (![ZQ_CommonTool isEmpty:_beginDate.text]) {
        NSTimeInterval begintime = [formatter dateFromString:_beginDate.text].timeIntervalSince1970;
        params[@"start_time"] = [NSString stringWithFormat:@"%f",begintime];
    }
    
    if (![ZQ_CommonTool isEmpty:_endDate.text]) {
        NSTimeInterval endtime = [formatter dateFromString:_endDate.text].timeIntervalSince1970;
        params[@"end_time"] = [NSString stringWithFormat:@"%f",endtime];
    }
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/inspect_select"];
    
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
                PollingTaskModel *model = [[PollingTaskModel alloc]init];
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
        _thereLabel.text = @"没有符合条件的巡检任务";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
#pragma mark-tableViewDelegate
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return _headerVIew;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 110;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PollingTaskReciveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    PollingTaskModel *model = (PollingTaskModel *)[_taskList objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"订单号: %@ \n客户名称: %@ \n巡检人员: %@  \n开始时间: %@",model.order_sn,model.customer_name,model.member_name,model.addtime];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PollingTaskModel *model = (PollingTaskModel *)[_taskList objectAtIndex:indexPath.row];
    PollingTaskEquipsVC *taskDetail = [[PollingTaskEquipsVC alloc]init];
    taskDetail.fromQury = YES;
    taskDetail.model = model;
    //不签到不能进行巡检
    if ([model.status isEqualToString:@"0"]) {
        
        [WCAlertView showAlertWithTitle:@"提示" message:@"该巡检任务还未完成,不能查看!" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        
    }else{
        [self.navigationController pushViewController:taskDetail animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PollingTaskModel *model = (PollingTaskModel *)[_taskList objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"订单号: %@ \n客户名称: %@ \n联系人: %@  \n联系人电话: %@",model.order_sn,model.customer_name,model.customer_contacts,model.customer_contacts_phone];
    
    
    if (_cellWild == 0) {
        if (0 < tableView.visibleCells.count) {
            UITableViewCell *cell = [tableView.visibleCells objectAtIndex:0];
            if (cell) {
                _cellWild =  cell.textLabel.frame.size.width;
            }
            
            NSLog(@"cellWild:%f",_cellWild);
            
        }
    }
    
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:_cellWild];
    if (size.height < 100) {
        return 100;
    }else{
        return size.height+20;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_customerNameTextField resignFirstResponder];
    return YES;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.beginDate resignFirstResponder];
//    [self.endDate resignFirstResponder];
//    [self.customerNameTextField resignFirstResponder];
//    [_status dontshowlist];
//}
-(void)hidelist{
    [_status dontshowlist];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

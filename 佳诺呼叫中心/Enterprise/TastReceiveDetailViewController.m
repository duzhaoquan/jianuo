//
//  TastReceiveDetailViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TastReceiveDetailViewController.h"
#import "TaskDetailTableViewCell.h"
#import "TxetViewController.h"
#import "AssigningTaskViewController.h"
#import "TaskModel.h"
#import "TaskfollowVC.h"
#import "CustomerInforViewController.h"
@interface TastReceiveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UIView *remarkView;
@property (nonatomic,strong)UITextField *remarkTextField;
@property (nonatomic,strong)UITextField *timeTextField;
@property (nonatomic,strong)UIDatePicker *datePicker;
@end

@implementation TastReceiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务接受";
    [self setupTableView];
    [self setdatepicker];
    [self setupbutton];
    [self getdata];
    
    //KVO观察键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 时间选择器
-(void)setdatepicker{
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    _datePicker.locale = locale;
    
    _datePicker.minimumDate = [NSDate date];//可选的时间最小是当前时间
    [ _datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
}

-(void)dateChanged:(id)sender{  
    UIDatePicker *control = (UIDatePicker*)sender;  
    NSDate *date = control.date;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日hh时mm分"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    _timeTextField.text = confromTimespStr;
    
    NSLog(@"date = %@",confromTimespStr);
    /*添加你自己响应代码*/  
} 
- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[TaskDetailTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
}

-(void)setupbutton{
    
    
    //备注
    _remarkView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenheight - 105, self.view.frame.size.width - 20, 60)];
    _remarkView.backgroundColor = [UIColor whiteColor];
    _remarkView.layer.borderWidth = 1.0f;
    _remarkView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[_remarkView layer] setCornerRadius:7.];
    [[_remarkView layer] setMasksToBounds:YES];
    [self.view addSubview:_remarkView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 30, 60, 30)];
    label.text = @"备注:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [_remarkView addSubview:label];
    
    //
    self.remarkTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 30, CGRectGetWidth(_remarkView.frame) - 60, 30)];
    _remarkTextField.placeholder = @"请输入备注信息";
    _remarkTextField.textAlignment = NSTextAlignmentLeft;
    _remarkTextField.borderStyle = UITextBorderStyleNone;
    _remarkTextField.font = [UIFont systemFontOfSize:15.f];
    _remarkTextField.delegate = self;
    //设置键盘的样式
    //_remarkTextField.keyboardType = UIKeyboardTypeDefault;
    _remarkTextField.returnKeyType = UIReturnKeyDone;
    [_remarkView addSubview:_remarkTextField];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 120, 30)];
    label1.text = @"预计到场时间:";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    [_remarkView addSubview:label1];
    
    //
    self.timeTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, CGRectGetWidth(_remarkView.frame) - 120, 30)];
    _timeTextField.placeholder = @"请输入到场时间";
    _timeTextField.textAlignment = NSTextAlignmentLeft;
//    _timeTextField.borderStyle = UITextBorderStyleNone;
//    _timeTextField.font = [UIFont systemFontOfSize:15.f];
    _timeTextField.inputView = _datePicker;
    
    _timeTextField.delegate = self;
    // 添加键盘上方的子视图  
    UIButton *keybutton = [UIButton buttonWithType:UIButtonTypeCustom];  
    keybutton.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 40.0);  
    keybutton.backgroundColor = [UIColor greenColor];  
    [keybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];  
    [keybutton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];  
    [keybutton setTitle:@"确定" forState:UIControlStateNormal];  
    [keybutton addTarget:self action:@selector(hiddenKeyboard:) forControlEvents:UIControlEventTouchUpInside];  
    self.timeTextField.inputAccessoryView = keybutton; 
    
    //设置键盘的样式
    //_remarkTextField.keyboardType = UIKeyboardTypeDefault;
    _timeTextField.returnKeyType = UIReturnKeyDone;
    [_remarkView addSubview:_timeTextField];
    
    if ([[USERDEFALUTS objectForKey:@"group_id"] isEqualToString:@"12"]) {
        _remarkView.hidden = YES;
    } else {
        _remarkView.hidden = NO;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    if ([[USERDEFALUTS objectForKey:@"group_id"] isEqualToString:@"12"]) {
        [button setTitle:@"接受并分配任务" forState:UIControlStateNormal];
    } else {
        [button setTitle:@"接受任务" forState:UIControlStateNormal];
    }
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = button;
    [self.view addSubview:button];
}

-(void)getdata{
    __weak TastReceiveDetailViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"task_id"] = _model.task_id;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_failure_info"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSDictionary *list = responseObject[@"listData"];
//        _model = [[TaskModel alloc]init];
        [_model setKeyValues:list];
        
                
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

-(void)buttonDidClick{
    
    if ([[USERDEFALUTS objectForKey:@"group_id"] isEqualToString:@"12"]) {
        AssigningTaskViewController *assingTaskVC = [[AssigningTaskViewController alloc]init];
        assingTaskVC.taskReceiveViewController = _taskReceiveViewController;
        assingTaskVC.task_id = _model.task_id;
        assingTaskVC.task_order = _model.task_order;
        
        [self.navigationController pushViewController:assingTaskVC animated:YES];
    } else {
        [self taskReceive];
    }
}


-(void)taskReceive{
    if ( [ZQ_CommonTool isEmpty:_timeTextField.text]) {
        
        [WCAlertView showAlertWithTitle:@"提示" message:@"预计到达时间不能为空" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    
    __weak TastReceiveDetailViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //uid运维人员id、task_id任务id、task_order故障任务订单号、utype职员/客户、remarks备注

    params[@"task_id"] = _model.task_id;
    params[@"task_order"] = _model.task_order;
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"remarks"] = _remarkTextField.text;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy年MM月dd日hh时mm分"];
    
    NSTimeInterval time = [formatter dateFromString:_timeTextField.text].timeIntervalSince1970;
    params[@"arrive_time"] = [NSString stringWithFormat:@"%f",time];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/task_acceptance"];//http://118.190.156.153:8085/index.php/api/api/task_acceptance
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        //NSLog(@"responseObject = %@",responseObject);
        [weakSelf showHint:responseObject[@"msg"]];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"任务单号:%@",_model.failure_order];
    }else if (indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"故障类型:%@",_model.fault_name];
    }else if (indexPath.row == 2){
        cell.textLabel.text = [NSString stringWithFormat:@"故障描述:%@",_model.failure_description];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 3){
        cell.textLabel.text = [NSString stringWithFormat:@"设备类型:%@",_model.equipment_name];
        
    }else if (indexPath.row == 4){
        cell.textLabel.text = [NSString stringWithFormat:@"设备唯一码:%@",_model.equipment_uniqid];
    }else if (indexPath.row == 5){
        cell.textLabel.text = [NSString stringWithFormat:@"提交时间:%@",_model.dt];
    }else if (indexPath.row == 6){
        cell.textLabel.text = [NSString stringWithFormat:@"任务处理跟踪表"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 7){
        cell.textLabel.text = [NSString stringWithFormat:@"客户名称:%@",_model.customer_name];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 8){
        cell.textLabel.text = [NSString stringWithFormat:@"联系人:%@",_model.customer_contacts];
    }else if (indexPath.row == 9){
        cell.textLabel.text = [NSString stringWithFormat:@"联系电话:%@",_model.customer_contacts_phone];
    }else if (indexPath.row == 10){
        cell.textLabel.text = [NSString stringWithFormat:@"通讯地址:%@",_model.customer_contacts_address];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 11){
        cell.textLabel.text = [NSString stringWithFormat:@"备注:%@",_model.remarks];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 12){
        cell.textLabel.text = [NSString stringWithFormat:@"更新时间:%@",_model.update];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TxetViewController *textView = [[TxetViewController alloc]init];
    if (indexPath.row == 6) {
        TaskfollowVC *taskFllowVC = [[TaskfollowVC alloc]init];
        taskFllowVC.model = _model;
        [self.navigationController pushViewController:taskFllowVC animated:YES];
    }else if (indexPath.row == 10) {
        textView.title = @"通讯地址";
        textView.text = _model.customer_contacts_address;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 11){
        textView.title = @"备注信息";
        textView.text = _model.remarks;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 2){
        textView.title = @"故障描述";
        textView.text = _model.failure_description;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 7){
        CustomerInforViewController *customerInfoVC = [[CustomerInforViewController alloc]init];
        customerInfoVC.customer_id = _model.customer_id;
        [self.navigationController pushViewController:customerInfoVC animated:YES];
    }else if (indexPath.row == 9){
        //打电话 
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.customer_contacts_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 100;
    }
    return 0.000000001;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 100)];
        return view;
    }else{
        return nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_remarkTextField resignFirstResponder];
    [_timeTextField resignFirstResponder];
    return YES;
}


- (void)hiddenKeyboard:(UIButton*)button{
    
    [self.timeTextField resignFirstResponder];
   
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日hh时mm分"];
    NSString *confromTimespStr = [formatter stringFromDate:_datePicker.date];
    
    //_datePicker.date.timeIntervalSince1970
    
    _timeTextField.text =  confromTimespStr;
    
    
}

#pragma mark - 键盘输入事件处理
- (void)willShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    self.remarkView.transform = CGAffineTransformMakeTranslation(0, -keyboardH+45);
    
    [UIView commitAnimations];
    
}

-(void)hideShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.remarkView.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
} 


@end

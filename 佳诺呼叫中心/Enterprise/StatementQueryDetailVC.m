//
//  StatementQueryDetailVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "StatementQueryDetailVC.h"
#import "TaskDetailTableViewCell.h"
#import "TxetViewController.h"
#import "AssigningTaskViewController.h"
#import "TaskModel.h"
#import "TaskfollowVC.h"
#import "CustomerInforViewController.h"
@interface StatementQueryDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *bottomBtn;

@end

@implementation StatementQueryDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务详情";
    [self setupTableView];
    [self setupbutton];
    [self getdata];
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [button setTitle:@"查看任务跟踪表" forState:UIControlStateNormal];
   
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = button;
    [self.view addSubview:button];
}

-(void)getdata{
    __weak StatementQueryDetailVC *weakSelf = self;
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
        
        [_model setKeyValues:list];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

-(void)buttonDidClick{
    TaskfollowVC *taskFllowVC = [[TaskfollowVC alloc]init];
    taskFllowVC.model = _model;
    [self.navigationController pushViewController:taskFllowVC animated:YES];
   
}
#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
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
        cell.textLabel.text = [NSString stringWithFormat:@"客户名称:%@",_model.customer_name];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 7){
        cell.textLabel.text = [NSString stringWithFormat:@"联系人:%@",_model.customer_contacts];
    }else if (indexPath.row == 8){
        cell.textLabel.text = [NSString stringWithFormat:@"联系电话:%@",_model.customer_contacts_phone];
//        if (![ZQ_CommonTool isEmpty:_model.customer_contacts2_phone]) {
//            cell.textLabel.text = [NSString stringWithFormat:@"联系电话:%@",_model.customer_contacts2_phone];
//        }
    }else if (indexPath.row == 9){
        cell.textLabel.text = [NSString stringWithFormat:@"通讯地址:%@",_model.customer_contacts_address];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 10){
        cell.textLabel.text = [NSString stringWithFormat:@"备注信息:%@",_model.remarks];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 11){
        cell.textLabel.text = [NSString stringWithFormat:@"更新时间:%@",_model.update];
    }
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TxetViewController *textView = [[TxetViewController alloc]init];
    if (indexPath.row == 5) {
    }else if (indexPath.row == 9) {
        textView.title = @"通讯地址";
        textView.text = _model.customer_contacts_address;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 10){
        textView.title = @"备注信息";
        textView.text = _model.remarks;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 2){
        textView.title = @"故障描述";
        textView.text = _model.failure_description;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 6){
        CustomerInforViewController *customerInfoVC = [[CustomerInforViewController alloc]init];
        customerInfoVC.customer_id = _model.customer_id;
        [self.navigationController pushViewController:customerInfoVC animated:YES];
    }else if (indexPath.row == 8){
        //打电话 
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.customer_contacts_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}

@end

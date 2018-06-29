//
//  CustomerInforViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/14.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "CustomerInforViewController.h"
#import "TaskDetailTableViewCell.h"
#import "CustomerModel.h"
#import "CustomerInforTableViewCell.h"
#import "EquipListViewController.h"

@interface CustomerInforViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)CustomerModel *model;
@end

@implementation CustomerInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户信息";
    _model = [[CustomerModel alloc]init];
    [self setupTableView];
    [self getdata];
    
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[CustomerInforTableViewCell class] forCellReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_tableView];
}


-(void)getdata{
    __weak CustomerInforViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"customer_id"] = _customer_id;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_customer_detail"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSDictionary *list = responseObject[@"customer_info"];
        
        [_model setKeyValues:list];
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHieght = 40;

    NSString *text = @"";
    if (indexPath.row == 0) {
        text = [NSString stringWithFormat:@"客户名称 :%@",_model.customer_name];
    }else if (indexPath.row == 1){
        text = [NSString stringWithFormat:@"所属区域:%@",_model.area_name];
    }else if (indexPath.row == 2){
        text = [NSString stringWithFormat:@"合同时间:%@",_model.contract_time];
    }else if (indexPath.row == 3){
        text = [NSString stringWithFormat:@"合同期限:%@",_model.contract_period];
    }else if (indexPath.row == 4){
        text = [NSString stringWithFormat:@"对比费用:%@",_model.comparative_cost];
    }else if (indexPath.row == 5){ 
        text = [NSString stringWithFormat:@"承担配件费:%@",_model.accessory_cost];
        
    }else if (indexPath.row == 6){
        text = [NSString stringWithFormat:@"试剂标气:%@",_model.reagent_gas];
    }else if (indexPath.row == 7){
        text = [NSString stringWithFormat:@"维修时效:%@",_model.maintenance_time_limit];
    }else if (indexPath.row == 8){
        text = [NSString stringWithFormat:@"排放标准:%@",_model.emission_standard];
    }else if (indexPath.row == 9){
        text = @"设备信息";
    }
    
    CGSize remarkSize = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    cellHieght = remarkSize.height + 10;
    if (cellHieght < 40) {
        return 50;
    }
    
    return cellHieght;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.messageLabel.text = [NSString stringWithFormat:@"客户名称 :%@",_model.customer_name];
    }else if (indexPath.row == 1){
        cell.messageLabel.text = [NSString stringWithFormat:@"所属区域:%@",_model.area_name];
    }else if (indexPath.row == 2){
        cell.messageLabel.text = [NSString stringWithFormat:@"合同时间:%@",_model.contract_time];
    }else if (indexPath.row == 3){
        cell.messageLabel.text = [NSString stringWithFormat:@"合同期限:%@",_model.contract_period];
    }else if (indexPath.row == 4){
        cell.messageLabel.text = [NSString stringWithFormat:@"对比费用:%@",_model.comparative_cost];
    }else if (indexPath.row == 5){ 
        cell.messageLabel.text = [NSString stringWithFormat:@"承担配件费:%@",_model.accessory_cost];
    }else if (indexPath.row == 6){
        cell.messageLabel.text = [NSString stringWithFormat:@"试剂标气:%@",_model.reagent_gas];
    }else if (indexPath.row == 7){
        cell.messageLabel.text = [NSString stringWithFormat:@"维修时效:%@",_model.maintenance_time_limit];
    }else if (indexPath.row == 8){
        cell.messageLabel.text = [NSString stringWithFormat:@"排放标准:%@",_model.emission_standard];
    }else if (indexPath.row == 9){
        cell.messageLabel.text = @"设备信息";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000001;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {
        EquipListViewController *equipListVC = [[EquipListViewController alloc]init];
        equipListVC.customer_id = _customer_id;
        [self.navigationController pushViewController:equipListVC animated:YES];
    }
}

@end

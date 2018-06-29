//
//  FormChoseVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/26.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "FormChoseVC.h"
#import "FormHeaderVC.h"
#import "MessageAndDetailCell.h"
#import "FormModel.h"
#import "PollingWebViewController.h"

@interface FormChoseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *formList;

@end

@implementation FormChoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择表格";
    [self setupTableView];
    //_formList = @[@"水污染源自动检测仪运营维护日常巡检表",@"水污染源自动监测仪校准记录表",@"水污染源自动监测仪校验记录表",@"水污染源自动监测仪故障维修记录表",@"标准溶液核查结果记录表"];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getdata];
}
-(void)getdata{
    __weak FormChoseVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"order_sn"] = _taskModel.order_sn;
    params[@"equipment_id"] = _equipModel.equipment_id;
    params[@"type"]  = _equipModel.type;
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/get_form_list"];
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"data"];
        NSMutableArray *tempArr = [NSMutableArray array];
        if (list.count == 0) {

        }else{
            for (NSDictionary *dic in list) {
                FormModel *model = [[FormModel alloc]init];
                [model setKeyValues:dic];
                
                [tempArr addObject:model];
            }
            _formList = tempArr;
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}
- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[MessageAndDetailCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [button setTitle:@"完成巡检" forState:UIControlStateNormal];
    
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}
-(void)buttonDidClick{
    __weak FormChoseVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"order_sn"] = _taskModel.order_sn;
    params[@"equipment_id"] = _equipModel.equipment_id;
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/inspect_complete"];
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        [weakSelf showHint:responseObject[@"msg"]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _formList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    //NSString *text = [NSString stringWithFormat:@"%@",_formList[indexPath.row]];
    FormModel *model = _formList[indexPath.row];
    cell.messageLabel.text = model.form_name;
    //cell.detailLabel.text = @"未完成";
    if ([model.is_writable integerValue] == 1) {
        cell.detailLabel.text = @"已提交";
    }else{
        cell.detailLabel.text = @"";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 60;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FormModel *model = _formList[indexPath.row];
    if ([model.form_name isEqualToString:@"烟气自动监测设备维修记录表"]||[model.form_name isEqualToString:@"水污染源自动监测仪故障维修记录表"]||[model.is_writable integerValue] == 0) {
        FormHeaderVC *headVC = [[FormHeaderVC alloc]init];
        headVC.formChoseVC = self;
        headVC.taskModel = _taskModel;
        headVC.equipModel = _equipModel;
        FormModel *model = _formList[indexPath.row];
        headVC.formModel = model;
        headVC.title = model.form_name;
        [self.navigationController pushViewController:headVC animated:YES];
    }else{
       
        PollingWebViewController *pollingWebViewController = [[PollingWebViewController alloc]init];
        pollingWebViewController.title = model.form_name;
        pollingWebViewController.URLString = model.form_url;
        [self.navigationController pushViewController:pollingWebViewController animated:YES];
        
    }
    
    
    
}

@end

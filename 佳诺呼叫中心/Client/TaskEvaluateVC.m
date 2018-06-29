//
//  TaskEvaluateVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/24.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskEvaluateVC.h"
#import "TaskListTableViewCell.h"
#import "TaskModel.h"
#import "TaskEvaluateDetailViewController.h"
@interface TaskEvaluateVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *faultList;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UILabel *thereLabel;
@end

@implementation TaskEvaluateVC

- (void)viewDidLoad {
    [super viewDidLoad];
     _faultList = [NSMutableArray array];
    self.title = @"任务评价";
    [self setuptableview];
    [self getdata];
}

-(void)setuptableview{
    _tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.estimatedSectionFooterHeight = 0;
    [_tableview registerClass:[TaskListTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableview];
}

- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"您没有需要评价的任务";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
-(void)getdata{
    __weak TaskEvaluateVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"group_id"] = [USERDEFALUTS objectForKey:@"group_id" ];
    params[@"status"] = @"6";
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_failure_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"listData"];
        if (list.count == 0) {
            
            self.tableview.tableHeaderView = self.thereLabel;
        }else{
            
            for (NSDictionary *dic in list) {
                TaskModel *model = [[TaskModel alloc]init];
                [model setKeyValues:dic];
                [_faultList addObject:model];
            }
            [self.tableview reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _faultList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    TaskModel *model = _faultList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"客户名称:%@ \n设备名称: %@ \n故障类型: %@ \n上报时间:%@ ",model.customer_name,model.equipment_name,model.fault_name,model.dt];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    TaskModel *model = _faultList[indexPath.row];
    TaskEvaluateDetailViewController *taskEvaluateDetailViewController = [[TaskEvaluateDetailViewController alloc]init];
    taskEvaluateDetailViewController.taskmodel = model;
    [self.navigationController pushViewController:taskEvaluateDetailViewController animated:YES];
    
}

@end

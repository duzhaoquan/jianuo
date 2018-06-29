//
//  ProgressQueryViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "ProgressQueryViewController.h"
#import "TaskListTableViewCell.h"
#import "TaskListTableViewCell.h"
#import "Fault.h"
#import "FaultTableViewCell.h"
#import "TaskModel.h"
#import "TaskListTableViewCell.h"
#import "AchieveSureDetailViewController.h"
#import "TaskfollowVC.h"

#import "UIViewController+ViewControllerPop.h"

@interface ProgressQueryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray *faultList;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UILabel *thereLabel;
@property (nonatomic,strong)UIDatePicker *datePicker;


@end

@implementation ProgressQueryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _faultList = [NSMutableArray array];
    self.title = @"进度查询";
    [self setuptableview];
    
    [self getdata];
}

- (BOOL)navigationShouldPopOnBackButton{
    _QueryBlock();
    
    return YES;
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
        _thereLabel.text = @"您没有提交过故障";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
-(void)getdata{
    __weak ProgressQueryViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"group_id"] = [USERDEFALUTS objectForKey:@"group_id" ];
    
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
    cell.cellType = 5;
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskModel *model = _faultList[indexPath.row];
    NSString *text = [NSString stringWithFormat:@"客户名称: %@ \n设备类型: %@ \n故障类型: %@ \n上报时间: %@ \n任务状态: %@",model.customer_name,model.equipment_name,model.fault_name,model.dt,model.status_name];
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    NSString *remarks = [NSString stringWithFormat:@"状态备注: %@",model.remarks];
    CGSize remarkSize = [remarks sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreenwidth - 20];
    
    CGFloat height = size.height + remarkSize.height + 10;
    //NSLog(@"s = %f,r = %f,h = %f",size.height,remarkSize.height,height);
    return height;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    TaskModel *model = _faultList[indexPath.row];
    TaskfollowVC *taskFollowVC = [[TaskfollowVC alloc]init];
    taskFollowVC.model = model;
    [self.navigationController pushViewController:taskFollowVC animated:YES];
    
}

@end

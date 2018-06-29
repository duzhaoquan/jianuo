//
//  PollingTaskReceiveViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/6.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "PollingTaskReceiveViewController.h"
#import "PollingTaskReciveCell.h"
#import "PollingTaskModel.h"
#import "PollingTaskDetailVC.h"
@interface PollingTaskReceiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *taskList;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *thereLabel;

@end

@implementation PollingTaskReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检任务接受";
    _taskList = [NSMutableArray array];
    [self setupTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getdata];
}
- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[PollingTaskReciveCell class] forCellReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_tableView];
    
    
}
-(void)getdata{
    __weak PollingTaskReceiveViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    //http://192.168.12.230:90/index.php/api/Inspect/get_task_list
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/get_task_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSArray *list = responseObject[@"listData"];
        if (list.count == 0) {
            [_taskList removeAllObjects];
            self.tableView.tableHeaderView = self.thereLabel;
        }else{
            [_taskList removeAllObjects];
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
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"您没有要接收的任务";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PollingTaskReciveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    PollingTaskModel *model = (PollingTaskModel *)[_taskList objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"客户名称: %@ \n巡检人员: %@  \n分配时间: %@",model.customer_name,model.member_name,model.addtime];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = text;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PollingTaskModel *model = (PollingTaskModel *)[_taskList objectAtIndex:indexPath.row];
    PollingTaskDetailVC *taskDetail = [[PollingTaskDetailVC alloc]init];
    taskDetail.customer_id = model.customer_id;
    taskDetail.order_sn = model.order_sn;
    [self.navigationController pushViewController:taskDetail animated:YES];
    
}

@end

//
//  PollingTaskChoseVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/24.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "PollingTaskChoseVC.h"
#import "PollingTaskReciveCell.h"
#import "PollingTaskModel.h"
#import "PollingTaskEquipsVC.h"

@interface PollingTaskChoseVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *taskList;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *thereLabel;

@property (nonatomic,assign)float cellWild;

@end

@implementation PollingTaskChoseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"巡检任务";
    _taskList = [NSMutableArray array];
        
    _cellWild = 0;
    [self setupTableView];
    
}
#pragma mark-视图将要加载
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getdata];
}
#pragma mark-表视图
- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[PollingTaskReciveCell class] forCellReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_tableView];
    
    
}
#pragma mark-加载数据
-(void)getdata{
    __weak PollingTaskChoseVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];

    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/my_inspect_list"];
    
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
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
#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PollingTaskReciveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    PollingTaskModel *model = (PollingTaskModel *)[_taskList objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"订单号: %@ \n客户名称: %@ \n联系人: %@  \n联系人电话: %@",model.order_sn,model.customer_name,model.customer_contacts,model.customer_contacts_phone];
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
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PollingTaskModel *model = (PollingTaskModel *)[_taskList objectAtIndex:indexPath.row];
    PollingTaskEquipsVC *taskDetail = [[PollingTaskEquipsVC alloc]init];
    taskDetail.model = model;
    //不签到不能进行巡检
    if ([model.status isEqualToString:@"0"]) {
        
        [WCAlertView showAlertWithTitle:@"提示" message:@"该巡检任务还未签到,请先进入签到页面进行签到!" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            [self.navigationController popViewControllerAnimated:YES];
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
        
    }else{
        [self.navigationController pushViewController:taskDetail animated:YES];
    }
}

@end

//
//  PollingTaskEquipsVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/24.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "PollingTaskEquipsVC.h"
#import "EquipmentModel.h"
#import "FormChoseVC.h"
#import "MessageAndDetailCell.h"
@interface PollingTaskEquipsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *equipList;
@property (nonatomic,strong) UILabel *thereLabel;
@end

@implementation PollingTaskEquipsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择设备";
    [self setupTableView];
    _equipList = [NSMutableArray array];
    [self getdata];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[MessageAndDetailCell class] forCellReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_tableView];
    
   
}

-(void)getdata{
    __weak PollingTaskEquipsVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!_fromQury) {
        params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    }
    params[@"order_sn"] = self.model.order_sn;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/my_equipment_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        if([responseObject[@"code"] integerValue] == 1){
            
            NSArray *list = responseObject[@"listData"];
            if (list.count == 0) {
                [_equipList removeAllObjects];
                self.tableView.tableHeaderView = self.thereLabel;
            }else{
                [_equipList removeAllObjects];
                for (NSDictionary *dic in list) {
                    EquipmentModel *model = [[EquipmentModel alloc]init];
                    [model setKeyValues:dic];
                    [_equipList addObject:model];
                    
                }
                
            }
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}
- (UILabel *)thereLabel
{
    if (!_thereLabel) {
        _thereLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
        _thereLabel.text = @"您没有要选择的设备";
        _thereLabel.textColor = [UIColor blackColor];
        _thereLabel.backgroundColor = kUIColorFromRGB(0xf1f1f1);
        _thereLabel.textAlignment = NSTextAlignmentCenter;
        _thereLabel.font = [UIFont systemFontOfSize:14.f];
    }
    return _thereLabel;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _equipList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    EquipmentModel *model = (EquipmentModel *)[_equipList objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"设备品牌: %@ \n设备位置: %@",model.brands_name,model.install_position];
    
    cell.messageLabel.text = text;
    if ([model.status integerValue] == 1) {
        cell.detailLabel.text = @"已完成";
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FormChoseVC *formChoseVC = [[FormChoseVC alloc]init];
    formChoseVC.equipModel = _equipList[indexPath.row];
    formChoseVC.taskModel = _model;
    
    formChoseVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:formChoseVC animated:YES];
}
@end

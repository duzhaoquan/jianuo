//
//  FormHeaderVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/27.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "FormHeaderVC.h"
#import "WaterMaintainDailyVC.h"
#define headcellID @"headcellID"
#import "ManyItemViewController.h"
#import "SmokeRepairViewController.h"
#import "PollingWebViewController.h"
#import "UploadKnowlegeVC.h"

@interface FormHeaderVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)NSArray *textList;
@property (nonatomic,strong)NSMutableDictionary *headerData;


@end

@implementation FormHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
 
    
    NSDate *now = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *confromTimespStr = [formatter stringFromDate:now];
    
    _headerData = [NSMutableDictionary dictionary];
    _headerData[@"order_sn"] = _taskModel.order_sn;//巡检号
    _headerData[@"equipment_id"] = _equipModel.equipment_id;//设备号
    _headerData[@"equipment_name"] = _equipModel.equipment_name;//设备名称
    _headerData[@"equipment_model"] = _equipModel.model;//设备型号
    _headerData[@"enterprise_name"] = _taskModel.customer_name;//企业名称
    _headerData[@"arrivetime"] = _taskModel.arrivetime;//签到时间
    _headerData[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    if ([self.title isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]) {
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"安装位置:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"设备型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"设备编号:%@",_equipModel.unique_code],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      [NSString stringWithFormat:@"巡检人:%@",_taskModel.member_name],
                      [NSString stringWithFormat:@"巡检日期:%@",confromTimespStr],
                      ];
        
        _headerData[@"equipment_number"] = _equipModel.unique_code;
        _headerData[@"maintenance_unit"] =@"河北佳诺";
        _headerData[@"installation_site"] = _equipModel.install_position;
        _headerData[@"inspector"] =_taskModel.member_name;
        _headerData[@"arrivetime"] = _taskModel.arrivetime;
        _headerData[@"inspection_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
    }else if ([self.title isEqualToString:@"水污染源自动监测仪校准记录表"]){
        _textList = @[[NSString stringWithFormat:@"企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"设备型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"巡检日期:%@",confromTimespStr],
                      ];
        
        _headerData[@"calibration_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
    }else if ([self.title isEqualToString:@"水污染源自动监测仪校验记录表"]){
        _textList = @[[NSString stringWithFormat:@"企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"设备型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"设备编号:%@",_equipModel.unique_code],
                      [NSString stringWithFormat:@"巡检日期:%@",confromTimespStr],
                      ];
        
        _headerData[@"equipment_number"] = _equipModel.unique_code;
        _headerData[@"calibration_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
    }else if ([self.title isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"设备型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"安装地点:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      ];
        _headerData[@"maintenance_unit"] =@"河北佳诺";
        _headerData[@"installation_site"] = _equipModel.install_position;
        
        _headerData[@"brands_name"] = _equipModel.brands_name;//品牌
        _headerData[@"equipment_id"] = _equipModel.equipment_id;
        _headerData[@"customer_id"] = _taskModel.customer_id;
        
    }else if ([self.title isEqualToString:@"标准溶液核查结果记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"测定日期:%@",confromTimespStr]
                      ];
        _headerData[@"determination_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
        
    }else if ([self.title isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"安装位置:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"设备型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"设备编号:%@",_equipModel.unique_code],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      [NSString stringWithFormat:@"巡检人:%@",_taskModel.member_name],
                      [NSString stringWithFormat:@"巡检日期:%@",confromTimespStr],
                      ];
        _headerData[@"equipment_code"] = _equipModel.unique_code;
        _headerData[@"maintenance_company"] =@"河北佳诺";
        _headerData[@"installlocalhost"] = _equipModel.install_position;
        _headerData[@"checking_people"] =_taskModel.member_name;
        _headerData[@"arrivetime"] = _taskModel.arrivetime;
        _headerData[@"inspection_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
        
    }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"安装地点:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"规格型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"设备编号:%@",_equipModel.unique_code],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      [NSString stringWithFormat:@"校准日期:%@",confromTimespStr],
                      ];
        
        _headerData[@"equipment_code"] = _equipModel.unique_code;
        _headerData[@"maintenance_company"] =@"河北佳诺";
        _headerData[@"installlocalhost"] = _equipModel.install_position;
        _headerData[@"specifications"] =_equipModel.model;
        _headerData[@"checking_people"] =_taskModel.member_name;
        _headerData[@"inspection_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
        
    }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"安装地点:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"规格型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      [NSString stringWithFormat:@"校验日期:%@",confromTimespStr],
                      ];

        _headerData[@"maintenance_company"] =@"河北佳诺";
        _headerData[@"installlocalhost"] = _equipModel.install_position;
        _headerData[@"specifications"] =_equipModel.model;
        _headerData[@"calibration_people"] =_taskModel.member_name;
        
        _headerData[@"check_time"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
        
    }else if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"安装地点:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"规格型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      [NSString stringWithFormat:@"日期:%@",confromTimespStr],
                      ];
        
        _headerData[@"maintenance_company"] =@"河北佳诺";
        _headerData[@"installlocalhost"] = _equipModel.install_position;
        _headerData[@"specifications"] =_equipModel.model;
        _headerData[@"calibration_people"] =_taskModel.member_name;
        _headerData[@"inspection_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
        
        _headerData[@"brands_name"] = _equipModel.brands_name;//品牌
        _headerData[@"equipment_id"] = _equipModel.equipment_id;
        _headerData[@"customer_id"] = _taskModel.customer_id;
        
    }else if ([self.title isEqualToString:@"易耗品更换记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"安装地点:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"规格型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      [NSString stringWithFormat:@"维护保养人:%@",_taskModel.member_name]
                      ];
        _headerData[@"maintenance_unit"] =@"河北佳诺";
        _headerData[@"installation_site"] = _equipModel.install_position;
        _headerData[@"equipment_model"] =_equipModel.model;
        _headerData[@"maintenance_representative"] =_taskModel.member_name;
        
    }else if ([self.title isEqualToString:@"比对试验结果记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"测定日期:%@",confromTimespStr],
                      ];
        _headerData[@"determination_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
        
    }else if ([self.title isEqualToString:@"标准物质更换记录表"]){
        _textList = @[[NSString stringWithFormat:@"排污企业名称:%@",_taskModel.customer_name],
                      [NSString stringWithFormat:@"设备名称:%@",_equipModel.equipment_name],
                      [NSString stringWithFormat:@"安装地点:%@",_equipModel.install_position],
                      [NSString stringWithFormat:@"规格型号:%@",_equipModel.model],
                      [NSString stringWithFormat:@"运营维护单位:%@",@"河北佳诺"],
                      [NSString stringWithFormat:@"维护保养人:%@",_taskModel.member_name]
                      ];
        
        _headerData[@"maintenance_company"] =@"河北佳诺";
        _headerData[@"installlocalhost"] = _equipModel.install_position;
        _headerData[@"specifications"] =_equipModel.model;
        _headerData[@"checking_people"] =_taskModel.member_name;
        
    }
    
    
    [_tableView reloadData];

}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:headcellID];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _textList.count;
    }else{
        return 1;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]||[self.title isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
        return 4;
    }
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headcellID];
                                                                                        
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section ==0) {
        cell.textLabel.text  = _textList[indexPath.row]; 
    }else if (indexPath.section == 1){
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text  = @"具体巡检内容";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2){
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text  = @"上传到知识库";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 3){
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text  = @"上报故障";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
      
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < 4) {
        return 10;
    }else{
        return 0.000000001;
    }
    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 60;
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    
    if (indexPath.section == 1) {
        if ([self.title isEqualToString:@"标准溶液核查结果记录表"]||[self.title isEqualToString:@"易耗品更换记录表"]||[self.title isEqualToString:@"比对试验结果记录表"]||[self.title isEqualToString:@"标准物质更换记录表"]){
            ManyItemViewController *manyItemViewController = [[ManyItemViewController alloc]init];
            manyItemViewController.formName = self.title;
            manyItemViewController.formChoseVC = self.formChoseVC;
            manyItemViewController.headerData = _headerData;
            [self.navigationController pushViewController:manyItemViewController animated:YES];
        }else if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]||[self.title isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
            if ([_formModel.is_writable integerValue] == 0) {
                SmokeRepairViewController *smokeRepairViewController = [[SmokeRepairViewController alloc]init];
                smokeRepairViewController.formName = self.title;
                smokeRepairViewController.formChoseVC = self.formChoseVC;
                smokeRepairViewController.headerData = _headerData;
                [self.navigationController pushViewController:smokeRepairViewController animated:YES];
            }else{
                PollingWebViewController *pollingWebViewController = [[PollingWebViewController alloc]init];
                pollingWebViewController.title = _formModel.form_name;
                pollingWebViewController.URLString = _formModel.form_url;
                [self.navigationController pushViewController:pollingWebViewController animated:YES];
            }
            
        } else{
            WaterMaintainDailyVC *waterMaintainDailyVC = [[WaterMaintainDailyVC alloc]init];
            waterMaintainDailyVC.formName = self.title;
            waterMaintainDailyVC.formChoseVC = self.formChoseVC;
            waterMaintainDailyVC.headerData = _headerData;
            [self.navigationController pushViewController:waterMaintainDailyVC animated:YES];
        }
       
    }else if (indexPath.section == 2){//上传到知识库
        UploadKnowlegeVC *uploadKnowlegeVC = [[UploadKnowlegeVC alloc]init];
        uploadKnowlegeVC.title = @"上传到知识库";
        uploadKnowlegeVC.headerData = _headerData;
        [self.navigationController pushViewController:uploadKnowlegeVC animated:YES];
        
    }else if (indexPath.section == 3){//上报故障
        UploadKnowlegeVC *uploadKnowlegeVC = [[UploadKnowlegeVC alloc]init];
        uploadKnowlegeVC.title = @"上报故障";
        uploadKnowlegeVC.headerData = _headerData;
        [self.navigationController pushViewController:uploadKnowlegeVC animated:YES];
    }
}




@end

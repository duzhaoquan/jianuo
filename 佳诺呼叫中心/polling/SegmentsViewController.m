//
//  SegmentsViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/1.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "SegmentsViewController.h"
#import "SegmentedTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "TextViewTableViewCell.h"

@interface SegmentsViewController ()<UITableViewDelegate,UITableViewDataSource,SegmentedCellDelegate,TextFieldCellDelegate,TextCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)NSArray<NSString*>*textList;
@property (nonatomic,strong)NSArray<NSString*>*keys;

@property (nonatomic,strong)NSMutableArray *pre_calibration;
@property (nonatomic,strong)NSMutableArray *after_calibration;
@property (nonatomic,strong)NSMutableArray *abnormal_parameters;

@end

@implementation SegmentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (_datasDic == nil) {
        _datasDic = [NSMutableDictionary dictionary];
    }
    
    [self setupTableView];
    if ([self.title isEqualToString:@"(一)维护预备"]) {
        _textList=@[@"查询日志",@"试剂、耗材准备"];
        _keys = @[@"prep_log",@"prep_reagent"];
    }else if ([self.title isEqualToString:@"(二)系统检查"]){
        _textList=@[@"供电系统(稳压/UPS)",@"通信系统(本地通信/远程通信等)",@"控制系统(PLC/工控机等)",@"子站设施(泵/阀等)",@"采水系统"];
        _keys = @[@"sys_power",@"sys_signal",@"sys_control",@"sys_station",@"sys_water"];
    }else if ([self.title isEqualToString:@"(三)仪器维护"]){
        _textList=@[@"仪器显示",@"故障报警",@"仪器管路",@"仪器校验"];
        _keys = @[@"inst_show",@"inst_alarm",@"inst_piping",@"inst_check"];
    }else if ([self.title isEqualToString:@"(四)周期维护"]){
        _textList=@[@"仪器清洗",@"集成管路清洗",@"废液处理",@"试剂更换",@"耗材更换",@"卫生打扫",@"站房记录"];
        _keys = @[@"cycle_clean",@"cycle_piping",@"cycle_liquid",@"cycle_replace",@"cycle_supplies",@"cycle_hygiene",@"cycle_record"];
    }else if ([self.title isEqualToString:@"烟气监测系统"]){
        _textList=@[@"探头滤芯、采样管、伴热管是否堵塞",@"采样探头反吹是否正常，电子阀、反吹气源是否正常",@"采样泵、致冷器、过滤器、采样流量是否正常",@"直接烟气分析仪的净化装置管路、风机、过滤器、风量",@"吸附剂、干燥剂是否过期",@"烟气监测数据是否正常，分析仪（直抽式）校准是否正常",@"标气的浓度、有效期时间、剩余压力"];
        _keys = @[@"probe_comp_des",@"sampling_probe_comp_des",@"czgc_comp_des",@"zjyqfxy_comp_des",@"xfgzgq_comp_des",@"yqfxjz_comp_des",@"bqyxsy_comp_des"];
    }else if ([self.title isEqualToString:@"烟尘监测系统"]){
        _textList = @[@"鼓风机、风管、空气过滤器等部件工作是否正常",@"穿法烟尘分析仪的光点是否偏移",@"烟尘监测数据是否正常"];
        _keys = @[@"gfjfgkq_comp_des",@"cfycfxy_comp_des",@"ycjzsj_comp_des"];
    }else if ([self.title isEqualToString:@"流速监测系统"]){
        _textList = @[@"检查皮托管的反吹管路、控制阀等否正常",@"超声波法：检查鼓风机、软管、过滤器等部件是否正常",@"检测流速值是否正常"];
        _keys = @[@"pgtfcglkzf_comp_des",@"csbgfjrgglv_comp_des",@"jclsz_comp_des"];
    }else if ([self.title isEqualToString:@"其他烟气监测参数"]){
        _textList = @[@"温度测量值是否正常",@"湿度测量值是否正常",@"氧气测量值是否正常"];
        _keys = @[@"wdclz_comp_des",@"sdclz_comp_des",@"yqclz_comp_des"];
    }else if ([self.title isEqualToString:@"数据采集传输装置"]){
        _textList = @[@"各通讯线的连接是否松动",@"数据传输卡上的费用",@"分析仪、工程机、数据采集传输仪上的数据是否一致"];
        _keys = @[@"txxlj_comp_des",@"sucskfy_comp_des",@"fxgcsjcjxt_comp_des"];
    }else if ([self.title isEqualToString:@"其他辅助设备"]){
        _textList = @[@"空气压缩系统是否正常分水器、储气装置中的水是否放掉",@"室内的温度、湿度是否正常",@"分析站房的门窗是否密封",@"站房的清洁卫生"];
        _keys = @[@"kqysxt_comp_des",@"snwdsd_comp_des",@"fxzfmc_comp_des",@"zfqjws_comp_des"];
    }else if ([self.title isEqualToString:@"常规项"]){
        _textList=@[@"异常参数:",@"校验前各参数是否正常",@"校验后各参数是否正常"];
        //_keys = @[@"abnormal_parameters",@"pre_calibration",@"after_calibration"];
    }
   // @[@"烟气检测系统",@"烟尘监测系统",@"流速检测系统",@"其他烟气检测参数",@"数据采集传输装置",@"其他辅助设备"];
    for (NSString*key in _keys) {
        if (_datasDic[key] == nil) {
            _datasDic[key] = @"正常";
        }
    }
    if ([self.title isEqualToString:@"常规项"]){
        _abnormal_parameters = _datasDic[@"abnormal_parameters"];
        _pre_calibration =  _datasDic[@"pre_calibration"];
        _after_calibration = _datasDic[@"after_calibration"];
        if (_abnormal_parameters == nil) {
            _pre_calibration = [NSMutableArray arrayWithObjects:@"正常",@"正常",@"正常", nil];
            _after_calibration = [NSMutableArray arrayWithObjects:@"正常",@"正常",@"正常", nil];
            _abnormal_parameters = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
            _datasDic[@"abnormal_parameters"] = _abnormal_parameters;
            _datasDic[@"pre_calibration"] = _pre_calibration;
            _datasDic[@"after_calibration"] = _after_calibration;
        }
        
    }    
    [_tableView reloadData];
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyBoard)];  
    gestureRecognizer.numberOfTapsRequired = 1;    
    gestureRecognizer.cancelsTouchesInView = NO;  
    [_tableView addGestureRecognizer:gestureRecognizer];
    
    [_tableView registerClass:[SegmentedTableViewCell class] forCellReuseIdentifier:@"CellID"];
    [_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextCellID"];
    [_tableView registerClass:[TextViewTableViewCell class] forCellReuseIdentifier:@"TextViewCellID"];
    [self.view addSubview:_tableView];
    
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenwidth/2 - 100,kScreenheight - 100, 200, 40);
    [self.view addSubview:button];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 10;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    
    button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
    
    [button addTarget:self action:@selector(backAcion) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)backAcion{
    if ([self.title isEqualToString:@"常规项"]) {
        for (int i = 2; i>=0; i--) {
            if (i<_abnormal_parameters.count) {
                NSString *abnormal = _abnormal_parameters[i];
                if ([abnormal isEqualToString:@""]) {
                    [_abnormal_parameters removeObjectAtIndex:i];
                    [_pre_calibration removeObjectAtIndex:i];
                    [_after_calibration removeObjectAtIndex:i];
                }
            }
        }
    }
    _dataBack(_datasDic);
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.title isEqualToString:@"常规项"]) {
        return 3;
    }else{
        return 2;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"常规项"]) {
        return 3;
    }else{
        if (section == 0) {
            return _textList.count;
        }else{
            return 1;
        }
        
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.title isEqualToString:@"常规项"]) {
        if (indexPath.row == 0) {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCellID"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.firstLableText = _textList[indexPath.row]; 
            if (indexPath.section < _abnormal_parameters.count) {
                NSString *abnormal =  _abnormal_parameters[indexPath.section];
                cell.textField.text = abnormal;
            }
            
            return cell;
        }else{
            SegmentedTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstLableText = _textList[indexPath.row];
            NSString *isGood;
            if (indexPath.row == 1){
                if (indexPath.section < _pre_calibration.count) {
                    isGood = _pre_calibration[indexPath.section];
                }
            }else if (indexPath.row == 2){
                if (indexPath.section < _after_calibration.count) {
                    isGood = _after_calibration[indexPath.section];
                }
            }
            if ([isGood isEqualToString:@"异常"]) {
                cell.segControl.selectedSegmentIndex = 1;
            }
            return cell;
        }
        
    }else{
        
        if (indexPath.section == 0) {
            SegmentedTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstLableText = _textList[indexPath.row];
            
            if ([_datasDic[_keys[indexPath.row]] isEqualToString:@"异常"]) {
                cell.segControl.selectedSegmentIndex = 1;
            }
            
            return cell;
        }else{
            TextViewTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewCellID"];
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstLable.text = @"异常备注";
            cell.textView.text = _datasDic[@"errorRemark"];
            
            return cell;
        }
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"常规项"]) {
        return 8;
    }else{
//        if (section == 0) {
//            return 8;
//        }
    }
    return 0.000000001;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![self.title isEqualToString:@"常规项"]&&indexPath.section == 1) {
        return 90;
    }
    return 44;
}
-(void)cellTextEndEdit:(NSString *)cellText IndexPath:(NSIndexPath *)indexPath{
    
    if ([self.title isEqualToString:@"常规项"]) {
        if (indexPath.row == 0) {
            [_abnormal_parameters removeObjectAtIndex:indexPath.section];
            [_abnormal_parameters insertObject:cellText atIndex:indexPath.section];
            
        }else if (indexPath.row == 1){
            [_pre_calibration removeObjectAtIndex:indexPath.section];
            [_pre_calibration insertObject:cellText atIndex:indexPath.section];
            
        }else if (indexPath.row == 2){
            [_after_calibration removeObjectAtIndex:indexPath.section];
            [_after_calibration insertObject:cellText atIndex:indexPath.section];
            
        }
        
    }else{
        if (indexPath.section == 1) {
            _datasDic[@"errorRemark"]  = cellText;
        }
        _datasDic[_keys[indexPath.row]] = cellText;
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
//收起键盘
-(void)hidekeyBoard{
    [self.view endEditing:YES];
}

@end

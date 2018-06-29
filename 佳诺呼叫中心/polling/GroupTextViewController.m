//
//  GroupTextViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/6.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "GroupTextViewController.h"
#import "TextFieldTableViewCell.h"
#import "UIResponder+FirstResponder.h"

@interface GroupTextViewController ()<UITableViewDelegate,UITableViewDataSource,TextFieldCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)NSArray<NSString*>*sectionStrs;
@property (nonatomic,strong)NSArray<NSArray<NSString*>*>*rowStrs;
@property (nonatomic,strong)NSArray<NSArray<NSString*>*>*keys;

@property (nonatomic,strong)NSMutableArray *monitoring_time;
@property (nonatomic,strong)NSMutableArray *parameter_determination_value;
@property (nonatomic,strong)NSMutableArray *CEMC_determination_value;

@end

@implementation GroupTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_datasDic == nil) {
        _datasDic = [NSMutableDictionary dictionary];
    }
    [self setupTableView];
    if ([self.title isEqualToString:@"校验1"]||[self.title isEqualToString:@"校验2"]) {
        _sectionStrs =@[@"质控样1",@"质控样2",@"水样1",@"水样2",@"水样3"];
        _rowStrs = @[@[@"标准值:",@"仪器值:",@"误差:",@"结论:"],
                     @[@"标准值:",@"仪器值:",@"误差:",@"结论:"],
                     @[@"标准值:",@"仪器值:",@"误差:",@"结论:"],
                     @[@"标准值:",@"仪器值:",@"误差:",@"结论:"],
                     @[@"标准值:",@"仪器值:",@"误差:",@"结论:"]
                     ];
        
        _keys = @[
        @[@"standard_quality1",@"instrument_quality1",@"error_quality1",@"conclusion_quality1"],
        @[@"standard_quality2",@"instrument_quality2",@"error_quality2",@"conclusion_quality2"],
        @[@"standard_water1",@"instrument_water1",@"error_water1",@"conclusion_water1"],
        @[@"standard_water2",@"instrument_water2",@"error_water2",@"conclusion_water2"],
        @[@"standard_water3",@"instrument_water3",@"error_water3",@"conclusion_water3"]
                  ];
    }else if([self.title containsString:@"仪校准"]){
        _sectionStrs =@[@"",@"零点漂移校准",@"跨度漂移校准"];
        _rowStrs = @[@[@"分析仪原理:",@"分析仪量程:   0  -",@"计量单位:"],
                     @[@"零气浓度值:",@"校前测试值:",@"零点漂移%:",@"仪器校准是否正常:",@"校准后测试值:"],
                     @[@"标气浓度值:",@"校前测试值:",@"跨度漂移%:",@"仪器校准是否正常:",@"校准后测试值:"]
                     ];
        if([self.title containsString:@"SO2分析仪校准"]){
            _keys = @[
                      @[@"so_principle_analyser",@"so_analyzer_range",@"so_measuring_unit"],
                  @[@"so_zero_gas_concentration",@"so_ldpreschool_test_value",@"so_zero_drift",@"so_ldcalibration_instrument_normal",@"so_ldtest_value_after_calibration"],
                  @[@"so_standard_gas_concentration",@"so_kdpreschool_test_value",@"so_span_drift",@"so_kdcalibration_instrument_normal",@"so_kdtest_value_after_calibration"]
                      ];
        }else if([self.title containsString:@"NOx分析仪校准"]){
            _keys = @[
                      @[@"no_principle_analyser",@"no_analyzer_range",@"no_measuring_unit"],
                      @[@"no_zero_gas_concentration",@"no_ldpreschool_test_value",@"no_zero_drift",@"no_ldcalibration_instrument_normal",@"no_ldtest_value_after_calibration"],
                      @[@"no_standard_gas_concentration",@"no_kdpreschool_test_value",@"no_span_drift",@"no_kdcalibration_instrument_normal",@"no_kdtest_value_after_calibration"]
                      ];
        }else if([self.title containsString:@"O2分析仪校准"]){
            _keys = @[
                      @[@"o_principle_analyser",@"o_analyzer_range",@"o_measuring_unit"],
                      @[@"o_zero_gas_concentration",@"o_ldpreschool_test_value",@"o_zero_drift",@"o_ldcalibration_instrument_normal",@"o_ldtest_value_after_calibration"],
                      @[@"o_standard_gas_concentration",@"o_kdpreschool_test_value",@"o_span_drift",@"o_kdcalibration_instrument_normal",@"o_kdtest_value_after_calibration"]
                      ];
        }else if([self.title containsString:@"流速仪校准"]){
            _rowStrs = @[@[@"分析仪原理:",@"分析仪量程:   0  -",@"计量单位:"],
                         @[@"零值:",@"校前测试值:",@"零点漂移%:",@"仪器校准是否正常:",@"校准后测试值:"],
                         @[@"校准用跨度值:",@"校前测试值:",@"跨度漂移%:",@"仪器校准是否正常:",@"校准后测试值:"]
                         ];
            _keys = @[
                      @[@"ls_principle_analyser",@"ls_analyzer_range",@"ls_measuring_unit"],
                      @[@"ls_zero_gas_concentration",@"ls_ldpreschool_test_value",@"ls_zero_drift",@"ls_ldcalibration_instrument_normal",@"ls_ldtest_value_after_calibration"],
                      @[@"ls_standard_gas_concentration",@"ls_kdpreschool_test_value",@"ls_span_drift",@"ls_kdcalibration_instrument_normal",@"ls_kdtest_value_after_calibration"]
                      ];
        }else if([self.title containsString:@"烟尘仪校准"]){
            _rowStrs = @[@[@"分析仪原理:",@"分析仪量程:   0  -",@"计量单位:"],
                         @[@"零值:",@"校前测试值:",@"零点漂移%:",@"仪器校准是否正常:",@"校准后测试值:"],
                         @[@"校准用跨度值:",@"校前测试值:",@"跨度漂移%:",@"仪器校准是否正常:",@"校准后测试值:"]
                         ];
            _keys = @[
                      @[@"yc_principle_analyser",@"yc_analyzer_range",@"yc_measuring_unit"],
                      @[@"yc_zero_gas_concentration",@"yc_ldpreschool_test_value",@"yc_zero_drift",@"yc_ldcalibration_instrument_normal",@"yc_ldtest_value_after_calibration"],
                      @[@"yc_standard_gas_concentration",@"yc_kdpreschool_test_value",@"yc_span_drift",@"yc_kdcalibration_instrument_normal",@"yc_kdtest_value_after_calibration"]
                      ];
        }
        
    }else if([self.title containsString:@"校验"]){
        _monitoring_time = [NSMutableArray array];
        _parameter_determination_value = [NSMutableArray array];
        _CEMC_determination_value = [NSMutableArray array];
        
        _sectionStrs =@[@"",@"",@"",@"",@""];
        _rowStrs = @[@[@"对比测试仪原理:",@"CEMS分析仪原理:"],
                     @[@"监测时间:",@"参比方法测定值:",@"CEMC测定值:"],
                     @[@"监测时间:",@"参比方法测定值:",@"CEMC测定值:"],
                     @[@"监测时间:",@"参比方法测定值:",@"CEMC测定值:"],
                     @[@"参比方法测定值平均值:",@"CEMC测定值平均值:",@"相对误差(%):",@"评价标准:",@"评价结果:"]
                     ];
        
        if([self.title containsString:@"烟尘校验"]){
            _keys = @[
                     @[@"yc_contrast_test_principle",@"yc_CEMS_Analyzer_principle"],
                     @[@"yc_monitoring_time1",@"yc_parameter_determination_value1",@"yc_CEMC_determination_value1"],
                     @[@"yc_monitoring_time2",@"yc_parameter_determination_value2",@"yc_CEMC_determination_value2"],
                     @[@"yc_monitoring_time3",@"yc_parameter_determination_value3",@"yc_CEMC_determination_value3"], @[@"yc_parameter_determination_test_average",@"yc_CEMC_determination_test_average",@"yc_relative_error",@"评价标准",@"yc_evaluation_results"]
                      ];
        }else if([self.title containsString:@"SO2校验"]){
            _keys = @[
                      @[@"so_contrast_test_principle",@"so_CEMS_Analyzer_principle"],
                      @[@"so_monitoring_time1",@"so_parameter_determination_value1",@"so_CEMC_determination_value1"],
                      @[@"so_monitoring_time2",@"so_parameter_determination_value2",@"so_CEMC_determination_value2"],
                      @[@"so_monitoring_time3",@"so_parameter_determination_value3",@"so_CEMC_determination_value3"], @[@"so_parameter_determination_test_average",@"so_CEMC_determination_test_average",@"so_relative_error",@"评价标准",@"so_evaluation_results"]
                      ];
        }else if([self.title containsString:@"NOx校验"]){
            _keys = @[
                      @[@"no_contrast_test_principle",@"no_CEMS_Analyzer_principle"],
                      @[@"no_monitoring_time1",@"no_parameter_determination_value1",@"no_CEMC_determination_value1"],
                      @[@"no_monitoring_time2",@"no_parameter_determination_value2",@"no_CEMC_determination_value2"],
                      @[@"no_monitoring_time3",@"no_parameter_determination_value3",@"no_CEMC_determination_value3"], @[@"no_parameter_determination_test_average",@"no_CEMC_determination_test_average",@"no_relative_error",@"评价标准",@"no_evaluation_results"]
                      ];
        }else if([self.title containsString:@"O2校验"]){
            _keys = @[
                      @[@"o_contrast_test_principle",@"o_CEMS_Analyzer_principle"],
                      @[@"o_monitoring_time1",@"o_parameter_determination_value1",@"o_CEMC_determination_value1"],
                      @[@"o_monitoring_time2",@"o_parameter_determination_value2",@"o_CEMC_determination_value2"],
                      @[@"o_monitoring_time3",@"o_parameter_determination_value3",@"o_CEMC_determination_value3"], @[@"o_parameter_determination_test_average",@"o_CEMC_determination_test_average",@"o_relative_error",@"评价标准",@"o_evaluation_results"]
                      ];
        }else if([self.title containsString:@"流速校验"]){
            _keys = @[
                      @[@"ls_contrast_test_principle",@"ls_CEMS_Analyzer_principle"],
                      @[@"ls_monitoring_time1",@"ls_parameter_determination_value1",@"ls_CEMC_determination_value1"],
                      @[@"ls_monitoring_time2",@"ls_parameter_determination_value2",@"ls_CEMC_determination_value2"],
                      @[@"ls_monitoring_time3",@"ls_parameter_determination_value3",@"ls_CEMC_determination_value3"], @[@"ls_parameter_determination_test_average",@"ls_CEMC_determination_test_average",@"ls_relative_error",@"评价标准",@"ls_evaluation_results"]
                      ];
        }else if([self.title containsString:@"温度校验"]){
            _keys = @[
                      @[@"wd_contrast_test_principle",@"wd_CEMS_Analyzer_principle"],
                      @[@"wd_monitoring_time1",@"wd_parameter_determination_value1",@"wd_CEMC_determination_value1"],
                      @[@"wd_monitoring_time2",@"wd_parameter_determination_value2",@"wd_CEMC_determination_value2"],
                      @[@"wd_monitoring_time3",@"wd_parameter_determination_value3",@"wd_CEMC_determination_value3"], @[@"wd_parameter_determination_test_average",@"wd_CEMC_determination_test_average",@"wd_relative_error",@"评价标准",@"wd_evaluation_results"]
                      ];
        }  
    }
    [_tableView reloadData];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)setupTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyBoard)];  
    gestureRecognizer.numberOfTapsRequired = 1;    
    gestureRecognizer.cancelsTouchesInView = NO;  
    [_tableView addGestureRecognizer:gestureRecognizer];
    [_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextCellID"];
    [self.view addSubview:_tableView];
    
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(kScreenwidth/2 - 100,kScreenheight - 40, 200, 40);
    [self.view addSubview:button];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    
    button.layer.cornerRadius = 10;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    
    button.layer.backgroundColor =[UIColor colorWithRed:189.0/255 green:215.0/255 blue:238.0/255 alpha:1].CGColor;
    
    [button addTarget:self action:@selector(backAcion) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)backAcion{
    
    if ([self.title isEqualToString:@"校验1"]||[self.title isEqualToString:@"校验2"]){
    }else if ([self.title containsString:@"仪校准"]){
    }else if([self.title containsString:@"校验"]){
        NSData *monitoring_timeData =  [NSJSONSerialization dataWithJSONObject:_monitoring_time options:0 error:nil];
        NSString *monitoring_time = [[NSString alloc]initWithData:monitoring_timeData encoding:NSUTF8StringEncoding];
        
        NSData *parameterData =  [NSJSONSerialization dataWithJSONObject:_parameter_determination_value options:0 error:nil];
        NSString *parameter_determination_value = [[NSString alloc]initWithData:parameterData encoding:NSUTF8StringEncoding];
        
        NSData *determinationData =  [NSJSONSerialization dataWithJSONObject:_CEMC_determination_value options:0 error:nil];
        NSString *CEMC_determination_value = [[NSString alloc]initWithData:determinationData encoding:NSUTF8StringEncoding];
        
        if([self.title containsString:@"烟尘校验"]){
            _datasDic[@"yc_monitoring_time"] = monitoring_time;
            _datasDic[@"yc_parameter_determination_value"] = parameter_determination_value;
            _datasDic[@"yc_CEMC_determination_value"] = CEMC_determination_value;
            
        }else if([self.title containsString:@"SO2校验"]){
            _datasDic[@"so_monitoring_time"] = monitoring_time;
            _datasDic[@"so_parameter_determination_value"] = parameter_determination_value;
            _datasDic[@"so_CEMC_determination_value"] = CEMC_determination_value;
        }else if([self.title containsString:@"NOx校验"]){
            _datasDic[@"no_monitoring_time"] = monitoring_time;
            _datasDic[@"no_parameter_determination_value"] = parameter_determination_value;
            _datasDic[@"no_CEMC_determination_value"] = CEMC_determination_value;
        }else if([self.title containsString:@"O2校验"]){
            _datasDic[@"o_monitoring_time"] = monitoring_time;
            _datasDic[@"o_parameter_determination_value"] = parameter_determination_value;
            _datasDic[@"o_CEMC_determination_value"] = CEMC_determination_value;
        }else if([self.title containsString:@"流速校验"]){
            _datasDic[@"ls_monitoring_time"] = monitoring_time;
            _datasDic[@"ls_parameter_determination_value"] = parameter_determination_value;
            _datasDic[@"ls_CEMC_determination_value"] = CEMC_determination_value;
        }else{
            _datasDic[@"wd_monitoring_time"] = monitoring_time;
            _datasDic[@"wd_parameter_determination_value"] = parameter_determination_value;
            _datasDic[@"wd_CEMC_determination_value"] = CEMC_determination_value;
        }    
        
    }
    _dataBack(_datasDic);
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _sectionStrs.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return _rowStrs[section].count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCellID"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    cell.firstLableText = _rowStrs[indexPath.section][indexPath.row];
    cell.textField.text = _datasDic[_keys[indexPath.section][indexPath.row]];
    cell.textField.enabled = YES;
    if ([self.title isEqualToString:@"校验1"]||[self.title isEqualToString:@"校验2"]) {
        if (indexPath.row < 3) {
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        }else{
            cell.textField.keyboardType = UIKeyboardTypeDefault;
        }
        if (indexPath.row == 2) {
            cell.textField.enabled = NO;
        }
    }else if([self.title containsString:@"仪校准"]){
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                if ([cell.textField.text hasPrefix:@"0-"] && cell.textField.text.length > 2){
                     cell.textField.text = [cell.textField.text substringFromIndex:2];
                }
            }else{
                cell.textField.keyboardType = UIKeyboardTypeDefault;
            }
        }else{
            if (indexPath.row == 3) {
                cell.textField.keyboardType = UIKeyboardTypeDefault;
            }else{
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            }
            if (indexPath.row == 2) {
                cell.textField.enabled = NO;
            }
        }
    }else if([self.title containsString:@"校验"]){
        if (indexPath.section == 0) {
            
        }else if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3){
            if (indexPath.row > 0) {
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            }else{
                cell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            }
        }else if (indexPath.section == 4){
            if (indexPath.row == 4) {
                
            }else{
                cell.textField.enabled = NO;
                if (indexPath.row == 3) {
                    cell.textField.text = @"根据HJ/T75-2007";
                    
                }
            }
            
        }
    }
       
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"校验1"]||[self.title isEqualToString:@"校验2"]){
    }else if ([self.title containsString:@"仪校准"]){
        if (section == 0) {
            return 0;
        }
    }else if([self.title containsString:@"校验"]){
        return 0;
    }
    return 40;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 40)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = _sectionStrs[section];
    return lable;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section<_sectionStrs.count) {
        return 8;
    }
    return 0.000000001;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


-(void)cellTextEndEdit:(NSString *)cellText IndexPath:(NSIndexPath *)indexPath{
    if ([ZQ_CommonTool isEmpty:cellText]) {
        return;
    }
    
    _datasDic[_keys[indexPath.section][indexPath.row]] = cellText;
    if ([self.title isEqualToString:@"校验1"]||[self.title isEqualToString:@"校验2"]) {
        if (indexPath.row == 0||indexPath.row == 1) {
            if (![ZQ_CommonTool isEmpty:_datasDic[_keys[indexPath.section][0]]] && ![ZQ_CommonTool isEmpty:_datasDic[_keys[indexPath.section][1]]]) {
                float chaValue = [_datasDic[_keys[indexPath.section][1]] floatValue] - [_datasDic[_keys[indexPath.section][0]] floatValue];
                float value = chaValue/[_datasDic[_keys[indexPath.section][0]]floatValue] *100;
                _datasDic[_keys[indexPath.section][2]] = [NSString stringWithFormat:@"%.2f%@",value,@"%"];
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
    }else if([self.title containsString:@"仪校准"]){
        if (indexPath.section > 0) {
            if (indexPath.row == 0||indexPath.row == 1) {
                if (![ZQ_CommonTool isEmpty:_datasDic[_keys[indexPath.section][0]]] && ![ZQ_CommonTool isEmpty:_datasDic[_keys[indexPath.section][1]]] && ![ZQ_CommonTool isEmpty:_datasDic[_keys[0][1]]]){
                    NSString *maxLiangcheng = _datasDic[_keys[0][1]];
                    if ([maxLiangcheng hasPrefix:@"0-"] && maxLiangcheng.length >2){
                        maxLiangcheng = [maxLiangcheng substringFromIndex:2];
                    }
                    float chaValue = [_datasDic[_keys[indexPath.section][1]] floatValue] - [_datasDic[_keys[indexPath.section][0]] floatValue];
                    float value = chaValue/[maxLiangcheng floatValue] * 100;
                    
                    _datasDic[_keys[indexPath.section][2]] = [NSString stringWithFormat:@"%.2f%@",value,@"%"];
                    
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationTop];
                }
            }
        }
        
    }else if([self.title containsString:@"校验"]){
        if (indexPath.section > 0 && indexPath.section < 4) {
            if (indexPath.row == 0) {
                if (![ZQ_CommonTool isEmpty:_datasDic[_keys[indexPath.section][0]]]){
                    
                    if (_monitoring_time.count > indexPath.section) {
                        [_monitoring_time removeObjectAtIndex:indexPath.section - 1];
                    }
                    [_monitoring_time insertObject:_datasDic[_keys[indexPath.section][0]] atIndex:indexPath.section - 1];
                    
                    
                }
            }else{
                if (indexPath.row == 1){
                    if (_parameter_determination_value.count > indexPath.section) {
                        [_parameter_determination_value removeObjectAtIndex:indexPath.section - 1];
                    }
                    [_parameter_determination_value insertObject:_datasDic[_keys[indexPath.section][1]] atIndex:indexPath.section - 1];
                    
                    float sum = 0;
                    for (NSString *str in _parameter_determination_value) {
                        sum += [str floatValue];
                    }
                    _datasDic[_keys[4][0]] = [NSString stringWithFormat:@"%.2f",sum / _parameter_determination_value.count] ;
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:4]] withRowAnimation:UITableViewRowAnimationTop];
                }else if (indexPath.row == 2){
                    if (_CEMC_determination_value.count > indexPath.section) {
                        [_CEMC_determination_value removeObjectAtIndex:indexPath.section - 1];
                    }
                    [_CEMC_determination_value insertObject:_datasDic[_keys[indexPath.section][2]] atIndex:indexPath.section - 1];
                    
                    float sum = 0;
                    for (NSString *str in _CEMC_determination_value) {
                        sum += [str floatValue];
                    }
                    _datasDic[_keys[4][1]] = [NSString stringWithFormat:@"%.2f",sum / _CEMC_determination_value.count] ;
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:4]] withRowAnimation:UITableViewRowAnimationTop];
                }
                
                if (![ZQ_CommonTool isEmpty:_datasDic[_keys[4][0]]] && ![ZQ_CommonTool isEmpty:_datasDic[_keys[4][1]]]) {
                    float chaValue = [_datasDic[_keys[4][1]] floatValue] - [_datasDic[_keys[4][0]] floatValue];
                    float value = chaValue/[_datasDic[_keys[4][0]] floatValue] * 100;
                    if (value < 0) {
                        value = -value;
                    }
                    _datasDic[_keys[4][2]] = [NSString stringWithFormat:@"%.2f%@",value,@"%"];
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:4]] withRowAnimation:UITableViewRowAnimationTop];
                }
                
            } 
        }
    }
    
}

-(void)hidekeyBoard{
    [self.view endEditing:YES];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //取得第一响应者
    UIView *activeField = [UIResponder currentFirstResponder];   
    //除去键盘后的页面显示区域
    CGRect aRect = self.view.frame;
    aRect.size.height =  aRect.size.height - keyBoardRect.size.height - 64;
    //判断cell底部是否在显示范围内
    CGPoint cellBottomPoint = CGPointMake(0.0, activeField.superview.superview.frame.origin.y +activeField.superview.superview.frame.size.height);
    if (!CGRectContainsPoint(aRect, cellBottomPoint) ) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
        CGPoint scrollPoint = CGPointMake(0.0, cellBottomPoint.y-aRect.size.height -44);
        [_tableView setContentOffset:scrollPoint animated:YES];
        
    }
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end

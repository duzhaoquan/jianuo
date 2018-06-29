//
//  WaterMaintainDailyVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/28.
//  Copyright © 2018年 jianuohb. All rights reserved.
//三组的结构方式,第一组是点击进入下一级,第二组是textView输入框,第三组是textField

#import "WaterMaintainDailyVC.h"
#import "MessageAndDetailCell.h"
#import "TextViewTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "NSString+HFExtension.h"
#import "SegmentsViewController.h"
#import "TxetViewController.h"
#import "MessageAndDetailCellModel.h"
#import "GroupTextViewController.h"
#import "UIResponder+FirstResponder.h"

@interface WaterMaintainDailyVC ()<UITableViewDelegate,UITableViewDataSource,TextCellDelegate,TextFieldCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *itemList;
@property (nonatomic,strong)NSMutableDictionary *allData;
@property (nonatomic,strong)GroupTextViewController *groupTextViewController;

@end

@implementation WaterMaintainDailyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _formName;
    if ([_formName isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]) {
        
        _itemList = @[@"(一)维护预备",@"(二)系统检查",@"(三)仪器维护",@"(四)周期维护",@"(五)其他情况"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<5; i++) {
            MessageAndDetailCellModel *model =[[MessageAndDetailCellModel alloc]init];
            model.name = _itemList[i];
            [tempArr addObject:model];
        }
        _itemList = tempArr;
    }else if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
        _itemList = @[@"常规项"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<1; i++) {
            MessageAndDetailCellModel *model =[[MessageAndDetailCellModel alloc]init];
            model.name = _itemList[i];
            [tempArr addObject:model];
        }
        _itemList = tempArr;
    }else if ([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
        _itemList = @[@"校验1",@"校验2"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<2; i++) {
            MessageAndDetailCellModel *model =[[MessageAndDetailCellModel alloc]init];
            model.name = _itemList[i];
            [tempArr addObject:model];
        }
        _itemList = tempArr;
    }else if ([_formName isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]) {
        
        _itemList = @[@"烟气监测系统",@"烟尘监测系统",@"流速监测系统",@"其他烟气监测参数",@"数据采集传输装置",@"其他辅助设备"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<6; i++) {
            MessageAndDetailCellModel *model =[[MessageAndDetailCellModel alloc]init];
            model.name = _itemList[i];
            [tempArr addObject:model];
        }
        _itemList = tempArr;
    }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]){
        _itemList = @[@"SO2分析仪校准",@"NOx分析仪校准",@"O2分析仪校准",@"流速仪校准",@"烟尘仪校准"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<5; i++) {
            MessageAndDetailCellModel *model =[[MessageAndDetailCellModel alloc]init];
            model.name = _itemList[i];
            [tempArr addObject:model];
        }
        _itemList = tempArr;
    }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
        _itemList = @[@"烟尘校验",@"SO2校验",@"NOx校验",@"O2校验",@"流速校验",@"温度校验"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (int i = 0; i<6; i++) {
            MessageAndDetailCellModel *model =[[MessageAndDetailCellModel alloc]init];
            model.name = _itemList[i];
            [tempArr addObject:model];
        }
        _itemList = tempArr;
    }
    
    [self setupTableView];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _allData = [NSMutableDictionary dictionaryWithDictionary:_headerData];
}


- (void)setupTableView {
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    [_tableView registerClass:[MessageAndDetailCell class] forCellReuseIdentifier:@"MessageCellID"];
    [_tableView registerClass:[TextViewTableViewCell class] forCellReuseIdentifier:@"TextViewCellID"];
    [_tableView registerClass:[TextFieldTableViewCell class] forCellReuseIdentifier:@"TextFieldCellID"];
    [self.view addSubview:_tableView];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyBoard)];  
    gestureRecognizer.numberOfTapsRequired = 1;    
    gestureRecognizer.cancelsTouchesInView = NO;  
    [_tableView addGestureRecognizer:gestureRecognizer];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [button setTitle:@"提交表格" forState:UIControlStateNormal];
  
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:button];
    
    
}
-(void)buttonDidClick{
    if ( [ZQ_CommonTool isEmpty:_allData[@"order_sn"]]) {
        
        [WCAlertView showAlertWithTitle:@"提示" message:@"订单号不存在" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    
    __weak WaterMaintainDailyVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URL = @"";
    if ([_formName isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]) {
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/water_maintain_daily"];
    }else if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
        NSArray *abnormal = _allData[@"abnormal_parameters"];
        NSData *abnormalData =  [NSJSONSerialization dataWithJSONObject:abnormal options:0 error:nil];
        NSString *abnormal_parameters = [[NSString alloc]initWithData:abnormalData encoding:NSUTF8StringEncoding];
        _allData[@"abnormal_parameters"] = abnormal_parameters;
        
        NSArray *preArr = _allData[@"pre_calibration"];
        NSData *preData =  [NSJSONSerialization dataWithJSONObject:preArr options:0 error:nil];
        NSString *pre_calibration = [[NSString alloc]initWithData:preData encoding:NSUTF8StringEncoding];
        _allData[@"pre_calibration"] = pre_calibration;
        
        NSArray *afterArr = _allData[@"after_calibration"];
        NSData *afterData =  [NSJSONSerialization dataWithJSONObject:afterArr options:0 error:nil];
        NSString *after_calibration = [[NSString alloc]initWithData:afterData encoding:NSUTF8StringEncoding];
        _allData[@"after_calibration"] = after_calibration;
        
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/water_calibration_record"];
    }else if ([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
         NSArray *tempArr =  _allData[@"checkout_recordArray"];
        NSData *afterData =  [NSJSONSerialization dataWithJSONObject:tempArr options:0 error:nil];
        NSString *after_calibration = [[NSString alloc]initWithData:afterData encoding:NSUTF8StringEncoding];
        _allData[@"checkout_record"] = after_calibration;
        
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/water_checkout_record"];
    }else if ([_formName isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]){
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/smoke_adjcsb"];
    }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]){
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/smoke_lpkpxz"];
    }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/smoke_spjycsjl"];
    }
    
    NSMutableDictionary *params = _allData;
    NSData *afterData =  [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *after = [[NSString alloc]initWithData:afterData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",after);
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        [weakSelf showHint:responseObject[@"msg"]];
        [self.navigationController popToViewController:weakSelf.formChoseVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _itemList.count;
    }else if(section == 1){
        if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
            return 6;
        }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]){
            return 0;
        }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
            return 3;
        }
        return 1;
        
    }else if(section == 2){
        if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
            return 5;
        }else if ([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
            return 4;
        }else if ([_formName isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]){
            return 2;
        }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]){
            return 3;
        }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
            return 5;
        }
        return 5;
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else if(indexPath.section == 1){
        if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
            if (indexPath.row > 2) {
                return 60;
            }
        }else if ([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
            return 200;
        }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
            return 40;
        }
        return 90;
    }else{
        return 40;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellID"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    TextViewTableViewCell *cell1 = [_tableView dequeueReusableCellWithIdentifier:@"TextViewCellID"];
    cell1.delegate = self;
    cell1.firstLable.text = @"异常情况描述:";
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.indexPath = indexPath;
    
    
    TextFieldTableViewCell *cell2 = [_tableView dequeueReusableCellWithIdentifier:@"TextFieldCellID"];
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    cell2.delegate = self;
    cell2.textField.returnKeyType = UIReturnKeyDone;
    cell2.indexPath = indexPath;
    cell2.textField.keyboardType = UIKeyboardTypeDefault;
    if (indexPath.section == 0) {
        MessageAndDetailCellModel *model = _itemList[indexPath.row];
        cell.messageLabel.text = model.name;
        cell.detailLabel.text = model.state;
        return cell;
    }else if(indexPath.section == 1){
        if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
            if (indexPath.row == 0) {
                cell1.firstLable.text = @"异常情况描述:";
                cell1.textView.placeHolder = @"异常情况描述...";
            }else if (indexPath.row == 1){
                cell1.firstLable.text = @"原因分析与采取措施:";
                cell1.textView.placeHolder = @"原因分析与采取措施...";
            }else if (indexPath.row== 2){
                cell1.firstLable.text = @"处理结果及器件更新:";
                cell1.textView.placeHolder = @"处理结果及器件更新...";
            }else if (indexPath.row== 3){
                cell1.firstLable.text = @"线性变动记录:";
                cell1.textView.placeHolder = @"线性变动记录...";
            }else if (indexPath.row== 4){
                cell1.firstLable.text = @"校验前:";
                cell1.textView.placeHolder = @"校验前...";
            }else if (indexPath.row== 5){
                cell1.firstLable.text = @"校验后:";
                cell1.textView.placeHolder = @"校验后...";
            }
        }else if ([_formName isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]){
            cell1.firstLable.text = @"异常情况处理:";
            cell1.textView.placeHolder = @"异常情况处理...";
            cell1.textView.text = _allData[@"abnormal_describe"];
        }else if ([_formName isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]){
            cell1.firstLable.text = @"异常情况备注:";
            cell1.textView.placeHolder = @"异常情况备注...";
            cell1.textView.text = _allData[@"note"];
        }else if ([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
            if (indexPath.row == 0) {
                cell1.firstLable.text = @"线性变动过程记录:";
                cell1.textView.placeHolder = @"线性变动过程记录...";
            }
        }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
            if (indexPath.row== 0){
                cell2.firstLableText = @"仪器名称:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                return cell2;
            }else if (indexPath.row== 1){
                cell2.firstLableText = @"仪器型号:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                return cell2;
            }else if (indexPath.row== 2){
                cell2.firstLableText = @"仪器供应商:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                return cell2;
            }
        }
        
        return cell1;
    }else if(indexPath.section == 2){
        
        if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
            if (indexPath.row == 0) {
                cell2.firstLableText = @"实施人1:";
                cell2.textFieldCellType = TextFieldCellTypeText;
            }else if (indexPath.row == 1){
                cell2.firstLableText = @"实施人2:";
                cell2.textFieldCellType = TextFieldCellTypeText;
            }else if (indexPath.row== 2){
                cell2.firstLableText = @"校准月份:";
                cell2.textFieldCellType = TextFieldCellTypeText;
            }else if (indexPath.row== 3){
                cell2.firstLableText = @"起始时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }else if (indexPath.row== 4){
                cell2.firstLableText = @"结束时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }
        }else if ([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
            if (indexPath.row == 0) {
                cell2.firstLableText = @"实施人:";
                cell2.textFieldCellType = TextFieldCellTypeText;
            }else if (indexPath.row== 1){
                cell2.firstLableText = @"校准月份:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                cell2.textField.keyboardType = UIKeyboardTypeNumberPad;
            }else if (indexPath.row== 2){
                cell2.firstLableText = @"起始时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }else if (indexPath.row== 3){
                cell2.firstLableText = @"结束时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }
        }else if ([_formName isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]){
            if (indexPath.row == 0) {
                cell2.firstLableText = @"企业方代表:";
            }else if (indexPath.row == 1){
                cell2.firstLableText = @"日期:";
                NSDate *now = [NSDate date];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                cell2.textField.enabled = NO;
                cell2.textField.text = [formatter stringFromDate:now];
                _allData[@"daily_date"] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
            }else if (indexPath.row == 2){
                cell2.firstLableText = @"离站时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }else if (indexPath.row == 3){
                cell2.firstLableText = @"服务耗时:";
                cell2.textField.enabled = NO;
                cell2.textField.text = _allData[@"service_time"];
            }else if (indexPath.row == 4){
                cell2.firstLableText = @"备注:";
            }
        }else if ([_formName isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]){
            if (indexPath.row == 0){
                cell2.firstLableText = @"离站时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }else if (indexPath.row == 1){
                cell2.firstLableText = @"服务耗时:";
                cell2.textField.enabled = NO;
                cell2.textField.text = _allData[@"servicetime"];
            }
        }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]){
            if (indexPath.row == 0) {
                cell2.firstLableText = @"本次校准人:";
                cell2.textField.text = _allData[@"checking_people"];
            }else if (indexPath.row == 1){
                cell2.firstLableText = @"校准起始时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }else if (indexPath.row == 2){
                cell2.firstLableText = @"校准结束时间:";
                cell2.textFieldCellType = TextFieldCellTypeDatePiker;
                cell2.datePicker.datePickerMode = UIDatePickerModeTime;
            }
        }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
            if (indexPath.row== 0){
                cell2.firstLableText = @"如校验合格前对系统进行过处理:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                return cell2;
            }else if (indexPath.row== 1){
                cell2.firstLableText = @"如校验合格后,烟尘分析仪、流速仪:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                return cell2;
            }else if (indexPath.row== 2){
                cell2.firstLableText = @"总体校验是否合格:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                return cell2;
            }else if (indexPath.row== 3){
                cell2.firstLableText = @"校验人员:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                cell2.textField.text = _allData[@"calibration_people"];
                return cell2;
            }else if (indexPath.row== 4){
                cell2.firstLableText = @"负责人:";
                cell2.textFieldCellType = TextFieldCellTypeText;
                return cell2;
            }
        }
        
        return cell2;
    }else{
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellids"];
        return cell;
    }
   
    
}
//尾视图
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section <2) {
        return 8;
    }
    return 0.000000001;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 8)];
//    view.backgroundColor = [UIColor grayColor];
    return nil;
}
//头视图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 40)];
        lable.textAlignment = NSTextAlignmentCenter;
        if (section == 1) {
           lable.text = @"参比法对比测试仪"; 
        }else if (section == 2) {
            lable.text = @"校验结论"; 
        }
        
        return lable;
    }else{
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
        if (section == 0) {
            return 0;
        }else{
           return 40;
        }
        
    }else{
        return 0;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        MessageAndDetailCellModel *model = _itemList[indexPath.row];
        if ([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
            GroupTextViewController *groupTextViewController = [[GroupTextViewController alloc]init];
            groupTextViewController.title = model.name;
            groupTextViewController.datasDic = _allData[model.name];
            groupTextViewController.dataBack = ^(NSDictionary *dataDic) {
                _allData[model.name] = dataDic;
                NSArray *checkout_record;
                if (_allData[@"校验1"] != nil&&_allData[@"校验2"]!=nil) {
                    checkout_record = @[_allData[@"校验1"],_allData[@"校验2"]];
                }else if(_allData[@"校验1"] == nil && _allData[@"校验2"] != nil){
                    checkout_record = @[_allData[@"校验2"]];
                }else if (_allData[@"校验1"] != nil && _allData[@"校验2"] == nil){
                    checkout_record = @[_allData[@"校验1"]];
                }
                
                if (checkout_record != nil) {
                    _allData[@"checkout_recordArray"] =checkout_record;
                }
                model.state = @"已填";
                [_tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            };
            [self.navigationController pushViewController:groupTextViewController animated:YES];
            
        }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]||[self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
            GroupTextViewController *groupTextViewController = [[GroupTextViewController alloc]init];
            groupTextViewController.title = model.name;
            groupTextViewController.datasDic = _allData[model.name];
            groupTextViewController.dataBack = ^(NSDictionary *dataDic) {
                _allData[model.name] = dataDic;
                model.state = @"已填";
                [_allData addEntriesFromDictionary:dataDic];
                [_tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:groupTextViewController animated:YES];
            
        }else{
            if ([_formName isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]&&indexPath.row == 4){
                TxetViewController *textVC = [[TxetViewController alloc]init];
                textVC.text = _allData[@"daily_other"];
                textVC.canEdite = YES;
                textVC.title = model.name;
                textVC.backText = ^(NSString *textStr) {
                    if (textStr != nil) {
                        _allData[@"daily_other"] = textStr;
                        
                    }
                };
                [self.navigationController pushViewController:textVC animated:YES];
            }else{
                SegmentsViewController *segmentsViewController = [[SegmentsViewController alloc]init];
                segmentsViewController.title = model.name;
                segmentsViewController.datasDic = _allData[model.name];
                segmentsViewController.dataBack = ^(NSDictionary *dataDic) {
                    _allData[model.name] = dataDic;
                    if (![model.name isEqualToString:@"常规项"]) {
                        NSString *remarkStr = @"";
                        for (MessageAndDetailCellModel *cellModel in _itemList) {
                            NSDictionary *dic = _allData[cellModel.name];
                            if (dic != nil) {
                                if (![ZQ_CommonTool isEmpty: dic[@"errorRemark"]]) {
                                     remarkStr = [NSString stringWithFormat:@"%@%@;",remarkStr,dic[@"errorRemark"]];
                                }
                               
                            }
                        }
                        if ([_formName isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]){
                            _allData[@"abnormal_describe"] = remarkStr;
                        }else if ([_formName isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]){
                            _allData[@"note"] = remarkStr;
                        }
                        
                    }
                    [_allData addEntriesFromDictionary:dataDic];
                    model.state = @"已填";
                    [_tableView reloadRowsAtIndexPaths: @[indexPath,[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    NSLog(@"allData:%@",_allData);
                };
                [self.navigationController pushViewController:segmentsViewController animated:YES];
            }
        }
    }
}

#pragma mark -cell输入框的回调方法
-(void)cellTextEndEdit:(NSString*)cellText IndexPath:(NSIndexPath*)indexPath{
    if ([_formName isEqualToString:@"水污染源自动检测仪运营维护日常巡检表"]) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {//异常处理情况
                _allData[@"abnormal_record"] = cellText;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                _allData[@"enterprise_representative"] = cellText;
            }else if(indexPath.row == 1){
                
            }else if (indexPath.row == 2){
                _allData[@"leave_time"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
                
                NSString *time = [NSString compareTwoTime:[_allData[@"arrivetime"] integerValue] time2:[cellText integerValue]];
                _allData[@"service_time"] = time;
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:2]] withRowAnimation:UITableViewRowAnimationTop];
            }else if (indexPath.row == 3){
                
            }else if (indexPath.row == 4){
                _allData[@"daily_remark"] = cellText;
            }
        }
    }else if ([_formName isEqualToString:@"烟气自动检测设备日常巡检维护记录表"]) {
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {//异常处理备注
                _allData[@"note"] = cellText;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                _allData[@"leaveltime"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
                
                NSString *time = [NSString compareTwoTime:[_allData[@"arrivetime"] integerValue] time2:[cellText integerValue]];
                _allData[@"servicetime"] = time;
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationTop];
            }else if (indexPath.row == 1){
                
            }
        }
    }else if ([_formName isEqualToString:@"水污染源自动监测仪校准记录表"]){
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {//异常处理情况
                _allData[@"abnormal_describe"] = cellText;
            }else if (indexPath.row == 1){
                _allData[@"reason_measures"] = cellText;
            }else if (indexPath.row == 2){
                _allData[@"result_device"] = cellText;
            }else if (indexPath.row == 3){
                _allData[@"linear_change"] = cellText;
            }else if (indexPath.row == 4){
                _allData[@"linear_front"] = cellText;
            }else if (indexPath.row == 5){
                _allData[@"linear_after"] = cellText;
            }
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                _allData[@"executive1"] = cellText;
            }else if(indexPath.row == 1){
                _allData[@"executive2"] = cellText;
            }else if (indexPath.row == 2){
                _allData[@"calibration_month"] = cellText;
            }else if (indexPath.row == 3){
                _allData[@"calibration_time1"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
            }else if (indexPath.row == 4){
               _allData[@"calibration_time2"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
            }
        }
    }else if([_formName isEqualToString:@"水污染源自动监测仪校验记录表"]){
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                _allData[@"linear_change"] = cellText;
            }
        }else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                _allData[@"executive"] = cellText;
            }else if (indexPath.row == 1){
                _allData[@"calibration_month"] = cellText;
            }else if (indexPath.row == 2){
                _allData[@"calibration_time1"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
            }else if (indexPath.row == 3){
                _allData[@"calibration_time2"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
            }
        }
    }else if ([self.title isEqualToString:@"烟气自动监测设备零漂、跨漂校准记录表"]){
        if (indexPath.row == 0) {
            _allData[@"calibration_people"] = cellText;
        }else if (indexPath.row == 1){
            _allData[@"calibration_time1"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
        }else if (indexPath.row == 2){
            _allData[@"calibration_time2"] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
        }
    }else if ([self.title isEqualToString:@"烟气自动监测设备校验测试记录"]){
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                _allData[@"instrument_name"] = cellText;
            }else if (indexPath.row == 1){
                _allData[@"instrument_model"] = cellText;
            }else if (indexPath.row == 2){
                _allData[@"Instrument_supplier"] = cellText;
            }
        }else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                _allData[@"jyhgqdxtjxgcl"] = cellText;
            }else if (indexPath.row == 1){
                _allData[@"jyhghycfxylsy"] = cellText;
            }else if (indexPath.row == 2){
                _allData[@"overall_check_qualified"] = cellText;
            }else if (indexPath.row == 3){
                _allData[@"calibration_people"] = cellText;
            }else if (indexPath.row == 4){
                _allData[@"head_people"] = cellText;
            }
        }
    }
    
    
}

//表视图滑动的时候收起键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hidekeyBoard];
}

//收起键盘
-(void)hidekeyBoard{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    //取得第一响应者
    UIView *activeField = [UIResponder currentFirstResponder];  
    //除去键盘后的页面显示区域
    CGRect tableReact = self.tableView.frame;
    float y = _tableView.contentOffset.y;
    tableReact.origin.y += y;
    tableReact.size.height -= keyBoardRect.size.height;
    //判断cell底部是否在显示范围内
    CGPoint cellBottomPoint = CGPointMake(0.0, activeField.superview.superview.frame.origin.y +activeField.superview.superview.frame.size.height);
    if (!CGRectContainsPoint(tableReact, cellBottomPoint) ) {
       
        CGPoint scrollPoint = CGPointMake(0.0, cellBottomPoint.y-tableReact.size.height);
        [_tableView setContentOffset:scrollPoint animated:YES];
        
    }
    
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
     
    [UIView animateWithDuration:.35 animations:^{
       self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

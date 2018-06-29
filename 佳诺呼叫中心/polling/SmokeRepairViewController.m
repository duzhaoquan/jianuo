//
//  SmokeRepairViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/13.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "SmokeRepairViewController.h"
#import "TextViewTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "NSString+HFExtension.h"
#import "TxetViewController.h"
#import "UIResponder+FirstResponder.h"
#import "NSString+HFExtension.h"

@interface SmokeRepairViewController ()<UITableViewDelegate,UITableViewDataSource,TextCellDelegate,TextFieldCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)NSMutableDictionary *allData;

@property (nonatomic,strong)NSArray<NSString*>*sectionStrs;
@property (nonatomic,strong)NSArray<NSArray<NSString*>*>*rowStrs;
@property (nonatomic,strong)NSArray<NSArray<NSString*>*>*keys;

@end

@implementation SmokeRepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _formName;
    [self setupTableView];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    _allData = [NSMutableDictionary dictionaryWithDictionary:_headerData];
    
    if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]) {
        _sectionStrs =@[@"烟尘测试仪",@"烟尘分析仪",@"烟尘参数测试仪",@"加热采样装置(含自控温气体伴热管)",@"气体制冷装置",@"数据采集与处理控制部分",@"空压机及反吹风机部分",@"采样泵、蠕动泵、控制阀部分",@"总结"];
        _rowStrs = @[@[@"检修情况描述:",@"更换部件:"],
                     @[@"检修情况描述:",@"更换部件:"],
                     @[@"检修情况描述:",@"更换部件:"],
                     @[@"检修情况描述:",@"更换部件:"],
                     @[@"检修情况描述:",@"更换部件:"],
                     @[@"检修情况描述:",@"更换部件:"],
                     @[@"检修情况描述:",@"更换部件:"],
                     @[@"检修情况描述:",@"更换部件:"],
                     @[@"站房清理:",@"停机维修情况总结:",@"停机时间:",@"维修人:",@"离站时间:"],
                     ];
        _keys = @[
                  @[@"yct_maintenance_description",@"yct_replacement_parts"],
                  @[@"ycf_maintenance_description",@"ycf_replacement_parts"],
                  @[@"yccs_maintenance_description",@"yccs_replacement_parts"],
                  @[@"jrcy_maintenance_description",@"jrcy_replacement_parts"],
                  @[@"qtzl_maintenance_description",@"qtzl_replacement_parts"],
                  @[@"sjcj_maintenance_description",@"sjcj_replacement_parts"],
                  @[@"kyjfcj_maintenance_description",@"kyjfcj_replacement_parts"],
                  @[@"cyrdkzf_maintenance_description",@"cyrdkzf_replacement_parts"],
                  @[@"house_cleaning",@"maintenance_downtime_conclusion",@"stoptime",@"calibration_people",@"leveltime"],
                  ];
    }else if ([self.title isEqualToString:@"水污染源自动监测仪故障维修记录表"]) {
        _sectionStrs =@[@"",@"",@""];
        _rowStrs = @[@[@"故障情况及发生时间:",@"维修人:",@"维修日期:"],
                     @[@"修复后使用前校验时间、校验结果说明:",@"校验人:",@"校验日期:"],
                     @[@"正常投入使用时间:",@"运维负责人:",@"运维日期:"],
                     ];
        _keys = @[
                  @[@"fault_description",@"repair_man",@"repair_date"],
                  @[@"calibration_description",@"calibration_man",@"calibration_date"],
                  @[@"normal_use",@"maintenance_representative",@"maintenance_date"],
                  ];
    }
    
}


- (void)setupTableView {
    
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
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
    
    __weak SmokeRepairViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *URL = @"";
    if ([_formName isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/water_fault_repair"];
    }else if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]){
        URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/smoke_jzsbwx"];
    }
    
    NSMutableDictionary *params = _allData;
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        [weakSelf showHint:responseObject[@"msg"]];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _sectionStrs.count;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _rowStrs[section].count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCellID"];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    cell.textFieldCellType = TextFieldCellTypeText;
    cell.firstLableText = _rowStrs[indexPath.section][indexPath.row];
    cell.textField.text = _allData[_keys[indexPath.section][indexPath.row]];
    
    TextViewTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"TextViewCellID"];
    cell1.delegate = self;
    cell1.selectionStyle = UITableViewCellSelectionStyleNone;
    cell1.indexPath = indexPath;
    cell1.firstLable.text = _rowStrs[indexPath.section][indexPath.row];
    cell1.textView.text = _allData[_keys[indexPath.section][indexPath.row]];
    
    if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]) {
        if (indexPath.section == 8) {
            if (indexPath.row ==1) {
                return cell1;
            }else if (indexPath.row == 4){
                cell.textFieldCellType = TextFieldCellTypeDatePiker;
                cell.datePicker.datePickerMode = UIDatePickerModeTime;
            }
            
        }
       
    }else if ([_formName isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
        if (indexPath.row == 0) {
            return cell1;
        }else if (indexPath.row == 2){
            NSDate *now = [NSDate date];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy年MM月dd日"];
            cell.textField.text = [formatter stringFromDate:now];
            cell.textField.enabled = NO;
            _allData[_keys[indexPath.section][indexPath.row]] = [NSString stringWithFormat:@"%ld",(NSInteger)now.timeIntervalSince1970];
        }
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]){
        return 40;
    }else if([self.title isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
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
    if ([self.title isEqualToString:@"烟气自动监测设备维修记录表"]) {
        if (indexPath.section == 8 && indexPath.row == 1) {
            return 90;
        }
        
    }else if ([_formName isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
        if (indexPath.row == 0) {
            return 90;
        }
    }
    return 40;
}



#pragma mark -cell输入框的回调方法
-(void)cellTextEndEdit:(NSString*)cellText IndexPath:(NSIndexPath*)indexPath{
    if ([ZQ_CommonTool isEmpty:cellText]) {
        return;
    }
    
    if ([_formName isEqualToString:@"烟气自动监测设备维修记录表"]) {
       _allData[_keys[indexPath.section][indexPath.row]] = cellText;
        if (indexPath.section == 8) {
             if (indexPath.row == 4){
               _allData[_keys[indexPath.section][indexPath.row]] = [NSString stringWithFormat:@"%ld",[cellText integerValue]];
            }
            
        }
        
//        NSString *str = [NSString faceStringWithWeiboText:cellText];
//        NSLog(@"--------------%@",str);
//        NSString *str1 =[NSString replacementText:cellText];
//        BOOL isbaohan = [NSString stringContainsEmoji:cellText];
//        NSLog(@"-------------包涵-%d结果-%@",isbaohan,str1);
    }else if ([_formName isEqualToString:@"水污染源自动监测仪故障维修记录表"]){
        _allData[_keys[indexPath.section][indexPath.row]] = cellText;
    }
    
}

//表视图滑动的时候收起键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hidekeyBoard];
}
//收起键盘
-(void)hidekeyBoard{
    for (UITableViewCell *cell in _tableView.visibleCells) {
        if([cell isKindOfClass:[TextViewTableViewCell class]]){
            TextViewTableViewCell *textViewCell = (TextViewTableViewCell*)cell;
            [textViewCell.textView resignFirstResponder];
        }else if([cell isKindOfClass:[TextFieldTableViewCell class]]){
            TextFieldTableViewCell *textFieldTableViewCell = (TextFieldTableViewCell*)cell;
            [textFieldTableViewCell.textField resignFirstResponder];
        }
    }
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height + 20, 0);
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

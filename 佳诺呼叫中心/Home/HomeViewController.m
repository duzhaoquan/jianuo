//
//  HomeViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/11.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "KNIconTitButton.h"
//企业端
#import "TaskReceiveViewController.h"
#import "TaskProcessingVC.h"
#import "TaskVerificVC.h"
#import "StatementQueryVC.h"

//客户端
#import "TroubleCallViewController.h"
#import "ProgressQueryViewController.h"
#import "AchieveSureViewController.h"
#import "TaskEvaluateVC.h"

@interface HomeViewController ()
@property (nonatomic,strong)SDCycleScrollView *imagePlayerView;
@property (nonatomic,assign)CGFloat safeArea;
@property (nonatomic,strong)UIImageView *backImageView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"维修";
    
    
    _safeArea = 0;
    if (kScreenheight == 812) {
        _safeArea = 24;
    }
    
    NSString *utype  = [USERDEFALUTS objectForKey:@"utype"];
    if ([utype integerValue] == 1) {
        //客户
        _isClient = YES;
    }
    
    //添加通知。收到推送时更新每个按钮上方的红点数
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"myNotificaton" object:nil];
    
    [self setupUI];
    
    __weak HomeViewController *weekSelf = self;
    self.QueryBlock = ^(){
        
       weekSelf.redDot.hidden = YES;
      
    };
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getdata];
}
-(void)notificationAction:(NSNotification*)noti{
    [self getdata];
    self.redDot.hidden = NO;
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setupUI{
    
    _backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight + 20)];
    _backImageView.image = [UIImage imageNamed:@"背景"];
    [self.view addSubview:_backImageView];
    [self setupScrollview];

    NSArray *imageNames = @[@"接受",@"现场",@"核销",@"查询"];
    NSArray *describStrings = @[@"任务接受",@"现场处理",@"任务核销",@"报表查询"];
    if (_isClient) {
        describStrings = @[@"故障报修",@"完工确认",@"任务评价",@"进度查询"];
    }
    CGFloat itemSize = kScreenwidth/7*2;
    CGFloat bigenY = kScreenwidth/2 + 100 + _safeArea;
    
    for (int i = 0; i<describStrings.count; i++) {
        
        KNIconTitButton *isDoneBtn = [[KNIconTitButton alloc] initWithFrame:CGRectMake(0.75*itemSize + (i%2)*(20+itemSize), bigenY + i/2*(30+itemSize), itemSize -20, itemSize)];
        //isDoneBtn.backgroundColor = [UIColor redColor];
        if (kScreenwidth <= 320) {//5s
            isDoneBtn.frame = CGRectMake(0.75*itemSize + (i%2)*(20+itemSize), bigenY - 20 + i/2*(20+itemSize), itemSize -20, itemSize);
        }
        isDoneBtn.tag = 500 +i;
        isDoneBtn.describString = describStrings[i];
        isDoneBtn.number = 0;
        isDoneBtn.stringFont = [UIFont systemFontOfSize:17];
        isDoneBtn.describColor =  kUIColorFromRGB(0x666666);
        isDoneBtn.iconString = imageNames[i];
        [isDoneBtn addTarget:self action:@selector(isDoneIBAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:isDoneBtn];

    }
    
    
    //客户端进度查询的右上角红点
    KNIconTitButton *queryButton = [self.view viewWithTag:503];
    UILabel *redView = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(queryButton.frame) - 15, -10, 38, 20)];
    redView.layer.cornerRadius = 5;
    redView.layer.backgroundColor = kUIColorFromRGB(0xfb7caf).CGColor;
    redView.hidden = YES;
    redView.textAlignment = NSTextAlignmentCenter;
    redView.text = @"new";
    redView.textColor = [UIColor whiteColor];
    redView.font = [UIFont systemFontOfSize:17];
    self.redDot = redView;
    
    if (_isClient) {
        [queryButton addSubview:self.redDot];
    }
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenheight - 80, kScreenwidth - 20, 30)];
    label.text = @"服务电话:0311-88868836";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
}

-(void)setupScrollview{
    NSArray *array = @[@"轮播1",@"轮播2",@"轮播3"];
    NSMutableArray *iamgesArray = [NSMutableArray array];
    for (NSString *item in array) {
        [iamgesArray addObject:[UIImage imageNamed:item]];
    }
    
    NSLog(@"x = %f,y= %f",kScreenwidth,kScreenheight);
    self.imagePlayerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(5, 64 + _safeArea, kScreenwidth-10, (kScreenwidth-10)/2) imagesGroup:iamgesArray where:1];
    _imagePlayerView.autoScrollTimeInterval = 3;
    _imagePlayerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    _imagePlayerView.backgroundColor = [UIColor yellowColor];
//    //_imagePlayerView.delegate = self;
    _imagePlayerView.dotColor = kUIColorFromRGB(0xfb7caf);
    _imagePlayerView.placeholderImage = [UIImage imageNamed:@"0"];
    [self.view addSubview:_imagePlayerView];
}

-(void)getdata{
    __weak HomeViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    manager.requestSerializer.timeoutInterval = 20;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_task_amount"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSDictionary *list = responseObject[@"listData"];
        if (![ZQ_CommonTool isEmptyDictionary:list]) {
            [weakSelf refreshTaskNum:list];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}


-(void)refreshTaskNum:(NSDictionary*)dic{
    KNIconTitButton *button1 = [self.view viewWithTag:500];
    
    if ([[USERDEFALUTS objectForKey:@"group_id"] isEqualToString:@"12"]) {
        NSNumber *ask_amount1 = dic[@"task_amount1"];
        button1.number = [ask_amount1 integerValue];
    }else if ([[USERDEFALUTS objectForKey:@"group_id"] isEqualToString:@"13"]){
        NSNumber *ask_amount2 = dic[@"task_amount2"];
        button1.number = [ask_amount2 integerValue];
    }
    

    KNIconTitButton *button2 = [self.view viewWithTag:501];
    KNIconTitButton *button3 = [self.view viewWithTag:502];
    if (_isClient) {
        NSNumber *ask_amount6 = dic[@"task_amount6"];
        button2.number = [ask_amount6 integerValue];
        
        NSString *ask_amount4 = dic[@"task_amount7"];
        button3.number = [ask_amount4 integerValue];
        
    }else{
        NSNumber *ask_amount3 = dic[@"task_amount3"];
        button2.number = [ask_amount3 integerValue];
        
        
        NSString *ask_amount4 = dic[@"task_amount4"];
        button3.number = [ask_amount4 integerValue];
    }

    
    
}
- (void)isDoneIBAction:(UIButton*)button{
    
    NSUInteger index = button.tag - 500;
    //企业端
    if (!_isClient) {
        switch (index) {
            case 0: {//任务接受
                TaskReceiveViewController *taskViewController  = [[TaskReceiveViewController alloc]init];
                taskViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:taskViewController animated:YES];
            }
            
                break;
             
            
            case 1://现场处理
            {
                TaskProcessingVC *taskProcessingVC = [[TaskProcessingVC alloc]init];
                taskProcessingVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:taskProcessingVC animated:YES];
            }
            
                break;
            case 2://任务核销
            {
                TaskVerificVC *taskVerific = [[TaskVerificVC alloc]init];
                taskVerific.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:taskVerific animated:YES];
            }
                break;
            case 3://报表查询
            {
                StatementQueryVC *statementQuery = [[StatementQueryVC alloc]init];
                statementQuery.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:statementQuery animated:YES];
            }
                break;
            default:
                break;
        }
    }else{
        switch (index) {
            case 0://故障报修
            {
                TroubleCallViewController *trouble = [[TroubleCallViewController alloc]init];
                trouble.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:trouble animated:YES];
            }
                break;
                
            
            case 1://完工确认AchieveSure
            {
                AchieveSureViewController *achiveSureVC = [[AchieveSureViewController alloc]init];
                achiveSureVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:achiveSureVC animated:YES];
            }
                
                break;
            case 2://任务评价TaskEvaluate
            {
                TaskEvaluateVC *taskEvaluate = [[TaskEvaluateVC alloc]init];
                taskEvaluate.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:taskEvaluate animated:YES];
            }
                break;
            case 3://进度查询ProgressQuery
            {
                ProgressQueryViewController *ProgressQueryVC = [[ProgressQueryViewController alloc]init];
                ProgressQueryVC.hidesBottomBarWhenPushed = YES;
                ProgressQueryVC.QueryBlock = _QueryBlock;
                [self.navigationController pushViewController:ProgressQueryVC animated:YES];
                
            }
                
                break;
            default:
                break;
        }
    }
   
    
}



@end

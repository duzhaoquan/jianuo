//
//  CheckInViewController.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/8.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "CheckInViewController.h"
#import "DropDown.h"
#import <corelocation/corelocation.h>
#import "CheckTaskModel.h"
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationAuth.h>
#import <BMKLocationKit/BMKLocationReGeocode.h>

@interface CheckInViewController ()<CLLocationManagerDelegate,BMKLocationAuthDelegate,BMKLocationManagerDelegate>
@property (nonatomic,strong)DropDown *customerList;
@property (nonatomic,strong)UIButton *checkButton;
@property (nonatomic,strong)UILabel *timeLable;
@property (nonatomic,strong)UILabel *showLable;
@property (nonatomic,strong)CLLocationManager *mgr;
@property (nonatomic,strong)NSMutableArray *taskList;
@property (nonatomic,strong)CheckTaskModel *currentModel;
@property (nonatomic,strong)UILabel *locationLable;

//
@property (nonatomic,strong)BMKLocationManager *locationManager;
@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"现场签到";
    self.view.backgroundColor = [UIColor whiteColor];
    _taskList = [NSMutableArray array];
    [self setupUI];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectCustomer:) name:@"checkIn" object:nil];
    
    //[self setlocation];
    //百度地位
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:@"YMr8pwETZNGI32NfHpgGb9x0iBfZgPsa" authDelegate:self];
    [self setlocation1];
    
    [self getdata];
}

#pragma mark-点击选择任务
-(void)selectCustomer:(NSNotification*)not{
    NSLog(@"not:%@",not.userInfo);
    NSDictionary *dictionary = not.userInfo;
    NSInteger index = [dictionary[@"index"] integerValue];
    if (index>=0&&index<_taskList.count) {
        _currentModel = _taskList[index];
        if ([_currentModel.is_clock boolValue] == YES) {
            _locationLable.text=@"状态:已签到";
        }else{
            _locationLable.text=@"状态:未签到";
        }
        //[self.mgr startUpdatingLocation];
        [self.locationManager startUpdatingLocation];
    }
    
}
#pragma mark-获取任务列表
-(void)getdata{
    __weak CheckInViewController *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/get_card_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        if([responseObject[@"code"] integerValue] == 1){
            
            NSArray *list = responseObject[@"listData"];
            NSMutableArray *arr = [NSMutableArray array];
            if (list.count == 0) {
                [_taskList removeAllObjects];
                
            }else{
                
                [_taskList removeAllObjects];
                for (NSDictionary *dic in list) {
                    CheckTaskModel *model = [[CheckTaskModel alloc]init];
                    [model setKeyValues:dic];
                    [_taskList addObject:model];
                    [arr addObject:model.customer_name];
                    
                }
                
            }

            _customerList.tableArray = arr;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}
#pragma mark - 定时器方法
- (void)timerFunc{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    _timeLable.text = [formatter stringFromDate:[NSDate date]];
    
}
#pragma mark - 设置页面UI
-(void)setupUI{
    _customerList = [[DropDown alloc]initWithFrame:CGRectMake(10, 74, kScreenwidth-20, 300)];
    _customerList.tableArray = @[@"冀鹏",@"扬天"];
    _customerList.textField.frame = CGRectMake(0, 0, kScreenwidth-20, 55);
    _customerList.textField.placeholder = @"选择巡检任务";
    _customerList.name = @"checkIn";
    [self.view addSubview:_customerList];
    
    //签到按钮
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:checkButton];
    [checkButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    checkButton.frame = CGRectMake(kScreenwidth/2 - kScreenwidth/6, (kScreenheight-164)/2, kScreenwidth/3, kScreenwidth/3);
    checkButton.layer.cornerRadius = kScreenwidth/6;
    checkButton.userInteractionEnabled = NO;
    checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);//    #7D9EC0
    [checkButton setTitle:@"点击签到" forState:UIControlStateNormal];
    checkButton.tintColor = [UIColor whiteColor];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:19];
    self.checkButton = checkButton;
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenwidth/6-50,CGRectGetHeight(checkButton.frame)/2+10,100, 30)];
    timeLable.textColor = [UIColor whiteColor];
    timeLable.textAlignment = NSTextAlignmentCenter;
    timeLable.font = [UIFont systemFontOfSize:15];
    [checkButton addSubview:timeLable];
    [self timerFunc];
    self.timeLable = timeLable;
    
    
    UILabel *showLable = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(checkButton.frame)+10, kScreenwidth-80, 40)];
    showLable.textColor = [UIColor blackColor];
    showLable.textAlignment = NSTextAlignmentCenter;
    showLable.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:showLable];
    showLable.text = @"未进入签到范围,";
    self.showLable = showLable;
    // 
    NSRange range = NSMakeRange(7, 1);
    showLable.userInteractionEnabled = YES;
    //点击
    UIButton *locationButton = [showLable viewWithTag:1234];  
    if (locationButton == nil) {  
        CGRect rect = [self boundingRectForCharacterRange:range andContentStr:showLable.text];
        UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeSystem];
        locationButton.frame = CGRectMake(rect.origin.x, 0, 80, 40);
        locationButton.tag = 1234;  
        locationButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [locationButton setTitle:@"重新定位" forState:UIControlStateNormal];
        [locationButton setTitleColor:[UIColor blueColor]forState:UIControlStateNormal];
        
        locationButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside]; 
        [showLable addSubview:locationButton];  
    }            
    
    
    UILabel *locationLable = [[UILabel alloc]initWithFrame:CGRectMake(10,120, kScreenwidth-20, 100)];
    locationLable.textColor = [UIColor blackColor];
    locationLable.textAlignment = NSTextAlignmentLeft;
    locationLable.numberOfLines = 0;
    locationLable.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:locationLable];
    locationLable.text=@"状态:未选择任务";
    self.locationLable = locationLable;
    
}
//点击重新定位
-(void)locationAction{
    //[self.mgr startUpdatingLocation];
    [self.locationManager startUpdatingLocation];
}

#pragma mark-<获取电话号码的坐标>  
- (CGRect)boundingRectForCharacterRange:(NSRange)range andContentStr:(NSString *)contentStr  
{  
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:contentStr];  
    
    NSDictionary *attrs =@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]};  
    [attributeString setAttributes:attrs range:NSMakeRange(0, contentStr.length)];  
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:attributeString];  
    
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];  
    [textStorage addLayoutManager:layoutManager];  
    
    CGSize size = [contentStr sizeWithFont:[UIFont systemFontOfSize:15] maxWidth:kScreenwidth - 20];
    NSLog(@"%f,%f",size.width,size.height);
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:size];  
    textContainer.lineFragmentPadding = 0;  
    [layoutManager addTextContainer:textContainer];  
    
    NSRange glyphRange;  
    
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];  
    
    CGRect rect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];  
    
      //剧中时
    rect.origin.x = rect.origin.x + (self.showLable.frame.size.width-size.width)/2;  
    rect.origin.y = rect.origin.y + (self.showLable.frame.size.height-size.height)/2;
    
    
    return rect;  
} 

#pragma mark-点击签到
-(void)buttonAction:(UIButton*)button{
    if (_currentModel == nil) {
        [WCAlertView showAlertWithTitle:@"提示" message:@"请先选择巡讲任务" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }else{
        __weak CheckInViewController *weakSelf = self;
        [self showHudInView1:self.view hint:@"加载中..."];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
        params[@"order_sn"] = _currentModel.order_sn;
        
        NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/punch_clock"];
        
        [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf hideHud];
            
            NSLog(@"responseObject = %@",responseObject);
            if([responseObject[@"code"] integerValue] == 1){
                [weakSelf hideHud];
                _locationLable.text=@"状态:已签到";
                [weakSelf showHint:responseObject[@"msg"]];
            }else{
                [weakSelf hideHud];
                [weakSelf showHint:responseObject[@"msg"]];
            }
                
                
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf hideHud];
            [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
            
        }];
    }
    
}

#pragma mark 设置定位
- (void)setlocation1{
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    _locationManager.allowsBackgroundLocationUpdates =NO;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
    [self.locationManager setLocatingWithReGeocode:YES];
    [self.locationManager startUpdatingLocation];
    
}
- (void)setlocation{
    
    //获取经纬度
    //实现定位
    //1. 创建位置管理器
    self.mgr = [CLLocationManager new];
    
    //2. 请求授权 --> iOS8开始才需要写
    //除了写方法, 还要配置一个plist键值
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        [self.mgr requestWhenInUseAuthorization];
    }
    
    //3. 设置代理 --> 获取数据
    self.mgr.delegate = self;
    
    //4. 开始定位
    [self.mgr startUpdatingLocation];
    
    //1. 距离筛选器 --> 当位置发生一定的改变时, 再调用代理方法, 以此节省电量
    //当发生10米以上的位移之后才会调用代理方法
    self.mgr.distanceFilter = 10;
    
    //2. 定位精准度
    //设置精准度//降低精准度, 可以减少手机和卫星之间的数据计算. 就会节省电
    self.mgr.desiredAccuracy = 10;
    
    
}
#pragma mark 当更新位置信息之后, 会调用此方法 --> 此方法频繁调用
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location = locations.lastObject;
    //定位精度
    NSLog(@"horizontalAccuracy = %f",location.horizontalAccuracy);
    _showLable.text = @"正在定位中...";
    _checkButton.userInteractionEnabled = NO;
    _checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);
    if (location.horizontalAccuracy > 0 && location.horizontalAccuracy < 100 ) {//水平位置的是否精确
        
        //系统会一直更新数据，达到我们设定的定位精度之后就停止更新
//        if (location.horizontalAccuracy < 80) {
            [self.mgr stopUpdatingLocation];
            _showLable.text = @"未进入签到范围,"; 
            _checkButton.userInteractionEnabled = NO;
            _checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);
//        }
        if (_currentModel != nil) {//+39.83893036,+116.29273435
            CLLocation *nowLocation = [[CLLocation alloc]initWithLatitude:39.831349 longitude:116.280276];
            double distance =  [location distanceFromLocation:nowLocation];
            NSLog(@"目标X:%@,y:%@ 两地之间的距离是%.5lf",_currentModel.point_x,_currentModel.point_y,distance);
            if (distance<100) {
                [self.mgr stopUpdatingHeading];
                _showLable.text = @"已进入签到范围,";
                _checkButton.userInteractionEnabled = YES;
                _checkButton.backgroundColor = kUIColorFromRGB(0x63B8FF);
            }else{
                _showLable.text = @"未进入签到范围,";
                _checkButton.userInteractionEnabled = NO;
                _checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);
            }
        }
        
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
         {
             if (array.count > 0)
             {
                 
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 NSString *local = [NSString stringWithFormat:@"位置:%@%@%@%@,经度%f,纬度%f:",placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.name,location.coordinate.longitude,location.coordinate.latitude];
                 
                 NSLog(@"local = %@",local);

                 //_locationLable.text = local;
                 
        
             }else if (error == nil && [array count] == 0)
             {
                 NSLog(@"No results were returned.");
             }else if (error != nil)
             {
                 NSLog(@"An error occurred = %@", error);
             }
         }];
        
        
    }
    
    
}
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error

{
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);  
    } if (location) {//得到定位信息，添加annotation
        if (location.location) {
            //[self baiduGeoCode:location.location];
            //定位精度
            NSLog(@"horizontalAccuracy = %f",location.location.horizontalAccuracy);
            _showLable.text = @"正在定位中...";
            _checkButton.userInteractionEnabled = NO;
            _checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);
            if (location.location.horizontalAccuracy > 0 && location.location.horizontalAccuracy < 100 ) {//水平位置的是否精确
                
                //系统会一直更新数据，达到我们设定的定位精度之后就停止更新
                if (location.location.horizontalAccuracy < 80) {
                    [self.locationManager stopUpdatingLocation];
                    _showLable.text = @"未进入签到范围,"; 
                    _checkButton.userInteractionEnabled = NO;
                    _checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);
                }
                if (_currentModel != nil) {//+39.83893036,+116.29273435
                    CLLocation *nowLocation = [[CLLocation alloc]initWithLatitude:[_currentModel.point_y doubleValue] longitude:[_currentModel.point_x doubleValue]];
                    double distance =  [location.location distanceFromLocation:nowLocation];
                    NSLog(@"目标X:%@,y:%@ 两地之间的距离是%.5lf",_currentModel.point_x,_currentModel.point_y,distance);
                    if (distance<100) {
                        [self.mgr stopUpdatingHeading];
                        _showLable.text = @"已进入签到范围,";
                        if ([_currentModel.is_clock boolValue] == YES) {
                            _checkButton.userInteractionEnabled = NO;
                            _checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);
                        }else{
                            _checkButton.userInteractionEnabled = YES;
                            _checkButton.backgroundColor = kUIColorFromRGB(0x63B8FF);
                        }
                    }else{
                        _showLable.text = @"未进入签到范围,";
                        _checkButton.userInteractionEnabled = NO;
                        _checkButton.backgroundColor = kUIColorFromRGB(0x7D9EC0);
                    }
                }
            }
            NSLog(@"LOC = %@",location.location);
        }
        if (location.rgcData) {
            NSLog(@"rgc = %@",[location.rgcData description]);
        }   
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_customerList dontshowlist];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

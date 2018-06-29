//
//  TaskVerificDetailVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/16.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import "TaskVerificDetailVC.h"
#import "TaskDetailTableViewCell.h"
#import "TxetViewController.h"
#import "LHGroupViewController.h"
#import "LHCollectionViewController.h"
#import "LHConst.h"
#import "TaskfollowVC.h"
#import "ChoseTableView.h"
#import "EquipidModel.h"
#import "XHMessageTextView.h"
#import "CustomerInforViewController.h"

@interface TaskVerificDetailVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ChoseTableViewDelegate,UIAlertViewDelegate,UITextViewDelegate>

@property (nonatomic,strong)NSArray *photosArr;
@property (nonatomic,strong) NSMutableArray *imageArray;//存放处理完的图片
@property (nonatomic,strong) UIScrollView *scrolView;//滚动视图
@property (nonatomic,strong) NSMutableArray *scrollSubViews;//存放图片子视图
@property (nonatomic,strong) NSMutableArray *scrollSubFrame;//子视图的frame
@property (nonatomic,strong) NSMutableArray *localLength;//每张图片的尺寸
@property (nonatomic,strong) ChoseTableView *choseTableview;
@property (nonatomic,strong)UIView *equipView;
@property (nonatomic,strong) XHMessageTextView *modelfyTextField;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *bottomBtn;
@property (nonatomic,strong)UIButton *addImagebutton;
@property (nonatomic,strong)UIView *remarkView;
@property (nonatomic,strong)UITextField *remarkTextField;

@property (nonatomic,strong)MBProgressHUD *myHUD;

@end

@implementation TaskVerificDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"任务核销";
    [self setupTableView];
    [self setupbutton];
    [self setScrol];
    [self getdata];
    
    //KVO观察键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
    self.imageArray = [NSMutableArray new];
    self.scrollSubViews = [NSMutableArray new];
    self.scrollSubFrame = [NSMutableArray new];
    self.localLength = [NSMutableArray new];
    
}

#pragma mark -上传
-(void)toUpload{
    for (int i = 0; i<self.imageArray.count; i++) {
        NSData *data = UIImageJPEGRepresentation(self.imageArray[i], 0.5);
        NSString *string = self.localLength[i];
        NSLog(@"%@---%lu",string,(unsigned long)data.length);
    }
}

#pragma mark --
-(void)setScrol{
    UIScrollView *scrol = [[UIScrollView alloc]init];
    scrol.frame = CGRectMake(10, kScreenheight - 245, SCREEN_WIDTH - 120, 77*(SCREEN_HEIGHT/568));
    if (SCREEN_WIDTH < 375) {
        scrol.frame = CGRectMake(10, kScreenheight - 245, SCREEN_WIDTH - 74, 77*(SCREEN_HEIGHT/568));
    }
    [self.view addSubview:scrol];
    self.scrolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrolView = scrol;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark --
-(void)addImage{
    [self.view resignFirstResponder];
    UIAlertController *alert = [[UIAlertController alloc]init];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self acquireLocal];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self acquireAlbum];
    }];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [alert addAction:archiveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -获取相机相册
-(void)acquireAlbum{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        if ([[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."].firstObject integerValue]  == 8) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}


#pragma mark --
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    __block UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    __weak TaskVerificDetailVC *weakSelf = self;
    void(^imageBlock)() = ^(UIImage *image){
        __strong TaskVerificDetailVC *strongSelf = weakSelf;
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        image = [self makeThumbnailFromImage:image scale:0.4];
        
        NSString *length  = [NSString stringWithFormat:@"%f*%f",image.size.width,image.size.height];
        [strongSelf.localLength addObject:length];
        
        
        [strongSelf.imageArray addObject:image];
    };
    void(^dismissBlock)() = ^(){//声明
        __strong TaskVerificDetailVC *strongSelf = weakSelf;
        [picker dismissViewControllerAnimated:YES completion:^{
            [strongSelf setSpread];
        }];
    };
    
    
    //写入本地
    [[LHPhotoList sharePhotoTool]saveImageToAblum:originalImage completion:^(BOOL success, PHAsset *asset) {
        if (success) {//存成功
            [[LHPhotoList sharePhotoTool]requestImageForAsset:asset size:CGSizeMake(1080, 1920) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                originalImage = [UIImage imageWithData:UIImageJPEGRepresentation(originalImage, 1) scale:originalImage.scale];
                imageBlock(originalImage);
                dismissBlock();
            }];
        }else{//存失败
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                originalImage = [UIImage imageWithData:UIImageJPEGRepresentation(originalImage, 1) scale:originalImage.scale];
                imageBlock(originalImage);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    dismissBlock();
                });
            });
        }
    }];
}


- (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale {  
    UIImage *thumbnail = nil;  
    CGSize imageSize = CGSizeMake(srcImage.size.width * imageScale, srcImage.size.height * imageScale);  
    
     
        UIGraphicsBeginImageContext(imageSize);  
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);  
        [srcImage drawInRect:imageRect];  
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();  
        UIGraphicsEndImageContext();  
      
      
    //thumbnail = [UIImage imageWithData: UIImageJPEGRepresentation(thumbnail, 0.01)];
      
    return thumbnail;  
}  

#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -获取本地图片
-(void)acquireLocal{
    LHGroupViewController *group = [[LHGroupViewController alloc]init];
    group.maxChooseNumber = 3 - _imageArray.count;
    __weak TaskVerificDetailVC *weakSelf = self;
    group.backImageArray = ^(NSMutableArray<PHAsset *> *array){
        __strong TaskVerificDetailVC *strongSelf = weakSelf;
        if (array) {
            for (int i = 0; i<array.count; i++) {
                PHAsset *asset = array[i];
                [[LHPhotoList sharePhotoTool]requestImageForAsset:asset size:CGSizeMake(1080, 1920) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
                    NSString *length  = [NSString stringWithFormat:@"%f*%f",image.size.width,image.size.height];
                    [_localLength addObject:length];
                    [_imageArray addObject:image];
                    [strongSelf setSpread];
                }];
            }
        }
    };
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:group] animated:YES completion:nil];
}

#pragma mark -展示UI在界面
-(void)setSpread{
    
    self.scrolView.contentSize = CGSizeMake((imageWidth+10)*self.imageArray.count, 77*(SCREEN_HEIGHT/568));
    for (NSInteger i = self.scrollSubViews.count; i<self.imageArray.count; i++) {
        UIView *itemView = [[UIView alloc]init];
        itemView.frame = CGRectMake(imageWidth*i+10*i, 5, imageWidth, imageWidth);
        itemView.backgroundColor = [UIColor whiteColor];
        [self.scrolView addSubview:itemView];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(0, 0, imageWidth, imageWidth);
        imageView.image = self.imageArray[i];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = 100 +i;
        [itemView addSubview:imageView];
        //手势
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(imageWidth - 17 , -5, 22, 22);
        deleteBtn.tag = 200+i;
        NSString *strDelete = [[NSBundle mainBundle]pathForResource:@"02" ofType:@"png"];
        [deleteBtn setImage:[UIImage imageWithContentsOfFile:strDelete] forState:UIControlStateNormal];//正常显示
        [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];//删除
        [itemView addSubview:deleteBtn];
        
        [self.scrollSubFrame addObject:[NSValue valueWithCGRect:itemView.frame]];
        [self.scrollSubViews addObject:itemView];
        [UIView animateWithDuration:0.2 animations:^{
            itemView.alpha = 1;
        } completion:nil];
    }
    
}

#pragma mark -删除图片
-(void)deleteImage:(UIButton *)btn{
    UIView *view  = btn.superview;
    NSInteger idx = [_scrollSubViews indexOfObject:view];
    [_scrollSubViews removeObject:view];
    [_imageArray removeObjectAtIndex:idx];
    [_localLength removeObjectAtIndex:idx];
    [_scrollSubFrame removeLastObject];
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        self.scrolView.contentSize = CGSizeMake(imageWidth*self.scrollSubViews.count, imageWidth);
        [UIView animateWithDuration:0.2 animations:^{
            for (NSInteger i = idx; i < self.scrollSubViews.count; i++) {
                UIView *item = self.scrollSubViews[i];
                item.frame = [(NSValue*)(self.scrollSubFrame[i]) CGRectValue];
            }
        } completion:^(BOOL finished) {
            if (finished) {
                //完成之后处理的code
            }
        }];
    }];
    
    
    
}

- (void)setupTableView {

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, kScreenheight - 250) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView registerClass:[TaskDetailTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:_tableView];
}

-(void)choseTableViewsureButtonclick{
    [_modelfyTextField resignFirstResponder];
    
    NSArray *valus =  _choseTableview.selectedValues;
    NSMutableString *equipids = [NSMutableString string];
    for (EquipidModel *equipodModel in valus) {
        [equipids appendFormat:@"%@,",equipodModel.equipment_uniqid];
    }
    _modelfyTextField.text = equipids;
    [_modelfyTextField contentSizeToFit];
    NSLog(@"valus = %@",equipids);
    
}
//- (void)getmodelfyData{
//    __weak TaskVerificDetailVC *weakSelf = self;
//    [self showHudInView1:self.view hint:@"加载中..."];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    //uid运维人员id、task_id任务id、task_order故障任务订单号、utype职员/客户、remarks备注
//    
//    params[@"customer_id"] = _model.customer_id;
//    
//    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/equipment_only"];
//    
//    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [weakSelf hideHud];
//        
//        NSLog(@"responseObject = %@",responseObject);
//        NSDictionary *list = responseObject[@"uniqid_info"];
//        NSMutableArray *equipmentList = [NSMutableArray array];
//        if (list.count != 0) {
//            for (NSString *equipid in list) {
//                
//                [equipmentList addObject:equipid];
//            }
//            _choseTableview.dataArr = equipmentList;
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [weakSelf hideHud];
//        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
//        
//    }];
//    
//    
//}

-(void)setupbutton{
    
    _remarkView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenheight - 95, self.view.frame.size.width - 20, 50)];
    _remarkView.backgroundColor = [UIColor whiteColor];
    _remarkView.layer.borderWidth = 1.0f;
    _remarkView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[_remarkView layer] setCornerRadius:7.];
    [[_remarkView layer] setMasksToBounds:YES];
    [self.view addSubview:_remarkView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 60, 50)];
    label.text = @"备注:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [_remarkView addSubview:label];
    
        
    self.remarkTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, CGRectGetWidth(_remarkView.frame) - 60, 50)];
    _remarkTextField.placeholder = @"请输入备注信息";
    _remarkTextField.textAlignment = NSTextAlignmentLeft;
    _remarkTextField.borderStyle = UITextBorderStyleNone;
    _remarkTextField.font = [UIFont systemFontOfSize:15.f];
    _remarkTextField.delegate = self;
    //设置键盘的样式
    _remarkTextField.returnKeyType = UIReturnKeyDone;
    [_remarkView addSubview:_remarkTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenheight - 251, 2000, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xe2e2e2);
    [self.view addSubview:lineView];
    
//    UIView *equipView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenheight - 150, self.view.frame.size.width - 20, 50)];
//    equipView.backgroundColor = [UIColor whiteColor];
//    equipView.layer.borderWidth = 1.0f;
//    equipView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
//    [[equipView layer] setCornerRadius:7.];
//    [[equipView layer] setMasksToBounds:YES];
//    [self.view addSubview:equipView];
//    self.equipView = equipView;
    
//    UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 100, 50)];
//    label1.text = @"设备唯一码:";
//    label1.textAlignment = NSTextAlignmentLeft;
//    label1.textColor = [UIColor blackColor];
//    label1.font = [UIFont systemFontOfSize:15];
//    [equipView addSubview:label1];
//    
//    
//    self.modelfyTextField = [[XHMessageTextView alloc] initWithFrame:CGRectMake(100, 0, CGRectGetWidth(_remarkView.frame) - 100, 50)];
//    _modelfyTextField.placeHolder = @"选择设备唯一码";
//    _modelfyTextField.textAlignment = NSTextAlignmentLeft;
//    //_modelfyTextField.borderStyle = UITextBorderStyleNone;
//    _modelfyTextField.font = [UIFont systemFontOfSize:15.f];
//    _modelfyTextField.delegate = self;
//    _modelfyTextField.tag = 888;
//    [_modelfyTextField contentSizeToFit];
//    
//
//    _choseTableview = [[ChoseTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 260) ItemName:@"选择设备" DataArray:nil]; 
//    _choseTableview.choseDelegate = self;
//    _modelfyTextField.inputView = _choseTableview;
//    
//    [equipView addSubview:_modelfyTextField];
    
    UIButton* addImagebtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addImagebtn.frame = ZQ_RECT_CREATE(kScreenwidth - 100, kScreenheight - 230, 80, 45);
    [addImagebtn setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    addImagebtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    [addImagebtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [addImagebtn setTintColor:[UIColor whiteColor]];
    addImagebtn.layer.cornerRadius = 5;
    [addImagebtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    self.addImagebutton = addImagebtn;
    
    if (SCREEN_WIDTH < 375) {
        addImagebtn.frame = ZQ_RECT_CREATE(kScreenwidth - 70, kScreenheight - 230, 65, 45);
        addImagebtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    }
    
    [self.view addSubview:addImagebtn];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [button setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    [button setTitle:@"任务核销" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = button;
    [self.view addSubview:button];
}


-(void)getdata{
    __weak TaskVerificDetailVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //uid运维人员id、task_id任务id、task_order故障任务订单号、utype职员/客户、remarks备注
    
    params[@"task_id"] = _model.task_id;

    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/get_failure_info"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        
        NSDictionary *list = responseObject[@"listData"];
        //        _model = [[TaskModel alloc]init];
        [_model setKeyValues:list];
        
//        NSMutableString *selectedEquipids = [NSMutableString string];
//        for (NSString *equipid in _model.equipment_uniqid) {
//            [selectedEquipids appendFormat:@"%@,",equipid];
//        }
//        _modelfyTextField.text = selectedEquipids;
//        if (![ZQ_CommonTool isEmpty:selectedEquipids]) {
//            [_modelfyTextField contentSizeToFit];
//        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

-(void)buttonDidClick{
    
    __weak TaskVerificDetailVC *weakSelf = self;
    //[self showHudInView1:self.view hint:@"正在上传..."];
    
    if (_myHUD == nil) {
        _myHUD = [[MBProgressHUD alloc] init];
        _myHUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
        _myHUD.labelColor = [UIColor whiteColor];
        _myHUD.labelFont = [UIFont systemFontOfSize:13];
        [_myHUD show:YES];
        
    }
    
    [self.view addSubview:weakSelf.myHUD];
    _myHUD.labelText = [NSString stringWithFormat:@"当前上传的进度为0.1"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"remarks"] = _remarkTextField.text;
    params[@"uid"] = [USERDEFALUTS objectForKey:@"uid"];
    params[@"utype"] = [USERDEFALUTS objectForKey:@"utype"];
    params[@"task_id"] = _model.task_id;
    params[@"task_order"] = _model.task_order;
    //params[@"equipment_uniqid"] = _modelfyTextField.text;
    
    //index.php/api/api/accomplish_tasks
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/api/accomplish_tasks"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 200;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];

    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
            for (int i = 0; i < self.imageArray.count; i++) {
                NSLog(@"开始");
                //写入文件
                UIImage *image = self.imageArray[i];
                NSData *imagedata;
                
                imagedata = UIImageJPEGRepresentation(image, 0.5); //压缩图片，方便上传
                
                //imagedata = UIImageJPEGRepresentation(image, 0.1);
                //imagedata = UIImagePNGRepresentation(image); 
                NSLog(@"中间");
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                
                NSString *name = [NSString stringWithFormat:@"img%d",i+1];
                NSString *fileName = [NSString  stringWithFormat:@"%@%@.jpg", name,dateString];
                
                [formData appendPartWithFileData:imagedata name:name fileName:fileName mimeType:@"image/jpg"];
                
                //对应服务器端[file]格式,img1为参数名
                NSLog(@"结束");
            }
    
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
        weakSelf.myHUD.progress = uploadProgress.fractionCompleted;
       
        if (weakSelf.myHUD.progress == 1) {
            weakSelf.myHUD.labelText = @"上传完成";
            
        }else{
            weakSelf.myHUD.labelText = [NSString stringWithFormat:@"当前上传的进度为%.2f",uploadProgress.fractionCompleted];
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"```上传成功``` responseObject = %@",responseObject);
        [weakSelf.myHUD hide:YES];
        [weakSelf hideHud];
        [weakSelf showHint:responseObject[@"msg"]];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.myHUD hide:YES];
        NSLog(@"xxx上传失败xxx %@", error);
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
    

    
}

#pragma mark-tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"任务单号:%@",_model.failure_order];
    }else if (indexPath.row == 1){
        cell.textLabel.text = [NSString stringWithFormat:@"故障类型:%@",_model.fault_name];
    }else if (indexPath.row == 2){
        cell.textLabel.text = [NSString stringWithFormat:@"故障描述:%@",_model.failure_description];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 3){
        cell.textLabel.text = [NSString stringWithFormat:@"设备类型:%@",_model.equipment_name];

    }else if (indexPath.row == 4){
        cell.textLabel.text = [NSString stringWithFormat:@"设备唯一码:%@",_model.equipment_uniqid];
    }else if (indexPath.row == 5){
        cell.textLabel.text = [NSString stringWithFormat:@"提交时间:%@",_model.dt];
    }else if (indexPath.row == 6){
        cell.textLabel.text = [NSString stringWithFormat:@"任务处理跟踪表"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 7){
        cell.textLabel.text = [NSString stringWithFormat:@"客户名称:%@",_model.customer_name];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 8){
        cell.textLabel.text = [NSString stringWithFormat:@"联系人:%@",_model.customer_contacts];
    }else if (indexPath.row == 9){
        cell.textLabel.text = [NSString stringWithFormat:@"联系电话:%@",_model.customer_contacts_phone];
    }else if (indexPath.row == 10){
        cell.textLabel.text = [NSString stringWithFormat:@"通讯地址:%@",_model.customer_contacts_address];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 11){
        cell.textLabel.text = [NSString stringWithFormat:@"备注:%@",_model.remarks];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 12){
        cell.textLabel.text = [NSString stringWithFormat:@"更新时间:%@",_model.update];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TxetViewController *textView = [[TxetViewController alloc]init];
    if (indexPath.row == 6) {
        TaskfollowVC *taskFllowVC = [[TaskfollowVC alloc]init];
        taskFllowVC.model = _model;
        [self.navigationController pushViewController:taskFllowVC animated:YES];
    }else if (indexPath.row == 10) {
        textView.title = @"通讯地址";
        textView.text = _model.customer_contacts_address;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 11){
        textView.title = @"备注信息";
        textView.text = _model.remarks;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 2){
        textView.title = @"故障描述";
        textView.text = _model.failure_description;
        [self.navigationController pushViewController:textView animated:YES];
    }else if (indexPath.row == 7){
        CustomerInforViewController *customerInfoVC = [[CustomerInforViewController alloc]init];
        customerInfoVC.customer_id = _model.customer_id;
        [self.navigationController pushViewController:customerInfoVC animated:YES];
    }else if (indexPath.row == 9){
        //打电话 
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.customer_contacts_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_remarkTextField resignFirstResponder];
    return YES;
}


//-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    if ([ZQ_CommonTool isEmptyArray:_choseTableview.dataArr]) {
//        //[self getmodelfyData];
//        
//        NSMutableArray *equipidModels = [NSMutableArray array];
//        for (NSString *equipid in _model.equipment_uniqid_all) {
//            EquipidModel *equipidModel = [[EquipidModel alloc]init];
//            equipidModel.equipment_uniqid = equipid;
//            for (NSString *selectequipid in _model.equipment_uniqid) {
//                if ([selectequipid isEqualToString:equipidModel.equipment_uniqid]) {
//                    equipidModel.isselected = YES;
//                }
//            }
//            [equipidModels addObject:equipidModel];
//        }
//        
//        _choseTableview.dataArr = equipidModels;
//    }
//    
//    return YES;
//}

#pragma mark - 键盘输入事件处理
- (void)willShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    if (_remarkTextField.isFirstResponder) {
        self.remarkView.transform = CGAffineTransformMakeTranslation(0, -keyboardH + 45);
    }else if(_modelfyTextField.isFirstResponder){
        self.equipView.transform = CGAffineTransformMakeTranslation(0, -keyboardH + 100);
    }
    [UIView commitAnimations];
    
}

-(void)hideShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.remarkView.transform = CGAffineTransformIdentity;
    self.equipView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
} 

@end

//
//  UploadKnowlegeVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/20.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "UploadKnowlegeVC.h"
#import "XHMessageTextView.h"
#import "LHConst.h"
#import "Fault.h"
#import "LHGroupViewController.h"
#import "LHCollectionViewController.h"

@interface UploadKnowlegeVC ()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
  
@property (nonatomic, strong) NSMutableArray *faultList;

@property (nonatomic, strong) UITextField *faultNametextfield; 
@property (nonatomic, strong) UITextField *positionTextfield;//品牌
@property (nonatomic, strong) UITextField *customerNameTextfield;
@property (nonatomic, strong) UITextField *equipmentUniqueTextfield;
@property (nonatomic, strong) XHMessageTextView *remarksTextView;

@property (nonatomic, strong) UITextField *timeTextfield;


@property (nonatomic, strong) XHMessageTextView *describeTextView;
@property (nonatomic, strong) XHMessageTextView *selutionTextView;

@property (nonatomic, strong)UIPickerView *pickerView ;
@property (nonatomic,strong)NSString *selectedfault_id;
@property (nonatomic,strong)UIButton *bottomBtn;

@property (nonatomic,strong)NSString *equipid;

@property (nonatomic,strong) NSMutableArray *imageArray;//存放处理完的图片
@property (nonatomic,strong) UIScrollView *scrolView;//滚动视图
@property (nonatomic,strong) NSMutableArray *scrollSubViews;//存放图片子视图
@property (nonatomic,strong) NSMutableArray *scrollSubFrame;//子视图的frame
@property (nonatomic,strong) NSMutableArray *localLength;//每张图片的尺寸
@property (nonatomic,strong) MBProgressHUD *myHUD;

@property (nonatomic,strong) UIView *uidView;




@end

@implementation UploadKnowlegeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _faultList = [NSMutableArray array];

    self.imageArray = [NSMutableArray new];
    self.scrollSubViews = [NSMutableArray new];
    self.scrollSubFrame = [NSMutableArray new];
    
    [self setupPikerView];
    [self setupUI];
    [self setScrol];
    [self getdata];
    
    //KVO观察键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideShowKeyboard:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setupUI{
    //主视图
    UIView *uidView = [[UIView alloc] initWithFrame:CGRectMake(10,  SafeAreaTopHeight+5, self.view.frame.size.width - 20, 415)];
    uidView.backgroundColor = [UIColor whiteColor];
    uidView.layer.borderWidth = 1.0f;
    uidView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[uidView layer] setMasksToBounds:YES];
    self.uidView = uidView;
    [self.view addSubview:uidView];
    
    //日期
    UILabel *timelabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, 80, 40)];
    timelabel.text = @"日       期:";
    timelabel.textAlignment = NSTextAlignmentLeft;
    timelabel.textColor = [UIColor blackColor];
    timelabel.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:timelabel];
    
    self.timeTextfield = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, CGRectGetWidth(uidView.frame) - 90, 40)];
    _timeTextfield.userInteractionEnabled = NO;
    _timeTextfield.textAlignment = NSTextAlignmentLeft;
    _timeTextfield.borderStyle = UITextBorderStyleNone;
    _timeTextfield.font = [UIFont systemFontOfSize:15.f];
    _timeTextfield.tag = 1000;
    _timeTextfield.delegate = self;
    _timeTextfield.enabled = NO;
    //设置键盘的样式
    _customerNameTextfield.keyboardType = UIKeyboardTypeDefault;
    [uidView addSubview:_timeTextfield];
    NSDate *now = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    _timeTextfield.text  = [formatter stringFromDate:now];
    
    //客户名称   
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 40, 80, 40)];
    label.text = @"客户名称:";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label];
    
    self.customerNameTextfield = [[UITextField alloc] initWithFrame:CGRectMake(90, 40, CGRectGetWidth(uidView.frame) - 90, 40)];
    _customerNameTextfield.enabled = NO;
    _customerNameTextfield.textAlignment = NSTextAlignmentLeft;
    _customerNameTextfield.borderStyle = UITextBorderStyleNone;
    _customerNameTextfield.font = [UIFont systemFontOfSize:15.f];
    _customerNameTextfield.text = _headerData[@"enterprise_name"];
    _customerNameTextfield.tag = 1001;
    _customerNameTextfield.delegate = self;
    //设置键盘的样式
    _customerNameTextfield.keyboardType = UIKeyboardTypeDefault;
    [uidView addSubview:_customerNameTextfield];
    
    //设备唯一码    
    UILabel *lael3 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 80, 80, 40)];
    lael3.text = @"设备名称:";
    lael3.textAlignment = NSTextAlignmentLeft;
    lael3.textColor = [UIColor blackColor];
    lael3.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:lael3];
    
    self.equipmentUniqueTextfield = [[UITextField alloc] initWithFrame:CGRectMake(90, 80, CGRectGetWidth(uidView.frame) - 90, 40)];
    _equipmentUniqueTextfield.enabled = NO;
    _equipmentUniqueTextfield.textAlignment = NSTextAlignmentLeft;
    _equipmentUniqueTextfield.borderStyle = UITextBorderStyleNone;
    _equipmentUniqueTextfield.font = [UIFont systemFontOfSize:15.f];
    _equipmentUniqueTextfield.placeholder = @"设备名称";
    _equipmentUniqueTextfield.text = _headerData[@"equipment_name"];
    _equipmentUniqueTextfield.tag = 1002;
    _equipmentUniqueTextfield.delegate = self;
    [uidView addSubview:_equipmentUniqueTextfield];
    
    
    //品牌名称   
    UILabel *lael2 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 120, 80, 40)];
    lael2.text = @"品牌名称:";
    lael2.textAlignment = NSTextAlignmentLeft;
    lael2.textColor = [UIColor blackColor];
    lael2.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:lael2];
    
    self.positionTextfield = [[UITextField alloc] initWithFrame:CGRectMake(90, 120, CGRectGetWidth(uidView.frame) - 90, 40)];
    _positionTextfield.placeholder = @"品牌名称";
    _positionTextfield.text = _headerData[@"brands_name"];
    _positionTextfield.enabled = NO;
    _positionTextfield.font = [UIFont systemFontOfSize:15.f];
    _positionTextfield.delegate = self;
    _positionTextfield.tag = 1003;
    _positionTextfield.inputView = _pickerView;
    [uidView addSubview:_positionTextfield];
    
    //线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 159, 2000, 1)];
    lineView.backgroundColor = kUIColorFromRGB(0xe2e2e2);
    [uidView addSubview:lineView];
    
    //故障类型    
    UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 160, 80, 40)];
    label1.text = @"故障类型:";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label1];
    
    
    self.faultNametextfield = [[UITextField alloc] initWithFrame:CGRectMake(90, 160, CGRectGetWidth(uidView.frame) - 90, 40)];
    _faultNametextfield.placeholder = @"请选择故障类型";
    _faultNametextfield.font = [UIFont systemFontOfSize:15.f];
    _faultNametextfield.delegate = self;
    self.faultNametextfield.tag = 1004;
    self.faultNametextfield.inputView = _pickerView;
    [uidView addSubview:_faultNametextfield];
    
    
    //故障描述    
    UILabel *label5 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 200, 80, 30)];
    label5.text = @"故障描述:";
    label5.textAlignment = NSTextAlignmentLeft;
    label5.textColor = [UIColor blackColor];
    label5.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label5];
    
    self.describeTextView = [[XHMessageTextView alloc]initWithFrame:CGRectMake(10, 230, kScreenwidth - 40, 40)];
    _describeTextView.font = [UIFont systemFontOfSize:15];
    _describeTextView.layer.borderWidth = 1;
    _describeTextView.layer.borderColor = [UIColor orangeColor].CGColor;
    _describeTextView.placeHolder = @"请填写故障描述";
    _describeTextView.tag = 1005;
    _describeTextView.delegate = self;
    [uidView addSubview:_describeTextView];
    
    
    //故障描述    
    UILabel *selutionlabel = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 270, 80, 30)];
    selutionlabel.text = @"解决方案:";
    selutionlabel.textAlignment = NSTextAlignmentLeft;
    selutionlabel.textColor = [UIColor blackColor];
    selutionlabel.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:selutionlabel];
    
    
    self.selutionTextView = [[XHMessageTextView alloc]initWithFrame:CGRectMake(10, 300, kScreenwidth - 40, 40)];
    _selutionTextView.font = [UIFont systemFontOfSize:15];
    _selutionTextView.layer.borderWidth = 1;
    _selutionTextView.layer.borderColor = [UIColor orangeColor].CGColor;
    _selutionTextView.placeHolder = @"请填写解决方案";
    _selutionTextView.tag = 1006;
    _selutionTextView.delegate = self;
    [uidView addSubview:_selutionTextView];
    
    //备注信息
    UILabel *lael6 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 340, 80, 30)];
    lael6.text = @"备注信息:";
    lael6.textAlignment = NSTextAlignmentLeft;
    lael6.textColor = [UIColor blackColor];
    lael6.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:lael6];
    
    //密码TextField
    self.remarksTextView = [[XHMessageTextView alloc] initWithFrame:CGRectMake(10, 370, kScreenwidth - 40, 40)];
    _remarksTextView.placeHolder = @"请填写备注信息";
    _remarksTextView.textAlignment = NSTextAlignmentLeft;
    _remarksTextView.keyboardType = UIKeyboardTypeDefault;
    _remarksTextView.layer.borderWidth = 1;
    _remarksTextView.layer.borderColor = [UIColor orangeColor].CGColor;
    _remarksTextView.font = [UIFont systemFontOfSize:15.f];
    _remarksTextView.delegate = self;
    [uidView addSubview:_remarksTextView];
    self.remarksTextView.tag = 1007;
    
    UIButton* addImagebtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addImagebtn.frame = ZQ_RECT_CREATE(kScreenwidth - 100, CGRectGetMaxY(uidView.frame) + 17, 80, 45);
    
    [addImagebtn setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    addImagebtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    [addImagebtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [addImagebtn setTintColor:[UIColor whiteColor]];
    addImagebtn.layer.cornerRadius = 5;
    [addImagebtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    
    if (SCREEN_WIDTH < 375) {
        addImagebtn.frame = ZQ_RECT_CREATE(kScreenwidth - 70, CGRectGetMaxY(uidView.frame) + 17, 65, 45);
        addImagebtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    }
    
    
    [self.view addSubview:addImagebtn];
    
    
    // 添加键盘上方的子视图  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  
    button.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 40.0);  
    button.backgroundColor = [UIColor greenColor];  
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];  
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];  
    [button setTitle:@"确定" forState:UIControlStateNormal];  
    [button addTarget:self action:@selector(hiddenKeyboard:) forControlEvents:UIControlEventTouchUpInside];  
    self.faultNametextfield.inputAccessoryView = button; 
    _positionTextfield.inputAccessoryView = button;
    
    UIButton *surebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    surebutton.frame = ZQ_RECT_CREATE(0, kScreenheight - 45, kScreenwidth, 45);
    [surebutton setBackgroundColor:kUIColorFromRGB(0xfb7caf)];
    surebutton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    [surebutton setTitle:@"确定报修" forState:UIControlStateNormal];
    [surebutton setTintColor:[UIColor whiteColor]];
    [surebutton addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtn = surebutton;
    [self.view addSubview:surebutton];
}

-(void)getdata{
    __weak UploadKnowlegeVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"customer_id"] = [USERDEFALUTS objectForKey:@"uid"];
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/knowledge_list"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        NSArray *faultlist = responseObject[@"faultData"];
        if (faultlist.count == 0) {
        }else{
            for (NSDictionary *dic in faultlist) {
                Fault *model = [[Fault alloc]init];
                [model setKeyValues:dic];
                [_faultList addObject:model];
            }
            
        }
        [_pickerView reloadAllComponents];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
}

#pragma mark -传照片相关
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
    scrol.frame = CGRectMake(10, CGRectGetMaxY(_uidView.frame), SCREEN_WIDTH - 120, 77*(SCREEN_HEIGHT/568));
    if (SCREEN_WIDTH < 375) {
        scrol.frame = CGRectMake(10, CGRectGetMaxY(_uidView.frame), SCREEN_WIDTH - 74, 77*(SCREEN_HEIGHT/568));
    }
    //ZQ_RECT_CREATE(kScreenwidth - 100, CGRectGetMaxY(uidView.frame), 80, 45);
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
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

#pragma mark --
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    __block UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    __weak UploadKnowlegeVC *weakSelf = self;
    void(^imageBlock)() = ^(UIImage *image){
        __strong UploadKnowlegeVC *strongSelf = weakSelf;
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        image = [self makeThumbnailFromImage:image scale:0.4];
        
        NSString *length  = [NSString stringWithFormat:@"%f*%f",image.size.width,image.size.height];
        [strongSelf.localLength addObject:length];
        
        
        [strongSelf.imageArray addObject:image];
    };
    void(^dismissBlock)() = ^(){//声明
        __strong UploadKnowlegeVC *strongSelf = weakSelf;
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
    __weak UploadKnowlegeVC *weakSelf = self;
    group.backImageArray = ^(NSMutableArray<PHAsset *> *array){
        __strong UploadKnowlegeVC *strongSelf = weakSelf;
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
-(void)buttonDidClick{
    
    __weak UploadKnowlegeVC *weakSelf = self;
    
    if ( [ZQ_CommonTool isEmpty:_describeTextView.text]) {
        
        [WCAlertView showAlertWithTitle:@"提示" message:@"故障描述不能为空" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }else if([ZQ_CommonTool isEmpty:_faultNametextfield.text]){
        [WCAlertView showAlertWithTitle:@"提示" message:@"故障类型不能为空" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    
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
    params[@"customer_id"] = _headerData[@"customer_id"];
    params[@"equipment_id"] = _headerData[@"equipment_id"];
    params[@"failure_description"] = _describeTextView.text;
    params[@"fault_id"] = _selectedfault_id;
    params[@"remarks"] = _remarksTextView.text;
    params[@"solutions"] = _selutionTextView.text;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/knowledge"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        for (int i = 0; i < self.imageArray.count; i++) {
            //NSLog(@"开始");
            //写入文件
            UIImage *image = self.imageArray[i];
            NSData *imagedata;
            
            imagedata = UIImageJPEGRepresentation(image, 0.5); //压缩图片，方便上传
            
            //NSLog(@"中间");
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            
            NSString *name = [NSString stringWithFormat:@"img%d",i+1];
            NSString *fileName = [NSString  stringWithFormat:@"%@%@.jpg", name,dateString];
            
            [formData appendPartWithFileData:imagedata name:name fileName:fileName mimeType:@"image/jpg"];
            
            //对应服务器端[file]格式,img1为参数名
            //NSLog(@"结束");
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
        if ([responseObject[@"code"] integerValue] == 1) {
            //[weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.myHUD hide:YES];
        NSLog(@"xxx上传失败xxx %@", error);
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
    }];
}


// 隐藏键盘  
- (void)hiddenKeyboard:(UIButton *)button  
{  
    if ([ZQ_CommonTool isEmpty:_faultNametextfield.text]) {
        Fault *model = _faultList[0];
        self.selectedfault_id = model.fault_id;
        self.faultNametextfield.text = model.fault_name;

    }
    [self.view endEditing:YES];  
} 
#pragma mark -pickerView
-(void)setupPikerView{
    _pickerView = [[UIPickerView alloc] init];  
    
    _pickerView.backgroundColor = [UIColor orangeColor];  
    NSLog(@"pickerView %@", _pickerView);
    
    _pickerView.delegate = self;  
    _pickerView.dataSource = self;  
    
}
// UIPickerViewDelegate  
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{  
    // 设置列的宽度  
    return 200.0;  
}  

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{  
    // 设置列中的每行的高度  
    return 40.0;  
}  

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component  
{  
    // 设置列中的每行的显示标题NSString  
    if (0 == component)  
    {  
       
        Fault *model = _faultList[row];
        NSString *title = model.fault_name;
        return title;
        
    }  
    
    return nil;  
}  



- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  
{  
    NSLog(@"component = %ld, row = %ld", component, row);  
    if (0 == component) {

        Fault *model = _faultList[row];
        self.selectedfault_id = model.fault_id;
        self.faultNametextfield.text = model.fault_name; 
        
    }  
} 

// UIPickerViewDataSource    
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView  
{  
    // 设置列数  
    return 1;  
}  

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component  
{  
    // 设置每列的行数  
    return _faultList.count;
}  

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; 
}
#pragma mark - 键盘输入事件处理
- (void)willShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    CGRect keyboardRect = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardRect.size.height;
    
    if (-keyboardH + kScreenheight - CGRectGetMaxY(_uidView.frame) < 0) {
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardH + kScreenheight - CGRectGetMaxY(_uidView.frame));
    }
    
    [UIView commitAnimations];
}


-(void)hideShowKeyboard:(NSNotification *)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.view.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
} 

@end

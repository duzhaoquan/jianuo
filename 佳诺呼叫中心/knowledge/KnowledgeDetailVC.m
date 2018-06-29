//
//  KnowledgeDetailVC.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/2/23.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "KnowledgeDetailVC.h"
#import "KnowledgeModel.h"
#import "WXPhotoBrowser.h"

#import "UIImageView+WebCache.h"
@interface KnowledgeDetailVC ()<PhotoBrowerDelegate>
@property (nonatomic,assign)float safeArea;

@property (nonatomic,strong)UIView *completeView;

@property (nonatomic,strong)NSMutableArray *iamgeViewArray;
@property (nonatomic,strong)NSMutableArray *iamgeArray;

@property (nonatomic,strong)UIScrollView *scrollView;

@end

@implementation KnowledgeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"知识库详情";
    self.view.backgroundColor = [UIColor whiteColor];
    _safeArea = 64;
    if (kScreenheight > 568) {
        _safeArea = 104;
    }
    if (kScreenheight == 812) {
        _safeArea += 24;
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kScreenwidth, kScreenheight);
    _iamgeArray = [NSMutableArray array];
    _iamgeViewArray = [NSMutableArray array];
    [self getdata];
    
}
-(void)getdata{
    __weak KnowledgeDetailVC *weakSelf = self;
    [self showHudInView1:self.view hint:@"加载中..."];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"know_id"] = _model.know_id;
    
    NSString *URL = [NSString stringWithFormat:@"%@%@",kHost,@"index.php/api/Inspect/knowledge_detail"];
    
    [manager POST:URL parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf hideHud];
        
        NSLog(@"responseObject = %@",responseObject);
        NSDictionary *list = responseObject[@"listData"];
        
        [_model setKeyValues:list];
        [self setupUI];
        NSString *img1 = list[@"img1"];
        //NSString *img1 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1519449488681&di=68f78b5265cae567d49b267f1938c32b&imgtype=0&src=http%3A%2F%2Fimg1c.xgo-img.com.cn%2Fpics%2F1563%2F1562268.jpg";
        if (![ZQ_CommonTool isEmpty:img1]) {
            [_iamgeArray addObject:img1];
        }
        NSString *img2 = list[@"img2"];
        //NSString *img2 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1519449488681&di=b765555be20f296e8b60b471656a905a&imgtype=0&src=http%3A%2F%2Fimg.xgo-img.com.cn%2Fpics%2F1643%2F1642420.jpg";
        if (![ZQ_CommonTool isEmpty:img2]) {
            [_iamgeArray addObject:img2];
        }
        NSString *img3 = list[@"img3"];
        //NSString *img3 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1519449488680&di=f76d8849562f7288bbe85c71f81167fe&imgtype=0&src=http%3A%2F%2Fimg.xgo-img.com.cn%2Fpics%2F1538%2F1537620.jpg";
        if (![ZQ_CommonTool isEmpty:img3]) {
            [_iamgeArray addObject:img3];
        }
        [weakSelf configurationimg];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf hideHud];
        [weakSelf showHint:@"网络状况较差，加载失败，建议刷新试试"];
        
    }];
    
    
}
-(void)setupUI{
    //
    UIView *uidView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.view.frame.size.width - 20, 120)];
    uidView.backgroundColor = [UIColor whiteColor];
    uidView.layer.borderWidth = 1.0f;
    uidView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    //[[uidView layer] setCornerRadius:7.];
    uidView.userInteractionEnabled = YES;
    [[uidView layer] setMasksToBounds:YES];
    [self.scrollView addSubview:uidView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, kScreenwidth - 30, 30)];
    label.text = [NSString stringWithFormat:@"客户名称: %@",_model.customer_name];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label];
    
    //
    UILabel *label4 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 30, kScreenwidth - 30, 30)];
    label4.text = [NSString stringWithFormat:@"品      牌: %@",_model.brands_name];;
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = [UIColor blackColor];
    label4.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label4];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 60, kScreenwidth - 30, 30)];
    label1.text = [NSString stringWithFormat:@"故障名称: %@",_model.fault_name];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 90, kScreenwidth - 30, 30)];
    label2.text = [NSString stringWithFormat:@"上报时间: %@",_model.dt]; 
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = [UIColor blackColor];
    label2.font = [UIFont systemFontOfSize:15];
    [uidView addSubview:label2];
    

    _completeView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(uidView.frame), self.view.frame.size.width - 20, 180)];
    _completeView.backgroundColor = [UIColor whiteColor];
    _completeView.layer.borderWidth = 1.0f;
    _completeView.layer.borderColor = kUIColorFromRGB(0xe9e9e9).CGColor;
    [[_completeView layer] setMasksToBounds:YES];
    [self.scrollView addSubview:_completeView];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, 0, kScreenwidth - 40, 30)];
    label3.text = [NSString stringWithFormat:@"故障描述: %@",_model.failure_description];
    CGSize label3Size = [label3.text sizeWithFont:[UIFont systemFontOfSize:15] maxWidth:kScreenwidth - 40];
    label3.frame = ZQ_RECT_CREATE(10, 0, kScreenwidth - 40, label3Size.height+10);
    label3.textAlignment = NSTextAlignmentLeft;
    label3.numberOfLines = 0;
    label3.textColor = [UIColor blackColor];
    label3.font = [UIFont systemFontOfSize:15];
    [_completeView addSubview:label3];
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:ZQ_RECT_CREATE(10, CGRectGetMaxY(label3.frame)+5, kScreenwidth - 40, 60)];
    label5.text = [NSString stringWithFormat:@"维修备注:%@",_model.remarks];
    CGSize label5Size = [label5.text sizeWithFont:[UIFont systemFontOfSize:15] maxWidth:kScreenwidth - 40];
    label5.frame = ZQ_RECT_CREATE(10, CGRectGetMaxY(label3.frame)+5, kScreenwidth - 40, label5Size.height+10);
    label5.textAlignment = NSTextAlignmentLeft;
    label5.numberOfLines = 0;
    label5.textColor = [UIColor blackColor];
    label5.font = [UIFont systemFontOfSize:15];
    [_completeView addSubview:label5];
    
    UILabel *label10 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(label5.frame)+5, 100, 25)];
    label10.text = @"维修图片:";
    label10.font = [UIFont systemFontOfSize:17];
    [_completeView addSubview:label10];
    //kuang
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(2, CGRectGetMaxY(label10.frame)+5, 322, 102)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1.0f;
    view.tag = 1111;
    view.layer.borderColor = [UIColor orangeColor].CGColor;
    
    if (kScreenwidth < 375) {
        view.frame = CGRectMake(2, CGRectGetMaxY(label10.frame)+5, 263, 82);
    }
    
    [_completeView addSubview:view];
    
    _completeView.frame = CGRectMake(10, CGRectGetMaxY(uidView.frame), self.view.frame.size.width - 20,label5Size.height+15 + label3Size.height+15 + 30 + 120 );

    if (CGRectGetHeight(_completeView.frame)+120 > kScreenheight) {
        _scrollView.contentSize = CGSizeMake(kScreenwidth, CGRectGetHeight(_completeView.frame)+120);
    }
    
}

-(void)configurationimg{
    for (int i = 0;i< _iamgeArray.count;i++) {
        NSString*img =  _iamgeArray[i];
        UIView *view = [_completeView viewWithTag:1111];
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(3 + i*110, CGRectGetMinY(view.frame)+1, 100, 100)];
        if (kScreenwidth < 375) {
            imageView1.frame = CGRectMake(3+i*90, CGRectGetMinY(view.frame)+1, 80, 80);
        }
        imageView1.userInteractionEnabled = YES;
        imageView1.tag = 1000+i;
        [imageView1 sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imageView1 addGestureRecognizer:tap];
        [_completeView addSubview:imageView1];
        
        [_iamgeViewArray addObject:imageView1];
    }
    
}
-(void)tapAction:(UITapGestureRecognizer*)tap{
   
    [WXPhotoBrowser showImageInView:self.view.window selectImageIndex:tap.view.tag - 1000 delegate:self];
    
}


#pragma mark - photoBrower delegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    
    return _iamgeViewArray.count;
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    WXPhoto *photo = [[WXPhoto alloc]init];
    
    photo.srcImageView = _iamgeViewArray[index];
    
    photo.url = [NSURL URLWithString:_iamgeArray[index]];
    
    return photo;
}

@end

//
//  LoopView.m
//  60_Homework00
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 Crystal. All rights reserved.
//

#import "LoopView.h"
#import "UIImageView+WebCache.h"
#define SelfHight self.bounds.size.height
#define SelfWidht self.bounds.size.width



@interface LoopView (){
    UIScrollView *_scrolview;
    UIPageControl *_pageControl;
    NSTimer *_tomer;
    float realScale;
    float scale;
    
}

@end

@implementation LoopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self creatView];
        scale = 1;
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _scrolview.frame = CGRectMake(0, 0, SelfWidht, SelfHight);
    _pageControl.frame = CGRectMake(0, SelfHight - 49, SelfWidht, 49);
    for (UIView *subView in _scrolview.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i = 0; i < _arr.count; i++) {
        //把imageView按照顺序添加到滑动视图上;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * SelfWidht, 0, SelfWidht , SelfHight)];
        //        imageV.image = [UIImage imageNamed:_arr[i]];
        imageV.userInteractionEnabled = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [imageV sd_setImageWithURL:_arr[i]];
        
        [_scrolview addSubview:imageV];
    }
}
- (void)creatView{
    //创建滑动视图;
    _scrolview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SelfWidht, SelfHight)];
    
    //设置内容尺寸;
    _scrolview.pagingEnabled = YES;//分页效果;
    _scrolview.backgroundColor = [UIColor whiteColor];
    _scrolview.delegate = self;
    //程序运行的时候显示数组里面的第二个元素;
    _scrolview.contentOffset = CGPointMake(SelfWidht, 0);
    _scrolview.showsHorizontalScrollIndicator = NO;
 
    _scrolview.bounces = NO;
    [self addSubview:_scrolview];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SelfHight - 49, SelfWidht, 49)];
    _pageControl.numberOfPages = _arr.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    _pageControl.backgroundColor = [UIColor clearColor];
    [self addSubview:_pageControl];
    
    
//    _scrolview.minimumZoomScale = 0.5;
//    _scrolview.maximumZoomScale = 10;
    
    
    
}
- (void)setArr:(NSArray *)arr{
    NSMutableArray *muarr = [NSMutableArray arrayWithArray:arr];
    if (arr.count > 0) {
        [muarr addObject:[arr firstObject]];
    }
    
    if (arr.count >= 2) {
        [muarr insertObject:arr[arr.count-2] atIndex:0];
    }
    
    _arr = muarr;
    
    for (UIView *view in _scrolview.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < _arr.count; i++) {
        //把imageView按照顺序添加到滑动视图上;
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * SelfWidht, 0, SelfWidht , SelfHight)];
//        imageV.image = [UIImage imageNamed:_arr[i]];
        imageV.userInteractionEnabled = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.tag  = 500 +i;
//        // 缩放手势  
//        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];  
//        [imageV addGestureRecognizer:pinchGestureRecognizer];
        
        NSString *imgStr = _arr[i];
        //NSString *imgUTF8String = [imgStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageV sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"头像.jpg"] options:SDWebImageRetryFailed];

        [_scrolview addSubview:imageV];
    }
    _scrolview.contentSize = CGSizeMake(_arr.count * SelfWidht, SelfHight);
    _scrolview.bounces = NO;
    _pageControl.numberOfPages = _arr.count - 2;
    _pageControl.currentPage = 0;
}
#pragma make  - 代理方法;

//当滑动完全停止的时候会调用这个代理方法;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //i 是当方法调用的时候滑动到数组的第几张;
    NSInteger i =  scrollView.contentOffset.x / SelfWidht;
    
    _pageControl.currentPage = i - 1;
    //只要满足了现在所处于张数:第一张或者最后一张;让他滑动一下滑动到对应的地方;
    if (i == 0) {
        //滑动到  4.jpeg;
        [scrollView setContentOffset:CGPointMake((_arr.count - 2) * SelfWidht, 0)];
        
        //这个方法能显示某个区域(可以试着用一下)
        _pageControl.currentPage = _arr.count - 3;

    }else if(i == _arr.count - 1){
        //满足条件滑动到数组里面的第二张
        [scrollView setContentOffset:CGPointMake(1 * SelfWidht , 0)];
        _pageControl.currentPage = 0;
    }
    
    
    scale = 1;realScale = 1;

    
    
}

// 处理缩放手势  
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer  
{  
    UIView *view = pinchGestureRecognizer.view;  
 
    realScale = scale + (pinchGestureRecognizer.scale - 1);//当前的放大倍数是上次的放大倍数加上当前手势pinch程度
    
    if (realScale > 10) {//设置最大放大倍数
        realScale = 10;
    }else if (realScale < 0.5){//最小放大倍数
        realScale = 0.5;
    }
    
    view.transform = CGAffineTransformMakeScale(realScale, realScale);
    
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded){//当结束捏合手势时记录当前图片放大倍数
        
        scale = realScale;
        
    }
    
    
    
}  

@end

//
//  Header.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/12.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define kScreenheight [UIScreen mainScreen].bounds.size.height
#define kScreenwidth [UIScreen mainScreen].bounds.size.width

// 通过色值去设置颜色 例如: kUIColorFromRGB(0xf9f9f9)
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ZQ_RECT_CREATE(x,y,w,h) CGRectMake(x,y,w,h)
//本地存储
#define USERDEFALUTS  [NSUserDefaults standardUserDefaults]

//frame
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)]?CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen]currentMode].size):NO)

#define SafeAreaTopHeight (kScreenheight == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (kScreenheight == 812.0 ? 34 : 0)

#import "AFNetworking.h"
#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+KN.h"
#import "MBProgressHUD+MJ.h"
#import "ZQ_UIAlertView.h"
#import "ZQ_CommonTool.h"
#import "MJExtension.h"
#import "WCAlertView.h"
#import "ZQ_CommonTool.h"
#import "NSString+HFExtension.h"


//#define kHost  @"http://118.190.156.153:8085/"  //外网
#define kHost @"http://192.168.12.230:90/"//内网

#endif /* Header_h */

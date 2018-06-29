//
//  UIViewController+ViewControllerPop.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/11/15.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackButtonHandlerProtocol <NSObject>

@optional

-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (ViewControllerPop) <BackButtonHandlerProtocol>

@end

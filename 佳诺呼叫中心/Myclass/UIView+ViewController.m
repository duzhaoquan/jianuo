//
//  UIView+ViewController.m
//  UITouch_Task04
//
//  Created by mR yang on 16/5/3.
//  Copyright © 2016年 mR yang. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)


-(UIViewController *)viewController{
  
  UIResponder *responder = self.nextResponder;
  
  while (responder!=nil) {
    
    if ([responder isKindOfClass:[UIViewController class]]) {
      
      return (UIViewController*)responder;
    }
    
    responder=responder.nextResponder;
    
  }
  
  return nil;
}

@end

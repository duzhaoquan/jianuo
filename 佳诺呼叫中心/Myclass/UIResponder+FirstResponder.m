//
//  UIResponder+FirstResponder.m
//  佳诺呼叫中心
//
//  Created by jp123 on 2018/3/7.
//  Copyright © 2018年 jianuohb. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+ (id)currentFirstResponder {  
    currentFirstResponder = nil;  
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];  
    return currentFirstResponder;  
}  

- (void)findFirstResponder:(id)sender {  
    currentFirstResponder = self;  
}  

@end

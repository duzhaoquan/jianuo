//
//  MessageModel.h
//  佳诺呼叫中心
//
//  Created by jp123 on 2017/10/26.
//  Copyright © 2017年 jianuohb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AspModel.h"

@interface MessageModel : NSObject

/*
 "_j_business" = 1;
 "_j_msgid" = 2162716524;
 "_j_uid" = 6149756464;
 aps =     {
 alert = wefwefewf;
 badge = 1;
 sound = sound;
 };
 order = 20154789;
 
 */


@property (nonatomic,strong)NSString *_j_business;
@property (nonatomic,strong)NSString *_j_msgid;
@property (nonatomic,strong)NSString *_j_uid;

@property (nonatomic,strong)AspModel *aps;

@property (nonatomic,strong)NSString *order;



@end

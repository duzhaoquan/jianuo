//
//  NSString+HFExtension.h
//  ResaleTreasure
//
//  Created by joyman04 on 16/1/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HFExtension)

-(BOOL)isChinese;

-(NSDate*)toDate;

+(NSString*)getDateFromTimeStamp:(NSString*)timeStamp;

+(NSString*)stringWithDate:(NSDate*)date;

+(NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)format;

-(CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

-(NSString*)monthAndDayFromTimeStamp;

-(NSString*)weekStrFromTimeStamp;

+ (NSString*)compareTwoTime:(long)time1 time2:(long)time2;

//去除重复的字符
-(NSString*)removeDuplicateCharater;
//将字符串中的表情(如 [兔子])换成表情图片
+(NSString *)faceStringWithWeiboText:(NSString *)weiboText;
//将表情图片转码
+(NSString*)replacementText:(NSString *)text WithUTFx:(NSInteger)UTFx;
//判断字符串中是否包含表情图片
+ (BOOL)stringContainsEmoji:(NSString *)string;

//去除字符串中的图像
-(NSString *)converStrEmoji;
//除字符串中的图像转为UTF8
-(NSString *)converStrEmojiToUTFx:(NSInteger)UTFx;

@end

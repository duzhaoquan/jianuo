//
//  NSString+HFExtension.m
//  ResaleTreasure
//
//  Created by joyman04 on 16/1/29.
//  Copyright © 2016年 HF. All rights reserved.
//

#import "NSString+HFExtension.h"
#import "RegexKitLite.h"
#define MAXFLOAT    0x1.fffffep+127f
#define MULITTHREEBYTEUTF16TOUNICODE(x,y) (((((x ^ 0xD800) << 2) | ((y ^ 0xDC00) >> 8)) << 8) | ((y ^ 0xDC00) & 0xFF)) + 0x10000

@implementation NSString (HFExtension)

-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

-(NSDate*)toDate{
    return [NSDate dateWithTimeIntervalSince1970:[self floatValue]];
}

+(NSString*)getDateFromTimeStamp:(NSString*)timeStamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStamp floatValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+(NSString*)stringWithDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

+(NSString*)stringWithDate:(NSDate*)date withFormat:(NSString*)format{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *confromTimespStr = [formatter stringFromDate:date];
    return confromTimespStr;
}

-(NSString*)weekStrFromTimeStamp{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now;
    NSDateComponents *comps;
    NSInteger unitFlags =NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit |NSMinuteCalendarUnit | NSSecondCalendarUnit;
    now = [NSDate dateWithTimeIntervalSince1970:[self floatValue]];;
    comps = [calendar components:unitFlags fromDate:now];
    
    //    NSLog(@"-----------weekday is %d",[comps weekday]);
    NSString* weekStr;
    switch ([comps weekday]) {
        case 1:weekStr = @"日"; break;
        case 2:weekStr = @"一"; break;
        case 3:weekStr = @"二"; break;
        case 4:weekStr = @"三"; break;
        case 5:weekStr = @"四"; break;
        case 6:weekStr = @"五"; break;
        case 7:weekStr = @"六"; break;
        default:weekStr = @"";  break;
    }
    return [NSString stringWithFormat:@"星期%@",weekStr];
}

-(NSString*)monthAndDayFromTimeStamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM/dd"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[self floatValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
/**
 72  *  计算文本的宽高
 75  *  @param font    文本显示的字体
 78  *  @return 文本占用的真实宽高
 79  */
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth{
    
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize maxSize = CGSizeMake(maxWidth, MAXFLOAT);
    if (self) {
        CGSize size =  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        if (size.width == 0 && size.height == 0) {
            return maxSize;
        }
        return size;
    }else{
        return CGSizeZero;
    }
}

+ (NSString*)compareTwoTime:(long)time1 time2:(long)time2

{
    
    NSTimeInterval balance = time2 - time1;
    
    NSString*timeString;
    
    timeString = [NSString stringWithFormat:@"%f",balance /60];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    NSInteger timeInt = [timeString intValue];
    
    NSInteger hour = timeInt /60;
    
    NSInteger mint = timeInt %60;
    
    if(hour ==0) {
        
        timeString = [NSString stringWithFormat:@"%ld分钟",(long)mint];
        
    }
    
    else
        
    {
        
        if(mint ==0) {
            
            timeString = [NSString stringWithFormat:@"%ld小时",(long)hour];
            
        }
        
        else
            
        {
            
            timeString = [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hour,(long)mint];
            
        }
        
    }
    
    return timeString;
    
}

//去除重复的字符
-(NSString*)removeDuplicateCharater{
    NSMutableString *valueStr = [NSMutableString string];
    
    for (int i=0; i<self.length; i++) {
        NSString *charStr = [self substringWithRange:NSMakeRange(i,1)];
        if (![valueStr containsString:charStr]) {
            [valueStr appendString:charStr];
        }
    }
    return valueStr;
}

//将字符串中的表情(如 [兔子])换成表情图片
+(NSString *)faceStringWithWeiboText:(NSString *)weiboText{
    
    //  chs [兔子]  [神马]  [哈哈]  <image url '001.png'>
    //  png 001.png  002.png
    //  1.查出表情字符
    NSString *regStr=@"\\[\\w+\\]";
    
    //  根据正则表达式取出[兔子]  [神马]  [哈哈]
    NSArray *faceStrs =  [weiboText componentsMatchedByRegex:regStr];
    
    if (!faceStrs.count) {
        return weiboText;
    }
    
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    
    //  读取plist文件
    NSArray *faceArr=[NSArray arrayWithContentsOfFile:plistPath];
    
    NSString *fullStr=nil;
    //  [兔子]
    for (NSString *faceString in faceStrs) {
        
        //    谓词
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"chs = %@",faceString];
        
        //    根据谓词从数组中过滤元素
        NSArray *dicArr = [faceArr filteredArrayUsingPredicate:predicate];
        
        if (!dicArr.count) {
            return weiboText;
        }
        NSDictionary *faceDic=[dicArr lastObject];
        
        NSString *facePng=[faceDic objectForKey:@"png"];
        
        NSString *lastStr=[NSString stringWithFormat:@"<image url = '%@'>",facePng];//facePng  --> 001.png
        //    [兔子]  ---> 001.jpg
        
        //    替换字符串
        
        if (!fullStr) {
            fullStr=[weiboText stringByReplacingOccurrencesOfString:faceString withString:lastStr];
        }else{
            fullStr=[fullStr stringByReplacingOccurrencesOfString:faceString withString:lastStr];
        }
        
    }
    
    return fullStr;
}

//将表情图片转码
+ (NSString*)replacementText:(NSString *)text WithUTFx:(NSInteger)UTFx
{
    if (text.length == 0) {
        return @"";
    }
    NSString *hexstr = @"";
    
    for (int i=0;i< [text length];i++)
    {
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%1X ",[text characterAtIndex:i]]];
    }
    NSLog(@"UTF16 [%@]",hexstr);
    if (UTFx == 2) {
        return [NSString stringWithFormat:@"[%@]",hexstr];
    }
    hexstr = @"";
    
    long slen = strlen([text UTF8String]);
    
    for (int i = 0; i < slen; i++)
    {
        //fffffff0 去除前面六个F & 0xFF
        hexstr = [hexstr stringByAppendingFormat:@"%@",[NSString stringWithFormat:@"0x%X ",[text UTF8String][i] & 0xFF ]];
    }
    NSLog(@"UTF8 [%@]",hexstr);
    
    
    if (UTFx == 1) {
        return [NSString stringWithFormat:@"[%@]",hexstr];
    }
    hexstr = @"";
    
    if ([text length] >= 2) {
        
        for (int i = 0; i < [text length] / 2 && ([text length] % 2 == 0) ; i++)
        {
            // three bytes
            if (([text characterAtIndex:i*2] & 0xFF00) == 0 ) {
                hexstr = [hexstr stringByAppendingFormat:@"Ox%1X 0x%1X",[text characterAtIndex:i*2],[text characterAtIndex:i*2+1]];
            }
            else
            {// four bytes
                hexstr = [hexstr stringByAppendingFormat:@"U+%1X ",MULITTHREEBYTEUTF16TOUNICODE([text characterAtIndex:i*2],[text characterAtIndex:i*2+1])];
            }
            
        }
        NSLog(@"(unicode) [%@]",hexstr);
        
        return [NSString stringWithFormat:@"[%@]",hexstr];
        
    }
    else
    {
        NSLog(@"(unicode) U+%1X",[text characterAtIndex:0]);
        return [NSString stringWithFormat:@"[U+%1X]",[text characterAtIndex:0]];
    }
    
    return text;
}

//判断字符串中是否含有表情
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    //判断系统emoji
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:string
                                                               options:0
                                                                 range:NSMakeRange(0, [string length])
                                                          withTemplate:@""];
    if (![modifiedString isEqualToString:string]){
        return YES;
    }
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//去除字符串中的图像
-(NSString *)converStrEmoji
{
    NSString *emojiStr = self;
    NSString *tempStr;
    NSMutableString *kksstr = [[NSMutableString alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    for(int i =0; i < [emojiStr length]; i++)
    {
        tempStr = [emojiStr substringWithRange:NSMakeRange(i, 1)];
        
        if ([NSString stringContainsEmoji:tempStr]) {
            continue;
        }else{
            [array addObject:tempStr];
        }
        
    }
    for (NSString *strs in array) {
        [kksstr appendString:strs];
    }
    return kksstr;
}


//除字符串中的图像转为UTF8
-(NSString *)converStrEmojiToUTFx:(NSInteger)UTFx;
{
    NSString *emojiStr = self;
    NSString *tempStr;
    NSMutableString *kksstr = [[NSMutableString alloc]init];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    
    for(int i =0; i < [emojiStr length]; i++)
    {
        tempStr = [emojiStr substringWithRange:NSMakeRange(i, 1)];
        
        if ([NSString stringContainsEmoji:tempStr]) {
            
            NSString *str = [emojiStr substringWithRange:NSMakeRange(i, 2)];
            tempStr = [NSString replacementText:str WithUTFx:UTFx];
            i++;

        }else{
            
        }
        [array addObject:tempStr];
    }
    for (NSString *strs in array) {
        [kksstr appendString:strs];
    }
    return kksstr;
}


@end

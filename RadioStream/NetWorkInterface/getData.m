//
//  YelpYapper.m
//  Glutton
//
//  Created by Tyler on 4/2/15.
//  Copyright (c) 2015 TylerCo. All rights reserved.
//

#import "getData.h"
#import <AFNetworking/AFNetworking.h>
//#import "NSURLRequest+OAuth.h"
/**
 Default paths and search terms used in this example
 */
NSMutableArray *ScheduleDataArry;
NSMutableDictionary *ScheduleData;
NSMutableDictionary *dateDict;
NSMutableArray *orderedKeys;

NSMutableArray *orderedDateKeys;


@implementation getData

+ (NSURLRequest *)searchRequest{
    
    NSDateFormatter *formatterDate = [[NSDateFormatter alloc] init];
    formatterDate.dateFormat = @"yyyy-MM-dd";
    
    NSDate *today = [NSDate date];
    
    NSDateFormatter *formatterComp = [[NSDateFormatter alloc] init];
    formatterComp.dateFormat = @"yyyy-MM-dd 09:00:00";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *fday = [formatterComp stringFromDate:today];
    
    NSDate *dateComp9 = [[NSDate alloc] init];
    dateComp9 = [formatter dateFromString:fday];
    
    if ([today compare:dateComp9] == NSOrderedAscending) {  // dateComp9 > today
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay;
        NSInteger value = -1;
        today = [calendar dateByAddingUnit:unit value:value toDate:today options:NSCalendarMatchStrictly];
    }
    fday = [formatterDate stringFromDate:today];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;
    NSInteger value = 6;
    NSDate *sdayDate = [calendar dateByAddingUnit:unit value:value toDate:today options:NSCalendarMatchStrictly];
    
    NSString *sday = [formatterDate stringFromDate:sdayDate];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://southwestunderground.com//getschedule/?fday=%@&sday=%@",fday,sday ];
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSURLRequest requestWithURL:url];
}
@end

//
//  getData.h
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface getData : NSObject

+ (NSURLRequest *)searchRequest;

extern NSMutableArray *ScheduleDataArry;
extern NSMutableDictionary *ScheduleData;
extern NSMutableDictionary *dateDict;
extern NSMutableArray *orderedKeys;
extern NSMutableArray *orderedDateKeys;
@end

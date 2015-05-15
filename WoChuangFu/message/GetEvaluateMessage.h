#import "message.h"

#define GETEVALUATE_BIZCODE @"cf0030"
@interface GetEvaluateMessage : message

+ (NSString*)getBizCode;

@end

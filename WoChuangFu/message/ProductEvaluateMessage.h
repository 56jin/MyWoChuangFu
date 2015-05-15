#import "message.h"

#define PRODUCTEVALUATE_BIZCODE @"cf0031"
@interface ProductEvaluateMessage : message

+ (NSString*)getBizCode;

@end

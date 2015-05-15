#import "message.h"

#define PRODUCTDETAIL_BIZCODE @"cf0011"
@interface ProductDetail : message<MessageDelegate>

+ (NSString*)getBizCode;

@end

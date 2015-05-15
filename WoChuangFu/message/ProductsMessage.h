#import "message.h"

#define PRODUCTS_BIZCODE @"cf0010"
@interface ProductsMessage : message<MessageDelegate>

+ (NSString*)getBizCode;

@end

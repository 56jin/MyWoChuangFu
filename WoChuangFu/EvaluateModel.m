#import "EvaluateModel.h"

@implementation EvaluateModel


- (EvaluateModel *)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.evaluateId = dict[@"evaluateId"] == [NSNull null] ?@"":dict[@"evaluateId"];
        self.evaluateContent = dict[@"evaluateContent"] == [NSNull null] ?@"":dict[@"evaluateContent"];
        self.evaluatesType = dict[@"evaluatesType"] == [NSNull null] ?@"":dict[@"evaluatesType"];
        self.evaluatesStar = dict[@"evaluatesStar"] == [NSNull null] ?@"":dict[@"evaluatesStar"];
        self.evaluateUser = [dict[@"evaluateUser"] isEqualToString: @""] ?@"游客":dict[@"evaluateUser"];
        self.evalateTime = dict[@"evalateTime"] == [NSNull null] ?@"":dict[@"evalateTime"];
        self.replyContent = dict[@"replyContent"] == [NSNull null] ?@"":dict[@"replyContent"];
        self.replyName = dict[@"replyName"] == [NSNull null] ?@"":dict[@"replyName"];
    }
    return self;
}

@end

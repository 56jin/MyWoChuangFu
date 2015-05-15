#import <Foundation/Foundation.h>

//评价信息数据模型
@interface EvaluateModel : NSObject

//回复信息模型
@property(nonatomic,copy) NSString *evaluateId;       //评价编号
@property(nonatomic,copy) NSString *evaluateContent;  //评价内容
@property(nonatomic,copy) NSString *evaluatesType;    //评价类型
@property(nonatomic,copy) NSString *evaluatesStar;    //评价星数
@property(nonatomic,copy) NSString *evaluateUser;     //评价用户
@property(nonatomic,copy) NSString *evalateTime;      //评价时间

//不一定存在
@property(nonatomic,copy) NSString *replyContent;     //回复内容
@property(nonatomic,copy) NSString *replyName;        //回复姓名

- (EvaluateModel *)initWithDict:(NSDictionary *)dict;

@end

#import <UIKit/UIKit.h>

//商品评价界面
@interface ProductEvaluationVC : UIViewController

@property(nonatomic,strong) NSMutableDictionary *evaluateDict; //评论数量信息
@property(nonatomic,copy) NSString              *productId;    //商品id

@end

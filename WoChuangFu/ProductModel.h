#import <Foundation/Foundation.h>

//商品模型
@interface ProductModel : NSObject

@property (nonatomic,copy) NSString *ID;             //商品ID
@property (nonatomic,copy) NSString *imgURL;         //商品图片URL
@property (nonatomic,copy) NSString *name;           //商品名称
@property (nonatomic,copy) NSString *desc;           //商品简介
@property (nonatomic,copy) NSString *sellCount;      //商品销量
@property (nonatomic,copy) NSString *sailPrice;      //商品市场价
@property (nonatomic,copy) NSString *contractPrice;  //商品合约价
@property (nonatomic,copy) NSString *discountPrice;  //商品折扣价
@property (nonatomic,copy) NSString *clickURL;       //点击跳转URL
@property (nonatomic,copy) NSString *moduleId;



@end

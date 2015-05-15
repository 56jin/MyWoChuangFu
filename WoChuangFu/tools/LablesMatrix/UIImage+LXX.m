#import "UIImage+LXX.h"
//#import "NSString+LXX.h"

//用于适配4-inch的屏幕
@implementation UIImage (LXX)

#pragma mark - 加载全屏图片
//+ (UIImage *)fullScreenImage:(NSString *)imgName
//{
//    if (IS_IPHONE5)
//    {
//        imgName = [imgName fileAppend:@"-568h@2x"];
//    }
//    return [self imageNamed:imgName];
//}

+ (UIImage *)resizedImage:(NSString *)imgName;
{
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos
{
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}

+(UIImage *)resizedUIImage:(UIImage *)image
{
    return [image stretchableImageWithLeftCapWidth:image.size.width *0.5 topCapHeight:image.size.height * 0.5];
}

@end
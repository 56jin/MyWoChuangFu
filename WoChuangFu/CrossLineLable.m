#import "CrossLineLable.h"

@implementation CrossLineLable

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.textColor setStroke];
    CGSize size;
    if (IOS7)
    {
        size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,nil]];
    }
    else
    {
        size = [self.text sizeWithFont:self.font];
    }
    CGContextSetLineWidth(context, 1);
#ifdef __IPHONE_6_0
    if (self.textAlignment == NSTextAlignmentRight)
#else
    if (self.textAlignment == UITextAlignmentRight)
#endif
    {
        CGContextMoveToPoint(context,self.frame.size.width-size.width,rect.size.height/2.0);
        CGContextAddLineToPoint(context,self.frame.size.width,rect.size.height/2.0);
    }
    else
    {
        CGContextMoveToPoint(context,0,rect.size.height/2.0);
        CGContextAddLineToPoint(context,size.width,rect.size.height/2.0);
    }
    
    CGContextStrokePath(context);
}

@end

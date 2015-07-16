//
//  CoreTextView.m
//  CoreTextMagazine
//
//  Created by 陈 贵邦 on 15-5-7.
//  Copyright (c) 2015年 陈贵邦. All rights reserved.
//

#import "CoreTextView.h"
#import <CoreText/CoreText.h>
@implementation CoreTextView



- (void)drawRect:(CGRect)rect {
    // Drawing code.
    
    //创建要输出的字符串
    NSString *longText = @"扫码关注\"广西联通\"官网微信,回复\"绑定\"，按提示完成电子协议认证，即可获取广西联通赠送的奖励噢！\n注：根据您办理套餐的不同，奖励的内容也不同。奖品为300M区内流量或10元话费。";
    
    //创建AttributeString
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
                                         initWithString:longText];
    
//    //创建字体以及字体大小
    CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"), 14.0, NULL);
    CTFontRef helveticaBold = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 14.0, NULL);
//
//    //添加字体 目标字符串从下标0开始到字符串结尾
    [string addAttribute:(id)kCTFontAttributeName
                   value:(__bridge id)helvetica
                   range:NSMakeRange(0, [longText length])];
//    //添加字体 目标字符串从下标0开始，截止到4个单位的长度
//    [string addAttribute:(id)kCTFontAttributeName
//                   value:(__bridge id)helveticaBold
//                   range:NSMakeRange(5, 5)];
    
//    //添加字体 目标字符串从下标6开始，截止到5个单位长度
//    [string addAttribute:(id)kCTFontAttributeName
//                   value:(__bridge id)helveticaBold
//                   range:NSMakeRange(10, 5)];
//    
//    //添加字体 目标字符串从下标109开始，截止到9个单位长度
//    [string addAttribute:(id)kCTFontAttributeName
//                   value:(__bridge id)helveticaBold
//                   range:NSMakeRange(15, 5)];
//    
//    //添加字体 目标字符串从下标223开始，截止到6个单位长度
//    [string addAttribute:(id)kCTFontAttributeName
//                   value:(__bridge id)helveticaBold
//                   range:NSMakeRange(20, 5)];
    
    //添加颜色，目标字符串从下标0开始，截止到4个单位长度
    [string addAttribute:(id)kCTForegroundColorAttributeName
                   value:(id)[UIColor grayColor].CGColor
                   range:NSMakeRange(0, [longText length])];
    
    [string addAttribute:(id)kCTForegroundColorAttributeName
                   value:(id)[UIColor blueColor].CGColor
                   range:NSMakeRange(5, 4)];
    [string addAttribute:(id)kCTForegroundColorAttributeName
                   value:(id)[UIColor blueColor].CGColor
                   range:NSMakeRange(18, 2)];
//    [string addAttribute:(id)kCTForegroundColorAttributeName
//                   value:(id)[UIColor redColor].CGColor
//                   range:NSMakeRange(48, [longText length]-48)];
    
//    //添加过程同上
//    [string addAttribute:(id)kCTForegroundColorAttributeName
//                   value:(id)[UIColor redColor].CGColor
//                   range:NSMakeRange(
//                                     30, 5)];
//    
//    [string addAttribute:(id)kCTForegroundColorAttributeName
//                   value:(id)[UIColor greenColor].CGColor
//                   range:NSMakeRange(35, 5)];
//    
//    [string addAttribute:(id)kCTForegroundColorAttributeName
//                   value:(id)[UIColor blueColor].CGColor
//                   range:NSMakeRange(40, 5)];
    
    //创建文本对齐方式
    CTTextAlignment alignment = kCTLeftTextAlignment;//左对齐 kCTRightTextAlignment为右对齐
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
//    //创建文本行间距
//    CGFloat lineSpace=30.0f;//间距数据
//    CTParagraphStyleSetting lineSpaceStyle;
//    lineSpaceStyle.spec=kCTParagraphStyleSpecifierLineSpacing;//指定为行间距属性
//    lineSpaceStyle.valueSize=sizeof(lineSpace);
//    lineSpaceStyle.value=&lineSpace;
    
//    //创建样式数组
//    CTParagraphStyleSetting settings[]={
//        alignmentStyle,lineSpaceStyle
//    };
    
    //设置样式
//    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings));
    
    //给字符串添加样式attribute
//    [string addAttribute:(id)kCTParagraphStyleAttributeName
//                   value:(__bridge id)paragraphStyle
//                   range:NSMakeRange(45, 5)];
    
    // layout master
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(
                                                                           (CFAttributedStringRef)string);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL,
                  CGRectMake(0, 0,
                             self.bounds.size.width,
                             self.bounds.size.height));
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,
                                                    CFRangeMake(0, 0),
                                                    leftColumnPath, NULL);
    // flip the coordinate system
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    // draw
    CTFrameDraw(leftFrame, context);
    // cleanup
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    CFRelease(helvetica);
    CFRelease(helveticaBold);
    UIGraphicsPushContext(context);
    
}

@end

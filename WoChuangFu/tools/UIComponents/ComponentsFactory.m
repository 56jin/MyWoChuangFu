//
//  ComponentsFactory.m
//  FJPZGZ
//
//  Created by Ma Genius on 10-10-16.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ComponentsFactory.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation ComponentsFactory

// Generate a button by the given parameters.
+ (UIButton *)buttonWithType:(NSUInteger)type
					   title:(NSString *)title 
					   frame:(CGRect)frame
				   imageName:(NSString *)imageName
			 tappedImageName:(NSString *)tappedImageName
					  target:(id)target 
					  action:(SEL)selector 
						 tag:(NSInteger)tag{
	UIButton *button = [UIButton buttonWithType:type];
	button.frame = frame;
	if( title!=nil && title.length>0 ){
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	}
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.tag = tag;
	if( imageName!=nil && ![imageName isEqualToString:@""]){
		[button setBackgroundImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
	}
	if( tappedImageName!=nil && ![tappedImageName isEqualToString:@""]){
		[button setBackgroundImage:[[UIImage imageNamed:tappedImageName] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
	}
	
	return button;
}

// Generate a label by the given parameters.
+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font
                        tag:(NSInteger)tag
                  hasShadow:(Boolean)hasShadow{
	UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
	label.text = text;
	label.textColor = textColor;
	label.backgroundColor = [UIColor clearColor];
	if( hasShadow ){
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(0,1);
	}
	label.textAlignment = UITextAlignmentCenter;
	label.font = font;
	label.tag = tag;
	
	return label;
}

// colin: generate label with auto calculated frame size
+ (UILabel *) labelWithText:(NSString *)text font:(UIFont *) font x:(CGFloat) x y:(CGFloat) y{
	CGSize size = [text sizeWithFont:font];
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(x,y,size.width, size.height)]autorelease];
	label.text = text;
	label.font = font;
	label.textColor = [UIColor blackColor];
	label.backgroundColor = [UIColor clearColor];
	return label;
}

+ (UILabel*) lableWithText:(NSString*)title font:(UIFont*)font
{
    UILabel* titleLable = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 44)] autorelease];
    titleLable.backgroundColor = [UIColor clearColor];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.textAlignment = UITextAlignmentCenter;
    titleLable.numberOfLines = 1;
    titleLable.adjustsFontSizeToFitWidth = YES;
    //titleLable.center = CGPointMake(160, 22);
    titleLable.minimumFontSize = 12.0;
    titleLable.lineBreakMode = UILineBreakModeWordWrap;
    titleLable.shadowOffset = CGSizeMake(0.5, 0.5);
    titleLable.shadowColor = [UIColor blackColor];
    if(nil != title){
        titleLable.text = title;
    }
    if(nil != font){
        titleLable.font = font;
    }else{
        titleLable.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    }
    
    return titleLable;
    
}
+ (UITextField *)textFieldWithFrame:(CGRect)frame
												borderStyle:(UITextBorderStyle)borderStyle
													textColor:(UIColor *)textColor
										backgroundColor:(UIColor *)backgroundColor
															 font:(UIFont *)font
											 keyboardType:(UIKeyboardType)keyboardType
																tag:(NSInteger)tag{
	UITextField *textField = [[[UITextField alloc] initWithFrame:frame] autorelease];
	textField.borderStyle = borderStyle;
	textField.textColor = textColor;
	textField.font = font;
	textField.backgroundColor = backgroundColor;
	textField.keyboardType = keyboardType;
	textField.tag = tag;
	
	textField.returnKeyType = UIReturnKeyDone;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.leftViewMode = UITextFieldViewModeUnlessEditing;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	return textField;
}

+ (UITextView *)textViewWithFrame:(CGRect)frame
						 textColor:(UIColor *)textColor
							  font:(UIFont *)font
							  text:(NSString*) text
{
	UITextView *view = [[[UITextView alloc] initWithFrame:frame] autorelease];
    view.textColor = textColor;
    view.font = font;
	view.textColor = textColor;
	view.text = text;
    return view;
}


+ (UIColor*) createColorByHex:(NSString *)hexColor
{
    
    if (hexColor == nil) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1; 
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3; 
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5; 
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];	
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+(NSString*)filterSpace:(NSString*) aFilterString
{
	if (nil != aFilterString) {
		NSMutableString* resultString = [[[NSMutableString alloc] initWithString:aFilterString] autorelease];
		NSUInteger length = [resultString length];
		[resultString replaceOccurrencesOfString:@" " 
									  withString:@"" 
										 options:NSBackwardsSearch 
										   range:NSMakeRange(0, length)];
		return resultString;
	}
	
	return nil;
}

+(NSInteger)GetWeekDayFromYear:(NSInteger)aYear 
				  AndFromMonth:(NSInteger)aMonth 
					AndFromDay:(NSInteger)aDay
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:aDay]; 
    [components setMonth:aMonth]; 
    [components setYear:aYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    [components release];
	
	NSDateComponents *todayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:thisDate];
	
	NSInteger theWeek = [todayComponents weekday];
	
	[gregorian release];
	
	return theWeek;
}

+(NSDate*)GetNSDateFromYear:(NSInteger)aYear 
			   AndFromMonth:(NSInteger)aMonth 
				 AndFromDay:(NSInteger)aDay
				IntervalDay:(NSInteger)aInterval
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setHour:00];
	[components setMinute:00];
	[components setSecond:00];
    [components setDay:aDay]; 
    [components setMonth:aMonth]; 
    [components setYear:aYear];
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (4.0 <= version) {
		[components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	}
    NSDate *thisDate = [gregorian dateFromComponents:components];	
    [components release];
	
	// now build a NSDate object for the next day
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:aInterval];
	NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: thisDate options:0];
	[offsetComponents release];
	[gregorian release];

	return nextDate;	
}

+(NSDate*)GetNSDateFromYear:(NSInteger)aYear 
			   AndFromMonth:(NSInteger)aMonth 
				 AndFromDay:(NSInteger)aDay
				IntervalMonth:(NSInteger)aInterval
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setHour:00];
	[components setMinute:00];
	[components setSecond:00];
    [components setDay:01]; 
    [components setMonth:aMonth]; 
    [components setYear:aYear];
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (4.0 <= version) {
		[components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	}
    NSDate *thisDate = [gregorian dateFromComponents:components];	
    [components release];
	
	// now build a NSDate object for the next day
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setMonth:aInterval];
	NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate: thisDate options:0];
	[offsetComponents release];
	[gregorian release];
	
	return nextDate;	
}


+(NSString*)GetStringFromNSDate:(NSDate*)aDate
{
	NSString *tempDate = [[NSString stringWithFormat:@"%@",aDate] substringToIndex:10];
	NSMutableString *strDate = [[[NSMutableString alloc]initWithFormat:@"%@",tempDate]autorelease];
	
	NSRange strRange;
	strRange.location = 4;
	strRange.length = 1;
	[strDate deleteCharactersInRange:strRange];
	
	strRange.location = 6;
	strRange.length = 1;
	[strDate deleteCharactersInRange:strRange];
	//NSLog(@"%@",strDate);		
	return strDate;
}

+(NSInteger)GetWeekDayFromString:(NSString*)aString
{
	NSString *theYear = [aString substringToIndex:4];
	
	
	NSRange monthRange;
	monthRange.location  = 4;
	monthRange.length = 2;
	NSString *theMonth = [aString substringWithRange:monthRange];
	
	monthRange.location = 6;
	monthRange.length = 2;
	
	NSString *theDay = [aString substringWithRange:monthRange];
	
	return [self GetWeekDayFromYear:[theYear intValue] 
					   AndFromMonth:[theMonth intValue]
						 AndFromDay:[theDay intValue]];
	
}


// 20110827
+(NSString*)getStringFormat:(NSString*)aString
{
	if ([aString length] < 8) {
		return @"";
		
	}
	
	NSString *theYear = [aString substringToIndex:4];
	
	NSRange monthRange;
	monthRange.location  = 4;
	monthRange.length = 2;
	NSString *theMonth = [aString substringWithRange:monthRange];
	
	monthRange.location = 6;
	monthRange.length = 2;
	
	NSString *theDay = [aString substringWithRange:monthRange];
	
	return [NSString stringWithFormat:@"%@-%@-%@",theYear,theMonth,theDay];
	
}
//2011-08-27 TO 20110827
+(NSString*)getStringFormatReverse:(NSString*)aString
{
	if ([aString length] < 10) {
		return @"";
		
	}
	
	NSString *theYear = [aString substringToIndex:4];
	
	NSRange monthRange;
	monthRange.location  = 5;
	monthRange.length = 2;
	NSString *theMonth = [aString substringWithRange:monthRange];
	
	monthRange.location = 8;
	monthRange.length = 2;
	
	NSString *theDay = [aString substringWithRange:monthRange];
	
	return [NSString stringWithFormat:@"%@%@%@",theYear,theMonth,theDay];
	
}
// 201108
+(NSString*)getStringFormat2:(NSString*)aString
{
	if ([aString length] < 6) {
		return @"";
	}
	
	NSString *theYear = [aString substringToIndex:4];
	
	NSRange monthRange;
	monthRange.location  = 4;
	monthRange.length = 2;
	NSString *theMonth = [aString substringWithRange:monthRange];

	return [NSString stringWithFormat:@"%@-%@",theYear,theMonth];
	
}

+(NSDate*)GetNSDateFromYear:(NSInteger)aYear 
			   AndFromMonth:(NSInteger)aMonth 
				 AndFromDay:(NSInteger)aDay
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *components = [[NSDateComponents alloc] init];
	[components setHour:00];
	[components setMinute:00];
	[components setSecond:00];
    [components setDay:aDay]; 
    [components setMonth:aMonth]; 
    [components setYear:aYear];
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (4.0 <= version) {
		[components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
	}
    NSDate *thisDate = [gregorian dateFromComponents:components];
	[gregorian release];
	[components release];
	
	return thisDate;	
}

+(NSDate*)getNSDateFromString:(NSString*)aString
{
	NSString *theYear = [aString substringToIndex:4];
	
	
	NSRange monthRange;
	monthRange.location  = 4;
	monthRange.length = 2;
	NSString *theMonth = [aString substringWithRange:monthRange];
	
	monthRange.location = 6;
	monthRange.length = 2;
	
	
	NSString *theDay = [aString substringWithRange:monthRange];
	
	
	return [self GetNSDateFromYear:[theYear intValue]
					  AndFromMonth:[theMonth intValue]
						AndFromDay:[theDay intValue]];
	
}

//20101010  TO NSDate
+(NSDate*)getNSDateFromStringTime:(NSString*)aString 
					 intervalTime:(NSInteger)aInterval
{
	NSString *theYear = [aString substringToIndex:4];
	
	NSRange monthRange;
	monthRange.location  = 4;
	monthRange.length = 2;
	NSString *theMonth = [aString substringWithRange:monthRange];
	
	monthRange.location = 6;
	monthRange.length = 2;
	
	NSString *theDay = [aString substringWithRange:monthRange];
	
	return [self GetNSDateFromYear:[theYear intValue]
			   AndFromMonth:[theMonth intValue]
				 AndFromDay:[theDay intValue]
				IntervalDay:aInterval];
	
}

+(NSDate*)getNSDateFromStringTime:(NSString*)aString 
					 intervalMonth:(NSInteger)aInterval
{
	NSString *theYear = [aString substringToIndex:4];
	
	NSRange monthRange;
	monthRange.location  = 4;
	monthRange.length = 2;
	NSString *theMonth = [aString substringWithRange:monthRange];
	
	monthRange.location = 6;
	monthRange.length = 2;
	
	NSString *theDay = [aString substringWithRange:monthRange];
	
	return [self GetNSDateFromYear:[theYear intValue]
					  AndFromMonth:[theMonth intValue]
						AndFromDay:[theDay intValue]
					   IntervalMonth:aInterval];
	
}




+(NSDictionary*)GetYearAndMonthFromNSDate:(NSDate*)aDate
{
	NSString *tempDate = [[NSString stringWithFormat:@"%@",aDate] substringToIndex:7];
	NSString *strDate = [NSString stringWithFormat:@"%@",tempDate];
	
	NSString *theYear = [strDate substringToIndex:4];
	
	NSRange monthRange;
	monthRange.location  = 5;
	monthRange.length = 2;
	NSString *theMonth = [strDate substringWithRange:monthRange];
	
	return [NSDictionary dictionaryWithObjectsAndKeys:theYear,@"year",
							 theMonth,@"month",nil];
	
}

+(NSString*)getUUID
{
    
    NSString *uuidStr = @"";
    uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    
    if (uuidStr != nil && ![uuidStr isEqualToString:@""]) {
        return uuidStr;
    } else {
        // Create universally unique identifier (object)
        CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
        uuidStr = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
        
        [[NSUserDefaults standardUserDefaults] setObject:uuidStr forKey:@"uuid"];
        CFRelease(uuidObject);
    }
    // Get the string representation of CFUUID object.
    
    
    return uuidStr;
}

//10月30日,to NSDate
+(NSDate*)GetMonthNSDateFromYear:(NSInteger)aYear FromMonth:(NSInteger)aMonth
{
	int tempMonth = aMonth+1;
	if (13 == tempMonth ) {
		tempMonth = 1;
	}
	
	return [self GetNSDateFromYear:aYear
					  AndFromMonth:tempMonth
						AndFromDay:1
					   IntervalDay:-1];
	

}

+(NSString*)getLastDate:(NSString*)begindate
{
	NSRange Range;
	Range.location  = 4;
	Range.length = 2;
	NSString *theMonth = [begindate substringWithRange:Range];
	Range.location = 6;
	Range.length = 2;
	NSString *theDay = [begindate substringWithRange:Range];
	NSString* str = [NSString stringWithFormat:@"%@.%@",theMonth,theDay];
	
	return str;
}

+(NSString*)getMonthChartDate:(NSString*)begindate
{
	NSRange Range;
	Range.location = 2;
	Range.length = 2;
	NSString* theYear = [begindate substringWithRange:Range];
	Range.location  = 4;
	Range.length = 2;
	NSString *theMonth = [begindate substringWithRange:Range];
	NSString* str = [NSString stringWithFormat:@"%@/%@",theMonth,theYear];
	
	return str;
}

+(NSString*)getNextChartDateStr:(NSString*)fromChartDate
				 chartTypeCycle:(NSString*)cycle 
					  oriention:(BOOL)isBehind
{
	NSInteger aInterval = 0;
	if ([cycle caseInsensitiveCompare:@"D"] == NSOrderedSame) {
		// 日报
		aInterval = 1;
	}else if ([cycle caseInsensitiveCompare:@"W"] == NSOrderedSame) {
		aInterval = 7;
	}else if ([cycle caseInsensitiveCompare:@"M"] == NSOrderedSame) {
		// 月报
		NSRange Range;
		Range.length = 4;
		Range.location = 0;
		NSString* theYear = [fromChartDate substringWithRange:Range];
		Range.location  = 4;
		Range.length = 2;
		NSString *theMonth = [fromChartDate substringWithRange:Range];
		
		NSInteger iMonth = [theMonth integerValue];
		NSInteger iYear = [theYear integerValue];
		if (isBehind) {
			if (iMonth == 12) {
				iMonth = 1;
				iYear +=1;
			}else {
				iMonth +=1;
			}
		}else {
			if (iMonth == 1) {
				iMonth = 12;
				iYear -=1;
			}else {
				iMonth -=1;
			}
		}
		
		NSString* strMonth = iMonth >=10 ? [[NSString alloc] initWithFormat:@"%d",iMonth]:[[NSString alloc] initWithFormat:@"0%d",iMonth];
		NSString* nextChartTimeStr = [[[NSString alloc] initWithFormat:@"%d%@",iYear,strMonth] autorelease];
		
		[strMonth release];
		
		return nextChartTimeStr;		
	}else if ([cycle caseInsensitiveCompare:@"Q"] == NSOrderedSame) {
		//  季报
	}else{
		// 是具体的天数了
		aInterval = [cycle integerValue];
		
	}
	
	aInterval *= isBehind ? 1 : -1;
	
	NSDate* aDate = [self getNSDateFromStringTime:fromChartDate intervalTime:aInterval];
	NSString* nextChartDateStr = [[[NSString alloc] initWithString:[self GetStringFromNSDate:aDate]] autorelease];
	return nextChartDateStr;
}

+(NSString*)getDateStringWithString:(NSString*)dateString
{
    if(dateString.length >= 14)
    {
        NSString* theYear = [dateString substringToIndex:4];
        
        NSRange monthRange;
        monthRange.location  = 4;
        monthRange.length = 2;
        NSString* theMonth = [dateString substringWithRange:monthRange];
        
        monthRange.location = 6;
        monthRange.length = 2;
        NSString* theDay = [dateString substringWithRange:monthRange];
        
        monthRange.location = 8;
        monthRange.length = 2;
        NSString* theHour = [dateString substringWithRange:monthRange];
        
        monthRange.location = 10;
        monthRange.length = 2;
        NSString* theMinute = [dateString substringWithRange:monthRange];
        
        monthRange.location = 12;
        monthRange.length = 2;
        NSString* theSecond = [dateString substringWithRange:monthRange];
        
        NSString* str = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",
                         theYear,theMonth,theDay,theHour,theMinute,theSecond];
        
        return str;
    }else{
        return dateString;
    }
}

+(NSString*)mdnFormat:(NSString*)mdnString rangeOfString:(NSString*)aString
{
    if(nil != mdnString){
        if(nil != aString){
            NSString* mdnHead = [mdnString substringToIndex:3];
            
            NSRange Range;
            Range.location  = 3;
            Range.length = 4;
            NSString* mdnArea = [mdnString substringWithRange:Range];
            
            Range.location = 7;
            Range.length = 4;
            NSString* mdnEnd = [mdnString substringWithRange:Range];
            
            NSString* str = [NSString stringWithFormat:@"%@%@%@%@%@",mdnHead,aString,mdnArea,aString,mdnEnd];
            
            return str;
        }else{
            NSString* str = [NSString stringWithString:mdnString];
            return str;
        }
    }else{
        NSString* str = [NSString stringWithString:mdnString];
        return str;
    }
}

+(NSString*)moneyFormat:(NSString*)moneyString
{
    if(nil != moneyString && moneyString.length > 0){
        NSString* moneyDoubleString = [NSString stringWithString:moneyString];
        double monetDouble = [moneyDoubleString doubleValue];
        
        NSNumberFormatter* numberFormat = [[NSNumberFormatter alloc] init];
        [numberFormat setPositiveFormat:@"###,##0.00"];
        [numberFormat setNegativeFormat:@"###,##0.00"];
        NSNumber* numberDouble = [NSNumber numberWithDouble:monetDouble];
        NSString* moneyFormatterString = [numberFormat stringFromNumber:numberDouble];
        [numberFormat release];
        
        return moneyFormatterString;
    }else{
        return moneyString;
    }
}

//截取部分图像  
+(UIImage*)subImage:(UIImage *)image rect:(CGRect)rect
{  
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);  
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));  
    
    UIGraphicsBeginImageContext(smallBounds.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextDrawImage(context, smallBounds, subImageRef);  
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    UIGraphicsEndImageContext();  
    
    return smallImage;  
}
+(void)showAlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles,...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    id arg;
    va_list argList;
    if(nil != otherButtonTitles){
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList,id))) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message 
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    alert.tag = tag;
    for(int i = 0; i < [argsArray count]; i++){
        [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
    }
    [alert show];
    [alert release];
    
    [argsArray release];
}

+(NSString *)MacAddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        if (buf != NULL) {
            free(buf);
        }
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

+ (void)dispatch_process_with_thread:(UIImage* (^)())block1 result:(void (^)(UIImage*))block2
{
    dispatch_async(dispatch_get_global_queue(0, 0),^{
        UIImage* img = block1();
        dispatch_async(dispatch_get_main_queue(),^{
            block2(img);
        });
    });
}
@end

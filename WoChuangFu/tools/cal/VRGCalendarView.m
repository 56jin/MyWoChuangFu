//
//  VRGCalendarView.m
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIView+convenience.h"

#define PI 3.1415926

@implementation VRGCalendarView
@synthesize currentMonth,delegate,labelCurrentMonth, animationView_A,animationView_B;
@synthesize markedDates,markedColors,calendarHeight,selectedDate;

#pragma mark - Select Date
-(void)selectDate:(int)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self.currentMonth];
    [comps setDay:date];
    self.selectedDate = [gregorian dateFromComponents:comps];
    
    int selectedDateYear = [selectedDate year];
    int selectedDateMonth = [selectedDate month];
    int currentMonthYear = [currentMonth year];
    int currentMonthMonth = [currentMonth month];
    
    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
//        [self setNeedsDisplay];
    }
    
    if ([delegate respondsToSelector:@selector(calendarView:dateSelected:)]) [delegate calendarView:self dateSelected:self.selectedDate];
}

#pragma mark - Mark Dates
//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
-(void)markDates:(NSArray *)dates {
    self.markedDates = dates;
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[dates count]; i++) {
        [colors addObject:[UIColor redColor]/*[UIColor colorWithHexString:@"0x383838"]*/];
    }
    
    self.markedColors = [NSArray arrayWithArray:colors];
    [colors release];
    
    [self setNeedsDisplay];
}

//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors {
    self.markedDates = dates;
    self.markedColors = colors;
    
    [self setNeedsDisplay];
}

#pragma mark - Set date to now
-(void)reset {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: [NSDate date]];
    self.currentMonth = [gregorian dateFromComponents:components]; //clean month
    
    [self updateSize];
    [self setNeedsDisplay];
    [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:NO];
}

#pragma mark - Next & Previous
-(void)showNextMonth {
    if (isAnimating) return;
    self.markedDates=nil;
    isAnimating=YES;
    prepAnimationNextMonth=YES;
    
    [self setNeedsDisplay];
    
    int lastBlock = [currentMonth firstWeekDayInMonth]+[currentMonth numDaysInMonth]-1;
    int numBlocks = [self numRows]*7;
    BOOL hasNextMonthDays = lastBlock<numBlocks;
    
    //Old month
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //New month
    self.currentMonth = [currentMonth offsetMonth:1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight: animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
    prepAnimationNextMonth=NO;
    [self setNeedsDisplay];
    
    UIImage *imageNextMonth = [self drawCurrentState];
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewTopBarHeight)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    [animationHolder release];
    
    //Animate
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imageNextMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    if (hasNextMonthDays) {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight - (kVRGCalendarViewDayHeight+3);
    } else {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight -3;
    }
    
    //Animation
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];
                         //blockSafeSelf.frameHeight = 100;
                         if (hasNextMonthDays) {
                             animationView_A.frameY = -animationView_A.frameHeight + kVRGCalendarViewDayHeight+3;
                         } else {
                             animationView_A.frameY = -animationView_A.frameHeight + 3;
                         }
                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
}

-(void)showPreviousMonth {
    if (isAnimating) return;
    isAnimating=YES;
    self.markedDates=nil;
    //Prepare current screen
    prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    BOOL hasPreviousDays = [currentMonth firstWeekDayInMonth]>1;
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //Prepare next screen
    self.currentMonth = [currentMonth offsetMonth:-1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
    prepAnimationPreviousMonth=NO;
    [self setNeedsDisplay];
    UIImage *imagePreviousMonth = [self drawCurrentState];
    
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewTopBarHeight)];
    
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    [animationHolder release];
    
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    if (hasPreviousDays) {
        animationView_B.frameY = animationView_A.frameY - (animationView_B.frameHeight-kVRGCalendarViewDayHeight) + 3;
    } else {
        animationView_B.frameY = animationView_A.frameY - animationView_B.frameHeight + 3;
    }
    
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];
                         
                         if (hasPreviousDays) {
                             animationView_A.frameY = animationView_B.frameHeight-(kVRGCalendarViewDayHeight+3); 
                             
                         } else {
                             animationView_A.frameY = animationView_B.frameHeight-3;
                         }
                         
                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
}


#pragma mark - update size & row count
-(void)updateSize {
    self.frameHeight = self.calendarHeight;
    [self setNeedsDisplay];
}

-(float)calendarHeight {
    return kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
}

-(int)numRows {
    float lastBlock = [self.currentMonth numDaysInMonth]+([self.currentMonth firstWeekDayInMonth]-1);
    return ceilf(lastBlock/7);
}

#pragma mark - Touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{       
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    self.selectedDate=nil;
    
    //Touch a specific day
    if (touchPoint.y > kVRGCalendarViewTopBarHeight) {
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-kVRGCalendarViewTopBarHeight;
        
        int column = floorf(xLocation/(kVRGCalendarViewDayWidth+2));
        int row = floorf(yLocation/(kVRGCalendarViewDayHeight+2));
        
        int blockNr = (column+1)+row*7;
        int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
        int date = blockNr-firstWeekDay;
        [self selectDate:date];
        return;
    }
    
    self.markedDates=nil;
    self.markedColors=nil;  
    
    CGRect rectArrowLeft = CGRectMake(0, 0, 50, 40);
    CGRect rectArrowRight = CGRectMake(self.frame.size.width-50, 0, 50, 40);
    
    //Touch either arrows or month in middle
    if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
        [self showPreviousMonth];
    } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
        [self showNextMonth];
    } else if (CGRectContainsPoint(self.labelCurrentMonth.frame, touchPoint)) {
        //Detect touch in current month
        int currentMonthIndex = [self.currentMonth month];
        int todayMonth = [[NSDate date] month];
        [self reset];
        if ((todayMonth!=currentMonthIndex) && [delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:NO];
    }
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    labelCurrentMonth.text = [formatter stringFromDate:self.currentMonth];
    labelCurrentMonth.backgroundColor=[UIColor clearColor];
    labelCurrentMonth.textColor=[UIColor whiteColor];
    [labelCurrentMonth sizeToFit];
    labelCurrentMonth.frameX = roundf(self.frame.size.width/2 - labelCurrentMonth.frameWidth/2);
    labelCurrentMonth.frameY = 10;
    [formatter release];
    [currentMonth firstWeekDayInMonth];
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rectangle = CGRectMake(0,0,self.frame.size.width,40);//kVRGCalendarViewTopBarHeight);
    CGContextAddRect(context, rectangle);
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0xF56742"].CGColor);
    CGContextFillPath(context);
    
    CGRect rectangle1 = CGRectMake(0,40,self.frame.size.width,kVRGCalendarViewTopBarHeight-40);//kVRGCalendarViewTopBarHeight);
    CGContextAddRect(context, rectangle1);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    //Arrows
    int arrowSize = 12;
    int xmargin = 20;
    int ymargin = 14;
    
    //Arrow Left
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xmargin+arrowSize/1.5, ymargin);
    CGContextAddLineToPoint(context,xmargin+arrowSize/1.5,ymargin+arrowSize);
    CGContextAddLineToPoint(context,xmargin,ymargin+arrowSize/2);
    CGContextAddLineToPoint(context,xmargin+arrowSize/1.5, ymargin);
    
    CGContextSetFillColorWithColor(context, 
                                   [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    //Arrow right
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width-(xmargin+arrowSize/1.5), ymargin);
    CGContextAddLineToPoint(context,self.frame.size.width-xmargin,ymargin+arrowSize/2);
    CGContextAddLineToPoint(context,self.frame.size.width-(xmargin+arrowSize/1.5),ymargin+arrowSize);
    CGContextAddLineToPoint(context,self.frame.size.width-(xmargin+arrowSize/1.5), ymargin);
    
    CGContextSetFillColorWithColor(context, 
                                   [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    
    //Weekdays
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"EEE";
    //always assume gregorian with monday first
    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];
    [weekdays moveObjectFromIndex:0 toIndex:6];
    
    CGContextSetFillColorWithColor(context, 
                                   [UIColor colorWithHexString:@"0x383838"].CGColor);
    for (int i =0; i<[weekdays count]; i++) {
        NSString *weekdayValue = (NSString *)[weekdays objectAtIndex:i];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [weekdayValue drawInRect:CGRectMake(i*(kVRGCalendarViewDayWidth+2), 45, kVRGCalendarViewDayWidth+2, 20) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    int numRows = [self numRows];
    
    CGContextSetAllowsAntialiasing(context, NO);
    
    //Grid background
    float gridHeight = numRows*(kVRGCalendarViewDayHeight+2)+1;
    CGRect rectangleGrid = CGRectMake(0,kVRGCalendarViewTopBarHeight,self.frame.size.width,gridHeight);
    CGContextAddRect(context, rectangleGrid);
//    CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0xf3f3f3"].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0xff0000"].CGColor);
    CGContextFillPath(context);
    
    //Grid white lines
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+1);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+1);
    for (int i = 1; i<7; i++) {
        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //rows
        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
    }
    
    CGContextStrokePath(context);
    
    //Grid dark lines
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"0xcfd4d8"].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight);
    for (int i = 1; i<7; i++) {
        //columns
        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1, kVRGCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1, kVRGCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //rows
        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1);
        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1);
    }
    CGContextMoveToPoint(context, 0, gridHeight+kVRGCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, gridHeight+kVRGCalendarViewTopBarHeight);
    
    CGContextStrokePath(context);
    
    CGContextSetAllowsAntialiasing(context, YES);
    
    //Draw days
    CGContextSetFillColorWithColor(context, 
                                   [UIColor colorWithHexString:@"0x383838"].CGColor);
    
    
    //NSLog(@"currentMonth month = %i, first weekday in month = %i",[self.currentMonth month],[self.currentMonth firstWeekDayInMonth]);
    
    int numBlocks = numRows*7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    int currentMonthNumDays = [currentMonth numDaysInMonth];
    int prevMonthNumDays = [previousMonth numDaysInMonth];
    
    int selectedDateBlock = ([selectedDate day]-1)+firstWeekDay;
    
    //prepAnimationPreviousMonth nog wat mee doen
    
    //prev next month
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;
    
    if (self.selectedDate!=nil) {
        isSelectedDatePreviousMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]<[currentMonth month]) || [selectedDate year] < [currentMonth year];
        
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]>[currentMonth month]) || [selectedDate year] > [currentMonth year];
        }
    }
    
    if (isSelectedDatePreviousMonth) {
        int lastPositionPreviousMonth = firstWeekDay-1;
        selectedDateBlock=lastPositionPreviousMonth-([selectedDate numDaysInMonth]-[selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [currentMonth numDaysInMonth] + (firstWeekDay-1) + [selectedDate day];
    }
    
    
    NSDate *todayDate = [NSDate date];
    int todayBlock = -1;
    
//    NSLog(@"currentMonth month = %i day = %i, todaydate day = %i",[currentMonth month],[currentMonth day],[todayDate month]);
    
    if ([todayDate month] == [currentMonth month] && [todayDate year] == [currentMonth year]) {
        todayBlock = [todayDate day] + firstWeekDay - 1;
    }
    
    for (int i=0; i<numBlocks; i++) {
        int targetDate = i;
        int targetColumn = i%7;
        int targetRow = i/7;
        int targetX = targetColumn * (kVRGCalendarViewDayWidth+2);
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight+2);
        
        // BOOL isCurrentMonth = NO;
        if (i<firstWeekDay) { //previous month
            targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
            NSString *hex = (isSelectedDatePreviousMonth) ? @"0x383838" : @"0xE2E2E2";
            
            CGContextSetFillColorWithColor(context, 
                                           [UIColor colorWithHexString:hex].CGColor);
        } else if (i>=(firstWeekDay+currentMonthNumDays)) { //next month
            targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
            NSString *hex = (isSelectedDateNextMonth) ? @"0x383838" : @"0xE2E2E2";
            CGContextSetFillColorWithColor(context, 
                                           [UIColor colorWithHexString:hex].CGColor);
        } else { //current month
            // isCurrentMonth = YES;
            targetDate = (i-firstWeekDay)+1;
            NSString *hex = (isSelectedDatePreviousMonth || isSelectedDateNextMonth) ? @"0xaaaaaa" : @"0x909090";
            CGContextSetFillColorWithColor(context, 
                                           [UIColor colorWithHexString:hex].CGColor);
        }
        
        NSString *date = [NSString stringWithFormat:@"%i",targetDate];
        
        //draw selected date
        if (selectedDate && i==selectedDateBlock) {
            
        } else if (todayBlock==i) {
            CGContextSetFillColorWithColor(context,
                                           [UIColor redColor].CGColor);
        }
        
        [date drawInRect:CGRectMake(targetX, targetY+10, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    //    CGContextClosePath(context);
    
//    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);//改变画笔颜色
    CGContextMoveToPoint(context, 0, 70);//开始坐标p1
    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
    CGContextAddArcToPoint(context, 310, 70, 310, 70, 0);
    CGContextStrokePath(context);//绘画路径
    
    //Draw markings
    if (!self.markedDates || isSelectedDatePreviousMonth || isSelectedDateNextMonth) return;
    
    for (int i = 0; i<[self.markedDates count]; i++) {
        id markedDateObj = [self.markedDates objectAtIndex:i];
        
        BOOL isToday;
        int targetDate;
        if ([markedDateObj isKindOfClass:[NSNumber class]]) {
            targetDate = [(NSNumber *)markedDateObj intValue];
            isToday=NO;
        } else if ([markedDateObj isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *)markedDateObj;
            targetDate = [date day];
            if(targetDate == [[NSDate date] day]){
                isToday=YES;
            }else{
                isToday=NO;
            }
        } else {
            continue;
        }
        
        
        
        int targetBlock = firstWeekDay + (targetDate-1);
        int targetColumn = targetBlock%7;
        int targetRow = targetBlock/7;
        
        int targetX = targetColumn * (kVRGCalendarViewDayWidth+2) + 7;
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight+2) + 38;
        
        CGContextSetRGBStrokeColor(context,0.93,0.93,0.93,1.0);
        UIColor*aColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.1];
        CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
        if(isToday){
            CGContextSetRGBStrokeColor(context,1,0.43,0.26,1.0);
            UIColor*aColor = [UIColor colorWithRed:1 green:0.43 blue:0.26 alpha:0.1];
            CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
            CGContextAddArc(context, targetX+14, targetY-17, 20, 0, 2*PI, 0); //添加一个圆
            CGContextDrawPath(context, kCGPathFill);//绘制填充
        }
        CGContextSetLineWidth(context, 1.0);//线的宽度
        CGContextAddArc(context, targetX+14, targetY-17, 18, 0, 2*PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
//        CGRect rectangle = CGRectMake(targetX,targetY,32,5);
//        CGContextAddRect(context, rectangle);
//        
//        UIColor *color;
//        if (selectedDate && selectedDateBlock==targetBlock) {
//            color = [UIColor whiteColor];
//        }  else if (todayBlock==targetBlock) {
//            color = [UIColor whiteColor];
//        } else {
//            color  = (UIColor *)[markedColors objectAtIndex:i];
//        }
//        
//        
//        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    }
    
//    [self drawRect11:rect];
}

//- (void)drawRect11:(CGRect)rect
//{
//    //An opaque type that represents a Quartz 2D drawing environment.
//    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    /*写文字*/
//    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);//设置填充颜色
//    UIFont  *font = [UIFont boldSystemFontOfSize:15.0];//设置
//    [@"画圆：" drawInRect:CGRectMake(10, 20, 80, 20) withFont:font];
//    [@"画线及孤线：" drawInRect:CGRectMake(10, 80, 100, 20) withFont:font];
//    [@"画矩形：" drawInRect:CGRectMake(10, 120, 80, 20) withFont:font];
//    [@"画扇形和椭圆：" drawInRect:CGRectMake(10, 160, 110, 20) withFont:font];
//    [@"画三角形：" drawInRect:CGRectMake(10, 220, 80, 20) withFont:font];
//    [@"画圆角矩形：" drawInRect:CGRectMake(10, 260, 100, 20) withFont:font];
//    [@"画贝塞尔曲线：" drawInRect:CGRectMake(10, 300, 100, 20) withFont:font];
//    [@"图片：" drawInRect:CGRectMake(10, 340, 80, 20) withFont:font];
//    
//    /*画圆*/
//    //边框圆
//    CGContextSetRGBStrokeColor(context,1,1,1,1.0);//画笔线的颜色
//    CGContextSetLineWidth(context, 1.0);//线的宽度
//    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
//    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
//    CGContextAddArc(context, 100, 20, 15, 0, 2*PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
//    
//    //填充圆，无边框
//    CGContextAddArc(context, 150, 30, 30, 0, 2*PI, 0); //添加一个圆
//    CGContextDrawPath(context, kCGPathFill);//绘制填充
//    
//    //画大圆并填充颜
//    UIColor*aColor = [UIColor colorWithRed:1 green:0.0 blue:0 alpha:1];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    CGContextSetLineWidth(context, 3.0);//线的宽度
//    CGContextAddArc(context, 250, 40, 40, 0, 2*PI, 0); //添加一个圆
//    //kCGPathFill填充非零绕数规则,kCGPathEOFill表示用奇偶规则,kCGPathStroke路径,kCGPathFillStroke路径填充,kCGPathEOFillStroke表示描线，不是填充
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
//    
//    /*画线及孤线*/
//    //画线
//    CGPoint aPoints[2];//坐标点
//    aPoints[0] =CGPointMake(100, 80);//坐标1
//    aPoints[1] =CGPointMake(130, 80);//坐标2
//    //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
//    //points[]坐标数组，和count大小
//    CGContextAddLines(context, aPoints, 2);//添加线
//    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
//    
//    //画笑脸弧线
//    //左
//    CGContextSetRGBStrokeColor(context, 0, 0, 1, 1);//改变画笔颜色
//    CGContextMoveToPoint(context, 140, 80);//开始坐标p1
//    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
//    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
//    CGContextAddArcToPoint(context, 148, 68, 156, 80, 10);
//    CGContextStrokePath(context);//绘画路径
//    
//    //右
//    CGContextMoveToPoint(context, 160, 80);//开始坐标p1
//    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
//    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
//    CGContextAddArcToPoint(context, 168, 68, 176, 80, 10);
//    CGContextStrokePath(context);//绘画路径
//    
//    //右
//    CGContextMoveToPoint(context, 150, 90);//开始坐标p1
//    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
//    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
//    CGContextAddArcToPoint(context, 158, 102, 166, 90, 10);
//    CGContextStrokePath(context);//绘画路径
//    //注，如果还是没弄明白怎么回事，请参考：http://donbe.blog.163.com/blog/static/138048021201052093633776/
//    
//    /*画矩形*/
//    CGContextStrokeRect(context,CGRectMake(100, 120, 10, 10));//画方框
//    CGContextFillRect(context,CGRectMake(120, 120, 10, 10));//填充框
//    //矩形，并填弃颜色
//    CGContextSetLineWidth(context, 2.0);//线的宽度
//    aColor = [UIColor blueColor];//blue蓝色
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    aColor = [UIColor yellowColor];
//    CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
//    CGContextAddRect(context,CGRectMake(140, 120, 60, 30));//画方框
//    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
//    
//    //矩形，并填弃渐变颜色
//    //关于颜色参考http://blog.sina.com.cn/s/blog_6ec3c9ce01015v3c.html
//    //http://blog.csdn.net/reylen/article/details/8622932
//    //第一种填充方式，第一种方式必须导入类库quartcore并#import <QuartzCore/QuartzCore.h>，这个就不属于在context上画，而是将层插入到view层上面。那么这里就设计到Quartz Core 图层编程了。
//    CAGradientLayer *gradient1 = [CAGradientLayer layer];
//    gradient1.frame = CGRectMake(240, 120, 60, 30);
//    gradient1.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor,
//                        (id)[UIColor grayColor].CGColor,
//                        (id)[UIColor blackColor].CGColor,
//                        (id)[UIColor yellowColor].CGColor,
//                        (id)[UIColor blueColor].CGColor,
//                        (id)[UIColor redColor].CGColor,
//                        (id)[UIColor greenColor].CGColor,
//                        (id)[UIColor orangeColor].CGColor,
//                        (id)[UIColor brownColor].CGColor,nil];
//    [self.layer insertSublayer:gradient1 atIndex:0];
//    //第二种填充方式
//    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        1,1,1, 1.00,
//        1,1,0, 1.00,
//        1,0,0, 1.00,
//        1,0,1, 1.00,
//        0,1,1, 1.00,
//        0,1,0, 1.00,
//        0,0,1, 1.00,
//        0,0,0, 1.00,
//    };
//    CGGradientRef gradient = CGGradientCreateWithColorComponents
//    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//形成梯形，渐变的效果
//    CGColorSpaceRelease(rgb);
//    //画线形成一个矩形
//    //CGContextSaveGState与CGContextRestoreGState的作用
//    /*
//     CGContextSaveGState函数的作用是将当前图形状态推入堆栈。之后，您对图形状态所做的修改会影响随后的描画操作，但不影响存储在堆栈中的拷贝。在修改完成后，您可以通过CGContextRestoreGState函数把堆栈顶部的状态弹出，返回到之前的图形状态。这种推入和弹出的方式是回到之前图形状态的快速方法，避免逐个撤消所有的状态修改；这也是将某些状态（比如裁剪路径）恢复到原有设置的唯一方式。
//     */
//    CGContextSaveGState(context);
//    CGContextMoveToPoint(context, 220, 90);
//    CGContextAddLineToPoint(context, 240, 90);
//    CGContextAddLineToPoint(context, 240, 110);
//    CGContextAddLineToPoint(context, 220, 110);
//    CGContextClip(context);//context裁剪路径,后续操作的路径
//    //CGContextDrawLinearGradient(CGContextRef context,CGGradientRef gradient, CGPoint startPoint, CGPoint endPoint,CGGradientDrawingOptions options)
//    //gradient渐变颜色,startPoint开始渐变的起始位置,endPoint结束坐标,options开始坐标之前or开始之后开始渐变
//    CGContextDrawLinearGradient(context, gradient,CGPointMake
//                                (220,90) ,CGPointMake(240,110),
//                                kCGGradientDrawsAfterEndLocation);
//    CGContextRestoreGState(context);// 恢复到之前的context
//    
//    //再写一个看看效果
//    CGContextSaveGState(context);
//    CGContextMoveToPoint(context, 260, 90);
//    CGContextAddLineToPoint(context, 280, 90);
//    CGContextAddLineToPoint(context, 280, 100);
//    CGContextAddLineToPoint(context, 260, 100);
//    CGContextClip(context);//裁剪路径
//    //说白了，开始坐标和结束坐标是控制渐变的方向和形状
//    CGContextDrawLinearGradient(context, gradient,CGPointMake
//                                (260, 90) ,CGPointMake(260, 100),
//                                kCGGradientDrawsAfterEndLocation);
//    CGContextRestoreGState(context);// 恢复到之前的context
//    
//    //下面再看一个颜色渐变的圆
//    CGContextDrawRadialGradient(context, gradient, CGPointMake(300, 100), 0.0, CGPointMake(300, 100), 10, kCGGradientDrawsBeforeStartLocation);
//    
//    /*画扇形和椭圆*/
//    //画扇形，也就画圆，只不过是设置角度的大小，形成一个扇形
//    aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:1];
//    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
//    //以10为半径围绕圆心画指定角度扇形
//    CGContextMoveToPoint(context, 160, 180);
//    CGContextAddArc(context, 160, 180, 30,  -60 * PI / 180, -120 * PI / 180, 1);
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
//    
//    //画椭圆
//    CGContextAddEllipseInRect(context, CGRectMake(160, 180, 20, 8)); //椭圆
//    CGContextDrawPath(context, kCGPathFillStroke);
//    
//    /*画三角形*/
//    //只要三个点就行跟画一条线方式一样，把三点连接起来
//    CGPoint sPoints[3];//坐标点
//    sPoints[0] =CGPointMake(100, 220);//坐标1
//    sPoints[1] =CGPointMake(130, 220);//坐标2
//    sPoints[2] =CGPointMake(130, 160);//坐标3
//    CGContextAddLines(context, sPoints, 3);//添加线
//    CGContextClosePath(context);//封起来
//    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
//    
//    /*画圆角矩形*/
//    float fw = 180;
//    float fh = 280;
//    
//    CGContextMoveToPoint(context, fw, fh-20);  // 开始坐标右边开始
//    CGContextAddArcToPoint(context, fw, fh, fw-20, fh, 10);  // 右下角角度
//    CGContextAddArcToPoint(context, 120, fh, 120, fh-20, 10); // 左下角角度
//    CGContextAddArcToPoint(context, 120, 250, fw-20, 250, 10); // 左上角
//    CGContextAddArcToPoint(context, fw, 250, fw, fh-20, 10); // 右上角
//    CGContextClosePath(context);
//    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
//    
//    /*画贝塞尔曲线*/
//    //二次曲线
//    CGContextMoveToPoint(context, 120, 300);//设置Path的起点
//    CGContextAddQuadCurveToPoint(context,190, 310, 120, 390);//设置贝塞尔曲线的控制点坐标和终点坐标
//    CGContextStrokePath(context);
//    //三次曲线函数
//    CGContextMoveToPoint(context, 200, 300);//设置Path的起点
//    CGContextAddCurveToPoint(context,250, 280, 250, 400, 280, 300);//设置贝塞尔曲线的控制点坐标和控制点坐标终点坐标
//    CGContextStrokePath(context);
//    
//    
//    /*图片*/
//    UIImage *image = [UIImage imageNamed:@"apple.jpg"];
//    [image drawInRect:CGRectMake(60, 340, 20, 20)];//在坐标中画出图片
//    //    [image drawAtPoint:CGPointMake(100, 340)];//保持图片大小在point点开始画图片，可以把注释去掉看看
//    CGContextDrawImage(context, CGRectMake(100, 340, 20, 20), image.CGImage);//使用这个使图片上下颠倒了，参考http://blog.csdn.net/koupoo/article/details/8670024
//    
//    //    CGContextDrawTiledImage(context, CGRectMake(0, 0, 20, 20), image.CGImage);//平铺图
//    
//}

#pragma mark - Draw image for animation
-(UIImage *)drawCurrentState {
    float targetHeight = kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
    
    UIGraphicsBeginImageContext(CGSizeMake(kVRGCalendarViewWidth, targetHeight-kVRGCalendarViewTopBarHeight));
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -kVRGCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Init
-(id)init {
    self = [super initWithFrame:CGRectMake(0, 0, kVRGCalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds=YES;
        
        isAnimating=NO;
        self.labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, kVRGCalendarViewWidth-68, 40)];
        [self addSubview:labelCurrentMonth];
        labelCurrentMonth.backgroundColor=[UIColor whiteColor];
        labelCurrentMonth.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        labelCurrentMonth.textColor = [UIColor colorWithHexString:@"0x383838"];
        labelCurrentMonth.textAlignment = UITextAlignmentCenter;
        
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1]; //so delegate can be set after init and still get called on init
        //        [self reset];
    }
    return self;
}

-(void)dealloc {
    
    self.delegate=nil;
    self.currentMonth=nil;
    self.labelCurrentMonth=nil;
    
    self.markedDates=nil;
    self.markedColors=nil;
    
    [super dealloc];
}
@end

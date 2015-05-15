//
//  PickerView.m
//  
//
//  Created by Wu YouJian on 8/20/11.
//  Copyright 2011 asiainfo-linkage. All rights reserved.
//

#import "PickerView.h"



@interface PickerView(Private)

- (id)initWithFrame:(CGRect)frame;
- (void)layoutTableListPickerView;
- (void)layoutDatePicker;
- (void)buttonAction:(id)sender;

@end


@implementation PickerView
@synthesize delegate;
@synthesize tableNameList;
@synthesize type;
@synthesize	selTableIndex;
@synthesize selDate;
@synthesize minDate;


// 单实例模式
static PickerView     *sharedPickerView = nil;


+(PickerView*)sharedPickerView:(CGRect)frame
{
    @synchronized ([PickerView class]) {
        if (sharedPickerView == nil) { 
			sharedPickerView = [[PickerView alloc] initWithFrame:frame];
			[[[UIApplication sharedApplication] keyWindow] addSubview:sharedPickerView];
        }
    }
	
    sharedPickerView.hidden = YES;	
    return sharedPickerView;
}


#pragma mark -
#pragma mark UI Methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		UIView *bview = [[UIView alloc] initWithFrame:frame];
		bview.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
		[self addSubview:bview];
		[bview release];
		
		UIView *bview1 = [[UIView alloc] initWithFrame:CGRectMake(0,436,320,44)];
		bview1.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
		[self addSubview:bview1];
		[bview1 release];
		
		[self layoutDatePicker];
		[self layoutTableListPickerView];
	
		//确定按钮
        UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        OKBtn.frame = CGRectMake(40,440,60,36);
        [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
        [OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        OKBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [OKBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        OKBtn.tag = kOkTag;
        [OKBtn setBackgroundImage:[[UIImage imageNamed:@"button2.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
        
        [OKBtn setBackgroundImage:[[UIImage imageNamed:@"button2.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		OKBtn.titleLabel.textAlignment = UITextAlignmentCenter;
		OKBtn.showsTouchWhenHighlighted = YES;
		[self addSubview:OKBtn];
        
		//取消按钮
        UIButton *CancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CancelBtn.frame = CGRectMake(220,440,60,36);
        [CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [CancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        CancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [CancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        CancelBtn.tag = kCancelTag;
        [CancelBtn setBackgroundImage:[[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
        
        [CancelBtn setBackgroundImage:[[UIImage imageNamed:@"button2.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateHighlighted];
		CancelBtn.titleLabel.textAlignment = UITextAlignmentCenter;
		CancelBtn.showsTouchWhenHighlighted = YES;
		[self addSubview:CancelBtn];

		
		
    }
    return self;
}

- (void)layoutTableListPickerView {	
	CGFloat frmWidth = self.frame.size.width;	
	CGFloat frmHeight = self.frame.size.height;
	
	tableListPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 220, frmWidth,frmHeight-240)];
	tableListPickerView.delegate = self;
	tableListPickerView.dataSource = self;
	tableListPickerView.contentMode = UIViewContentModeCenter;
	tableListPickerView.backgroundColor = [UIColor blackColor];
	tableListPickerView.showsSelectionIndicator = YES;
	
	
	[self addSubview:tableListPickerView];	
}


- (void)layoutDatePicker {	
	CGFloat frmWidth = self.frame.size.width;	
	CGFloat frmHeight = self.frame.size.height;
	
	CGRect datePickerFrame = CGRectMake(0, 220, frmWidth, frmHeight-240);
	datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	datePicker.backgroundColor = [UIColor blackColor];
	datePicker.tag = kDateSelectPickerTag;
	[datePicker setFrame:datePickerFrame];
	
	datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	datePicker.datePickerMode = UIDatePickerModeDate;
	
	[datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//	NSLocale* loc = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//	[datePicker setLocale:loc];
//	//NSLog(@"localeIdentifier:%@",[loc localeIdentifier]);
//	[loc release];
//	
//	NSCalendar* calendar = [[NSCalendar alloc] init];
//	[calendar setLocale:loc];
//	[datePicker setCalendar:calendar];
//	[calendar release];
	
//	NSDateFormatter* dateF = [[NSDateFormatter alloc] init];
//	[dateF setDateFormat:@"yyyyMMdd"];
//	[datePicker setDate:[dateF dateFromString:@"20080808"]];	

	//
    if (minDate != nil ) {
        [datePicker setMinimumDate:minDate];
    }else{        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:00];
        [components setMinute:00];
        [components setSecond:00];
        [components setDay:1]; 
        [components setMonth:1]; 
        [components setYear:2010];
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (4.0 <= version) {
            [components setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        }
        NSDate *date = [gregorian dateFromComponents:components];
        [gregorian release];
        [components release];
        
        [datePicker setMinimumDate:date];
    }

	[self addSubview:datePicker];
	
	coverView = [[UIView alloc] initWithFrame:CGRectMake(220,220,100,frmHeight-240)];
	coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];;
	[self addSubview:coverView];
	coverView.hidden = YES;
}

-(void)ShowPickerView:(viewType)itype cover:(BOOL)bcover
{
	self.type = itype;
	self.hidden = NO;
	
	switch (type) {
		case enum_dateType:
		{
			datePicker.hidden = NO;
			tableListPickerView.hidden = YES;

			NSLocale* loc = [NSLocale currentLocale];
			NSString* locId = [loc localeIdentifier];
			//NSLog(@"locId:%@",locId);
			
			if ([locId isEqualToString:@"zh_CN"]) {
				coverView.hidden = !bcover;
			}else {
				coverView.hidden = YES;
			}
			if (self.selDate != nil) {
                [datePicker setDate:self.selDate];
            }else{
                [datePicker setDate:[NSDate date]];
            }
			
			break;
		}
		case enum_listType:
		{
			datePicker.hidden = YES;
			coverView.hidden = YES;
			tableListPickerView.hidden = NO;
			
			[tableListPickerView reloadComponent:0];
			[tableListPickerView selectRow:self.selTableIndex inComponent:0 animated:YES];	
			break;
		}
		default:
			break;
	}	
}

-(void)HiddenPickerView
{	
	self.hidden = YES;
}



-(void)buttonAction:(id)sender
{
	UIButton* btn = (UIButton*)sender;
	if (btn.tag == kOkTag) {
		if (self.delegate != nil) {
			switch (self.type) {
				case enum_dateType:
					[self.delegate getSelectDate:[datePicker date]];
					break;
				case enum_listType:
					[self.delegate getSelectTable:self.selTableIndex];
					break;
				default:
					break;
			}
		}
	}else {		
	}
	
	[self HiddenPickerView];
}





#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger num = 0;
	switch (component) {
		case 0:	
		{
			if (pickerView == tableListPickerView) {
				num = [self.tableNameList count];
			}
			
			break;
		}
		default:
			break;
	}
	return num;	
}

#pragma mark - Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView*)pickerView 
             titleForRow:(NSInteger)row 
            forComponent:(NSInteger)component
{
	switch (component) {
		case 0:	
		{
			if (pickerView == tableListPickerView) {
				return [self.tableNameList objectAtIndex:row];
			}
		}	
		default:
			return @"-";
	}
}

- (void)pickerView:(UIPickerView *)pickerView
	  didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component
{	
	if (component == 0) {
		if (pickerView == tableListPickerView) {
			self.selTableIndex = row;
		}
	}
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(16.0,
																0,
																[pickerView rowSizeForComponent:component].width, 
																[pickerView rowSizeForComponent:component].height)] autorelease];
	if (pickerView == tableListPickerView) {
		[label setText:[self.tableNameList objectAtIndex:row]];
	}
	
	label.lineBreakMode = UILineBreakModeMiddleTruncation;
	[label setFont:[UIFont boldSystemFontOfSize:24]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextAlignment:UITextAlignmentCenter];
	return label;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[datePicker release];
	[tableNameList release];
	[coverView release];
	[tableListPickerView release];	
	[selDate release];	
	[super dealloc];
}


@end

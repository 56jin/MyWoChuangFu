//
//  PickerView.h
//  
//
//  Created by Wu YouJian on 8/20/11.
//  Copyright 2011 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kDateSelectPickerTag  400
#define kOkTag				  401
#define kCancelTag			  402


typedef enum{
    enum_dateType,
    enum_listType
    
}viewType;

@protocol UIPickerViewHiddenDelegate

@optional
-(void)getSelectTable:(NSInteger)index;
-(void)getSelectDate:(NSDate*)selectDate;
@end

@interface PickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate> {
	UIDatePicker* datePicker;
	UIPickerView* tableListPickerView;
    UIView* coverView;
	
	viewType type;
	NSArray* tableNameList;
	
	id <UIPickerViewHiddenDelegate> delegate;
	NSInteger selTableIndex;
	NSDate* selDate;
    
    NSDate* minDate;
}

@property(nonatomic, assign)id <UIPickerViewHiddenDelegate> delegate;
@property(nonatomic,assign)viewType type;
@property(nonatomic,retain)NSArray* tableNameList;
@property(nonatomic,assign)NSInteger selTableIndex;
@property(nonatomic,retain)NSDate* selDate;
@property(nonatomic,retain)NSDate* minDate;


+(PickerView*)sharedPickerView:(CGRect)frame;
-(void)ShowPickerView:(viewType)itype cover:(BOOL)bcover;
-(void)HiddenPickerView;



@end

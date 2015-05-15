//
//  ZSYCommonPickerView.m
//  WNMPro
//
//  Created by Zhu Shouyu on 6/17/13.
//  Copyright (c) 2013 朱守宇. All rights reserved.
//

static const char * const cancelButtonKey = "cancelButtonKey";
static const char * const makeSureButtonKey = "makeSureButtonKey";

#import "ZSYCommonPickerView.h"
#import <objc/runtime.h>
#import "DataDictionary_back_cart_item.h"


@interface ZSYCommonPickerView ()

@property (nonatomic, retain) NSArray *pickerViewDatasource;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) UIPickerView *mainPickerView;
@property (nonatomic, retain) UIToolbar *mainToobar;

@property (nonatomic, retain) UIControl *mainControl;
@property (nonatomic,retain)UIBarButtonItem *btnItemDismiss;

@end

@implementation ZSYCommonPickerView

@synthesize pickerViewDatasource = _pickerViewDatasource;
@synthesize selectedIndex = _selectedIndex;
@synthesize mainPickerView = _mainPickerView;
@synthesize mainToobar = _mainToobar;
@synthesize btnItemDismiss;
@synthesize mainControl = _mainControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIColor*) createColorByHex:(NSString *)hexColor
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

- (id)initWithTitle:(NSString *)title
         includeAll:(BOOL)includeAll
         dataSource:(NSArray *)datasource
  selectedIndexPath:(NSInteger)selectedIndex
           Firstrow:(NSString *)Str
  cancelButtonBlock:(ZSYCommonPickerViewCancelButtonBlock)cancelBlock
makeSureButtonBlock:(ZSYCommonPickerViewMakeSureButtonBlock)makeSureBlock
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])
    {
        NSMutableArray *allValues = [[NSMutableArray alloc] initWithCapacity:1];
        if (includeAll)
        {
            DataDictionary_back_cart_item *item = [[DataDictionary_back_cart_item alloc] init];
            item.ITEM_CODE = @"";
            item.ITEM_NAME = Str;
            [allValues addObject:item];
            [item release];
        }
        [allValues addObjectsFromArray:datasource];
        _pickerViewDatasource = [[NSArray alloc] initWithArray:allValues];
        [allValues release];
        
        _mainControl = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _mainControl.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [_mainControl addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_mainControl];
        objc_setAssociatedObject(self, cancelButtonKey, [cancelBlock copy], OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(self, makeSureButtonKey, [makeSureBlock copy], OBJC_ASSOCIATION_RETAIN);
        btnItemDismiss = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked:)];
        btnItemDismiss.width=60.0;
        UIBarButtonItem *btnSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 43)];
        lab.backgroundColor=[UIColor clearColor];
#ifdef __IPHONE_6_0
        lab.textAlignment = NSTextAlignmentCenter;
#else
        lab.textAlignment = UITextAlignmentCenter;
#endif
        lab.textColor=[UIColor whiteColor];
        lab.font=[UIFont boldSystemFontOfSize:19];
        lab.text=title;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithCustomView:lab];
        
        UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        btnSpace.title=title;
        UIBarButtonItem *btnSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *btnItemConfirmstart = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(makeSureButtonClicked:)];
        btnItemConfirmstart.width=60.0;
        _mainToobar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 255.0f, 320, 43.0f)];
        [_mainToobar setBarStyle:UIBarStyleBlackTranslucent];
        
        _mainToobar.items = [NSArray arrayWithObjects:btnItemDismiss,btnSpace2, space, btnSpace1,btnItemConfirmstart, nil];
        _mainToobar.alpha = 1.0f;
        [self addSubview:_mainToobar];
        [btnItemConfirmstart release];
        [btnItemDismiss release];
        [space release];
        [lab release];
        [btnSpace release];
        [btnSpace1 release];
        [btnSpace2 release];
        
        _mainPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 215.0f, self.bounds.size.width, 220.0f)];
        _mainPickerView.backgroundColor=[UIColor whiteColor];
        _mainPickerView.dataSource = self;
        _mainPickerView.delegate = self;
        _mainPickerView.alpha = 1.0f;
        _mainPickerView.showsSelectionIndicator=YES;
        if (selectedIndex >= 0 && selectedIndex <= [_pickerViewDatasource count])
        {
            [_mainPickerView selectRow:selectedIndex inComponent:0 animated:YES];
        }
        [self addSubview:_mainPickerView];
    }
    return self;
}

- (void)touchForDismissSelf:(id)sender
{
    [self disMiss];
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    [self animatedIn];
}

- (void)disMiss
{
    ZSYCommonPickerViewCancelButtonBlock cancelBlock;
    cancelBlock = objc_getAssociatedObject(self, cancelButtonKey);
    if (cancelBlock)
    {
        cancelBlock();
    }
    [self animatedOut];
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.0f, 0.0f);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.mainControl removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

- (void)cancelButtonClicked:(id)sender
{
    ZSYCommonPickerViewCancelButtonBlock cancelBlock;
    cancelBlock = objc_getAssociatedObject(self, cancelButtonKey);
    if (cancelBlock)
    {
        cancelBlock();
    }
    [self animatedOut];
}

- (void)makeSureButtonClicked:(id)sender
{
    ZSYCommonPickerViewMakeSureButtonBlock makeSureBlock;
    makeSureBlock = objc_getAssociatedObject(self, makeSureButtonKey);
    if (makeSureBlock)
    {
        self.selectedIndex = [self.mainPickerView selectedRowInComponent:0];
        makeSureBlock(self.selectedIndex);
    }
    [self animatedOut];
}
#pragma mark - UIPickerViewDatasource
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    DataDictionary_back_cart_item *item = [self.pickerViewDatasource objectAtIndex:row];
    return item.ITEM_NAME;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerViewDatasource count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    if(!retval)
    {
        retval = [[[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)] autorelease];
    }
    retval.font = [UIFont boldSystemFontOfSize:18.0f];
    retval.backgroundColor = [UIColor clearColor];
#ifdef __IPHONE_6_0
    retval.textAlignment = NSTextAlignmentCenter;
#else
    retval.textAlignment = UITextAlignmentCenter;
#endif
    DataDictionary_back_cart_item *item = [self.pickerViewDatasource objectAtIndex:row];
    retval.text = item.ITEM_NAME;
    return retval;
}

@end

//
//  ZSYCommonPickerView.h
//  WNMPro
//
//  Created by Zhu Shouyu on 6/17/13.
//  Copyright (c) 2013 朱守宇. All rights reserved.
//

typedef void (^ZSYCommonPickerViewCancelButtonBlock)();

typedef void (^ZSYCommonPickerViewMakeSureButtonBlock)(NSInteger indexPath);

#import <UIKit/UIKit.h>

@interface ZSYCommonPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>


- (id)initWithTitle:(NSString *)title
         includeAll:(BOOL)includeAll
         dataSource:(NSArray *)datasource
  selectedIndexPath:(NSInteger)selectedIndex
           Firstrow:(NSString *)Str
  cancelButtonBlock:(ZSYCommonPickerViewCancelButtonBlock)cancelBlock
makeSureButtonBlock:(ZSYCommonPickerViewMakeSureButtonBlock)makeSureBlock;

- (void)show;

- (void)disMiss;

@end


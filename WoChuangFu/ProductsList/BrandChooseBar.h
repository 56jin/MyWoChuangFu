//
//  BrandChooseBar.h
//  WoChuangFu
//
//  Created by 李新新 on 15-1-25.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandChooseBar;
@protocol BrandChooseBarDelegate <NSObject>

@optional
- (void)brandChooseBar:(BrandChooseBar *)bar didSelectedRowAtIndex:(NSInteger)index;

@end

@interface BrandChooseBar : UIView

@property (nonatomic,strong) NSArray *brands;
@property (nonatomic,assign) id       delegate;

@end

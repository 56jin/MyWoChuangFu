//
//  AddressComBox.h
//  WoChuangFu
//
//  Created by 李新新 on 15-2-7.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddressComBox;
@protocol AddressComBoxDelegate <NSObject>

@optional
- (void)addressComBox:(AddressComBox *)comBoxView didSelectAtIndex:(NSInteger)index withData:(NSDictionary *)data;

@end


@interface AddressComBox : UIView

@property(nonatomic,strong) NSArray *dataSources;
@property(nonatomic,assign) id<AddressComBoxDelegate> delegate;

-(void)setLabelToLeft;
-(void)reloadTbData;
-(id)initWithFrame:(CGRect)frame isPacke:(BOOL)ispake;

-(void)setData:(NSArray*)arr;
@end

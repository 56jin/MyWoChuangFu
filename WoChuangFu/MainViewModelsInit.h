//
//  MainViewModelsInit.h
//  WoChuangFu
//
//  Created by duwl on 12/11/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MODEL_0_HEIGHT      200/2
#define MODEL_1_HEIGHT      298/2
#define MODEL_2_HEIGHT      108/2
#define MODEL_3_HEIGHT      350/2
#define MODEL_4_HEIGHT      (89+295+190+20)/2
#define MODEL_5_HEIGHT      478/2
#define MODEL_6_HEIGHT      148/2
#define MODEL_7_HEIGHT      390/2


@interface MainViewModelsInit : UIView<UIScrollViewDelegate>

@property(nonatomic,strong) NSTimer *timer;

-(id)initWithFrame:(CGRect)frame Data:(NSDictionary*)dic;
@end

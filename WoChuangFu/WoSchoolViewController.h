//
//  WoSchoolViewController.h
//  WoChuangFu
//
//  Created by 陈亦海 on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimeBlock)(void);

@class MLTableAlert;
@interface WoSchoolViewController : UIViewController{
    NSDictionary* params;
    NSString *isChangGui;
}
@property (strong, nonatomic) MLTableAlert *alert;
@property(nonatomic,retain)NSDictionary* params;
@property (nonatomic,strong)NSMutableArray *cardOrderKeyValuelist;
@property (nonatomic)NSString *isChangGui;
@property(nonatomic,copy) TimeBlock timeBlock;

-(void)setIsCG:(NSString *)_isChangGui;
@end

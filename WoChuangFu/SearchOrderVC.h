//
//  SearchOrderVC.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/15.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHeader.h"
#import "TitleBar.h"
#import "CommonMacro.h"
#import "SeachedTermVC.h"
#import "CellStyle.h"

@interface SearchOrderVC : UIViewController<UITableViewDataSource,UITableViewDelegate,HttpBackDelegate,MyHeaderDelegate,TitleBarDelegate>

/**
 用来获取 Delegate 传过来的值
 */
@property (strong, nonatomic)  NSString *orderCode;         //传入的订单号
@property (strong, nonatomic)  NSString *receiverPhoneNum;  //传入的收件人手机号码
@property (strong, nonatomic)  NSString *certNum;           //传入的入网人证件号码


@end

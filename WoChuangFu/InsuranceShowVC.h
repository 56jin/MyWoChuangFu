//
//  InsuranceShowVC.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/29.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsuranceShowVC : UIViewController

@property(nonatomic,strong)NSString      *userName;        //订单号
@property(nonatomic,strong)NSString      *userPhoneNum; //收件人手机号码
@property(nonatomic,strong)NSString      *certNum;          //证件号码
@property(nonatomic,strong)NSString      *phoneName;//手机型号
@property(nonatomic,strong)NSString      *imeiNub;//手机IMEI号
@property(nonatomic,strong)NSString      *phoneType;//手机品牌


@end

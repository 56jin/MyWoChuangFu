//
//  ChooseNumVC.h
//  WoChuangFu
//
//  Created by duwl on 12/1/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ChooseNumVC : UIViewController<HttpBackDelegate,CLLocationManagerDelegate>

@property (nonatomic,copy)void(^block)(NSMutableDictionary *dict);
@property (nonatomic,copy)NSString *productID;

@end

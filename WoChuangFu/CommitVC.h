//
//  CommitVC.h
//  WoChuangFu
//
//  Created by duwl on 12/15/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleBar.h"
#import "CommitView.h"

@interface CommitVC : UIViewController<
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        CommitDelegate,
                        NSURLConnectionDelegate,
                        HttpBackDelegate,
                        TitleBarDelegate>
@property(nonatomic,strong)TitleBar* titleBar;
@property(nonatomic,strong)CommitView* commitView;
@property(nonatomic,strong)NSDictionary*receiveData;
@property(nonatomic,strong)UIImage*    photoImage;
@property(nonatomic,copy)NSString*   saveedUploadPhotoId;
@property(nonatomic,assign)BOOL isNeedCertInfo;

@end

//
//  CommitView.h
//  WoChuangFu
//
//  Created by duwl on 12/15/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsetsLabel.h"

typedef enum
{
    TypeContract = 1001,
    TypeCard = 1002,
    TypeNet = 1011,
    TypePhone = 1004,
    TypeParts = 1005
}DetailType;

typedef enum enterDataTag{
    UPLOAD_PHOTO_BTN = 315,
    UPLOAD_PHOTO_IMG,
    ENTER_NAME,
    ENTER_CER,
    ENTER_RECEIVER_NAME,
    ENTER_CONTRACT,
    SELECT_READ_PROTOCAL,
    SELECT_PACKAGE_TYPE,
    SELECT_ADDR_AREA,
    ENTER_ADDR_DETAIL,
    ENTER_RECEPE,
    ENTER_MARK,
    LABEL_PAY_VALUE,
    COMMIT_ORDER,
    UPLOAD_PHOTO_BACK_BTN,
    UPLOAD_PHOTO_BACK_IMG,
    IDCARD_SCROLL_VIEW
}enterDataTag;

@protocol CommitDelegate<NSObject>
@optional
//调用相机
-(void)showCamera;
//提交数据
-(void)commitRequestData:(NSDictionary*)data;
//请求区县数据
-(void)requestAreaData;
-(void)showProtocal:(NSString *)userName;
@end

@interface CommitView : UIView<UIScrollViewDelegate,UITextFieldDelegate>
{
    DetailType myType;
}
@property(nonatomic,assign)id<CommitDelegate> target;
@property(nonatomic,strong)UIScrollView* scrollView;
@property(nonatomic,strong)NSArray*    pkgDataArray;

- (id)initWithFrame:(CGRect)frame productType:(DetailType)type;

//选择区县后，刷新区县数据
-(void)updateAreaData:(NSString*)area;
- (void)updataPriceinfo:(NSString *)price;
-(void)initAreaData:(NSString*)area;

- (void)setNeedUploadIDCardBack;

@end

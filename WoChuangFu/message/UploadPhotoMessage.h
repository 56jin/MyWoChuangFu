//
//  UploadPhotoMessage.h
//  WoChuangFu
//
//  Created by duwl on 12/16/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "message.h"

#define UPLOAD_PHOTO_BIZCODE @"cf_upload_photo"

@interface UploadPhotoMessage : message
{
    NSString* saveId;
}

@property(nonatomic,retain)NSString* saveId;

+ (NSString*)getBizCode;

@end

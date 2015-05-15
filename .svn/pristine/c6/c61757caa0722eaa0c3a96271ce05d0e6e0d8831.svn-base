//
//  UploadPhotoMessage.m
//  WoChuangFu
//
//  Created by duwl on 12/16/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "UploadPhotoMessage.h"

@implementation UploadPhotoMessage
@synthesize saveId;

-(void)dealloc
{
    if(saveId != nil){
        [saveId release];
    }
    [super dealloc];
}

- (NSString *)getRequest
{
	return [requestInfo objectForKey:@"photoStr"];//[message hexStringDes:requestStr withEncrypt:YES];
}

-(void)parseOther
{
    [super parseOther];
    [self parseMessage];
}

- (void)parseResponse:(NSString *)responseMessage
{
    NSLog(@"responseMessage=%@",responseMessage);
    saveId = responseMessage;
}

+ (NSString*)getBizCode
{
    return UPLOAD_PHOTO_BIZCODE;
}

- (NSString*)getBusinessCode
{
	return UPLOAD_PHOTO_BIZCODE;
}

-(void)parseMessage
{
    
}
@end

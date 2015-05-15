//
//  ResourceGetter.h
//  WoChuangFu
//
//  Created by duwl on 12/9/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IPHONE_4_5_WIDTH        320
#define IPHONE_5_HEIGHT         568
#define IPHONE_6_WIDTH          375
#define IPHONE_6_HEIGHT         667
#define IPHONE_6_PLUS_WIDTH     414
#define IPHONE_6_PLUS_HEIGHT    734

@interface ResourceGetter : NSObject{
    
}

+(id)getAddustImageResourceWitnId:(NSString*)image_id;
+(float)getAddustWidthWithDefault:(float)value;
+(float)getAddustHeightWithDefault:(float)value;
@end

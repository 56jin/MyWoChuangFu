//
//  ResourceGetter.m
//  WoChuangFu
//
//  Created by duwl on 12/9/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "ResourceGetter.h"

@implementation ResourceGetter

+(id)getAddustImageResourceWitnId:(NSString*)image_id
{
    UIImage* image = nil;
    
    switch ((int)[AppDelegate sharePhoneWidth]) {
        case IPHONE_4_5_WIDTH:
            image = [UIImage imageNamed:[image_id stringByAppendingString:@".png"]];
            break;
        case IPHONE_6_WIDTH:
            image= [UIImage imageNamed:[image_id stringByAppendingString:@"@2x.png"]];
            if(image == nil){
                image = [UIImage imageNamed:[image_id stringByAppendingString:@".png"]];
            }
            break;
        case IPHONE_6_PLUS_WIDTH:
            image= [UIImage imageNamed:[image_id stringByAppendingString:@"@3x.png"]];
            if(image == nil){
                image = [UIImage imageNamed:[image_id stringByAppendingString:@"@2x.png"]];
                if(image == nil){
                    image = [UIImage imageNamed:[image_id stringByAppendingString:@".png"]];
                }
            }
            break;
        default:
            break;
    }
    
    return image;
};

+(float)getAddustWidthWithDefault:(float)value
{
    float add_value = value;
    switch ((int)[AppDelegate sharePhoneWidth]) {
        case IPHONE_6_WIDTH:
            add_value = value / IPHONE_4_5_WIDTH * IPHONE_6_WIDTH;
        case IPHONE_6_PLUS_WIDTH:
            add_value = value / IPHONE_4_5_WIDTH * IPHONE_6_PLUS_WIDTH;
        default:
            break;
    }
    return add_value;
}

+(float)getAddustHeightWithDefault:(float)value
{
    float add_value = value;
    switch ((int)[AppDelegate sharePhoneHeight]) {
        case IPHONE_6_HEIGHT:
            add_value = value / IPHONE_5_HEIGHT * IPHONE_6_HEIGHT;
        case IPHONE_6_PLUS_HEIGHT:
            add_value = value / IPHONE_5_HEIGHT * IPHONE_6_PLUS_HEIGHT;
        default:
            break;
    }
    return add_value;
}

@end

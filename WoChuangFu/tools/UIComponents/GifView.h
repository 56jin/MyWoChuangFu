//
//  GifView.h
//  SaleToolsKit
//
//  Created by syerven on 12-3-15.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GifView : UIView{
    CGImageSourceRef gif;
	NSDictionary *gifProperties;
	size_t index;
	size_t count;
	NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath;

@end

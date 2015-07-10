//
//  ReaderDelegate.h
//  IOS_Client_Audio
//
//  Created by BlueElf on 13-4-19.
//  Copyright (c) 2013年 BlueElf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICardReaderEvent.h"

@protocol ReaderDelegate <NSObject>

//call-back method
-(void)onReaderStatusChanged:(BOOL) isConnected;
-(void)onCardStatusChanged:(BOOL) isConnected;


@end

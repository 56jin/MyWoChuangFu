//
//  ICardReaderEvent.h
//  IOS_Client_Audio
//
//  Created by BlueElf on 13-4-19.
//  Copyright (c) 2013年 BlueElf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICardReaderEvent : NSObject{
    BOOL isReaderConnected;
    BOOL isCardConnected;
}

-(BOOL)isReaderConnected;
-(BOOL)isCardConnected;
-(void)setReaderConnected:(BOOL)isReaderConnected;
-(void)setCardConnected:(BOOL)isCardConnected;

@end

//
//  btReader.h
//  btReaderTest
//
//  Created by Chenfan on 3/31/15.
//  Copyright (c) 2015 Chenfan. All rights reserved.
//

#ifndef __btReader_h
#define __btReader_h

#import <UIKit/UIKit.h>


#define ERR_SUCCESS				0
#define ERR_NO_READER			-1
#define ERR_OPEN_ID				-2
#define ERR_DATA_ERROR			-3
#define ERR_AUTH_ID				-4
#define ERR_READ_ID				-5
#define ERR_INVALID_PARA		-6
#define ERR_NET_ERROR			-7
#define ERR_SAM_ERROR			-8
#define ERR_RESET_ID			-9
#define ERR_CLOSE_ID			-10
#define ERR_ICC_NO_CARD         -11
#define ERR_NO_ID               1

@protocol btReaderDelegate;

@interface btReader : NSObject

@property (strong, nonatomic) id<btReaderDelegate> delegate;
-(void)openReader:(NSString*)name;
-(void)closeReader;
-(int)readid:(NSString*)srvAddr port:(int)port retry:(int)retry_count;
-(int)getSerialNum:(uint8_t*)serialNum length:(int*)serlen;
-(int)cardPoweron:(uint8_t*)atr length:(int*)atrlen;
-(int)cardTransmit:(uint8_t*)apdu apdulen:(int)apdulen response:(uint8_t*)response reslen:(int*)reslen;
-(int)getVersion:(uint8_t*)ver length:(int*)verlen;
-(int)changePeripheralName:(NSString*)nameString;
@end

@protocol btReaderDelegate <NSObject>

@required

-(void)didConnected;
-(void)disConnected;
-(void)updateDeviceName:(NSString*)name;
-(void)idName:(NSString*)name;
-(void)idImage:(NSData*)image;
-(void)id_readState:(int)state;
@end

#endif

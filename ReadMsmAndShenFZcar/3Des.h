//
//  3Des.h
//  BLECardReaderDemoCode
//
//  Created by kaer on 15-3-24.
//  Copyright (c) 2015年 kaer. All rights reserved.
//

#ifndef __BLECardReaderDemoCode___Des__
#define __BLECardReaderDemoCode___Des__

#include <stdio.h>
typedef unsigned short int				u16;
typedef unsigned char					u8;
typedef unsigned int					u32;
typedef unsigned short int				uint16;
typedef unsigned char					uint8;


void MsgDesDecrypt(uint8 *src,uint16 len);
void MsgDesEncrypt(uint8 *src,uint16 len);
void Des_PsamEncrypt(uint8 *key,uint8 *encrypt_data);
void Des3_Decrypt(uint8 *src, uint8 *dst, uint16 src_len,uint8 *key);
void Des3_Encrypt(uint8 *src, uint8 *dst, uint16 src_len,uint8 *key);
#endif /* defined(__BLECardReaderDemoCode___Des__) */

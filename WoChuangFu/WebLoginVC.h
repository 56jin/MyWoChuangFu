//
//  WebLoginVC.h
//  WoChuangFu
//
//  Created by 郑渊文 on 14/11/13.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebLoginVC : UIViewController<UIWebViewDelegate>
{
    NSString* Url;
}
@property(nonatomic,retain)NSString* Url;


@end

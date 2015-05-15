//
//  RemoteImageView.h
//  WOXTXPro
//
//  Created by Donghai Cheng on 12-7-17.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RemoteImageViewDelegate;

@interface RemoteImageView : UIView<ASIHTTPRequestDelegate>
{
    NSString *localFolder;
    NSString *defaultImage;
    UIImageView *imageView;
    BOOL subFlag;
    id<RemoteImageViewDelegate> delegate;
    NSString *imageUrl;
    
    ASIHTTPRequest *request;
}

@property(nonatomic,retain)NSString *imageUrl;

@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)NSString *localFolder;
@property(nonatomic,retain)NSString *defaultImage;
@property(nonatomic,assign) id<RemoteImageViewDelegate> delegate;

-(void)setLocalFolder:(NSString *)localfolder andDefaultImage:(NSString *)defaultimage;
- (BOOL)dataPath;
-(void)loadImages:(NSString *)url;
-(void)fillImage:(UIImage *)image;
-(void)setLoadingViewFrame;
- (id)initWithFrame:(CGRect)frame 
    withLocalFolder:(NSString *)localfolder 
       defaultImage:(NSString *)defaultImg;
-(void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style;
-(void)setImageViewFrame:(CGRect)rect;
-(void)setImage:(UIImage *)image;
-(void)loadImageNamed:(NSString *)url isRomate:(BOOL)isRomate;
-(void)loadSubImageNamed:(NSString *)url isRomate:(BOOL)isRomate;
-(void)setSubImg:(UIImage *)image;
-(void)resizeImgRect:(CGSize)imgSize frameSize:(CGSize)frameSize;

@end
@protocol RemoteImageViewDelegate <NSObject>

@optional
-(void)remoteImageDidLoadEnd:(RemoteImageView *)imageView image:(UIImage *)image;
-(void)remoteImageView:(RemoteImageView *)imageView clickImageBegan:(NSString *)imageurl;
-(void)remoteImageView:(RemoteImageView *)imageView clickImageEnd:(NSString *)imageurl;
@end
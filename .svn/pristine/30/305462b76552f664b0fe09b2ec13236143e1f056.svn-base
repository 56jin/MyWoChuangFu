//
//  RemoteImageView.m
//  WOXTXPro
//
//  Created by Donghai Cheng on 12-7-17.
//  Copyright (c) 2012年 asiainfo-linkage. All rights reserved.
//

#import "RemoteImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "ComponentsFactory.h"
#import "UIImage+Resize.h"

#define loadingViewTag 12

@interface RemoteImageView(Private)
-(void)removeLoadingImage;
-(void)layoutImageView;
-(UIImage *)scaleImage:(UIImage *)image scaleFactor:(float)scaleBy;


@end



@implementation RemoteImageView
@synthesize imageView;
@synthesize localFolder;
@synthesize defaultImage;
@synthesize delegate;
@synthesize imageUrl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.localFolder = [self defaultPath];
        self.defaultImage = @"defaultImage.png";
        [self layoutImageView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame 
    withLocalFolder:(NSString *)localfolder 
       defaultImage:(NSString *)defaultImg 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (localfolder == nil || localfolder.length == 0) {
            self.localFolder = [self defaultPath];
        } else {
            self.localFolder = localfolder;
        }
        self.defaultImage = defaultImg;
        [self layoutImageView];
   
    }
    return self;
}

- (NSString*)defaultPath
{
    NSString* path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
                      stringByAppendingPathComponent:@"Temp"];
    
    return [[[NSString alloc] initWithFormat:@"%@",path] autorelease];
}


-(void)layoutImageView
{
    subFlag = NO;
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:self.defaultImage];
    
    [self addSubview:imageView];
    UIActivityIndicatorView  *avt = [[UIActivityIndicatorView alloc] 
                                     init];
    
    avt.tag = loadingViewTag;
    
    [avt setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [imageView addSubview:avt];
    [avt release];
    
    [self setLoadingViewFrame];
}

-(void)setImageViewFrame:(CGRect)rect
{
    imageView.frame = rect;
}

-(void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *avt = (UIActivityIndicatorView *)[imageView viewWithTag:loadingViewTag];
    if (avt) {
        [avt setActivityIndicatorViewStyle:style];
    }
}

-(void)removeLoadingImage
{
    UIActivityIndicatorView *avt = (UIActivityIndicatorView *)[imageView viewWithTag:loadingViewTag];
    
    if ([avt isAnimating]) {
        [avt stopAnimating];
    }
    [avt removeFromSuperview];
    avt = nil;
}

-(void)setLocalFolder:(NSString *)localfolder andDefaultImage:(NSString *)defaultimage
{
    self.localFolder = localfolder;
    self.defaultImage = defaultimage;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setImageViewFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self setLoadingViewFrame];
}

-(void)setLoadingViewFrame
{
    UIView *view = [imageView viewWithTag:loadingViewTag];
    if (view) {
        UIActivityIndicatorView *avt = (UIActivityIndicatorView *)view;
        [avt setCenter:CGPointMake(imageView.frame.size.width/2.0, imageView.frame.size.height/2.0)];
    }
    
}
//创建目录
- (BOOL)dataPath
{
    
    BOOL bo =  [[NSFileManager defaultManager] createDirectoryAtPath:self.localFolder withIntermediateDirectories:YES attributes:nil error:nil];
    if (!bo) {
        NSLog(@"创建目录失败！");
    }
    return bo;
}

-(void)loadImages:(NSString *)url {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *urlString =  url;//[self.arrayImage objectAtIndex:index.section];
   // NSLog(@"%@",urlString);
    if (![urlString isEqualToString:@""]) {
        NSArray *imgUrlArray = [urlString componentsSeparatedByString:@"/"];
        //提取图片名
        NSString *imgNameForSave = [NSString stringWithFormat:@"%@",[imgUrlArray lastObject]];
        //图片保存路径
        NSString *imgFilePath = [NSString stringWithFormat:@"%@/%@",self.localFolder,imgNameForSave];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        UIActivityIndicatorView *avt = (UIActivityIndicatorView *)[imageView viewWithTag:loadingViewTag];

        //本地无图片时从服务器下载
        if (![fileManager fileExistsAtPath:imgFilePath]) {
            [avt startAnimating];
            if ([self dataPath]) {
                
                NSURL *imgUrl = [NSURL URLWithString:urlString];
                NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
                
                UIImage *image;
                //下载不到图片
                if ([imgData bytes] == 0) {
                    NSLog(@"无图");
                    image = [UIImage imageNamed:self.defaultImage];
                }
                else {
                    image = [UIImage imageWithData:imgData];
                    //保存图片到savedImagePath路径下
                   // NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",self.localFolder,imgNameForSave]];
                    [imgData writeToFile:imgFilePath atomically:YES];
                }
                
                [self performSelectorOnMainThread:@selector(fillImage:) withObject:image  waitUntilDone:NO];
            }
            else {
                //目录创建失败，使用默认图片
                UIImage *image = [UIImage imageNamed:self.defaultImage];
                [self performSelectorOnMainThread:@selector(fillImage:) withObject:image  waitUntilDone:NO];
            }
        }
        else {
            UIImage *image = [UIImage imageWithContentsOfFile:imgFilePath];
            [self performSelectorOnMainThread:@selector(fillImage:) withObject:image  waitUntilDone:NO];
        }
        
    }
    else {
        //图片url为@“”
        UIImage *image = [UIImage imageNamed:self.defaultImage];
        //保存图片到savedImagePath路径下    
        [self performSelectorOnMainThread:@selector(fillImage:) withObject:image  waitUntilDone:NO];        
    }
    [pool release];
    
}

-(void)loadImages2:(NSString *)url {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSString *urlString =  url;//[self.arrayImage objectAtIndex:index.section];
    // NSLog(@"%@",urlString);
    if (![urlString isEqualToString:@""]) {
        NSArray *imgUrlArray = [urlString componentsSeparatedByString:@"/"];
        //提取图片名
        NSString *imgNameForSave = [NSString stringWithFormat:@"%@",[imgUrlArray lastObject]];
        //图片保存路径
        NSString *imgFilePath = [NSString stringWithFormat:@"%@/%@",self.localFolder,imgNameForSave];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        UIActivityIndicatorView *avt = (UIActivityIndicatorView *)[imageView viewWithTag:loadingViewTag];
        
        //本地无图片时从服务器下载
        if (![fileManager fileExistsAtPath:imgFilePath]) {
            [avt startAnimating];
            if ([self dataPath]) {
                
                NSURL *imgUrl = [NSURL URLWithString:urlString];
                
                if (request != nil) {
                    request.delegate = nil;
                    [request cancel];
                    [request release];
                    request = nil;
                }
                request = [[ASIHTTPRequest alloc]initWithURL:imgUrl];
                [request setTimeOutSeconds:20.0];
                [request setDelegate:self];
                [request setUserInfo:[NSDictionary dictionaryWithObject:imgFilePath forKey:@"ImgFilePath"]];
                NSLog(@"开始请求图片：%@",url);
                [request startAsynchronous];
            
            }
            else {
                //目录创建失败，使用默认图片
                UIImage *image = [UIImage imageNamed:self.defaultImage];
                [self fillImage:image];
                
               // [self performSelectorOnMainThread:@selector(fillImage:) withObject:image  waitUntilDone:NO];
            }
        }
        else {
            NSLog(@"从本地加载图片：%@",imgNameForSave);
            UIImage *image = [UIImage imageWithContentsOfFile:imgFilePath];
            [self fillImage:image];
            //[self performSelectorOnMainThread:@selector(fillImage:) withObject:image  waitUntilDone:NO];
        }
        
    }
    else {
        //图片url为@“”
        UIImage *image = [UIImage imageNamed:self.defaultImage];
        //保存图片到savedImagePath路径下    
        [self fillImage:image];
        //[self performSelectorOnMainThread:@selector(fillImage:) withObject:image  waitUntilDone:NO];        
    }
    [pool release];
    
}
-(void)requestFinished:(ASIHTTPRequest *)_request
{

    NSString *imgFilePath = [[request userInfo] objectForKey:@"ImgFilePath"];
    NSData *imageData = [_request responseData];
    UIImage *img = [UIImage imageWithData:imageData]; 
    [imageData writeToFile:imgFilePath atomically:YES];
    NSLog(@"请求图片成功:%@",[[_request url]absoluteString]);
    [self fillImage:img];
}
-(void)requestFailed:(ASIHTTPRequest *)_request
{
    
    NSLog(@"请求图片失败:%@,错误信息:%@",[[_request url]absoluteString],[_request error]);
    [self fillImage:[UIImage imageNamed:self.defaultImage]];

}

-(UIImage *)scaleImage:(UIImage *)image scaleFactor:(float)scaleBy
{
    CGSize size = CGSizeMake(image.size.width * scaleBy, image.size.height * scaleBy);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform = CGAffineTransformScale(transform, scaleBy, scaleBy);
    CGContextConcatCTM(context, transform);
    
    // Draw the image into the transformed context and return the image
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

-(void)fillImage:(UIImage *)image{
    
    

    [self removeLoadingImage];
    if (image) {
        UIImage *scalImage = nil;
        
        if (image.size.width * image.size.height > 960 * 320 * 2) {
            
            float rate =sqrtf((960 * 320 * 2) / (image.size.width * image.size.height));
            scalImage = [self scaleImage:image scaleFactor:rate];// (UIImage *)[image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:self.frame.size interpolationQuality:kCGInterpolationHigh];
        } else {
            scalImage = image;
        }
            
        if (subFlag) {
            [self setSubImg:scalImage];
        } else {
            imageView.image = scalImage;
        }
        if (self != nil && delegate && [delegate respondsToSelector:@selector(remoteImageDidLoadEnd:image:)]) {
            [delegate remoteImageDidLoadEnd:self image:scalImage];
        }
    }
}


-(void)loadImageNamed:(NSString *)url isRomate:(BOOL)isRomate
{
    self.imageUrl = url;
    
    if (isRomate) {
        [self loadImages2:url];
        //[NSThread detachNewThreadSelector:@selector(loadImages:) toTarget:self withObject:url];
    } else {
        imageView.image = [UIImage imageNamed:url];
        [self removeLoadingImage];
        if (delegate && [delegate respondsToSelector:@selector(remoteImageDidLoadEnd:image:)]) {
            [delegate remoteImageDidLoadEnd:self image:imageView.image];
        }
    }
    
}
-(void)setImage:(UIImage *)image
{
    imageView.image = image;
    [self removeLoadingImage];
}
-(void)setSubImg:(UIImage *)image
{
    float rate1 = image.size.width / image.size.height;
    float rate2 = self.frame.size.width / self.frame.size.height;

    UIImage *img = nil;
    if (rate1 > rate2) {
        img = [ComponentsFactory subImage:image rect:CGRectMake((image.size.width - image.size.height * rate2)/2.0, 0, image.size.height * rate2, image.size.height)];
    } else if(rate1 < rate2) {
        img = [ComponentsFactory subImage:image rect:CGRectMake(0, (image.size.height - image.size.width / rate2)/2.0, image.size.width, image.size.width / rate2)];
    } else {
        img = image;
    }
    imageView.image = img;
}
-(void)loadSubImageNamed:(NSString *)url isRomate:(BOOL)isRomate
{
    subFlag = YES;
    if (isRomate) {
        [self loadImages2:url];
        //[NSThread detachNewThreadSelector:@selector(loadImages:) toTarget:self withObject:url];
    } else {
        [self setSubImg:[UIImage imageNamed:url]];
        [self removeLoadingImage];
        
    }
    
}
-(void)resizeImgRect:(CGSize)imgSize frameSize:(CGSize)frameSize
{
    float x = (frameSize.width - imgSize.width)/2.0;
    float y = (frameSize.height - imgSize.height)/2.0;
    float width = imgSize.width;
    float height = imgSize.height;
    if (x < 0 || y < 0) {
        float rate = 1.0f;
        if (imgSize.height != 0) {
            rate = imgSize.width/imgSize.height;
        }
        
        if (rate > frameSize.width/frameSize.height) {
            width = frameSize.width;
            height = (1.0f / rate)*width ;
            x = 0.0f;
            y = frameSize.height/2.0f - height/2.0f;
        } else {
            height = frameSize.height;
            width = rate * height ;
            x = frameSize.width/2.0f- width/2.0f;
            y = 0.0f;
        }
    }
    imageView.frame = CGRectMake(x, y, width, height);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (delegate && [delegate respondsToSelector:@selector(remoteImageView:clickImageBegan:)]) {
        [delegate remoteImageView:self clickImageBegan:self.imageUrl];
    }
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{   
    [super touchesEnded:touches withEvent:event];
    [self performSelector:@selector(clickSelf:) withObject:nil afterDelay:0.1];
}

-(void)clickSelf:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(remoteImageView:clickImageEnd:)]) {
        [delegate remoteImageView:self clickImageEnd:self.imageUrl];
    }
}
- (void)dealloc {
    
    delegate = nil;
    [imageUrl release];
    [imageView release];
    [defaultImage release];
    [localFolder release];
    if (request != nil) {
        request.delegate = nil;
        [request cancel];
        [request release];
    }
   
    
    [super dealloc];
}
@end

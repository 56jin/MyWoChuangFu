//
//  ImageCheckVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-2-11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ImageCheckVC.h"
#import "FileHelpers.h"

#define SCROLL_VIEW_TAG 8000

@interface ImageCheckVC ()<UIScrollViewDelegate>

@end

@implementation ImageCheckVC

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    [self layoutV];
}

- (void)layoutV
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    scroll.tag = SCROLL_VIEW_TAG;
    scroll.scrollEnabled = YES;
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    scroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scroll];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGesturerecognizer
{
    CGRect rect = tapGesturerecognizer.view.frame;
    rect.size.width = rect.size.width *2;
    rect.size.height = rect.size.height *2;
    tapGesturerecognizer.view.frame =rect;
    UIScrollView *scroll = (UIScrollView *)tapGesturerecognizer.view.superview;
    scroll.contentSize = rect.size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:SCROLL_VIEW_TAG];
    for (int i = 0;i<[self.imageUrls count]; i++) {
        UIScrollView *subScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(i*scroll.frame.size.width,0,scroll.frame.size.width,scroll.frame.size.height)];
        subScroll.scrollEnabled = YES;
        subScroll.pagingEnabled = YES;
        subScroll.delegate = self;
        subScroll.backgroundColor = [UIColor clearColor];
        [scroll addSubview:subScroll];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:subScroll.bounds];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [imageView addGestureRecognizer:tap];
        [subScroll addSubview:imageView];
        if (hasCachedImage([NSURL URLWithString:self.imageUrls[i]])){
            UIImage *image = [UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:self.imageUrls[i]])];
            [imageView setImage:image];
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.imageUrls[i],@"url",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *image)
             {
                 [imageView setImage:image];
             }];
        }
        scroll.contentSize = CGSizeMake(scroll.frame.size.width*self.imageUrls.count,0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

#pragma mark
#pragma mark - 异步图片
- (UIImage *)LoadImage:(NSDictionary*)aDic{
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    NSData *data=[NSData dataWithContentsOfURL:aURL];
    if (data == nil) {
        return nil;
    }
    UIImage *image=[UIImage imageWithData:data];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    [fileManager createFileAtPath:pathForURL(aURL) contents:data attributes:nil];
    return image;
}

@end

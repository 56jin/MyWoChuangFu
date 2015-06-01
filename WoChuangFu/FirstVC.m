//
//  FirstVC.m
//  WoChuangFu
//
//  Created by 颜 梁坚 on 14-7-15.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "FirstVC.h"
#import "FileHelpers.h"
#import "LoginVC.h"
#import "UIDevice-Reachability.h"
#import "webVC.h"
#import <ShareSDK/ShareSDK.h>
#import "WebLoginVC.h"
#import "DesToHexString.h"
#import "GTMBase64_My.h"

@interface FirstVC ()

@property(nonatomic,retain)NSDictionary *SendDic;

@end

@implementation FirstVC

@synthesize delegate;
@synthesize tabDelegate;
@synthesize SendDic;

- (void)viewWillAppear:(BOOL)animated
{
    [NdUncaughtExceptionHandler setDefaultHandler];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version>=7.0){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [UIApplication sharedApplication].statusBarHidden=NO;
    }
    
    bussineDataService *bus=[bussineDataService sharedDataService];
    if(isFirst){
        isFirst=NO;
        if(![[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"]] isEqualToString:@"yes"]){/*第一次登录展示图片*/
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"isFirst"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIImageView *ima=[[UIImageView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
            ima.userInteractionEnabled=YES;
            ima.image=[UIImage imageNamed:@"kanshaomiao.png"];
            ima.tag=202;
            [[[UIApplication sharedApplication] keyWindow] addSubview:ima];
            UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleExitPreview:)];
            [ima addGestureRecognizer:doubleTapGesture];
            [ima release];
        }else{
#ifdef AppStore
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread detachNewThreadSelector:@selector(GetAppStrore) toTarget:self withObject:nil];
            });
#else
            /*版本更新*/
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus updateVersion:nil];
#endif
        }
    }else{
        if(bus.HasLogIn){
            if(isLogINCome){
                isLogINCome=NO;
                [URlStr setString:[NSString stringWithFormat:@"http://o2o.gx10010.com/%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"]]];
                NSURL* url = [NSURL URLWithString:[URlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSURLRequest* request = [NSURLRequest requestWithURL:url];
                [viewWeb loadRequest:request];
//                [TypeStr setString:@"1"];
//                bussineDataService *bussineService = [bussineDataService sharedDataService];
//                bussineService.target=self;
//                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:TypeStr,@"queryType",@"",@"userCode",nil];
//                [bussineService zhuye:data];
//                self.SendDic=data;
//                [data release];
            }
            
//            [self setTopTab];
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 8, 28, 28);
            [btn setBackgroundImage:[UIImage imageNamed:@"caidan.png"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"caidan-on.png"] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(ShowList) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        }
    }
}

-(void)loadView
{
    [super loadView];
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[ComponentsFactory createColorByHex:@"#F8F8F8"];
    self.view = BackV;
    [BackV release];
    self.title=@"沃创富";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    ShujuDic=[[NSMutableDictionary alloc] initWithCapacity:0];
    URlStr = [[NSMutableString alloc] initWithCapacity:0];
    appstoreUrl=[[NSMutableString alloc] initWithCapacity:0];
    [URlStr setString:@"http://o2o.gx10010.com/"];
    isFirst=YES;
    isLogINCome=YES;
    TypeStr=[[NSMutableString alloc] initWithCapacity:0];
    [TypeStr setString:@"0"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 8, 28, 28);
    [btn setBackgroundImage:[UIImage imageNamed:@"Log.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"Log-on.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(Show) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    viewWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height-44)];
    viewWeb.scalesPageToFit = YES;
    viewWeb.delegate=self;
    
    NSURL* url = [NSURL URLWithString:[URlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [viewWeb loadRequest:request];
    [self.view addSubview: viewWeb];
    
//    NSString *test = @"H4sIAAAAAAAAAL2aSZIkuQ1Fr8SZwBIgwfsfSQ+hlaIWMllHqYcaMj3cSeDjD/Ssa8fV2/fZ597mNZqd4VZkaNO7Zh9l+n0nbtzhr0SISd9TmpcpO1ZMM4m7rel8z568PVeIu9Sx/Iw2tXTR09d4+41y/elT6Xe8UOsa/d3+ZhnmcdSkzFbqHp1bll7ncm9Va23rVj9mzj3m7L5jbyumfLP1cFba1rFx5hyj8xizaNdGnb73Vh2ho0nYGqylD6v3tNvi7dZraJnm/bW6a13VS/E515hv8+z7hIrsU6OwgMKDal/5+OH1bdO1bbU3e3lWtFTr9/a5m+orzZRrD9fN3LqMYX2W1eqpOya3l1Etrh1zUY913769i5cl9exxrfX/uT7rstNDjVnWdLbf3OwpOwvRacK3i1aKpL774+9SSqfdZxyPN28z6lju0eNe79bJE7ufXiykWAmAEr5mmXOXdc62U0Vi7rlfYmLVTQdOLVfauKeIL64/om8em2zJ/FyWve/Y2qyO1qwJ17VbdY0zHn18UlrTxh/m3ny52NtgaRbnusauQeW8k3pJ589H5imTPc2Em9DMVuUs3e+ynt4G99u933hOG4ftNsYxtri0bz1H+ymrlhirTAB1pAef0dFP79reDpdX71Dj08D48PFnNDlmo421U8f9bInbWn7vigs+h+uN6bNXXz6WrCs66JzcybbFN2tazMCWM73tNbeoRRzh80PMxlxLKXeCbrRa71StbhT9mVsPBXx9dBpJMZTNnQWa/FSXOa252qABm116bWNT55s4pxTqtwy55dXVemPm6WgwDbSVh1+REkss/PXZ72F7bEervcXfadaQzeDIfCPMrrDPwz+6B5eO3PKqjcE8jKk4cOvN97AV+ynoKsuU4YNedFLHCkA1Fxaxa+9elI6PTcXe3omSU/p4QJESegMHA8TXdaN4O41dXmPWyrV4vQlj63cWPfPRXJgiVvGw2+5+HxZw2mAbtDOSDmzvKiL1NbpIBZh/Kjqel82erUWMASoY/ABji0+9M6u8iOh0YUEWrK+trYXt2a2HEdiguK99G/2jJ0sNcFMXLbZ7gVOmgpZjRw5Da3Sqq4RTlZY7fVPmjsaya1BtVab7aOwOR0OXZRT61lphOtjTba/UxgTaWY2K7wYAh+/JJMoJFW7w1t0OIYM2z/kagH2B5wqeGKVZKgQ+LVmLC5pBUlVqf8sgmVIa7bjMvbIX18oGvEO6ZrS5jwXFAqeYLzoj1/k0rE57yn5L5TGBA7bqsOvlRpJTInqPDBvbZrkTvkiJEKTEYw4oqwcfvmWeF1R2C7hxbk7zJZnZ81sQzYKjx7xAS/aCBAxUwm8KBmBJ+AxWptlJP3wS1tgX/hwzhsIp1bc/xnKPoPAnzmGWQ1GwzZ4KH7HDfHda+LKH0O+spTPnqN7eDVIPyCvkXqn8c2FpKbS+QgCNMYuFsghLQloEKRggjr4CQbrvH6pua7QtecWttjdfQFyt1zo3zBbBxMtKau0bmPbLkA/Qtxk5JoxKvu5wlO555n3Mg0tBG3XlPvnqZAkQJ8wJ8M7uAZEvVs32xZkRY1WdyQUdY6OMXhmLC4/Ac3wP8SnsHXCVAkOIsBEouQMPhMNpNmQ3Cmg7THhDs7avd/9dWFYxYYy67L25ZoCPBwVZ6cp8tbEG1aBkt7dnXJmAHwapo29UH9XhTmdVZeQYzJ6Lw3zsu8wYh/MKiJ3OjIylMBdz5CY5lYzW6h39eFvNaEESWBdG4XwAHKiMnVZ2g2RYG7zTXrKndRqQVMC6D34geCzYm/5qyf60vltQr2LwYWeak9TPe6uBMvgWhdlH0VOEbbX9ZsUunKchsC0fjopA6kZx3w0E3hDCWPAhOgbE0ci22RHFvQ892jiMc5UhyalLz0JdQKL2BzCVWdkFH4V/2IwdPUJCwQ2C5xNSx3l4wbdcmr8WWx8TEOljvBv1YFiQeCjlyWQVHaV0GvBoIJPII9C+EfIAUr0pefwW45V0g32eFb1vMDZgnYIspc9hLNf87JU+5NgEJobnb3SXoWVs6ksWksvW1TBBs8UG+xi2dT9mCfCCd8U64KWsO1jHVGI/+J/GLzgWGY6JiA5FhNeqJxsIqSCFQJEWDZ440bwHk/i+iPyOwuKvp6uDhIAwU8PQ4ahqv/l08A4gazCCBnbRDVpMQ1AwpQvYule1YGwXBR2SNhdGxuCmrhSq0+5xYFQTREchI/S2aaJoYTFqYm0NVYrwfT9gfBG/wnytvSq0gQbJrLoLxgEUQ9Abd8P8pp1Glc6hWigPYp26q8OlaedKhUmGYE6xD+gJnhhkQoMNo9zxpq/2WgZmgQGlSO1i9TU9SNB2KBg0Y1p1YYBwcGwOd5VltHP4lclYSGK5Cx1aAhjS2rAlOAS8TuazcL10qACk8YgCzQ/weMplSqqwWVT/3Epy0Gw3oG3KwsBP9IBWcJz4Rj4NvVMTx5gegZUGfvlhnqCPj8py7w2LCA4GiWFv+DHJxbwE0k7rtOjyI8EYyu5jHzwWN7f9fT0x5jNfhJjDeMFsyNuA59kwTw7G7eWIMsmMxvGhSRcyUtorzgJqson1gy1wRMz+0BO1wmz+EKIdDIN45VPsEAv+3f98xlSIE38BGgvGGY3rOHiIrbILiXaOv7SkRvMwsJMkFZTpYItZF4SETwZFL3kQx0DTUd9x+oXUWHHg5B+0f7BxER+cx4ag6IgcwPBY2X1YEczqoE4t5YW8c6CyCoRzvpKwGqZxcxkRgYde0hJCBBGoF0p1hSkCVqjXhA29OcthIB0i3gv5YznoYGK3BZDchfa8jFANl30/GEildvTv1SmHZlFez0xzssKETOVK/CQqdpLPYGbBygLPTHzHOhr90fz6KPwYtLlQ945WEsNoXieHYYiDUQjDWQg4Qcsfzv10AIA0ktDS9Y+kDlaInUb42DtkBV9nSoJLSbR1pTEhRUzCLeTJnAOQTHIDY2pQOKpPdKoFx8YcA8DIsIqZ3L0dqCeFDVNMPLZGqqhsVgWKfRM73BkK5psUgD0kfLPqlXLdC5RI0qYLUAKGDolD6DTKuox8ZdaSQj4+YECPqUXeFx4b61pPKgT1yttgCfBLtB7skUCYUp9YY0xyIyonZ7+ZNMJ90xujG/BhR9gwD4ATaqY5PT+w0B4yGVqKM36ZuwVs0mC0tiXCCBWsdBKpHvzCZJHYcvpRgWfMOVs8b+HoGJnURhadHtYIXFZIAjrwPheqaxkUgul/TFoBb1guTFcg2cgIaAKekJuTxTdGBWZaOXgNYDJ7B5hCGQFFV9xQ7pb44ElUFBCjtDNa/sN6T3yONwnSBtde/eP5LJt9U9ENEWdGhStZZ6TzVQoWesHXO6ChIwe/xq8/HBnsuPBrlFsORRJi284cyaiDhW4QhKbXZaq+8bsWAek0Qm4NT5fznQeI+KimsGzNLf0av3jNiSnAPhITsSXf+G2p3ZLhr6QnaN/4TcNZ0nJiICbuTmhFoKvk6/XIshAMbnw6FFb4le9gyOYk6J6DIML4AHyvwlKeQJnkNiQQMAI7CSOR6qgkYFjsIA3x4DkGnWBH4qK90OZSHySaDrW9miaihONK2TnC3+MWVSYI1mwZQ/B2gbHfpeFY/HznIwpd2CWbwtGgSxkiyFkdK9ZSRegL2XgUyaQUr6SnCsmgAX3y384MRMqKFcnNGtyafAn83ux60/a+SxHJjMQVkoJg0HFtCeNB5oe71NQf8e1+GJrkGQDg1UW5IOQVqITh8nk6/IYI2fXUxI1vgD/y9AqJY6Rp5RbmeeWByRB+w3hm+QgkeZSRGQHMV29zQA1Y95NnlZgbdGyAJ6uku9tTUC+3Jl1jvy8K2s8emLKSZ2iI6+fWZjnwVzGDWPj5iTKISkU2yzlUEPspWDuYEAtKvI+ZNUvDnicrjmIyatgLzMHOaE0ei4J1uIPUezEUfaZsK2R4Jnnt5QERljdQWWIjfQ6ucvw2cRGtXWnBUWitCHN6GNwlc08QIjxZHUz7ABfst66MLQUkQhf1UoOKMrcMmSUVmMkCfaQn4nSp6SWhGoacfTC1BSsgwpexg8t/zc8ClB5ivAlsKATLGU6r8Q6Es4bHiZsnZdBRLZPtffOjBc92IgplR1+RWTzQSMuXp7jYbuICDr4Wz/PR9XN+wX+uDgdvvoTFYM2j5/kjjfApaKdXGXpLWlslNPzBL0AXI4jxWaXjVSnYIW8Fng2UEGyp3sowOMhu2O1f4x3bCgzArkM/G1L6wjtQHsRtbpnnknztC++HNeKq8Ix57yYzLgjmG84Iw1Ht42LHPRAcGRInlvE3j1myQ4BYSVx53oGVATzcDExcsLiyPPL38eYpd5EH9elk8yBA7zSdeVh8T/vGG1LbHcFELPiSUS8Mt19KiPy2jBxEH9Tg9nmRlPg13tqE+HZKOpoNvX7jbTfxAwpIj/d0gPGFN0elKkzSIHx8NpWnaLC9wHvMkUDeTN40xg2SxXz/Zb5idAYTu0/0KyospLr2dGktfcP4b3xFMYCJFOuS1EUdtxFDcD8EC0LFX8fPl58kDselCtKoPav8xk8gjGSQiR2zyIPbU+bm7uSv6RRA8/CoGrM7oN1OQxcZU6U2Qj1Zh9B5ehiZEbPWRlFwUuajKlDGng/HI9Akhppg2/Ha/UadKHCS+D7loNUkH5wsRowKEAL3kM9p9IpFwWdZHUYF/4WmoIO28ihWA0sSrDy2bcuXMw8utgxqJH2kfIx8wUDT21WMLLZ52Kv313yVZweFUcHiMmNIFMMbs2bDYBr0G40zSs2zKobvffNVsdB8I9PzXZfkWYUnHNCHeYYaZniABZIrX7q6Ii0U3Yp8B4SXwVoTUTBkjwFHqPzX8w3Tn3VkJSxIBvLtV8XK0lmOoyY3T8C/5hv4+yVEDzw121kXRLw8Qvm8pj2ENDgESMINcMC5v84L+QoKXni7dtLoAEW943adug9Yg47SP9IqJinf6Ml3XmA+Ue1AeiRPU0n5sQAXdAvy4SfJBH2vf15MBfX4y/MNwPLUfn70eadBjeRG4AxfxfHv+W65rdoUA068Qd/zPHVM/ElLPzVyErHoq9JTADx+Pd9jxElVQJFit3oZdsf1l0I7+BbzbvlmKM+fuMrr93w3sgEppTJETNLJs+uJSI/ODgpEVQd7RiHQfWmA/Od+Kt9nvv4c+/+u/ZHXMgMjUay0PjR3fOP/bASpYlrmXqFEItgh36IXFKjnO4J/WO8KE9E3FjgQQtgLYHV11OYFA6bffCPoGBYx89NkxKQ0jAEDRyos+RLm1/nRessXpZYMKsSPS+oGtWcJ2G9ttbLVDpRN6oLmwAcrirhPE8x5Xvef+VErGg8VUVqZMMKv/SjqHzTgBuPRkpW/9QZzcIsJJUh2lwe9bLyK7cq/XP0P8ysNgUfoMlAhEtdvv4G/qaCGVEVP+CsSicOqo5Lrisz96/n1Aj4A8JyI7+0pdX6FmkL3+aMhpKKx8oVDr+m89Y/5VS9oePUcHoMF8kQcWoIXsYwI/V+uF9Fl8WfmgpUfBrPXGgOdgBKxyQiKZH1eySxZiMNQxn1T8x0o9XoVdr1wveDtHJkpEzcYxJFehORtaHZQYzICY6Jg/8f+FEareQBtviU90ff5BJIZPsQXQIdJ83wJRmgDM2qfH3ioA3MN9RJFyRH2tCicNtNooViVlFDoNXJCH0+yE8bFPF9sSbI2wlAMSjNWZ/lu7B/q2w7uJzYh8q6MkDuWigQ2UepSRL75E2OFM8z3DiePYOTX/FQV13Ih9fHyx4LKt/5f6QlorXivmT+ccg0niYm4nY7sn58Pw2Sec4J16ar5xogMUfINPxDPn/pabJB+w5OSr62+9Z6dAs/YCRyElcfhGz3DsxEHBelEMdLyZ7BESx3BW9hYhLTa1v7/nsebb63G3qm2Ld/fwmlQUc03DCmW/+95yp9wknzvQmIiTOcPWmnvSZxl9MjjT7Tp8ER/yqeHtNqx9QtNymNnYNzyZ2iW4lQl3xrlTxjCuiwNOJj+CwmF7lCwKAAA";
//    MyLog(@"the start data:%@" ,[test dataUsingEncoding:NSUTF8StringEncoding]);
//    NSData* comData = [self uncompressZippedData:[GTMBase64_My decodeData:[test dataUsingEncoding:NSUTF8StringEncoding]]];
//    MyLog(@"uncompress data :%@",[[[NSString alloc] initWithData:comData encoding:NSUTF8StringEncoding] autorelease]);
//    
//    NSString* ret = [DesToHexString decrypt:[[[NSString alloc] initWithData:comData encoding:NSUTF8StringEncoding] autorelease] withKey:@"MAPP_DESKEY"];
//    MyLog(@"decrypt data :%@",ret);
//    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64-65)];
//    scroll.delegate=self;
//    scroll.showsHorizontalScrollIndicator=NO;
//    scroll.showsVerticalScrollIndicator=NO;
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if(version>=7.0){
//        scroll.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20-44-50);
//    }
//    scroll.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:scroll];
//    [self LayOutV];
    // Do any additional setup after loading the view.
}

-(void)Show
{
    WebLoginVC *log=[[[WebLoginVC alloc] init] autorelease];
    [self.navigationController pushViewController:log animated:YES];
}

-(void)setTopTab
{
    bussineDataService *bus=[bussineDataService sharedDataService];
    
    if([[bus.rspInfo objectForKey:@"menuList"] objectForKey:@"pri_menu"]!=[NSNull null]&&[[[bus.rspInfo objectForKey:@"menuList"] objectForKey:@"pri_menu"] count]>0){
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 8, 28, 28);
        [btn setBackgroundImage:[UIImage imageNamed:@"caidan.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"caidan-on.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(ShowList) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        if(self.tabDelegate!=nil){
            [self.tabDelegate SetTab:[[bus.rspInfo objectForKey:@"menuList"]objectForKey:@"pri_menu"]];
        }
    }else{
        self.navigationItem.rightBarButtonItem=nil;
    }
}

-(NSData *)uncompressZippedData:(NSData *)compressedData

{
    
    
    
    if ([compressedData length] == 0) return compressedData;
    
    
    
    unsigned full_length = [compressedData length];
    
    
    
    unsigned half_length = [compressedData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    
    BOOL done = NO;
    
    int status;
    
    z_stream strm;
    
    strm.next_in = (Bytef *)[compressedData bytes];
    
    strm.avail_in = [compressedData length];
    
    strm.total_out = 0;
    
    strm.zalloc = Z_NULL;
    
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    
    while (!done) {
        
        // Make sure we have enough room and reset the lengths.
        
        if (strm.total_out >= [decompressed length]) {
            
            [decompressed increaseLengthBy: half_length];
            
        }
        
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        
        strm.avail_out = [decompressed length] - strm.total_out;
        
        // Inflate another chunk.
        
        status = inflate (&strm, Z_SYNC_FLUSH);
        
        if (status == Z_STREAM_END) {
            
            done = YES;
            
        } else if (status != Z_OK) {
            
            break;
            
        }
        
        
        
    }
    
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.  
    
    if (done) {  
        
        [decompressed setLength: strm.total_out];  
        
        return [NSData dataWithData: decompressed];  
        
    } else {  
        
        return nil;  
        
    }  
    
}

-(void)ShowList
{
//    if(self.delegate!=nil){
//        [self.delegate ShowList];
//    }
    bussineDataService *bus=[bussineDataService sharedDataService];
    if([bus.loginInfo objectForKey:@"adminUrl"]==[NSNull null]){
        [self showSimpleAlertView:@"跳转失败"];
    }else{
        webVC *web=[[[webVC alloc] initwithStr:[bus.loginInfo objectForKey:@"adminUrl"] title:@"沃创富" withType:@"0"] autorelease];
        [self.navigationController pushViewController:web animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    if (Timer)
	{
		[Timer invalidate];
		Timer = nil;
	}
    self.delegate=nil;
    self.tabDelegate=nil;
    self.SendDic=nil;
    [scroll release];
    [PageArr release];
    [scrView release];
    [_refreshHeaderView release];
    [ShujuDic release];
    [TypeStr release];
    [Page release];
    [super dealloc];
}

-(void)LayOutV
{
    MyEGORefreshTableHeaderView *view = [[MyEGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
    view.backgroundColor=[ComponentsFactory createColorByHex:@"#F8F8F8"];
    view.delegate = self;
    [scroll addSubview:view];
    _refreshHeaderView = view;
    [view release];

    PageArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    scroll.contentSize=CGSizeMake(320, scroll.frame.size.height+1);
    
    
    scrView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    scrView.delegate=self;
    scrView.pagingEnabled=YES;
    scrView.showsHorizontalScrollIndicator =NO;
    [scroll addSubview:scrView];
    [PageArr setArray:[ShujuDic objectForKey:@"header"]];
    
    for (int i=0; i<[PageArr count]; i++) {
        UIImageView *im=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sd"]];
        im.userInteractionEnabled=YES;
        im.backgroundColor=[UIColor whiteColor];
        im.tag=5000+i;
        im.frame=CGRectMake(320*i, 0, 320, 100);
        [scrView addSubview:im];
        
        UITapGestureRecognizer *oneFingerOneTaps =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerOneTaps:)];
        [oneFingerOneTaps setNumberOfTapsRequired:1];
        [oneFingerOneTaps setNumberOfTouchesRequired:1];
        [im addGestureRecognizer:oneFingerOneTaps];
        [oneFingerOneTaps release];
        [im release];
        
        UIImageView *imgV=(UIImageView *)[scrView viewWithTag:5000+i];
        imgV.image=[UIImage imageNamed:@"ic_launcher.png"];
        if (hasCachedImage([NSURL URLWithString:[[PageArr objectAtIndex:i] objectForKey:@"ptPath"]])) {
            imgV.image=[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:[[PageArr objectAtIndex:i] objectForKey:@"ptPath"]])];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[[PageArr objectAtIndex:i] objectForKey:@"ptPath"],@"url",imgV,@"imageView",@"0",@"size",nil];
                [NSThread detachNewThreadSelector:@selector(LoadImage:) toTarget:self withObject:dic];
            });
        }
    }
    
    PageNum=0;
    
    //    scrView.backgroundColor=[UIColor grayColor];
    Page = [[CustomPageControl alloc] initWithFrame:CGRectMake(320-13*[PageArr count], 80, 13*[PageArr count] , 20) sPage:[PageArr count] iPage:0 unEnableColor:[UIColor whiteColor] enableColor:[UIColor orangeColor]];
    [scroll addSubview:Page];
    scrView.contentSize=CGSizeMake(320*Page.sumPage, 100);
    
    NSArray *picarr=[ShujuDic objectForKey:@"menu"];
    int jianju=31;
    int First=27;
    
    for(int i=0;i<([picarr count]%4!=0?[picarr count]/4+1:[picarr count]/4);i++){
        if(i==([picarr count]%4!=0?[picarr count]/4+1:[picarr count]/4)||i==0){
            
        }else{
            UILabel *Lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 100+i*90, [UIScreen mainScreen].bounds.size.width, 1)];
            Lab.backgroundColor=[ComponentsFactory createColorByHex:@"#d0d0d0"];
            [scroll addSubview:Lab];
            [Lab release];
        }
        for(int j=0;j<4;j++){
            if([picarr count]<=(i*4+j)){
                break;
            }else{
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"sd"] forState:UIControlStateNormal];
                btn.titleLabel.font=[UIFont systemFontOfSize:15];
                btn.tag=4000+i*4+j;
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                MyLog(@"%@",[[picarr objectAtIndex:i*4+j] objectForKey:@"name"]);
                [btn setTitle:[[picarr objectAtIndex:i*4+j] objectForKey:@"name"] forState:UIControlStateNormal];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(43.5, -10, -20, -10)];
                btn.frame=CGRectMake(First+j*(jianju+43.5), 120+i*90, 43.5, 43.5);
                [btn addTarget:self action:@selector(Select:) forControlEvents:UIControlEventTouchUpInside];
                [scroll addSubview:btn];
                [btn setBackgroundImage:[UIImage imageNamed:@"ic_launcher.png"] forState:UIControlStateNormal];
                if([[picarr objectAtIndex:i*4+j] objectForKey:@"ptPath"]!=[NSNull null]){
                    NSString *ImageUrl=[[picarr objectAtIndex:i*4+j] objectForKey:@"ptPath"];
                    if (hasCachedImage([NSURL URLWithString:ImageUrl])) {
                        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:ImageUrl])] forState:UIControlStateNormal];
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:ImageUrl,@"url",btn,@"imageView",@"1",@"size",nil];
                            [NSThread detachNewThreadSelector:@selector(LoadImage:) toTarget:self withObject:dic];
                        });
                    }
                }
            }
        }
    }
    
//    MyLog(@"%d",([picarr count]%4!=0?[picarr count]/4+1:[picarr count]/4)*90+120);
    if((([picarr count]%4!=0?[picarr count]/4+1:[picarr count]/4)*90+120)<scroll.frame.size.height){
        
    }else{
        scroll.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, ([picarr count]%4!=0?[picarr count]/4+1:[picarr count]/4)*90+120);
    }
    Timer=[NSTimer scheduledTimerWithTimeInterval:5.0f
                                           target:self
                                         selector:@selector(movePic)
                                         userInfo:nil
                                          repeats:YES];
//    UIImageView *FootV=[[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-64-60, 320, 60)];
////    FootV.backgroundColor=[UIColor clearColor];
//    [self.view addSubview:FootV];
//    if([ShujuDic objectForKey:@"footer"]!=[NSNull null]&&[[ShujuDic objectForKey:@"footer"] isKindOfClass:[NSArray class]]&&[[ShujuDic objectForKey:@"footer"] count]>0){
//        if([[[ShujuDic objectForKey:@"footer"] objectAtIndex:0] objectForKey:@"ptPath"]!=[NSNull null]){
//            NSString *ImageUrl1=[[[ShujuDic objectForKey:@"footer"] objectAtIndex:0] objectForKey:@"ptPath"];
//            if (hasCachedImage([NSURL URLWithString:ImageUrl1])) {
//                FootV.image=[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:ImageUrl1])];
//            }else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:ImageUrl1,@"url",FootV,@"imageView",@"2",@"size",nil];
//                    [NSThread detachNewThreadSelector:@selector(LoadImage:) toTarget:self withObject:dic];
//                });
//            }
//        }
//    }
//    [FootV release];
}

-(void)movePic
{
    [scrView scrollRectToVisible:CGRectMake(PageNum*320, 0, 320, 135) animated:YES];
    if(PageNum == [PageArr count]-1){
        PageNum=0;
    }else{
        PageNum++;
    }
}

-(void)handleExitPreview:(UIGestureRecognizer *)gesture{
    UIImageView *ima=(UIImageView *)[[[UIApplication sharedApplication] keyWindow] viewWithTag:202];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        //        MyNSLog(@"-------------%d", self.imageShowPageControl.currentPage);
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.7;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"rippleEffect";
        [[ima layer] addAnimation:animation forKey:@"animation"];
        ima.alpha = 0.0f;
    }
    
    /*版本更新*/
    bussineDataService *bus=[bussineDataService sharedDataService];
    bus.target=self;
    [bus updateVersion:nil];
}

#pragma mark - Recognizer
-(void)oneFingerOneTaps:(UITapGestureRecognizer*)recognizer{
    UIImageView *tapImageView = (UIImageView *)[recognizer view];
    if([[[ShujuDic objectForKey:@"header"] objectAtIndex:tapImageView.tag-5000] objectForKey:@"clickUrl"]==[NSNull null]){
//        UIAlertView *ar=[[UIAlertView alloc] initWithTitle:@"提示:" message:@"当前暂无点击事件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [ar show];
//        [ar release];
    }else{
        webVC *web=[[[webVC alloc] initwithStr:[[[ShujuDic objectForKey:@"header"] objectAtIndex:tapImageView.tag-5000] objectForKey:@"clickUrl"] title:[[[ShujuDic objectForKey:@"header"] objectAtIndex:tapImageView.tag-5000] objectForKey:@"name"] withType:@"0"] autorelease];
        [self.navigationController pushViewController:web animated:YES];
    }
}

-(void)Select:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if([[[ShujuDic objectForKey:@"menu"] objectAtIndex:btn.tag-4000] objectForKey:@"clickUrl"]==[NSNull null]){
//        UIAlertView *ar=[[UIAlertView alloc] initWithTitle:@"提示:" message:@"当前暂无点击事件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [ar show];
//        [ar release];
    }else{
        webVC *web=[[[webVC alloc] initwithStr:[[[ShujuDic objectForKey:@"menu"] objectAtIndex:btn.tag-4000] objectForKey:@"clickUrl"] title:[[[ShujuDic objectForKey:@"menu"] objectAtIndex:btn.tag-4000] objectForKey:@"name"] withType:@"0"] autorelease];
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == scroll){
        [_refreshHeaderView MyEGORefreshScrollViewWillBeginScroll:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if(scrollView == scroll){
        [_refreshHeaderView MyEGORefreshScrollViewDidScroll:scrollView];
    }else{
        CGFloat pageWidth = scrollView.frame.size.width;
        int page1 = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        Page.currentPage = page1;
        if(page1 == [PageArr count]-1){
            PageNum=0;
        }else{
            PageNum=page1+1;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if(scrollView == scroll){
        [_refreshHeaderView MyEGORefreshScrollViewDidEndDragging:scrollView];
	}
}


#pragma mark -
#pragma mark MyEGORefreshTableHeaderDelegate Methods

- (void)MyEGORefreshTableHeaderDidTriggerRefresh:(MyEGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)MyEGORefreshTableHeaderDataSourceIsLoading:(MyEGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)MyEGORefreshTableHeaderDataSourceLastUpdated:(MyEGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    if ([[UIDevice currentDevice] networkAvailable]) {
        _reloading = YES;
        bussineDataService *bussineService = [bussineDataService sharedDataService];
        bussineService.target=self;
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:TypeStr,@"queryType",@"",@"userCode",nil];
        [bussineService zhuye:data];
        self.SendDic=data;
        [data release];
        
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(animation1) userInfo:nil repeats:NO];
    }else{
//        [self performSelector:@selector(doneLoadingfail) withObject:nil afterDelay:0.5];
//        [self showSimpleAlertView:@"亲，请连接网络！"];
    }
}

-(void)animation1{
    _reloading = NO;
    [_refreshHeaderView MyEGORefreshScrollViewDataSourceDidFinishedLoading:scroll];
}

- (void)doneLoadingTableViewData{
	for(id tmpView in scroll.subviews){
        UIView *LabView = (UIView *)tmpView;
        [LabView removeFromSuperview]; //删除子视图
        
    }
    if (Timer)
	{
		[Timer invalidate];
		Timer = nil;
	}
    
    [self LayOutV];
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView MyEGORefreshScrollViewDataSourceDidFinishedLoading:scroll];
}

-(void)LoadImage:(NSDictionary*)aDic{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL *TureUrl=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    
    NSMutableString *UrlStr=[[NSMutableString alloc] initWithCapacity:0];
    [UrlStr setString:[aDic objectForKey:@"url"]];
    NSURL *aURL=[NSURL URLWithString:UrlStr];
    [UrlStr release];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil) {
        return;
    }
    CGSize origImageSize= [image size];
    
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
    
    if([[aDic objectForKey:@"size"] isEqualToString:@"0"]){
        newRect.size.width=320*2;//150*2;
        newRect.size.height=100*2;//180*2;
    }else if([[aDic objectForKey:@"size"] isEqualToString:@"1"]){
        newRect.size.width=43.5*2;//150*2;
        newRect.size.height=43.5*2;//180*2;
    }else{
        newRect.size.width=320*2;//150*2;
        newRect.size.height=60*2;//180*2;
    }
    
    
    //缩放倍数
    float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    
//    UIGraphicsBeginImageContext(newRect.size);
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 1);
    
    CGRect projectRect;
    projectRect.size.width =ratio * origImageSize.width;
    projectRect.size.height=ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    
    //压缩比例
    NSData *smallData=UIImagePNGRepresentation(small);
    if (smallData) {
        [fileManager createFileAtPath:pathForURL(TureUrl) contents:smallData attributes:nil];
    }
    
    UIView *view=[aDic objectForKey:@"imageView"];
    //判断view是否还存在 如果tablecell已经移出屏幕会被回收 那么什么都不用做，下次滚到该cell 缓存已存在 不需要执行此方法
    if (view!=nil) {
        if([[aDic objectForKey:@"size"] isEqualToString:@"0"]){
            [(UIImageView*)view setImage:small];
        }else if([[aDic objectForKey:@"size"] isEqualToString:@"1"]){
            [(UIButton*)view setBackgroundImage:small forState:UIControlStateNormal];
        }else{
            [(UIImageView*)view setImage:small];
        }
    }
    UIGraphicsEndImageContext();
    [pool release];
}

#pragma mark -
#pragma mark HttpBackDelegate
- (void)requestDidFinished:(NSDictionary*)info
{
//    NSLog(@"%@",info);
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ZhuYeMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
//            MyLog(@"ShujuDic=%@",ShujuDic);
            if([TypeStr isEqualToString:@"0"]){
                bussineDataService *bus=[bussineDataService sharedDataService];
                [ShujuDic setDictionary:[bus.rspInfo objectForKey:@"menuList"]];
                if(isFirst){
                    [self LayOutV];
                    isFirst=NO;
                }else{
                    [self doneLoadingTableViewData];
                }
            }else{
                if(isLogINCome){
                    isLogINCome=NO;
                }else{
                    
                }
                [self setTopTab];
            }
        }else{
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"请求数据异常！";
            }
            if(nil == msg){
                msg = @"请求数据异常！";
            }
            [self showSimpleAlertView:msg];
        }
    }else if([[VersionUpdataMessage getBizCode] isEqualToString:bizCode]){
        if([@"7777" isEqualToString:errCode]){
            //可选升级
            bussineDataService *bus=[bussineDataService sharedDataService];
            [self showAlertViewTitle:@"有新版本发布，是否升级？"
                             message:[bus.rspInfo objectForKey:@"remark"]==[NSNull null]?@"":[bus.rspInfo objectForKey:@"remark"]
                            delegate:self
                                 tag:10106
                   cancelButtonTitle:@"取消"
                   otherButtonTitles:@"确定", nil];
        }else{
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
            NSFileManager* fm=[NSFileManager defaultManager];
            NSData *data = [fm contentsAtPath:path];
            NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            if([str length]!=0){/*有错误上传*/
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
                NSFileManager* fm=[NSFileManager defaultManager];
                NSData *data = [fm contentsAtPath:path];
                NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                [fm removeItemAtPath:path error:nil];
                bussineDataService *bus=[bussineDataService sharedDataService];
                bus.target = self;
                NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"iphone",@"device_info",str,@"error_Content",nil];
                self.sendDic=dic;
                [bus BaoCuoback:dic];
                [dic release];
            }else{/*没错误请求首页*/
//                bussineDataService *bussineService = [bussineDataService sharedDataService];
//                bussineService.target=self;
//                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:TypeStr,@"queryType",@"",@"userCode",nil];
//                [bussineService zhuye:data];
//                self.SendDic=data;
//                [data release];
            }
        }
    }else if([[BaoCuoMessage getBizCode] isEqualToString:bizCode]){
//        bussineDataService *bussineService = [bussineDataService sharedDataService];
//        bussineService.target=self;
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:TypeStr,@"queryType",@"",@"userCode",nil];
//        [bussineService zhuye:data];
//        self.SendDic=data;
//        [data release];
    }
}

- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ZhuYeMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"请求数据失败！";
        }
        if(nil == msg){
            msg = @"请求数据失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10101
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
        
    }else if([[BaoCuoMessage getBizCode] isEqualToString:bizCode]){
//        bussineDataService *bussineService = [bussineDataService sharedDataService];
//        bussineService.target=self;
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:TypeStr,@"queryType",@"",@"userCode",nil];
//        [bussineService zhuye:data];
//        self.SendDic=data;
//        [data release];
    }else if([[VersionUpdataMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"获取新版本失败！";
        }
        if (msg == nil) {
            msg = @"获取新版本失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10102
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
    }
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus zhuye:self.SendDic];
        }
    }else if(alertView.tag==10102){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus updateVersion:self.SendDic];
        }
    }else if(alertView.tag==10106){
        if([buttonTitle isEqualToString:@"确定"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSLog(@"更新地址 %@",bus.updateUrl);
            NSURL* url = [NSURL URLWithString:bus.updateUrl];
            if([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
                exit(0);
            }
        }else{
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
            NSFileManager* fm=[NSFileManager defaultManager];
            NSData *data = [fm contentsAtPath:path];
            NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            if([str length]!=0){/*有错误上传*/
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
                NSFileManager* fm=[NSFileManager defaultManager];
                NSData *data = [fm contentsAtPath:path];
                NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                [fm removeItemAtPath:path error:nil];
                bussineDataService *bus=[bussineDataService sharedDataService];
                bus.target = self;
                NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"iphone",@"device_info",str,@"error_Content",nil];
                self.sendDic=dic;
                [bus BaoCuoback:dic];
                [dic release];
            }else{/*没错误请求首页*/
                
            }
        }
    }else if (alertView.tag==20202){
        if([buttonTitle isEqualToString:@"确认"])
        {
            //打开iTunes  方法一
            if (appstoreUrl == nil) {
                [appstoreUrl setString:@""];
            }else{
        
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
            exit(0);
            
            /*
             // 打开iTunes 方法二:此方法总是提示“无法连接到itunes”，不推荐使用
             NSString *iTunesLink = @"itms-apps://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=692579125&mt=8";
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
             */
        }else{
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
            NSFileManager* fm=[NSFileManager defaultManager];
            NSData *data = [fm contentsAtPath:path];
            NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            if([str length]!=0){/*有错误上传*/
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
                NSFileManager* fm=[NSFileManager defaultManager];
                NSData *data = [fm contentsAtPath:path];
                NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                [fm removeItemAtPath:path error:nil];
                bussineDataService *bus=[bussineDataService sharedDataService];
                bus.target = self;
                NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"iphone",@"device_info",str,@"error_Content",nil];
                self.sendDic=dic;
                [bus BaoCuoback:dic];
                [dic release];
            }else{
                
            }
        }
    }
}

#pragma mark -
#pragma mark AlertView
-(void)showAlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate1 tag:(NSInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles,...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    id arg;
    va_list argList;
    if(nil != otherButtonTitles){
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList,id))) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate1
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    alert.tag = tag;
    for(int i = 0; i < [argsArray count]; i++){
        [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
    }
    [alert show];
    [alert release];
    [argsArray release];
}

-(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    //    [MBProgressHUD showHUDAddedTo:[AppDelegate shareMyApplication].window animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"hideHeader()"];
    //    [MBProgressHUD hideAllHUDsForView:[AppDelegate shareMyApplication].window animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //    [MBProgressHUD hideAllHUDsForView:[AppDelegate shareMyApplication].window animated:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    MyLog(@"url==%@",url);
    MyLog(@"%@",[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"/"]);
    if([[NSString stringWithFormat:@"%@",url] hasPrefix:@"http://o2o.gx10010.com/"]&&[[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"/"] count]<=4){
        return YES;
    }else{
        webVC *web=[[[webVC alloc] initwithStr:[NSString stringWithFormat:@"%@",url] title:@"沃创富" withType:@"0"] autorelease];
        [self.navigationController pushViewController:web animated:YES];
        return NO;
    }
}

-(void)GetAppStrore{
    NSString *newVersion= @"";
    NSString *downloadUrl = @"";
    NSString *releaseNotes = @"";
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=932323446"];
    
    //通过url获取数据
    NSString *jsonResponseString=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    MyLog(@"通过appStore获取的数据是：%@",jsonResponseString);
    
    //解析json数据为数据字典
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data == nil){
        [self showSimpleAlertView:@"网络连接异常！"];
    }else{
        NSDictionary *loginAuthenticationResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //[self dictionaryFromJsonFormatOriginalData:jsonResponseString];
        
        //从数据字典中检出版本号数据
        NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
        if([configData count]==0){
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
            NSFileManager* fm=[NSFileManager defaultManager];
            NSData *data = [fm contentsAtPath:path];
            NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            if([str length]!=0){/*有错误上传*/
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
                NSFileManager* fm=[NSFileManager defaultManager];
                NSData *data = [fm contentsAtPath:path];
                NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                [fm removeItemAtPath:path error:nil];
                bussineDataService *bus=[bussineDataService sharedDataService];
                bus.target = self;
                NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"iphone",@"device_info",str,@"error_Content",nil];
                self.sendDic=dic;
                [bus BaoCuoback:dic];
                [dic release];
            }else{
                
            }
        }else{
            for(id config in configData)
            {
                newVersion = [config valueForKey:@"version"];
                downloadUrl = [config valueForKey:@"trackViewUrl"];
                releaseNotes = [config valueForKey:@"releaseNotes"];
                [appstoreUrl setString:downloadUrl];
            }
            MyLog(@"通过appStore获取的版本号是：%@",newVersion);
            
            //获取本地软件的版本号
            NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"];
            
            //对比发现的新版本和本地的版本
            if ([newVersion floatValue] > [localVersion floatValue])
            {
                UIAlertView *createUserResponseAlert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"有新版本V%@发布，是否升级？",newVersion] message:releaseNotes delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消",nil];
                createUserResponseAlert.tag=20202;
                [createUserResponseAlert show];
                [createUserResponseAlert release];
            }else{
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
                NSFileManager* fm=[NSFileManager defaultManager];
                NSData *data = [fm contentsAtPath:path];
                NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                if([str length]!=0){/*有错误上传*/
                    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Exception.txt"];
                    NSFileManager* fm=[NSFileManager defaultManager];
                    NSData *data = [fm contentsAtPath:path];
                    NSString *str=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
                    [fm removeItemAtPath:path error:nil];
                    bussineDataService *bus=[bussineDataService sharedDataService];
                    bus.target = self;
                    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"iphone",@"device_info",str,@"error_Content",nil];
                    self.sendDic=dic;
                    [bus BaoCuoback:dic];
                    [dic release];
                }else{
                    
                }
            }
        }
    }
}

@end

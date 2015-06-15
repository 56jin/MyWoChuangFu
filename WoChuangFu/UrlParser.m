//
//  UrlParse.m
//  WoChuangFu
//
//  Created by duwl on 12/1/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "UrlParser.h"
#import "ShowWebVC.h"
#import "MoreModuleVC.h"
#import "NewProductDetailVC.h"

#import "ProductDetailVC.h"
#import "SeachedTermVC.h"
#import "CommitVC.h"
#import "ChoosePackageVC.h"
#import "ChooseNumVC.h"
#import "SearchOrderVC.h"
#import "ProductsListVC.h"

@implementation UrlParser

+(void)gotoNewVCWithUrl:(NSString*)clickUrlStr
{
    [self gotoNewVCWithUrl:clickUrlStr VC:nil];
}

//URL解析并实界面跳转
//解析规则：？后面的为参数，前面的以最后两个/中的内容决定跳转界面
+(void)gotoNewVCWithUrl:(NSString*)clickUrlStr VC:(UIViewController*)startVC{
    
    if ([clickUrlStr isEqualToString:@"gotoMore"])
    {
        MoreModuleVC *moreModuleVC = [[MoreModuleVC alloc] init];
        [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_PAGE_URL_PARSE object:moreModuleVC];
        [moreModuleVC release];
        return;
    }
//    NSURL *url=[NSURL URLWithString:[clickUrlStr stringByReplacingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)]];
        NSURL *url=[NSURL URLWithString:clickUrlStr];
    MyLog(@"%@",url);
    MyLog(@"Path components as array: %@", [url pathComponents]);
    MyLog(@"Query: %@", [url query]);
    
    UIViewController* gotoVC = nil;// [[[ShowWebVC alloc] init] autorelease];
//    ((ShowWebVC*)gotoVC).urlStr = clickUrlStr;
    
    //根据[url pathComponents]确定下一个跳转界面
    NSMutableArray *urlCom= nil;
    NSMutableArray *paramsArr=nil;
    if(url == nil){ //如果url无法转换成功
        NSArray *allArr = [[clickUrlStr stringByReplacingPercentEscapesUsingEncoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)] componentsSeparatedByString:@"?"];
        if(allArr.count <2){
            urlCom = [[NSMutableArray alloc] init];
            paramsArr = [[NSMutableArray alloc] init];
        } else {
            urlCom = [[NSMutableArray alloc] initWithArray:[[allArr objectAtIndex:0] componentsSeparatedByString:@"/"]];
            
            paramsArr = [[NSMutableArray alloc] initWithArray:[[allArr objectAtIndex:1] componentsSeparatedByString:@"&"]];
        }
    } else {
        urlCom = [[NSMutableArray alloc] initWithArray:[url pathComponents]];
        paramsArr=[[NSMutableArray alloc] initWithArray:[[url query] componentsSeparatedByString:@"&"]];
    }
    
    NSMutableDictionary* paramsDic = [[NSMutableDictionary alloc] init];
    if([urlCom count] >2){
        
        if([[urlCom objectAtIndex:[urlCom count]-2] isEqualToString:@"emallorder"]||[[urlCom objectAtIndex:[urlCom count]-2] isEqualToString:@"emallcardorder"]){
            if([[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"choiceTreaty.do"]||
               [[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"choiceTreatyDetail.do"]||
               [[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"choicebroadBandDetail.do"]||
               [[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"numbCardDetail.do"]){
                //判断是否带有productId
                BOOL isDetail = NO;
                
                for(int i=0;i<paramsArr.count;i++){
                    if([[paramsArr objectAtIndex:i] rangeOfString:@"productId="].length > 0){
                        MyLog(@"productId: %@", [paramsArr objectAtIndex:i]);
                        isDetail = YES;
                    }
                    
                    NSArray* keyV = [[paramsArr objectAtIndex:i] componentsSeparatedByString:@"="];
                    if(keyV.count >1){
                        NSString *object = [[[keyV objectAtIndex:1] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        [paramsDic setObject:object forKey:[keyV objectAtIndex:0]];
                    }
                }
                
                if(isDetail){//详情界面
//                    [paramsDic setObject:@"1" forKey:@""];
                    if (![paramsDic[@"productId"] isEqualToString:@"10056"]&&
                        ![paramsDic[@"productId"] isEqualToString:@"30090"]&&
                        ![paramsDic[@"productId"] isEqualToString:@"30010"]&&!
                        [paramsDic[@"productId"] isEqualToString:@"30070"]) {
                        gotoVC = [[[NewProductDetailVC alloc] init] autorelease];
                        ((NewProductDetailVC*)gotoVC).params = paramsDic;
                    }
                } else {//列表界面
                    gotoVC = [[[ProductsListVC alloc] init] autorelease];
                    ((ProductsListVC*)gotoVC).params = paramsDic;
                }
            }
        }else if([[urlCom objectAtIndex:[urlCom count]-2] isEqualToString:@"netPostionController"]){
            if([[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"initMap.do"]){
                //周边营业厅
            }
        }else if([[urlCom objectAtIndex:[urlCom count]-2] isEqualToString:@"emallfloworder"]){
            if([[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"jhllb.do"]){
                //订流量
            }
        }
    } else if([urlCom count] > 0){
        if([[urlCom objectAtIndex:[urlCom count]-1] isEqualToString:@"qry"]){//查询订单
            gotoVC = [[[SeachedTermVC alloc] init] autorelease];
        }
    }
    
    [paramsDic release];
    [urlCom release];
    [paramsArr release];
    
    if(gotoVC == nil){
        gotoVC = [[[ShowWebVC alloc] init] autorelease];
        ((ShowWebVC*)gotoVC).urlStr = clickUrlStr;
    }
    
//    gotoVC.hidesBottomBarWhenPushed = NO;
    
    gotoVC.hidesBottomBarWhenPushed = [gotoVC isKindOfClass:[ProductsListVC class]] ? NO : YES;
    //根据[url query]获取传给下一个界面的参数
    if(startVC == nil){
        [[NSNotificationCenter defaultCenter] postNotificationName:MAIN_PAGE_URL_PARSE object:gotoVC];
    } else {
        [startVC.navigationController pushViewController:gotoVC animated:YES];
    }
}

@end

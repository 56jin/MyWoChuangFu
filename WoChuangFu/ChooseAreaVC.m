//
//  ChooseAreaVC.m
//  WoChuangFu
//
//  Created by duwl on 12/19/14.
//  Copyright (c) 2014 asiainfo-linkage. All rights reserved.
//

#import "ChooseAreaVC.h"
#import "ChooseAreaMessage.h"
#import "passParams.h"

#define TABLE_VIEW_TAG  200

@interface ChooseAreaVC ()
{
    NSArray* areaData;
}

@property(nonatomic,retain)NSArray* areaData;
@end


@implementation ChooseAreaVC

@synthesize params;
@synthesize areaData;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)dealloc
{
    if(params != nil){
        [params release];
    }
    if(areaData != nil){
        [areaData release];
    }
    [super dealloc];
}

-(void)loadView
{
    [super loadView];
    CGRect ScF=[UIScreen mainScreen].bounds;
    UIView *BackV=[[UIView alloc] initWithFrame:ScF];
    BackV.backgroundColor=[UIColor blackColor];//[ComponentsFactory createColorByHex:@"#F8F8F8"];
    self.view = BackV;
    [BackV release];
    self.navigationController.navigationBarHidden=YES;
}

- (void)layoutTitleBar
{
    TitleBar* title = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:left_position];
    [title setLeftIsHiden:NO];
    if (IOS7){
        title.frame = CGRectMake(0, 20, [AppDelegate sharePhoneWidth], TITLE_BAR_HEIGHT);
    }
    NSString* titleStr = [self.params objectForKey:@"title_str"];
    if(titleStr != nil && titleStr.length >0){
        [title setTitle:titleStr];
    } else {
        [title setTitle:@"选择地区"];
    }
    title.target = self;
    [self.view addSubview:title];
    [title release];
}

- (void)layoutContentTable
{
    UITableView* table = [[UITableView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+SYSTEM_BAR_HEIGHT, [AppDelegate sharePhoneWidth], [AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-SYSTEM_BAR_HEIGHT) style:UITableViewStylePlain];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    table.dataSource = self;
    table.delegate = self;
    table.tag = TABLE_VIEW_TAG;
    [self.view addSubview:table];
    [table release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutTitleBar];
    [self layoutContentTable];
    
    [self sendRequestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma
#pragma TitleBarDelegate
-(void)backAction
{
//    [[passParams sharePassParams].params removeObjectForKey:@"cityCode"];
//    [[passParams sharePassParams].params removeObjectForKey:@"countryCode"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma
#pragma TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return areaData==nil?0:[areaData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellStr=@"CellStr";
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:CellStr];
    if(Cell == nil){
        Cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr] autorelease];
        Cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        Cell.selectionStyle=UITableViewCellSelectionStyleNone;
        Cell.backgroundColor=[ComponentsFactory createColorByHex:@"#ffffff"];
    }
    Cell.textLabel.text=[[areaData objectAtIndex:indexPath.row] objectForKey:@"areaName"];
    Cell.textLabel.font= [UIFont systemFontOfSize:15];
    return Cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* requestDic = [self.params objectForKey:@"request_data" ];
    if(requestDic != nil &&
       (NSObject*)requestDic != [NSNull null] &&
       [requestDic objectForKey:@"cityCode"] != nil &&
       ![[requestDic objectForKey:@"cityCode"] isEqualToString:@""])
    {
        //cityCode不为空当前选择的是区县
        UIViewController *callViewVC = [[self.navigationController viewControllers] objectAtIndex:[self.navigationController viewControllers].count-3];
        
        [[passParams sharePassParams].params setObject:[self.areaData objectAtIndex:indexPath.row] forKey:@"countryCode"];
        
        [self.navigationController popToViewController:callViewVC animated:YES];
        
    } else {
        //跳转下一级
        ChooseAreaVC* chooseArea = [[ChooseAreaVC alloc] init];
        [[passParams sharePassParams].params setObject:[self.areaData objectAtIndex:indexPath.row] forKey:@"cityCode"];
        
        NSDictionary* request_data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"",@"provinceCode",
                                      [[self.areaData objectAtIndex:indexPath.row] objectForKey:@"areaCode"],@"cityCode",
                                      @"",@"countryCode",nil];
        NSDictionary* dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"选择区县",@"title_str",
                             request_data,@"request_data", nil];
        [request_data release];
        chooseArea.params = dic;
        [dic release];
        
        [self.navigationController pushViewController:chooseArea animated:YES];
        [chooseArea release];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

#pragma
#pragma http
-(void)sendRequestData
{
    bussineDataService* buss = [bussineDataService sharedDataService];
    buss.target = self;
    NSDictionary* requestDic = [self.params objectForKey:@"request_data"];
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjectsAndKeys:self.params,@"params",nil];
    if(requestDic == nil || (NSObject*)requestDic == [NSNull null]){
        requestDic = [[[NSDictionary alloc] initWithObjectsAndKeys:
                     paramsDict,@"expand",
                      @"",@"provinceCode",
                      @"",@"cityCode",
                      @"",@"countryCode",nil] autorelease];
    }
    [buss chooseArea:requestDic];
    
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

//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];

    if([bizCode isEqualToString:[ChooseAreaMessage getBizCode]]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService* buss = [bussineDataService sharedDataService];
            self.areaData = [buss.rspInfo objectForKey:@"areas"];
            if(self.areaData != nil){
                [((UITableView*)[self.view viewWithTag:TABLE_VIEW_TAG]) reloadData];
            }
        } else {
            if(nil == msg || [info objectForKey:@"MSG"] == [NSNull null]){
                msg = @"获取区域数据失败！";
            }
            [self showSimpleAlertView:msg];
        }
    }
}

//key: bussineCode value :; Key:errorCode, value: key:MSG, value:
- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[LoginMessage getBizCode] isEqualToString:bizCode]){
        if(nil == msg || [info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"获取区域数据失败！";
        }
        [self showSimpleAlertView:msg];
        
    }
}

@end

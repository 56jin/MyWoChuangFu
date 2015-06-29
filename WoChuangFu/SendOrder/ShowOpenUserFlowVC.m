//
//  ShowOpenUserFlowVC.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ShowOpenUserFlowVC.h"
#import "TitleBar.h"
#import "GifView.h"

#define CELL_ROW_HEIGHT                 40.0f

#define CELL_TITLE_LABEL_TAG            101
#define CELL_IMAGE_VIEW_TAG             102
#define CELL_GIF_VIEW_TAG               103

@interface ShowOpenUserFlowVC ()<TitleBarDelegate,UITableViewDataSource,UITableViewDelegate,HttpBackDelegate>
{
    UITableView *contentTable;
    NSArray *flowList;
}
@property (nonatomic ,retain)NSArray *flowList;
@property (nonatomic ,retain)UITableView *contentTable;
@end

@implementation ShowOpenUserFlowVC

@synthesize contentTable;
@synthesize flowList;
@synthesize orderDic;

- (void)dealloc
{
    [contentTable release];
    if (flowList != nil) {
        [flowList release];
    }
    [orderDic release];
    
    [super dealloc];
}

- (void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *rootView = [[UIView alloc] initWithFrame:frame];
    self.view = rootView;
    [rootView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO
                                                     ShowSearch:NO
                                                       TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"开户流程";
    titleBar.target = self;
    titleBar.frame = CGRectMake(0,20, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:titleBar];
    [titleBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TITLE_BAR_HEIGHT+20, self.view.frame.size.width,self.view.frame.size.height - TITLE_BAR_HEIGHT-20)
                                                          style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contentTable = tableView;
    [self.view addSubview:tableView];
    [tableView release];
    
    [NSTimer scheduledTimerWithTimeInterval:0.05f
                                     target:self
                                   selector:@selector(sendHttpMessage)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark - TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark
#pragma mark - SendHttpMessage
- (void)sendHttpMessage
{
    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [self.orderDic objectForKey:@"orderCode"],@"orderCode", nil];
    bussineDataService  *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService checkFlow:requestDic];
    [requestDic release];
}


#pragma mark
#pragma mark - UITableViewDelegate/UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.flowList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_ROW_HEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *deviceCell = @"deviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:deviceCell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:deviceCell] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, self.view.frame.size.width - 60, CELL_ROW_HEIGHT)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:13.0F];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.adjustsFontSizeToFitWidth = NO;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = CELL_TITLE_LABEL_TAG;
        [cell.contentView addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView *flowView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, (CELL_ROW_HEIGHT-30)/2.0f, 30, 30)];
        flowView.tag = CELL_IMAGE_VIEW_TAG;
        [cell.contentView addSubview:flowView];
        [flowView release];
        
        GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, (CELL_ROW_HEIGHT-30)/2.0f, 30, 30)
                                                 filePath:[[NSBundle mainBundle] pathForResource:@"wait.gif" ofType:nil]];
        gifView.tag = CELL_GIF_VIEW_TAG;
        [cell.contentView addSubview:gifView];
        [gifView release];
        
        UIView *seperView =  [[UIView alloc] initWithFrame:CGRectMake(0, CELL_ROW_HEIGHT-1, self.view.frame.size.width, 1)];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView release];
        
    }
    
    NSDictionary *data = [self.flowList objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    UIImageView *flowView = (UIImageView *)[cell.contentView viewWithTag:CELL_IMAGE_VIEW_TAG];
    GifView *gifView = (GifView *)[cell.contentView viewWithTag:CELL_GIF_VIEW_TAG];
    
    titleLabel.text = [data valueForKey:@"key"];
    NSString *flow = [data objectForKey:@"value"];
    if ([flow isEqualToString:@"Y"]) {
        flowView.hidden = NO;
        gifView.hidden = YES;
        flowView.image = [UIImage imageNamed:@"icon_right.png"];
    }else if ([flow isEqualToString:@"N"]){
        flowView.hidden = NO;
        gifView.hidden = YES;
        flowView.image = [UIImage imageNamed:@"icon_wrong.png"];
    }else if ([flow isEqualToString:@"W"]){
        flowView.hidden = YES;
        gifView.hidden = NO;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errorCode = [info objectForKey:@"errorCode"];
    if ([bizCode isEqualToString:[CheckFLowMessage getBizCode]]){
        if ([errorCode isEqualToString:@"0000"]) {
            bussineDataService *bussineService = [bussineDataService sharedDataService];
            NSArray *flowItems = [bussineService.rspInfo objectForKey:@"respDesc"];
            self.flowList = flowItems;
            [self.contentTable reloadData];
        }
    }

}

- (void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* MSG = [info objectForKey:@"MSG"];
    if ([bizCode isEqualToString:[CheckFLowMessage getBizCode]]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:MSG
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
    }
}

@end

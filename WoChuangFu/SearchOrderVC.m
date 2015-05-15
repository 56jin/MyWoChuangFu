//
//  SearchOrderVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/15.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//
#import "OrderCell.h"
#import "SearchOrderVC.h"
#import "ShowWebVC.h"


#define FONT_SIZE 14.0f
#define CELL_CONTENT_MARGIN 10.0f


@interface SearchOrderVC ()


@property (strong, nonatomic) NSMutableArray *orderCodesList;//订单号列表
@property (strong, nonatomic) NSMutableArray *detailsList;//订单详情列表

// 所有标题行的字典
@property (strong, nonatomic) NSMutableDictionary *sectionDict; //sectionView字典
@property (strong, nonatomic) NSMutableDictionary *detailsDict;
@property (weak, nonatomic) UITableView *mytable;
@property(nonatomic,retain)NSDictionary *SendDic;

@end


@implementation SearchOrderVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:left_position];
    titleBar.title = @"订单详情";
    titleBar.target = self;
    [titleBar setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    [self.view addSubview:titleBar];
    
    bussineDataService *bus = [bussineDataService  sharedDataService];
    bus.target = self;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 _orderCode == nil?@"":_orderCode ,@"orderCode",
                                 _receiverPhoneNum == nil?@"":_receiverPhoneNum,@"receiverPhoneNum",
                                 _certNum == nil?@"":_certNum,@"certNum",@"",@"orderStatus",@"1",@"pageIndex",@"20",@"pageCount",nil];
    [bus order:dict];
    self.SendDic = dict;
    
    MyLog(@"dic的值%@",dict[@"orderCode"]);
    
    
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-60) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    _mytable = tab;
    [self.view addSubview:_mytable];
    
    // 1. 设置标题行高
    [_mytable setSectionHeaderHeight:kHeaderHeight];
    // 2. 设置表格行高
    [_mytable setRowHeight:50];
    // 3. 给表格注册可重用标题行
//    [_mytable registerClass:[MyHeader class] forHeaderFooterViewReuseIdentifier:@"MyHeader"];
//    [_mytable registerClass:[CellStyle class] forCellReuseIdentifier:@"MyCell"];
    _mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mytable.showsHorizontalScrollIndicator = NO;
}



#pragma mark - 数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderCodesList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果字典中分组对应的折叠状态，返回0，否则返回数组的数量
    MyHeader *header = self.sectionDict[@(section)];
    BOOL isOpen = header.isOpen;
    if (isOpen) {
        return [(NSArray *)_detailsList[section] count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyCell";
    
    CellStyle *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[CellStyle alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSArray *array =_detailsList[indexPath.section];
    NSDictionary *item = array[indexPath.row];
    NSString *name = item[@"name"];
    NSString *Value = item[@"value"];
    if ([name isEqualToString:@"查看证件:"] ||[name isEqualToString:@"物流查询:"]||[name isEqualToString:@"查看协议:"])
    {
        Value = @"点击查看详情";
    }
    [cell setLabel1Text:name label2Text:Value];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array =_detailsList[indexPath.section];
    NSDictionary *item = array[indexPath.row];
    NSString *name = item[@"name"];
    NSString *Value = item[@"value"];
    if ([name isEqualToString:@"查看证件:"] ||[name isEqualToString:@"物流查询:"]||[name isEqualToString:@"查看协议:"])
    {
        ShowWebVC *webVC = [[ShowWebVC alloc] init];
        webVC.urlStr = Value;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark 表格标题栏
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderID = @"MyHeader";
    
    // 1. 在缓冲池查找可重用的标题行
    // 从字典中读取标题行
    MyHeader *header = self.sectionDict[@(section)];
    
    if (header == nil) {
        
        // 实例化表格标题，一定要用initWithReuseIdentifier方法
        header = [[MyHeader alloc]initWithReuseIdentifier:HeaderID];
        //[header setFrame:CGRectMake(0, 74, SCREEN_WIDTH, SCREEN_HEIGHT)];
        // 设置代理
        [header setDelegate:self];
        
        // 将自定义标题栏加入字典
        [self.sectionDict setObject:header forKey:@(section)];
    }
    NSString *headerStr = self.orderCodesList[section];
    
    header.textLabel.text = headerStr;
    
    // 在标题栏自定义视图中记录对应的分组数
    [header setSection:section];
    
    return header;
}

#pragma mark - 自定义标题栏代理方法
- (void)myHeaderDidSelectedHeader:(MyHeader *)header
{
    // 处理展开折叠
    // 需要记录每个分组的展开折叠情况
    // 从字典中取出标题栏
    MyHeader *clickHeader = self.sectionDict[@(header.section)];
    BOOL isOpen = clickHeader.isOpen;
    [clickHeader setIsOpen:!isOpen];
    [clickHeader.textLabel setTextColor:!isOpen?[UIColor orangeColor]:[UIColor blackColor]];
    [_mytable reloadSections:[NSIndexSet indexSetWithIndex:header.section] withRowAnimation:UITableViewRowAnimationFade];
    for (int i = 0;i <self.sectionDict.count; i++)
    {
        MyHeader *headerItem = self.sectionDict[@(i)];
        
        if (headerItem != clickHeader && headerItem.isOpen == YES)
        {
            headerItem.isOpen = NO;
            [headerItem.textLabel setTextColor:[UIColor blackColor]];
            [_mytable reloadSections:[NSIndexSet indexSetWithIndex:headerItem.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

#pragma mark 数据接收

-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[SearchOrderMessage getBizCode] isEqualToString:bizCode]){
        if([oKCode isEqualToString:errCode]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            NSArray *orderDetail = bus.rspInfo[@"orderDetail"];
            
            _orderCodesList = [NSMutableArray array];
            _detailsList = [NSMutableArray array];
            for (NSDictionary *orderDetailDict in orderDetail)
            {
                NSString *orderCode =  orderDetailDict[@"orderCode"];
                [_orderCodesList addObject:orderCode];
                NSArray *details = orderDetailDict[@"details"];
                [_detailsList addObject:details];
                
            }
            if (_orderCodesList==nil||_orderCodesList.count == 0){
                [self ShowProgressHUDwithMessage:@"没有搜索到订单"];
            }
            else if(_orderCodesList!=nil)
            {
                
                [_mytable reloadData];
                // 初始化展开折叠字典
                self.sectionDict = [NSMutableDictionary dictionaryWithCapacity:self.orderCodesList.count];

            }
        }else{
            
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"获取数据异常！";
            }
            if(nil == msg){
                msg = @"获取数据异常！";
            }
            [self showSimpleAlertView:msg];
        }
    }
}

-(void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[SearchOrderMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"搜索失败！";
        }
        if(nil == msg){
            msg = @"搜索失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10101
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
        
    }
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus order:self.SendDic];
        }
    }
}



#pragma mark -
#pragma mark AlertView
-(void)showAlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles,...
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
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    alert.tag = tag;
    for(int i = 0; i < [argsArray count]; i++){
        [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
    }
    [alert show];
}


-(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark - HUD
- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

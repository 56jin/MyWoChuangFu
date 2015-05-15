//
//  WealthView.m
//  WoChuangFu
//
//  Created by 李新新 on 14-12-30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "WealthView.h"
#import "UIImage+LXX.h"

@interface WealthView()<HttpBackDelegate>

@property(nonatomic,weak) UILabel *availableMoney;
@property(nonatomic,weak) UILabel *WealthMoney;
@property(nonatomic,weak) UILabel *overNum;
@property (nonatomic,strong) NSMutableDictionary *requestDict;      //请求参数字典

@end

@implementation WealthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubViews];
        self.contentSize = CGSizeMake(PHONE_WIDTH, 600);
    }
    return self;
}

- (void)initSubViews
{
    CGRect frame = self.frame;
    
    CGFloat width = frame.size.width;
    [self loadWealthInfo];
    
    //可提取金额背景
    UIView *availableBgView = [[UIView alloc] init];
    availableBgView.frame = CGRectMake(0, 0,width,120);
    availableBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:availableBgView];
    
    //可提取金额(标签)
    UILabel *available = [[UILabel alloc] init];
    available.frame = CGRectMake(20, 20, 100, 20);
    available.textColor = [ComponentsFactory createColorByHex:@"#acacac"];
    available.font = [UIFont systemFontOfSize:14];
    available.text = @"可提取金额(元)";
    [availableBgView addSubview:available];
    
    //可提取金额(显示)
    UILabel *availableMoney = [[UILabel alloc] init];
    availableMoney.frame = CGRectMake(20, 50, width - 40, 40);
    availableMoney.font = [UIFont systemFontOfSize:40];
    availableMoney.textColor = available.textColor = [ComponentsFactory createColorByHex:@"#f96c00"];
    [availableBgView addSubview:availableMoney];
    self.availableMoney = availableMoney;
    
    //提现按钮
    UIButton *getMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getMoneyBtn setBackgroundColor:[UIColor whiteColor]];
    [getMoneyBtn setImage:[UIImage resizedImage:@"icon_money"] forState:UIControlStateNormal];
    [getMoneyBtn setTitleColor:[ComponentsFactory createColorByHex:@"#f96c00"] forState:UIControlStateNormal];
    [getMoneyBtn addTarget:self action:@selector(getMoney:) forControlEvents:UIControlEventTouchUpInside];
    [getMoneyBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [getMoneyBtn setTitle:@"我要提现" forState:UIControlStateNormal];
    [getMoneyBtn setTitle:@"我要提现" forState:UIControlStateNormal];
    [getMoneyBtn setFrame:CGRectMake(width-20-80,10,80, 30)];
    [availableBgView addSubview:getMoneyBtn];
    
    //已累计财富背景
    UIView *accumulatedWealthBgView = [[UIView alloc] init];
    accumulatedWealthBgView.frame = CGRectMake(0, 120,width,80);
    accumulatedWealthBgView.backgroundColor = [ComponentsFactory createColorByHex:@"#efeff4"];
    [self addSubview:accumulatedWealthBgView];
    
    //已累计财富(标签)
    UILabel *accumulatedWealth = [[UILabel alloc] init];
    accumulatedWealth.frame = CGRectMake(20, 15, 100, 20);
    accumulatedWealth.font = [UIFont systemFontOfSize:14];
    accumulatedWealth.text = @"已累计财富(元)";
    accumulatedWealth.textColor = [ComponentsFactory createColorByHex:@"#acacac"];
    [accumulatedWealthBgView addSubview:accumulatedWealth];
    
    //已累计财富(显示)
    UILabel *WealthMoney = [[UILabel alloc] init];
    WealthMoney.frame = CGRectMake(20, 45, width - 40, 30);
    WealthMoney.font = [UIFont systemFontOfSize:30];
    WealthMoney.textColor = [ComponentsFactory createColorByHex:@"#494846"];
    [accumulatedWealthBgView addSubview:WealthMoney];
    self.WealthMoney = WealthMoney;
    
    //超过创富者(标签)
    UILabel *over = [[UILabel alloc] init];
    over.frame = CGRectMake(200, 15, 100, 20);
    over.font = [UIFont systemFontOfSize:14];
    over.textColor = [ComponentsFactory createColorByHex:@"#acacac"];
    over.text = @"超过创富者";
    [accumulatedWealthBgView addSubview:over];
    
    //超过创富者(显示)
    UILabel *overNum = [[UILabel alloc] init];
    overNum.frame = CGRectMake(200, 45, width - 40, 30);
    overNum.textColor = [ComponentsFactory createColorByHex:@"#494846"];
    overNum.font = [UIFont systemFontOfSize:30];
    self.overNum = overNum;
    [accumulatedWealthBgView addSubview:overNum];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, width, 400) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
}

- (void)getMoney:(UIButton *)sender
{
    [self ShowProgressHUDwithMessage:@"敬请期待"];
}

- (NSMutableArray *)dataSources
{
    if (nil== _dataSources)
    {
        _dataSources = [NSMutableArray array];
        
        NSArray *array1 = [NSArray arrayWithObjects:@{@"查看清单":@"沃创富发展创富"},@{@"未设置":@"财富余额提醒"}, nil];
        NSArray *array2 = [NSArray arrayWithObjects:@{@"未绑定":@"绑定支付宝"},@{@"财富转至银行卡，需登录全民付":@"全民付"}, nil];
        [_dataSources addObject:array1];
        [_dataSources addObject:array2];
    }
    return _dataSources;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        [cell.textLabel setTextColor:[ComponentsFactory createColorByHex:@"#4a4a4a"]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [cell.detailTextLabel setTextColor:[ComponentsFactory createColorByHex:@"#999999"]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0f]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    NSArray *array =  self.dataSources[indexPath.section];
    NSDictionary *dict = array[indexPath.row];
    NSString *key =  [dict allKeys][0];
    cell.textLabel.text = dict[key];
    cell.detailTextLabel.text = key;
    return cell;
}

//加载用户数据
- (void)loadWealthInfo
{
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;

    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    if (userId != nil && ![userId isEqualToString:@""])
    {
        _requestDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        userId,@"userId",nil];
        [bus getWealth:_requestDict];
    }
//
//    _requestDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"8853",@"userId",nil];
//    [bus getWealth:_requestDict];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 10;
    }
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self ShowProgressHUDwithMessage:@"敬请期待"];
}

-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if ([[WealthMessage getBizCode] isEqualToString:bizCode])
    {
        if ([oKCode isEqualToString:errCode])
        {
            bussineDataService *bus=[bussineDataService sharedDataService];
            
            NSDictionary *dic = bus.rspInfo[@"brokerageInfo"];
            
            if (dic[@"abledwithdrawcash"] != [NSNull null])
            {
                _availableMoney.text =  dic[@"abledwithdrawcash"];
            }
            if(dic[@"sumBrokerage"] != [NSNull null])
            {
                _WealthMoney.text  = dic[@"sumBrokerage"];
            }
            if(dic[@"exceptBrokerage"] != [NSNull null])
            {
                _overNum.text  = [NSString stringWithFormat:@"%@%%", dic[@"exceptBrokerage"]];
            }
        }
    }
}
-(void)requestFailed:(NSDictionary *)info
{
    
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[WealthMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"获取财富信息失败！";
        }
        if(nil == msg){
            msg = @"获取财富信息失败！";
        }
        [self ShowProgressHUDwithMessage:msg];
    }
}

- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end

//
//  SIMPackageChooseVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-2-4.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SIMPackageChooseVC.h"
#import "Titlebar.h"
#import "UIImage+LXX.h"
#define POSTION_Y [UIScreen mainScreen].applicationFrame.origin.y

@interface SIMPackageChooseVC ()<UITableViewDelegate,UITableViewDataSource,TitleBarDelegate>

@end

@implementation SIMPackageChooseVC

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    [self createTitleBar];
    [self createMainView];
}

- (void)createTitleBar
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:left_position];
    titleBar.frame = CGRectMake(0,POSTION_Y,[AppDelegate sharePhoneWidth],TITLE_BAR_HEIGHT);
    titleBar.title = @"选择套餐";
    titleBar.target = self;
    [self.view addSubview:titleBar];
}
- (void)createMainView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,POSTION_Y +TITLE_BAR_HEIGHT,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-POSTION_Y) style:UITableViewStylePlain];
    tableView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}

#pragma mark
#pragma mark - TitleBarDelegate
- (void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark
#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *packageType = [self.dataSources objectAtIndex:[indexPath row]];
    if (self.handler) {
        self.handler(packageType);
    }
    [self backAction];
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SIMPackageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        [cell.textLabel setTextColor:[ComponentsFactory createColorByHex:@"#333333"]];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"bg_content_select_n"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"bg_content_select_hover"xPos:0.1 yPos:0.2]];
    }
    NSDictionary *packageType = [self.dataSources objectAtIndex:[indexPath row]];
    
    NSString *cellTitle =[NSString stringWithFormat:@"%@,%@,%@,%@",packageType[@"packageName"],packageType[@"packageInlandVoice"],packageType[@"packageInlandFlow"],packageType[@"packageInlandMessage"]];
    
    cell.textLabel.text = cellTitle;
    return cell;
}

@end

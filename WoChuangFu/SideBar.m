//
//  SideBar.m
//  WoChuangFu
//
//  Created by 李新新 on 14-12-30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//
#define KSIDE_BAR_WIDTH 260
#define PHONE_HEIGHT [AppDelegate sharePhoneHeight] //手机高度

#import "SideBar.h"
#import "UIImage+LXX.h"

@interface SideBar()

@property(nonatomic,weak) UIImageView *icon;
@property(nonatomic,weak) UILabel     *userName;

@end

@implementation SideBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configSubViews];
    }
    return self;
}

- (NSArray *)dataSources
{
    if (nil == _dataSources)
    {
        _dataSources = [NSArray array];
    }
    return _dataSources;
}

- (void)configSubViews
{
    self.backgroundColor = [ComponentsFactory createColorByHex:@"#2f2f31"];
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0,KSIDE_BAR_WIDTH, 64);
    headerView.backgroundColor = [ComponentsFactory createColorByHex:@"#212123"];
    [self addSubview:headerView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10,8, 50, 50)];
    icon.image = [UIImage imageNamed:@"userIcon"];
    icon.layer.cornerRadius = icon.frame.size.width/2.0;
    icon.layer.masksToBounds = YES;
    [headerView addSubview:icon];
    self.icon = icon;
    
    UILabel *userName = [[UILabel alloc] init];
    userName.frame = CGRectMake(70, 15, 100, 30);
    [userName setFont:[UIFont systemFontOfSize:15.0f]];
    userName.text = @"叮当猫";
    userName.textColor = [ComponentsFactory createColorByHex:@"#ffffff"];
    userName.backgroundColor = [UIColor clearColor];
    [headerView addSubview:userName];
    self.userName = userName;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSIDE_BAR_WIDTH, self.frame.size.height- 114) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self addSubview:tableView];
    
    UIView *btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height - 50, KSIDE_BAR_WIDTH, 50)];
    btnBgView.backgroundColor = [ComponentsFactory createColorByHex:@"#353535"];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [logoutBtn setFrame:CGRectMake(20, 10, KSIDE_BAR_WIDTH - 40, 30)];
    [logoutBtn setImage:[UIImage resizedImage:@"exit"] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(userLogout:) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnBgView addSubview:logoutBtn];
    [self addSubview:btnBgView];
}

#pragma mark - 按钮时间
- (void)userLogout:(UIButton *)sender
{
    //step1.设置HasLogIn为NO
    bussineDataService *bus= [bussineDataService sharedDataService];
    bus.HasLogIn = NO;
    
    //step2.清空NSUserDefaults信息
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"PassWord"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //step3.清空自身信息
    self.userName.text = @"用户未登录";
    
    //step4.通知代理用户已退出
    if ([self.delegate respondsToSelector:@selector(userDidLogout)])
    {
        [self.delegate userDidLogout];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0f]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 1, cell.frame.size.width,1)];
        imageView.image = [UIImage imageNamed:@"ios_sidebar_bg_line"];
        [cell addSubview:imageView];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor colorWithRed:47/255.0f green:46/255.0f blue:49/255.0f alpha:1];
        UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,2,cell.frame.size.height)];
        [orangeView setBackgroundColor:[UIColor orangeColor]];
        [bgView addSubview:orangeView];
        cell.selectedBackgroundView = bgView;
    
    }
    cell.textLabel.text = self.dataSources[indexPath.row][@"menuName"];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *dict = self.dataSources[indexPath.row];
//    
//    NSString *menuId = dict[@"menuId"];
//    
    if ([self.delegate respondsToSelector:@selector(sideBar:didSelectAtIndex:)])
    {
        [self.delegate sideBar:self didSelectAtIndex:indexPath.row];
    }
}

- (void)setCustomName:(NSString *)customName
{
    _customName = customName;
    self.userName.text = _customName;
}

@end

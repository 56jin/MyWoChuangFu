//
//  UserInfoView.m
//  WoChuangFu
//
//  Created by 李新新 on 14-12-30.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "UserInfoView.h"
#import "TitleBar.h"
#import "CommonMacro.h"
#import "InsetsLabel.h"

@interface UserInfoView()

@property(nonatomic,strong)UITableView *mytable;
@property(nonatomic,strong)NSMutableArray *models;

@property (nonatomic,strong) NSMutableDictionary *requestDict;

@end

@implementation UserInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self LayoutV];
    }
    return self;
}

- (void)loadUserInfo
{
    bussineDataService *bus = [bussineDataService  sharedDataService];
    
    if (bus.HasLogIn == YES)
    {
        bus.target = self;
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userCode = [userDefault objectForKey:@"userCode"];
        NSString *userType = [userDefault objectForKey:@"userType"];
        
        _requestDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        userCode,@"userCode",
                        userType,@"userType",nil];
        [bus getInfo:_requestDict];

    }
}

-(void)LayoutV
{
    self.contentSize = CGSizeMake(0,600);
    self.backgroundColor = UIColorWithRGBA(240, 239, 245, 1);
    
    _mytable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,600)];
    _mytable.dataSource = self;
    _mytable.delegate = self;
    _mytable.scrollEnabled = NO;
    _mytable.backgroundColor = [UIColor whiteColor];
    _mytable.showsVerticalScrollIndicator = NO;
    _mytable.scrollEnabled = NO;
    _mytable.backgroundColor = UIColorWithRGBA(240, 239, 245, 1);
    
    [self addSubview:_mytable];
    
    _mytable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSMutableArray *)models
{
    if (nil == _models)
    {
        _models = [NSMutableArray array];
    }
    return _models;
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *group =  self.models[section];
    
    InsetsLabel *groupNameLabel = nil;
    if (group[@"groupName"]!= [NSNull null])
    {
        groupNameLabel = [[InsetsLabel alloc] initWithFrame:CGRectZero andInsets:UIEdgeInsetsMake(0,10, 0, 0)];
        groupNameLabel.font = [UIFont systemFontOfSize:14.0f];
        groupNameLabel.textColor = [ComponentsFactory createColorByHex:@"#acacac"];
        groupNameLabel.text = group[@"groupName"];
    }
    
    return groupNameLabel;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.models.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *group =  self.models[section];
    NSMutableArray *infos = group[@"infos"];
    return infos.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCell = @"cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    //取出对应分组
    NSDictionary *group = self.models[indexPath.section];
    
    //取出infos列表
    NSArray *infos = group[@"infos"];
    
    //取出对应row详情
    NSDictionary *detail = infos[indexPath.row];
    
    cell.textLabel.text = detail[@"itemName"];
    
    if (indexPath.section == 2)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"erbroad_black"]];
        imageView.frame = CGRectMake(0, 0, 19, 18);
        cell.accessoryView = imageView;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (detail[@"itemValue"]!=[NSNull null])
        {
            cell.detailTextLabel.text = detail[@"itemValue"];
        }
        else
        {
            cell.detailTextLabel.text = @"未填写";
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[InfoMessage getBizCode] isEqualToString:bizCode])
    {
        if ([oKCode isEqualToString:errCode])
        {
            bussineDataService *bus=[bussineDataService sharedDataService];
            
            self.models= bus.rspInfo[@"models"];
            
            [_mytable reloadData];
        }
    }
}

-(void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[InfoMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"获取数据失败！";
        }
        if(nil == msg){
            msg = @"获取数据失败！";
        }
        
    }
}

@end

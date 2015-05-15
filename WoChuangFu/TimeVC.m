//
//  TimeVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/17.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "TimeVC.h"
#import "TimeModel.h"
#import "TimeManager.h"
#import "CommonMacro.h"
#import "TitleBar.h"
#import "ChooseCell.h"

@interface TimeVC ()<TitleBarDelegate>

@property(nonatomic,weak)UITableView *mytable;
@property(nonatomic,strong)NSArray *array;

@end

@implementation TimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutsubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)layoutsubViews
{
    TitleBar *titlebar = [[TitleBar alloc]initWithFramShowHome:YES ShowSearch:NO TitlePos:30];
    titlebar.target = self;
    [self.view addSubview:titlebar];
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _mytable = tab;
    _array = @[@"12个月", @"24个月", @"36个月"];
    _mytable.delegate = self;
    _mytable.dataSource = self;
    
    //除去多余cell用view代替
    _mytable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_mytable];
    
}

#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCell = @"cell_identifier";
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    
    if (cell == nil) {
        cell = [[ChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }
    
    //    while ([cell.contentView.subviews lastObject] != nil) {
    //        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    //    }
    
    
    
    TimeModel *style = [TimeManager shareInstance].time;
    if(style == nil)
        cell.SelectedimgView.hidden = true;
    else
    {
        if([style.time isEqualToString:[_array objectAtIndex:indexPath.row]])
            cell.SelectedimgView.hidden = false;
        else
            cell.SelectedimgView.hidden = true;
    }
    
    cell.style.text = _array[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 数据项
    TimeModel *item =[[TimeModel alloc]init];
    item.time =  [_array objectAtIndex:indexPath.row];
    
    // 保存到单例
    [TimeManager shareInstance].time = item;
    [_mytable reloadData];
    [self.navigationController popViewControllerAnimated:YES];
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

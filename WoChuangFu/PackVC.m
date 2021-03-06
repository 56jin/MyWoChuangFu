//
//  PackVC.m
//  WoChuangFu
//
//  Created by 郑渊文 on 14/12/16.
//  Copyright (c) 2014年 asiainfo-linkage. All rights reserved.
//

#import "PackVC.h"
#import "CommonMacro.h"
#import "TitleBar.h"
#import "ChooseCell.h"
#import "PackManager.h"


@interface PackVC ()<TitleBarDelegate>
@property(nonatomic,weak)UITableView *mytable;
@property(nonatomic,strong)NSArray *array;

@end

@implementation PackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutsubViews];
    // Do any additional setup after loading the view.
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
    _array = @[@"A套餐", @"B套餐", @"C套餐"];
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
 
    NSString *pack1 = [PackManager shareInstance].pack;
    if(pack1 == nil)
        cell.SelectedimgView.hidden = true;
    else
    {
        if([pack1 isEqualToString:[_array objectAtIndex:indexPath.row]])
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

    NSString *pack =  [_array objectAtIndex:indexPath.row];
    
    // 保存到单例
    [PackManager shareInstance].pack = pack;
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

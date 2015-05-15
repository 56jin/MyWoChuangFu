//
//  BrandChooseBar.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-25.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "BrandChooseBar.h"

@interface BrandChooseBar()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BrandChooseBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initMainContentView];
    }
    return self;
}

#pragma
#pragma mark -
- (void)initMainContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.layer.borderWidth =0.3f;
    tableView.layer.borderColor = [[ComponentsFactory createColorByHex:@"#eeeeee"] CGColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
}

#pragma 
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.brands count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BrandCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
    }
    cell.textLabel.text = self.brands[indexPath.row][@"name"];
    
    return cell;
}

#pragma
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(brandChooseBar:didSelectedRowAtIndex:)])
    {
        [self.delegate brandChooseBar:self didSelectedRowAtIndex:indexPath.row];
    }
}

@end

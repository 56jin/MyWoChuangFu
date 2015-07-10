//
//  BLEDeviceListView.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/24.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "BLEDeviceListView.h"
#define CELL_ROW_HEIGHT                 30.0f
#define CELL_TITLE_LABEL_TAG            101

@implementation BLEDeviceListView

@synthesize deviceList;
@synthesize deviceTable;
@synthesize delegate;

- (void)dealloc
{
    [deviceList release];
    [deviceTable release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    UITableView *contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                             style:UITableViewStylePlain];
    contentTable.backgroundColor = [UIColor clearColor];
    contentTable.delegate = self;
    contentTable.dataSource = self;
    contentTable.separatorColor = [UIColor clearColor];
    contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:contentTable];
    self.deviceTable = contentTable;
    [contentTable release];
}

- (void)reloadViewData:(NSArray *)itemList
{
    self.deviceList = itemList;
    [self.deviceTable reloadData];
}

#pragma mark
#pragma mark - UITableViewDelegate/UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.deviceList count];
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
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, CELL_ROW_HEIGHT)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:13.0F];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.adjustsFontSizeToFitWidth = NO;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = CELL_TITLE_LABEL_TAG;
        [cell.contentView addSubview:titleLabel];
        [titleLabel release];
        
        UIView *seperView =  [[UIView alloc] initWithFrame:CGRectMake(0, CELL_ROW_HEIGHT-1, self.frame.size.width, 1)];
        seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#DDDDDD"];
        [cell.contentView addSubview:seperView];
        [seperView release];

    }
    
    NSDictionary *data = [self.deviceList objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    titleLabel.text = [data valueForKey:@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *curdict= self.deviceList[indexPath.row];//选择当前选定的ble设备，取其uuid，连接该设备。
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(bleDeviceDidSelectbLE:)]) {
        [self.delegate bleDeviceDidSelectbLE:[curdict valueForKey:@"uuid"]];
    }
}


@end

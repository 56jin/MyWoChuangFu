//
//  FilterView.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-30.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "FilterView.h"

#define TABLE_TAG 1000

@interface FilterView()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    FilterViewDataType myType;
}

@end

@implementation FilterView


- (id)initWithDataArray:(NSArray *)dataArray andType:(FilterViewDataType)type
{
    self = [super initWithFrame:CGRectMake(0,0,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight])];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.dataSources = dataArray;
        myType = type;
        [self initTableView];
        [self startAnimation];
    }
    return self;
}

- (void)initTableView
{
    float table_height = 308;
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0,[AppDelegate sharePhoneHeight],[AppDelegate sharePhoneWidth],table_height) style:UITableViewStylePlain];
    table.tag = TABLE_TAG;
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] init];
    [self addSubview:table];
}
- (void)startAnimation
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
    UITableView *table = (UITableView *)[self viewWithTag:TABLE_TAG];
    [UIView animateWithDuration:0.25f animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [UIView animateWithDuration:0.25f animations:^{
            table.transform = CGAffineTransformMakeTranslation(0,-table.frame.size.height);
        }];
    } completion:^(BOOL finished) {
    }];
}

-(void)tappedCancel
{
    UITableView *table = (UITableView *)[self viewWithTag:TABLE_TAG];
    [UIView animateWithDuration:.25 animations:^{
        table.transform = CGAffineTransformMakeTranslation(0, table.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isKindOfClass:[self class]]){
        return YES;
    }
    return NO;
}

#pragma mark
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FilterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setTextColor:[ComponentsFactory createColorByHex:@"#666666"]];
        cell.textLabel.numberOfLines = 0;
    }
    if (myType == FilterViewDataTypeCity) {
        cell.textLabel.text = [self.dataSources objectAtIndex:[indexPath row]][@"areaName"];
    }else if (myType == FilterViewDataTypeNumberType){
        cell.textLabel.text = [self.dataSources objectAtIndex:[indexPath row]][@"typeName"];
    }else if (myType == FilterViewDataTypeAddress){
        cell.textLabel.text = [self.dataSources objectAtIndex:[indexPath row]][@"areaName"];
    }else if (myType == FilterViewDataTypeNetPackage){
        cell.textLabel.text = [self.dataSources objectAtIndex:[indexPath row]][@"packDesc"];
    }
    return cell;
}
#pragma mark
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectedRowAtIndex:withData:andType:)]) {
        [self.delegate didSelectedRowAtIndex:indexPath.row withData:self.dataSources[indexPath.row]andType:myType];
    }
    [self tappedCancel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (FilterViewDataTypeAddress == myType ||FilterViewDataTypeNetPackage == myType) {
        return 60;
    }else{
        return 44;
    }
}

- (void)showInView:(UIViewController *)view
{
    if(view==nil){
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }else{
        [view.view addSubview:self];
    }
}

@end

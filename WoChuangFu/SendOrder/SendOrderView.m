//
//  SendOrderView.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SendOrderView.h"

#define SECTION_VIEW_HEIGHT         84/2.0f
#define ROW_VIEW_HEIGHT             60/2.0f

#define SECTION_BASE_VIEW_TAG       500

#define CELL_TITLE_LABEL_TAG        100
#define CELL_VALUE_LABEL_TAG        101

@implementation SendOrderView
@synthesize contentTable;
@synthesize pageLoadNum;
@synthesize itemList;
@synthesize delegate;
@synthesize paramterDic;
@synthesize rowShowList;

- (void)dealloc
{
    [contentTable release];
    if (itemList != nil) {
        [itemList release];
    }
    
    if (showItems != NULL) {
        free(showItems);
    }
    if (paramterDic != nil) {
        [paramterDic release];
    }
    if (rowShowList != nil) {
        [rowShowList release];
    }
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        pageLoadNum = 0;
        showItems = NULL;
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    RefreshSingleView *singleView = [[RefreshSingleView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    singleView.loadIndex = 5;
    singleView.backgroundColor = [UIColor clearColor];
    singleView.pageNumLoad = pageLoadNum;
    singleView.dataSource = self;
    singleView.delegate = self;
    [self addSubview:singleView];
    self.contentTable = singleView;
    [singleView release];

    [self layoutTableHeaderView];

}

- (void)layoutTableHeaderView
{
    OrderSearchConditionView *conditionView = [[OrderSearchConditionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 671/2.0f)];
    conditionView.delegate = self;
    conditionView.backgroundColor = [UIColor whiteColor];
    self.contentTable.contentTable.tableHeaderView = conditionView;
    [conditionView release];
}

#pragma mark
#pragma mark - tableView delegate
- (UITableViewCell *)customTableViewCell:(UITableView *)tableView
                   cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PrepaidListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(87/2.0f, 0, 100, ROW_VIEW_HEIGHT)];
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.tag = CELL_TITLE_LABEL_TAG;
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.numberOfLines = 1;
        titleLabel.contentMode = UIViewContentModeCenter;
        titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [ComponentsFactory createColorByHex:@"#333333"];
        [cell.contentView addSubview:titleLabel];
        [titleLabel release];
        
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(105+87/2.0f, 0, self.frame.size.width-105-87/2.0f, ROW_VIEW_HEIGHT)];
        codeLabel.font = [UIFont systemFontOfSize:13.0f];
        codeLabel.tag = CELL_VALUE_LABEL_TAG;
        codeLabel.textAlignment = NSTextAlignmentLeft;
        codeLabel.numberOfLines = 1;
        codeLabel.textColor = [ComponentsFactory createColorByHex:@"#F96C00"];
        codeLabel.backgroundColor = [UIColor clearColor];
        codeLabel.contentMode = UIViewContentModeCenter;
        codeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [cell.contentView addSubview:codeLabel];
        [codeLabel release];
    }
    
    UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:CELL_TITLE_LABEL_TAG];
    UILabel *codeLabel = (UILabel *)[cell.contentView viewWithTag:CELL_VALUE_LABEL_TAG];
    
    NSInteger row = indexPath.row;
    NSDictionary *data = [self.rowShowList objectAtIndex:row];
    
    codeLabel.text = [data objectForKey:@"value"];
    titleLabel.text = [data objectForKey:@"key"];
    return cell;
    
}

#pragma mark
#pragma mark - RefreshSingleViewDelegate
- (UITableViewCell *)refreshSingleView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self customTableViewCell:tableView cellForRowAtIndexPath:indexPath];
}


- (UIView *)refreshSingleView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionClickView *clickedView = [[[SectionClickView alloc]
                                      initWithFrame:CGRectMake(0, 0, self.contentTable.frame.size.width, SECTION_VIEW_HEIGHT)
                                      WithOpen:showItems[section]]
                                     autorelease];
    clickedView.delegate = self;
    clickedView.backgroundColor = [UIColor clearColor];
    clickedView.tag = SECTION_BASE_VIEW_TAG + section;
    
    NSDictionary *data = [self.itemList objectAtIndex:section];
    NSString *orderId = [data objectForKey:@"orderCode"];
    NSString *orderType = nil;
    if ([[data objectForKey:@"orderResult"] isEqualToString:@"0"]) {
        orderType = @"已开户";
    }else{
        orderType = @"未开户";
    }
    
    
    [clickedView reloadSectionViewWithOrderID:orderId orderType:orderType arrowStatus:YES];
    
    return clickedView;
}

- (void)refreshSingleView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)refreshLoadData:(NSInteger)pageNumLoad
{
    pageLoadNum = pageNumLoad;
    
    [self.paramterDic setObject:[NSString stringWithFormat:@"%d",5*pageNumLoad]
                         forKey:@"start"];
    
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService searchAccountOrder:self.paramterDic];
}

- (void)DataChange:(NSMutableArray *)itemData
{
    self.itemList = itemData;
    
    if (showItems != NULL) {
        free(showItems);
        showItems = NULL;
    }
    
    NSInteger cnt = [self.itemList count];
    showItems = (BOOL *)malloc(sizeof(BOOL)*cnt);
    memset(showItems, NO, cnt);
}
#pragma mark
#pragma mark - RefreshSingleViewDataSource
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_VIEW_HEIGHT;
}
- (CGFloat)refreshSingleView:(RefreshSingleView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_VIEW_HEIGHT;
}

- (NSInteger)refreshSingleView:(RefreshSingleView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (showItems[section]) {
        return [self.rowShowList count];
    }
    return 0;
}
- (NSInteger)numberOfSectionsInRefreshSingleView:(RefreshSingleView *)tableView
{
    return [self.itemList count];
}

#pragma mark
#pragma mark - SectionClickedViewDelegate
- (void)didSelectView:(SectionClickView *)sectionView isShow:(BOOL)isShow
{
    NSInteger section = sectionView.tag - SECTION_BASE_VIEW_TAG;
    showItems[section] = isShow;
    
    //组装数据流
    NSDictionary *itemData = [self.itemList objectAtIndex:section];
    NSMutableArray *itemRowList = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([itemData objectForKey:@"custName"] != nil && ![[itemData objectForKey:@"custName"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      @"客户信息:",@"key",
                                      [itemData objectForKey:@"custName"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"mainNumber"] != nil && ![[itemData objectForKey:@"mainNumber"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"订购号码:",@"key",
                                 [itemData objectForKey:@"mainNumber"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"orderAmount"] != nil && ![[itemData objectForKey:@"orderAmount"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"订购金额:",@"key",
                                 [NSString stringWithFormat:@"%d",[[itemData objectForKey:@"orderAmount"] integerValue]/1000],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"payType"] != nil && ![[itemData objectForKey:@"payType"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"支付方式:",@"key",
                                 [itemData objectForKey:@"payType"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"orderStatuName"] != nil && ![[itemData objectForKey:@"orderStatuName"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"订单状态:",@"key",
                                 [itemData objectForKey:@"orderStatuName"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"createTime"] != nil && ![[itemData objectForKey:@"createTime"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"下单时间:",@"key",
                                 [itemData objectForKey:@"createTime"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"orderId"] != nil && ![[itemData objectForKey:@"orderId"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"mimi单号:",@"key",
                                 [itemData objectForKey:@"orderId"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"receiveTel"] != nil && ![[itemData objectForKey:@"receiveTel"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"收件人联系电话:",@"key",
                                 [itemData objectForKey:@"receiveTel"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    if ([itemData objectForKey:@"developAgent"] != nil && ![[itemData objectForKey:@"developAgent"] isEqualToString:@""]) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"白卡类型:",@"key",
                                 [itemData objectForKey:@"developAgent"],@"value",nil];
        [itemRowList addObject:itemDic];
        [itemDic release];
    }
    
    self.rowShowList = itemRowList;
    [itemRowList release];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    [self.contentTable.contentTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
}

- (void)didClickedPhoto:(SectionClickView *)sectionView
{
    NSInteger section = sectionView.tag - SECTION_BASE_VIEW_TAG;
    NSDictionary  *data = [self.itemList objectAtIndex:section];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didGoToPhotoView:)]) {
        [self.delegate didGoToPhotoView:data];
    }
}

- (void)didShowCheckFlow:(SectionClickView *)sectionView
{
    NSInteger section = sectionView.tag - SECTION_BASE_VIEW_TAG;
    NSDictionary  *data = [self.itemList objectAtIndex:section];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didGoToFlowVC:)]) {
        [self.delegate didGoToFlowVC:data];
    }
}


#pragma mark
#pragma mark - OrderConditionViewDelegate
- (void)didOrderConditionSearch:(NSDictionary *)data
{
    pageLoadNum = 0;
    [self.contentTable resetViewDataStream];
    
    NSMutableDictionary *paramter = [[NSMutableDictionary alloc] initWithDictionary:data
                                                                          copyItems:YES];
    self.paramterDic = paramter;
    [paramter release];
    bussineDataService *bussineService = [bussineDataService sharedDataService];
    bussineService.target = self;
    [bussineService searchAccountOrder:self.paramterDic];
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errorCode = [info objectForKey:@"errorCode"];
    if ([bizCode isEqualToString:[SearchOpenAccountOrderMessage getBizCode]]) {
        if ([errorCode isEqualToString:@"0000"]) {
            bussineDataService *bussineService = [bussineDataService sharedDataService];
            NSDictionary *rspInfo = bussineService.rspInfo;
            NSString *respCode = [rspInfo objectForKey:@"respCode"];
            NSString *respDesc = [rspInfo objectForKey:@"respDesc"];
            if ([respCode isEqualToString:@"1"]) {
                NSArray *orderData = [rspInfo objectForKey:@"orderData"];
                
                [self.contentTable reloadViewData:orderData];
            }else{
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:respDesc
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alter show];
                [alter release];
                if (pageLoadNum == 0) {
                    [self.contentTable reloadViewData:nil];
                }
            }
            
        }
    }
}

- (void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* MSG = [info objectForKey:@"MSG"];
    if ([bizCode isEqualToString:[SearchOpenAccountOrderMessage getBizCode]]) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:MSG
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alter show];
        [alter release];
        if (pageLoadNum == 0) {
            [self.contentTable reloadViewData:nil];
        }
    }
}

@end

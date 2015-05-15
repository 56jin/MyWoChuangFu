//
//  SearchTypeBar.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SearchTypeBar.h"
#import "FileHelpers.h"
#define NAME_LABLE_TAG 4000
#define SEL_IMAGEVIEW_TAG 4001
#define NOR_IMAGEVIEW_TAG 4002
#define TABLE_VIEW_TAG    4003

@implementation SearchTypeBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMainView];
    }
    return self;
}

- (void)setSearchTypes:(NSArray *)searchTypes
{
    _searchTypes = searchTypes;
    UITableView *table = (UITableView *)[self viewWithTag:TABLE_VIEW_TAG];
    [table reloadData];
}

- (void)initMainView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    tableView.tag = TABLE_VIEW_TAG;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.scrollEnabled = NO;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,20)];
    tableView.tableHeaderView = headerView;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
}

#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SearchTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];

        UIImageView *selBgView = [[UIImageView alloc] init];
        UIImage *image= [UIImage imageNamed:@"bg_search_sidebar_hoverBg"];
        selBgView.image =[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
        UIImageView *selImageView = [[UIImageView alloc] init];
        selImageView.tag = SEL_IMAGEVIEW_TAG;
        [selBgView addSubview:selImageView];
        cell.selectedBackgroundView = selBgView;
        
        UIImageView *norBgView = [[UIImageView alloc] init];
        UIImageView *norImageView = [[UIImageView alloc] init];
        norImageView.tag = NOR_IMAGEVIEW_TAG;
        [norBgView addSubview:norImageView];
        cell.backgroundView = norBgView;
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0,60,90, 20)];
        [name setTextColor:[ComponentsFactory createColorByHex:@"#666666"]];
        [name setFont:[UIFont systemFontOfSize:14.0]];
#ifdef __IPHONE_6_0
        [name setTextAlignment:NSTextAlignmentCenter];
#else
        [name setTextAlignment:UITextAlignmentCenter];
#endif
        name.tag = NAME_LABLE_TAG;
        [cell.contentView addSubview:name];
    }

    UIImageView *selImageView = (UIImageView *)[cell.selectedBackgroundView viewWithTag:SEL_IMAGEVIEW_TAG];
    UIImageView *norImageView = (UIImageView *)[cell viewWithTag:NOR_IMAGEVIEW_TAG];
    UILabel *name = (UILabel *)[cell viewWithTag:NAME_LABLE_TAG];
    
    NSString *typeName = nil;
    
    NSDictionary *group = self.searchTypes[indexPath.row];
    typeName = [group objectForKey:@"groupName"];
    name.text = typeName;
    
    NSString *groupLogoURL = [group objectForKey:@"groupLogo"];
    NSString *groupLogo_On_URL = [group objectForKey:@"groupLogo_On"];
    
    if ([typeName isEqualToString:@"历史搜索"]) {
        UIImage *normal = [UIImage imageNamed:groupLogoURL];
        UIImage *select = [UIImage imageNamed:groupLogo_On_URL];
        norImageView.image = normal;
        norImageView.frame = CGRectMake((90-normal.size.width)/2,(86-normal.size.height)/2-10,normal.size.width,normal.size.height);
        selImageView.image = select;
        selImageView.frame = CGRectMake((90-select.size.width)/2,(86-select.size.height)/2-10,select.size.width,select.size.height);
        
    }else{
        if (hasCachedImage([NSURL URLWithString:groupLogoURL]))
        {
            UIImage *image = [UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:groupLogoURL])];
            norImageView.image= image;
            norImageView.frame = CGRectMake((90-image.size.width/2)/2,(86-image.size.height/2)/2-10,image.size.width/2,image.size.height/2);
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:groupLogoURL,@"url",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *image)
             {
                 norImageView.image=image;
                 norImageView.frame = CGRectMake((90-image.size.width/2)/2,(86-image.size.height/2)/2-10,image.size.width/2,image.size.height/2);
             }];
        }
        
        if (hasCachedImage([NSURL URLWithString:groupLogo_On_URL]))
        {
            UIImage *image = [UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:groupLogo_On_URL])];
            selImageView.image= image;
            selImageView.frame = CGRectMake((90-image.size.width/2)/2,(86-image.size.height/2)/2-10,image.size.width/2,image.size.height/2);
        }else{
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:groupLogo_On_URL,@"url",nil];
            [ComponentsFactory dispatch_process_with_thread:^{
                UIImage* ima = [self LoadImage:dic];
                return ima;
            } result:^(UIImage *image)
             {
                 selImageView.image=image;
                 selImageView.frame = CGRectMake((90-image.size.width/2)/2,(86-image.size.height/2)/2-10,image.size.width/2,image.size.height/2);
             }];
        }

    }
    //默认选中第一个Cell
    if (indexPath.row == 0)
    {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        if ([self.delegate respondsToSelector:@selector(searchTypeBar:didSelectAtIndex:)])
        {
            [self.delegate searchTypeBar:self didSelectAtIndex:indexPath.row];
        }
    }
    return cell;
}
#pragma mark - 异步图片
- (UIImage *)LoadImage:(NSDictionary*)aDic{
    
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL];
    if (data == nil) {
        return nil;
    }
    UIImage *image=[UIImage imageWithData:data];
    [fileManager createFileAtPath:pathForURL(aURL) contents:data attributes:nil];
    return image;
}
#pragma mark
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(searchTypeBar:didSelectAtIndex:)])
    {
        [self.delegate searchTypeBar:self didSelectAtIndex:indexPath.row];
    }
}

@end

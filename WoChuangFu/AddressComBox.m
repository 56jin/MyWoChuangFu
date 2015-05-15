//
//  AddressComBox.m
//  WoChuangFu
//
//  Created by 李新新 on 15-2-7.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "AddressComBox.h"

@interface AddressComBox()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isShow;
}

@property(nonatomic,weak) UIImageView *imageView;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,weak)  UILabel  *titleLabel;

@end

@implementation AddressComBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isShow = NO;
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width-15,self.frame.size.height)];
        [self addSubview:lable];
        self.titleLabel = lable;
        lable.textColor = [ComponentsFactory createColorByHex:@"#666666"];
        lable.backgroundColor = [UIColor clearColor];
        lable.text = @"请选择您所在的城市";
#ifdef __IPHONE_6_0
        [lable setTextAlignment:NSTextAlignmentCenter];
#else
        [lable setTextAlignment:UITextAlignmentCenter];
#endif
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_dark0"]];
        imageView.frame = CGRectMake(self.frame.size.width-25,(self.frame.size.height-15)/2,15,15);
        self.imageView = imageView;
        [self addSubview:imageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = self.bounds;
        [self addSubview:button];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+self.frame.size.height,self.frame.size.width,0) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        self.tableView = tableView;
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender
{
    isShow = !isShow;
    [self imageViewAnimation];
    [self tableViewAnimation];
}

- (void)imageViewAnimation
{
    if (isShow) {
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

- (void)tableViewAnimation
{
    if (isShow) {
        [UIView animateWithDuration:0.3f animations:^{
            if ([self.dataSources count] >0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            [self.superview addSubview:self.tableView];
            [self.superview bringSubviewToFront:self.tableView];
            CGRect rect = self.tableView.frame;
            rect.size.height = 300;
            self.tableView.frame = rect;
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            CGRect rect = self.tableView.frame;
            rect.size.height = 0;
            self.tableView.frame = rect;
        }completion:^(BOOL finished) {
            [self.tableView removeFromSuperview];
        }];
        
    }
}

#pragma mark -tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.textLabel.textColor = [ComponentsFactory createColorByHex:@"#666666"];
    }
    cell.textLabel.text = [self.dataSources objectAtIndex:indexPath.row][@"areaName"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.dataSources[indexPath.row];
    self.titleLabel.text = dict[@"areaName"];
    [self btnClicked:nil];
    if([self.delegate respondsToSelector:@selector(addressComBox:didSelectAtIndex:withData:)])
    {
        [self.delegate addressComBox:self didSelectAtIndex:indexPath.row withData:dict];
    }
}


@end

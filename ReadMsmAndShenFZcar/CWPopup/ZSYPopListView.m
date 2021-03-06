//
//  ZSYPopListView.m
//  StoreGuest
//
//  Created by 1 on 14-9-29.
//  Copyright (c) 2014年 mobitide. All rights reserved.
//

#import "ZSYPopListView.h"

@implementation ZSYPopListView



@synthesize selectedIndexPath = _selectedIndexPath;
@synthesize delegate = delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWitZSYPopFrame:(CGRect)frame WithNSArray:(NSMutableArray *)data{
    self = [super init];
    if (self) {
        
        dateData = [NSMutableArray arrayWithArray:data];
        
        listView = [[ZSYPopoverListView alloc] initWithFrame:frame];
        listView.titleName.text = @"选择取消原因";
        listView.datasource = self;
        listView.delegate = self;
        [listView setCancelButtonTitle:@"取消" block:^{}];
        [listView setDoneButtonWithTitle:@"确定" block:^{}];
        [listView show];
        
        self.frame = frame;

    }
    return self;
}

- (id)initWitZSYPopFrame:(CGRect)frame WithNSArray:(NSMutableArray *)data WithString:(NSString *)string{
    self = [super init];
    if (self) {
        
        dateData = [NSMutableArray arrayWithArray:data];
        
        listView = [[ZSYPopoverListView alloc] initWithFrame:frame];
        listView.titleName.text = string;
        listView.datasource = self;
        listView.delegate = self;
//        [listView setCancelButtonTitle:@"取消" block:^{}];
//        [listView setDoneButtonWithTitle:@"确定" block:^{}];
        [listView show];
        
        self.frame = frame;
        
    }
    return self;
}



#pragma mark -ZSYPopoverListView
- (NSInteger)popoverListView:(ZSYPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dateData.count;
}

- (UITableViewCell *)popoverListView:(ZSYPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identifier];
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
   
        
    
    
    
    
    if (self.isTitle == NO) {
        
        if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
        {
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
        }
        cell.textLabel.font=[UIFont boldSystemFontOfSize:17];
        cell.textLabel.lineBreakMode=NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines=0;
        cell.textLabel.text = [dateData objectAtIndex:indexPath.row][@"name"];

    }else{
        
        if (indexPath.row != dateData.count - 1){
            
            if ( self.selectedIndexPath && NSOrderedSame == [self.selectedIndexPath compare:indexPath])
            {
                cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
            }
            else
            {
                cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
            }
            cell.textLabel.font=[UIFont boldSystemFontOfSize:17];
            cell.textLabel.lineBreakMode=NSLineBreakByCharWrapping;
            cell.textLabel.numberOfLines=0;
            cell.textLabel.text = [dateData objectAtIndex:indexPath.row][@"name"];
            
        }

        
//        else if (indexPath.row == dateData.count - 1) {
//            
//            UITextField *reasion = [UITextField new];
//            reasion.frame = CGRectMake(5.0f, 5.0f, 200 - 10, 35);
//            reasion.font = [UIFont systemFontOfSize:14.0];
//            reasion.textColor = [UIColor blackColor];
//            reasion.textAlignment = NSTextAlignmentLeft;
//            reasion.tag = 1001;
//            reasion.borderStyle = UITextBorderStyleRoundedRect;
//            reasion.returnKeyType = UIReturnKeyDone;
//            //        rightTextField.adjustsFontSizeToFitWidth = YES;
//            reasion.delegate = self;
//            reasion.placeholder = @"请输入原因";
//            
//            [cell addSubview:reasion];
//        }

    }
    
    
    
    
    return cell;
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    //    NSLog(@"deselect:%ld", (long)indexPath.row);
    //    [listView dismiss];
}

- (void)popoverListView:(ZSYPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
    //    NSLog(@"select:%ld", (long)indexPath.row);
    state_info = [dateData objectAtIndex:indexPath.row];

    if (self.isTitle == NO) {
        
        if (delegate && [delegate respondsToSelector:@selector(sureDoneWith:)]) {
            [delegate sureDoneWith:state_info];
        }
    }
    
    
}

- (void)dissViewClose{
    
    [listView dismiss];
    [dateData removeAllObjects];
    dateData = nil;
    state_info = nil;
    
    listView.datasource = nil;
    listView.delegate = nil;
    
    listView = nil;
}


//确定按钮代理方法
-(void)sureDone{
    
    if (delegate && [delegate respondsToSelector:@selector(sureDoneWith:)]) {
        [delegate sureDoneWith:state_info];
    }

    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
//    [self dissViewClose];
//    
//    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"请输入原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [aler setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    [aler textFieldAtIndex:0].placeholder = @"请输入取消原因";
//    aler.tag = 377;
//    [aler show];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self endEditing:YES];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//     NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入内容
//    state_info = [NSString stringWithFormat:@"%@",toBeString];
////    NSLog(@"shu  ru :   %@",state_info);
//    return YES;
//}
//
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    state_info = [NSString stringWithFormat:@"%@",textField.text];
////    NSLog(@"wancheng shuru  :   %@",state_info);
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

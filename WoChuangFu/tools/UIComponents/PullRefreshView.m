//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshView.h"

#define REFRESH_HEADER_HEIGHT 52.0f


@implementation PullRefreshView

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner, lastRefreshTime, textUpdateTime;
@synthesize pDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self != nil) {
        textPull = [[NSString alloc] initWithString:@"拖动来更新..."];
        textRelease = [[NSString alloc] initWithString:@"松开来更新..."];
        textLoading = [[NSString alloc] initWithString:@"加载中..."];
        textUpdateTime = [[NSString alloc]initWithString:@"最后更新于: "];
        self.delegate = self;
        [self addPullToRefreshHeader];
    }
    return self;
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];

    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 320, 15)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont systemFontOfSize:12.0];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    refreshLabel.textColor = [UIColor lightGrayColor];
    
    lastRefreshTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 15)];
    lastRefreshTime.backgroundColor = [UIColor clearColor];
    lastRefreshTime.font = [UIFont systemFontOfSize:12.0];
    lastRefreshTime.textAlignment = UITextAlignmentCenter;
    lastRefreshTime.textColor = [UIColor lightGrayColor];
    lastRefreshTime.text = [self formatDate:@"MM/dd/yyyy HH:mm"];
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT) / 2,
                                    (REFRESH_HEADER_HEIGHT - 39) / 2,
                                    22, 39);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT -10) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    refreshSpinner.hidesWhenStopped = YES;

    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:lastRefreshTime];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    [self addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            [refreshArrow layer].transform = CATransform3DMakeRotation(-M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
    
    if (isLoading == NO && isDragging == NO && (scrollView.contentSize.height - scrollView.contentOffset.y - scrollView.frame.size.height) < 20) {
        //[loadMoreViewTemp startLoading];
        if (pDelegate && [pDelegate respondsToSelector:@selector(pullLoadMoreTableView:)]) {
            [pDelegate pullLoadMoreTableView:self];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (pDelegate &&  [pDelegate respondsToSelector:@selector(pullRefreshTableView:didSelectRowAtIndexPath:)]) {
        [pDelegate pullRefreshTableView:self didSelectRowAtIndexPath:indexPath];
    }
}
-(void)startLoadMore
{
    [loadMoreViewTemp startLoading];
}
-(void)stopLoadMore
{
    [loadMoreViewTemp stopLoading];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (pDelegate &&  [pDelegate respondsToSelector:@selector(pullRefreshTableView:heightForHeaderInSection:)]) {
        return [pDelegate pullRefreshTableView:self heightForHeaderInSection:section];
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (pDelegate &&  [pDelegate respondsToSelector:@selector(pullRefreshTableView:heightForRowAtIndexPath:)]) {
        return [pDelegate pullRefreshTableView:self heightForRowAtIndexPath:indexPath];
    }
    
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    LoadMoreView *loadMoreView = [[LoadMoreView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    loadMoreViewTemp = loadMoreView;
    //[loadMoreView startLoading];
    return [loadMoreView autorelease];
     
}

- (void)startLoading {
    isLoading = YES;

    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];

    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    lastRefreshTime.text = [self formatDate:@"MM/dd/yyyy HH:mm"];
   
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.contentInset = UIEdgeInsetsZero;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}
-(NSString *)formatDate:(NSString *)format
{
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:format];
    NSString *s = [NSString stringWithFormat:@"%@%@",textUpdateTime,[f stringFromDate:[NSDate date]]];
    [f release];
    return s;
}
- (void)refresh {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    if (pDelegate && [pDelegate respondsToSelector:@selector(pullRefreshTableView:)]) {
        [pDelegate pullRefreshTableView:self];
    }
}

- (void)dealloc {
    [refreshHeaderView release];
    [refreshLabel release];
    [lastRefreshTime release];
    [refreshArrow release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [textUpdateTime release];
    [super dealloc];
}

@end

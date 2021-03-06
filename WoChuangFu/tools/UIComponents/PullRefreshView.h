//
//  PullRefreshTableViewController.h
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

#import <UIKit/UIKit.h>
#import "LoadMoreView.h"

@protocol PullRefreshViewDelegate;


@interface PullRefreshView : UITableView<UITableViewDelegate> {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UILabel *lastRefreshTime;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    NSString *textUpdateTime;
    
    LoadMoreView *loadMoreViewTemp;
    id<PullRefreshViewDelegate> pDelegate;
}

@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UILabel *lastRefreshTime;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, copy) NSString *textUpdateTime;
@property (nonatomic, assign) id<PullRefreshViewDelegate> pDelegate;


-(NSString *)formatDate:(NSString *)format;
- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;
- (void)startLoadMore;
- (void)stopLoadMore;
@end

@protocol PullRefreshViewDelegate<NSObject>
@required
-(void)pullRefreshTableView:(PullRefreshView *)tableview ;
-(void)pullLoadMoreTableView:(PullRefreshView *)tableview ;
-(void)pullRefreshTableView:(PullRefreshView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)pullRefreshTableView:(PullRefreshView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
-(CGFloat)pullRefreshTableView:(PullRefreshView *)tableView heightForHeaderInSection:(NSInteger)section;
@end 

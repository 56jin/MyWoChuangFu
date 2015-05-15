#import "EvaluateTableVC.h"
#import "EvaluateCell.h"
#import "MJRefresh.h"
#import "bussineDataService.h"
#import "EvaluateCellFrame.h"
#import "EvaluateModel.h"
#define PAFE_COUNT @"20"

static NSString *identifier = @"EvaluationCell";

@interface EvaluateTableVC ()<HttpBackDelegate>
{
    NSMutableArray      *evaluatesList;    //评论列表
    NSMutableDictionary *requestDict;      //请求列表
    int                 pageIndex;         //页码
}

@end

@implementation EvaluateTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    pageIndex = 1;
    evaluatesList = [NSMutableArray array];
    // 上拉加载更多
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    requestDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   self.productId,@"productId",
                   [NSString stringWithFormat:@"%d",self.evaluateId],@"productType",
                   @"1",@"pageIndex",
                   PAFE_COUNT,@"pageCount",nil];
    
    [bus getEvaluate:requestDict];
}

//下拉刷新
- (void)footerRereshing
{
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    [bus getEvaluate:requestDict];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return evaluatesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EvaluateCell *cell = (EvaluateCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[EvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.myEvaluateCellFrame = evaluatesList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EvaluateCellFrame *frame = evaluatesList[indexPath.row];
    return frame.cellHeight;
}

- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if ([[GetEvaluateMessage getBizCode] isEqualToString:bizCode])
    {
        if ([oKCode isEqualToString:errCode])
        {
            bussineDataService *bus = [bussineDataService sharedDataService];
            bus.target = self;
            if (bus.rspInfo[@"evaluates"] != [NSNull null])
            {
                NSArray *array =bus.rspInfo[@"evaluates"];
                if (array.count == 0) {
                    [self ShowProgressHUDwithMessage:@"没有更多评论了！"];
                }
                else
                {
                    for (NSDictionary *dict in bus.rspInfo[@"evaluates"])
                    {
                        EvaluateModel *model = [[EvaluateModel alloc] initWithDict:dict];
                        EvaluateCellFrame *frame =[[EvaluateCellFrame alloc] init];
                        frame.evaluateModel = model;
                        [evaluatesList addObject:frame];
//                        [self.tableView beginUpdates];
//                        int newRowIndex = [evaluatesList count];
//                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex-1<0?newRowIndex:newRowIndex-1 inSection:0];
//                        [self.tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//                        [self.tableView endUpdates];
                    }
                    [self.tableView reloadData];
                    pageIndex ++;
                    [requestDict setObject:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
                }
            }
            else
                [self ShowProgressHUDwithMessage:@"没有更多评论了！"];
        }
        else
        {
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"刷新异常！";
            }
            if(nil == msg){
                msg = @"刷新异常！";
            }
            [self ShowProgressHUDwithMessage:msg];
        }
    }
    [self.tableView footerEndRefreshing];
}
- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[GetEvaluateMessage getBizCode] isEqualToString:bizCode])
    {
        if([info objectForKey:@"MSG"] == [NSNull null])
        {
            msg = @"刷新失败！";
        }
        if(nil == msg)
        {
            msg = @"刷新失败！";
        }
        [self ShowProgressHUDwithMessage:msg];
    }
    [self.tableView footerEndRefreshing];
}

- (void)cancelTimeOutAndLinkError
{
    if ([self.tableView isFooterRefreshing])
    {
        [self.tableView footerEndRefreshing];
    }
}

- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}


@end

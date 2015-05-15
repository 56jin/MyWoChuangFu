#import "ProductEvaluationVC.h"
#import "TitleBar.h"
#import "TabBar.h"
#import "MJRefresh.h"
#import "UIImage+LXX.h"
#import "StarView.h"
#import "EvaluateTableVC.h"

#define PAGE_COUNT 4   //页数
#define MY_TAB_BAR_HEIGHT 33
#define EVABAR_HEIGHT 20  //评价条高度
#define NAVBAR_HEIGHT 64 //导航栏高度
#define PHONE_WIDTH [AppDelegate sharePhoneWidth] //手机宽度
#define PHONE_HEIGHT [AppDelegate sharePhoneHeight] //手机高度
#define MARGIN 10
//=====第一页=====
#define EVE_CONTENT_VIEW_HEIGHT 130 //EVA容器视图高度
#define EVE_CONTENT_TOP_MARGIN 24   //距离视图顶部位置
#define EVE_LINE_POSTION_X 155      //EVA视图X坐标
#define EVE_LINE_POSTION_Y 24       //EVA视图Y坐标(第一个)
#define EVA_LINE_HEIGHT 20          //EVA视图高度
#define EVA_LINE_MARGIN 10          //EVE视图间距
#define EVA_LINE_WIDTH 150          //EVE视图长度

#define EVE_IMGVIEW_POSTION_X 115.5 //EVE图片视图X坐标
#define EVE_IMGVIEW_HEIGHT 23       //EVE图片视图高度
#define EVE_IMGVIEW_WIDTH 22.5      //EVE图片视图长度


@interface ProductEvaluationVC ()<TabBarDelegate,UIScrollViewDelegate,UITextViewDelegate,HttpBackDelegate,StarViewDelegate,TitleBarDelegate>
{
    //评论条
    UIView *evaLine_G;//好
    UIView *evaLine_N;//中
    UIView *evaLine_B;//差
    UILabel *evaNumLable_G;//好评率标签
    
    UITextView *myTextView;//评论输入框
    UILabel *placeholder_lable;//评论holder
    
    //主容器
    UIScrollView *mainContentView;
    TabBar *myTabbar;
    
    EvaluateTableVC *tableVC_G;//好评控制器
    EvaluateTableVC *tableVC_N;//中评控制器
    EvaluateTableVC *tableVC_B;//差评控制器
    
    int starCount;//星星数量
    
    UIButton *submitBtn; //提交按钮
}

@end

@implementation ProductEvaluationVC

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT)];
    [self layoutSubViews];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    starCount = 5;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setEvaluationLine:self.evaluateDict];
}

- (void)layoutSubViews
{
    //导航条
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:NO TitlePos:middle_position];
    if (IOS7) {
        titleBar.frame = CGRectMake(0, 20, PHONE_WIDTH, 44);
    }
    titleBar.target = self;
    titleBar.title= @"商品评价";
    [self.view addSubview:titleBar];
    
    //选择条
    TabBar *tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, PHONE_WIDTH,MY_TAB_BAR_HEIGHT) andTitles:@[@"评论",@"好评",@"中评",@"差评"]];
    tabBar.delegate = self;
    myTabbar = tabBar;
    tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabBar];
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT + MY_TAB_BAR_HEIGHT, PHONE_WIDTH, PHONE_HEIGHT - MY_TAB_BAR_HEIGHT- NAVBAR_HEIGHT)];
    mainView.backgroundColor = [ComponentsFactory createColorByHex:@"#f0eff4"];
    mainView.bounces = NO;
    mainView.pagingEnabled = YES;
    mainView.contentSize = CGSizeMake(PHONE_WIDTH * PAGE_COUNT, 0);
    [self.view addSubview:mainView];
    mainView.delegate = self;
    mainContentView = mainView;
    //评论视图
    UIView *evaView = [[UIView alloc] initWithFrame:CGRectMake(0,0,PHONE_WIDTH, PHONE_HEIGHT-MY_TAB_BAR_HEIGHT- NAVBAR_HEIGHT)];
    
    //图表容器视图
    UIView *evaContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,PHONE_WIDTH,EVE_CONTENT_VIEW_HEIGHT)];
    evaContentView.backgroundColor = [UIColor whiteColor];
    
    //添加单击手势
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Taped:)];
    [evaContentView addGestureRecognizer:recognizer];
    
    //好评标签
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 95, 50)];
    [lable1 setFont:[UIFont systemFontOfSize:55]];
#ifdef __IPHONE_6_0
    lable1.textAlignment = NSTextAlignmentCenter;
#else
    lable1.textAlignment = UITextAlignmentCenter;
#endif
    [lable1 setTextColor:[ComponentsFactory createColorByHex:@"#f96c00"]];
    lable1.text = @"00";
    evaNumLable_G = lable1;
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(87, 70, 30, 20)];
    [lable2 setFont:[UIFont systemFontOfSize:20]];
    lable2.text = @"%";
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 75, 20)];
    [lable3 setFont:[UIFont systemFontOfSize:20]];
#ifdef __IPHONE_6_0
    [lable3 setTextAlignment:NSTextAlignmentCenter];
#else
    [lable3 setTextAlignment:UITextAlignmentCenter];
#endif
    lable3.text = @"好评率";
    [evaContentView addSubview:lable1];
    [evaContentView addSubview:lable2];
    [evaContentView addSubview:lable3];
    //红色
    UIView *redView_bg = [[UIView alloc] initWithFrame:CGRectMake(EVE_LINE_POSTION_X,EVE_LINE_POSTION_Y,EVA_LINE_WIDTH,EVA_LINE_HEIGHT)];
    redView_bg.backgroundColor = [ComponentsFactory createColorByHex:@"#f2f0eb"];
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(EVE_LINE_POSTION_X,EVE_LINE_POSTION_Y,0,EVABAR_HEIGHT)];
    redView.backgroundColor = [ComponentsFactory createColorByHex:@"#e61515"];
    UIImageView *goodView = [[UIImageView alloc] initWithFrame:CGRectMake(EVE_IMGVIEW_POSTION_X,EVE_LINE_POSTION_Y,EVE_IMGVIEW_WIDTH,EVE_IMGVIEW_HEIGHT)];
    goodView.image = [UIImage imageNamed:@"red"];
    evaLine_G = redView;
    
    //黄色
    UIView *yellowView_bg = [[UIView alloc] initWithFrame:CGRectMake(EVE_LINE_POSTION_X,EVE_LINE_POSTION_Y+EVA_LINE_HEIGHT+EVA_LINE_MARGIN, EVA_LINE_WIDTH, EVABAR_HEIGHT)];
    yellowView_bg.backgroundColor = [ComponentsFactory createColorByHex:@"#f2f0eb"];
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(EVE_LINE_POSTION_X,EVE_LINE_POSTION_Y+EVA_LINE_HEIGHT+EVA_LINE_MARGIN,0, EVABAR_HEIGHT)];
    yellowView.backgroundColor = [ComponentsFactory createColorByHex:@"#ffae00"];
    UIImageView *normalView = [[UIImageView alloc] initWithFrame:CGRectMake(EVE_IMGVIEW_POSTION_X,EVE_LINE_POSTION_Y+EVA_LINE_HEIGHT+EVA_LINE_MARGIN, EVE_IMGVIEW_WIDTH,EVE_IMGVIEW_HEIGHT)];
    normalView.image = [UIImage imageNamed:@"yellow"];
    evaLine_N = yellowView;
    
    //蓝色
    UIView *blueView_bg = [[UIView alloc] initWithFrame:CGRectMake(EVE_LINE_POSTION_X,EVE_LINE_POSTION_Y+(EVA_LINE_HEIGHT+EVA_LINE_MARGIN)*2, EVA_LINE_WIDTH, EVABAR_HEIGHT)];
    blueView_bg.backgroundColor = [ComponentsFactory createColorByHex:@"#f2f0eb"];
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(EVE_LINE_POSTION_X,EVE_LINE_POSTION_Y+(EVA_LINE_HEIGHT+EVA_LINE_MARGIN)*2,0, EVABAR_HEIGHT)];
    blueView.backgroundColor = [ComponentsFactory createColorByHex:@"#3598dd"];
    UIImageView *badView = [[UIImageView alloc]initWithFrame:CGRectMake(EVE_IMGVIEW_POSTION_X,EVE_LINE_POSTION_Y+(EVA_LINE_HEIGHT+EVA_LINE_MARGIN)*2, EVE_IMGVIEW_WIDTH,EVE_IMGVIEW_HEIGHT)];
    badView.image = [UIImage imageNamed:@"blue"];
    evaLine_B = blueView;
    
    //评论输入区
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(0, EVE_CONTENT_VIEW_HEIGHT + 5, PHONE_WIDTH, 100)];
    textV.delegate = self;
    textV.returnKeyType = UIReturnKeyDone;
    [textV setFont:[UIFont systemFontOfSize:16.0f]];
    myTextView = textV;
    placeholder_lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, PHONE_WIDTH - 20, 20)];
    [placeholder_lable setTextColor:[UIColor lightGrayColor]];
    placeholder_lable.text = @"服务评价，限100字以内";
    [textV addSubview:placeholder_lable];
    [evaView addSubview:textV];
    
    //满意度评价
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, EVE_CONTENT_VIEW_HEIGHT + 110, PHONE_WIDTH, 40);
    bgView.backgroundColor = [UIColor whiteColor];
    
    //满意度标签
    UILabel *satlab = [[UILabel alloc] init];
    [satlab setFrame:CGRectMake(15,10, 100, 21)];
    satlab.font =[UIFont systemFontOfSize:16];
    satlab.text = @"满意度评分";
    [bgView addSubview:satlab];
    
    StarView *starView = [[StarView alloc] initWithFrame:CGRectMake(180, 10, 100, 21)];
    starView.delegate = self;
    [bgView addSubview:starView];
    
    //按钮区
    //按钮背景
    UIView *btnView = [[UIView alloc] init];
    btnView.frame = CGRectMake(0,evaView.frame.size.height - 50, PHONE_WIDTH, 50);
    btnView.backgroundColor = [UIColor whiteColor];
    //按钮
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(10, 7, PHONE_WIDTH - 20,36);
    [submitBtn setBackgroundImage:[UIImage resizedImage:@"bnt_content_primary_n.png"] forState:UIControlStateNormal];
    submitBtn.enabled = NO;
    [submitBtn addTarget:self action:@selector(submitEvaluation:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:submitBtn];
    
    [evaView addSubview:btnView];
    [evaView addSubview:bgView];
    [evaContentView addSubview:redView_bg];
    [evaContentView addSubview:redView];
    [evaContentView addSubview:goodView];
    [evaContentView addSubview:yellowView_bg];
    [evaContentView addSubview:yellowView];
    [evaContentView addSubview:normalView];
    [evaContentView addSubview:blueView_bg];
    [evaContentView addSubview:blueView];
    [evaContentView addSubview:badView];
    [evaView addSubview:evaContentView];
    [mainView addSubview:evaView];
}

- (void)submitEvaluation:(UIButton *)sender
{
    bussineDataService *bus = [bussineDataService sharedDataService];
    bus.target = self;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.productId,@"productId",myTextView.text, @"evaluateContent",[NSString stringWithFormat:@"%d",starCount],@"evaluatesStar",nil];
    [bus ProductEvaluate:dict];
    sender.enabled = NO;
    placeholder_lable.hidden = NO;
}

//设置评论条百分比
- (void)setEvaluationLine:(NSDictionary *)dict
{
    int count =  [dict[@"evaluateCount"] intValue];
    int evaluateNiceCount = [dict[@"evaluateNiceCount"] intValue];
    int evaluateNeutralCoun = [dict[@"evaluateNeutralCoun"] intValue];
    int evaluateNegativeCoun = [dict[@"evaluateNegativeCoun"] intValue];
    if (count >0)
    {
        [UIView animateWithDuration:2 animations:^{
            [evaLine_G setFrame:CGRectMake(EVE_LINE_POSTION_X, 24, EVA_LINE_WIDTH *evaluateNiceCount/count, EVABAR_HEIGHT)];
            [evaLine_N setFrame:CGRectMake(EVE_LINE_POSTION_X, 24 + 20 + 10, EVA_LINE_WIDTH *evaluateNeutralCoun/count, EVABAR_HEIGHT)];
            [evaLine_B setFrame:CGRectMake(EVE_LINE_POSTION_X, 24 + 20 + 10 + 20 + 10, EVA_LINE_WIDTH *evaluateNegativeCoun/count, EVABAR_HEIGHT)];
        }];
        float num = (double)evaluateNiceCount/count * 100.0;
        [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setEvaluationNum:) userInfo:@{@"Count":@((int)num)} repeats:YES];
        
    }
}

//设置评论百分比数值
- (void)setEvaluationNum:(NSTimer *)sender
{
    static int i = 0;
    if (i >[[sender.userInfo objectForKey:@"Count"] intValue] - 1)
    {
        [sender invalidate];
        evaNumLable_G.text = i < 9?[NSString stringWithFormat:@"0%d",i++]:[NSString stringWithFormat:@"%d",i++];
        i = 0;
    }
    else
    {
        evaNumLable_G.text = i < 9?[NSString stringWithFormat:@"0%d",i++]:[NSString stringWithFormat:@"%d",i++];
    }
}

#pragma mark - HttpBackDelegate

- (void)requestDidFinished:(NSDictionary*)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if ([[ProductEvaluateMessage getBizCode] isEqualToString:bizCode])
    {
        if ([oKCode isEqualToString:errCode])
        {
            myTextView.text = @"";
            bussineDataService *bus = [bussineDataService sharedDataService];
            if (bus.rspInfo[@"assess"] != [NSNull null])
            {
                [self setEvaluationLine:bus.rspInfo[@"assess"]];
                [self ShowProgressHUDwithMessage:@"评价成功"];
            }
        }
        else
        {
            if([NSNull null] == [info objectForKey:@"MSG"]){
                msg = @"评价失败！";
            }
            if(nil == msg){
                msg = @"评价失败！";
            }
            [self ShowProgressHUDwithMessage:msg];
        }
    }
}
- (void)requestFailed:(NSDictionary*)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ProductEvaluateMessage getBizCode] isEqualToString:bizCode])
    {
        if([info objectForKey:@"MSG"] == [NSNull null])
        {
            msg = @"评价失败！";
        }
        if(nil == msg)
        {
            msg = @"评价失败！";
        }
        [self ShowProgressHUDwithMessage:msg];
    }
}
- (void)cancelTimeOutAndLinkError
{
    [self ShowProgressHUDwithMessage:@"网络超时"];
}

//隐藏软键盘
- (void)Taped:(UITapGestureRecognizer *)recognizer
{
    if (myTextView.text.length == 0)
    {
        placeholder_lable.hidden = NO;
        submitBtn.enabled = NO;
    }
    [myTextView resignFirstResponder];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

- (void)textViewDidChange:(UITextView *)textView
{
    placeholder_lable.hidden = textView.text.length == 0 ?NO:YES;
    submitBtn.enabled = textView.text.length == 0 ?NO:YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 100)
    {
        textView.text = [textView.text substringToIndex:100];
    }
}

#pragma mark - TabBarDelegate
- (void)tabBar:(TabBar *)tabBar itemDidSelectedWithIndex:(NSInteger)index
{
    [self lazyAddEvaListView:index];
    [mainContentView setContentOffset:CGPointMake(PHONE_WIDTH *index, 0) animated:YES];
    if ([myTextView isFirstResponder])
    {
        [myTextView resignFirstResponder];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([myTextView isFirstResponder])
    {
        [myTextView resignFirstResponder];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //过滤UITableView的滚动影响
    if (![scrollView isMemberOfClass:[UITableView class]])
    {
        NSInteger index = (NSInteger)scrollView.contentOffset.x/PHONE_WIDTH;
        myTabbar.currentItemIndex = index;
        [self lazyAddEvaListView:index];
    }
}

#pragma mark - StarViewDelegate
- (void)starView:(StarView *)starView score:(int)score
{
    starCount = score;
}

- (void)lazyAddEvaListView:(int)index
{
    if (index == 1)
    {
        if (tableVC_G == nil)
        {
            tableVC_G = [[EvaluateTableVC alloc] init];
            tableVC_G.evaluateId = 1;
            tableVC_G.productId = self.productId;
            UIView *gv =tableVC_G.view;
            gv.frame = CGRectMake(PHONE_WIDTH *1,0, PHONE_WIDTH, PHONE_HEIGHT - MY_TAB_BAR_HEIGHT- NAVBAR_HEIGHT);
            [mainContentView addSubview:gv];
        }
    }
    else if(index == 2)
    {
        if(tableVC_N == nil)
        {
            tableVC_N = [[EvaluateTableVC alloc] init];
            tableVC_N.evaluateId = 2;
            tableVC_N.productId = self.productId;
            UIView *nv =tableVC_N.view;
            nv.frame = CGRectMake(PHONE_WIDTH *2,0, PHONE_WIDTH, PHONE_HEIGHT - MY_TAB_BAR_HEIGHT- NAVBAR_HEIGHT);
            [mainContentView addSubview:nv];
        }
    }
    else if(index == 3)
    {
        if(tableVC_B == nil)
        {
            tableVC_B = [[EvaluateTableVC alloc] init];
            tableVC_B.evaluateId = 3;
            tableVC_B.productId = self.productId;
            UIView *bv =tableVC_B.view;
            bv.frame = CGRectMake(PHONE_WIDTH *3,0, PHONE_WIDTH, PHONE_HEIGHT - MY_TAB_BAR_HEIGHT- NAVBAR_HEIGHT);
            [mainContentView addSubview:bv];
        }
    }
}
#pragma
#pragma TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)ShowProgressHUDwithMessage:(NSString *)msg
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = msg;
    hud.dimBackground = NO;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

@end

//
//  MessageCenterVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-26.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "MessageCenterVC.h"
#import "TitleBar.h"
#import "UrlParser.h"

#define SEPARATOR_TAG 4000
#define ROUND_TAG     4001
#define SEPARATOR_SEL_TAG 5000
#define ROUND_SEL_TAG     5001
#define MIN_CELL_HEIGHT  90
#define TEXT_LABLE_TAG 6000
#define TEXT_BG_TAG 6001
#define NO_CONTENT_IMAGEVIEW_TAG 6002
#define TABLE_VIEW_TAG  6003
#define DATA_LABLE_TAG 6004
#define TIME_LABLE_TAG 6005

@interface MessageCenterVC ()<TitleBarDelegate,UITableViewDataSource,UITableViewDelegate,HttpBackDelegate>

@property(nonatomic,strong) NSMutableArray *messages;
@property(nonatomic,strong) NSMutableDictionary *messageRequestDict;

@end

@implementation MessageCenterVC


- (NSMutableDictionary *)messageRequestDict
{
    if (_messageRequestDict == nil) {
        _messageRequestDict = [NSMutableDictionary dictionary];
        [_messageRequestDict setObject:@"1" forKey:@"page"];
        [_messageRequestDict setObject:@"20" forKey:@"size"];
        [_messageRequestDict setObject:@"" forKey:@"msgType"];
        [_messageRequestDict setObject:@"" forKey:@"msgId"];
    }
    return _messageRequestDict;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self sendGetMessageDataRequest];
}

- (void)sendGetMessageDataRequest
{
    bussineDataService *buss = [bussineDataService sharedDataService];
    buss.target = self;
    [buss getMsgCenterData:self.messageRequestDict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    bgView.backgroundColor = [UIColor blackColor];
    self.view = bgView;
    [self initTitleBar];
    [self initMainContentView];
    
}
- (void)initTitleBar
{
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    titleBar.frame = CGRectMake(0,[[UIScreen mainScreen] applicationFrame].origin.y,[AppDelegate sharePhoneWidth],44);
    titleBar.title = @"消息中心";
    titleBar.target = self;
    [self.view addSubview:titleBar];
}

- (NSMutableArray *)messages
{
    if (_messages == nil)
    {
        _messages = [NSMutableArray array];
//        WithObjects:@"中国将举行胜利日大阅兵，俄军可能共同受阅",@"2015年是第二次世界大战胜利70周年。日前，香港《文汇报》北京站执行总编辑凯雷向凤凰军事透露，作为反法西斯战争的战胜国，中国今年将举行盛大的胜利日大阅兵。此次阅兵亮点众多，不仅是中国元首习近平主席任内的首次阅兵，也是中国首次在抗战胜利纪念日举行阅兵，同时据俄罗斯方面的消息，俄元首普京将会飞抵北京共同与会，而俄军亦可能与中国军队一起参加受阅。",@"阅兵日期不是“十一”，规模略小于国庆阅兵",@"中华人民共和国建国以来，曾经在北京天安门广场进行过14次国庆大阅兵。由于2015年大阅兵的主旨，是纪念世界反法西斯战争暨中国抗日战争胜利70周年，因此今年的阅兵日期不是10月1日，而定在了9月3日，阅兵地点依然是北京天安门广场。据消息人士称，与以往国庆阅兵相比，今年阅兵的规模可能略小。",@" 俄方称将与中方共同举办，俄军或将参与受阅",@"凤凰军事注意到，中国外交部发言人华春莹1月23日在例行记者会上表示，今年是世界反法西斯战争暨中国人民抗日战争胜利70周年。中俄两国作为二战亚洲和欧洲两个主战场，将共同举办一系列庆祝活动，包括安排两国领导人相互出席对方举办的相关庆祝和纪念活动。据凯雷从俄方得到的消息，俄方将与中方共同举办这次大阅兵，其时很可能出现俄军受阅部队在天安门前与中国军队共同接受检阅的可能。",@" 胜利日阅兵或将成为惯例，“铭记历史，警示后人”",@"中国官方的相关表述正在发生着变化。2005年时，中国官方的表述是“中国人民抗日战争暨世界反法西斯战争胜利60周年”，然而现在，这种表述变成了“世界反法西斯战争暨中国人民抗日战争胜利70周年，也是联合国成立70周年”。凯雷分析，这显示出此次纪念活动的国际视野与国际定位，中俄共同举办纪念反法西斯战争胜利的纪念活动，就是要继续坚决反对歪曲历史和破坏战后国际秩序的图谋。习近平主席指出，要“铭记历史，警示后人”，而普京则说“希望人们牢记二战这一历史灾难”。据悉，中国的胜利日阅兵有可能成为惯例。",@"外国元首将与会，进一步确立中国反法西斯东方主战场地位",@"此次中国胜利日大阅兵将邀请外国元首参加。对此，军事专家罗援指出，中国将进一步确立其在反法西斯战争中作为东方主战场的地位，邀请抗战同盟国首脑参加阅兵活动，既彰显了世界人民大团结的精神，也表达了中国感谢世界人民对中国抗战做出的贡献。在那段艰难的岁月中，美国飞虎队、苏联航空支援队、加拿大白求恩医生等众多国际友人给予了中国人民有力的支援。",@"阅兵筹备工作业已展开，参阅武器装备引人关注",@"根据以往国庆大阅兵的情况来看，受阅部队一般会在当年春天进入阅兵村，进行为期半年左右高强度、高标准的受阅训练。据香港《文汇报》消息，将在大阅兵中参与受阅的解放军北京军区和武警部队已经在京郊多地集合，展开训练，阅兵村的建设也已基本完成。",@"在大阅兵上亮相的武器装备是人们热切关注的一点。此次胜利日大阅兵，中国将展出哪些武器装备，目前尚不得而知，中国的歼-20、俄罗斯的T-50会否出现在天安门广场上空参加受阅，成了人们猜测的焦点。这一切恐怕还要等到9月3日才能揭开答案。",nil
    }
    return _messages;
}

- (void)initMainContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,TITLE_BAR_HEIGHT+[[UIScreen mainScreen] applicationFrame].origin.y,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight]-TITLE_BAR_HEIGHT-[[UIScreen mainScreen] applicationFrame].origin.y) style:UITableViewStylePlain];
    tableView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
    tableView.tag = TABLE_VIEW_TAG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIImage *image = [UIImage imageNamed:@"has_no_content"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.tag = NO_CONTENT_IMAGEVIEW_TAG;
    imageView.center = CGPointMake(tableView.frame.size.width/2,tableView.frame.size.height/2);
    [tableView addSubview:imageView];
}

#pragma mark
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    
    NSDictionary *messageDict = [self.messages objectAtIndex:[indexPath row]];
    NSString *message= nil;
    if ([[messageDict objectForKey:@"msg_type"] intValue] == 10) {
        message = [NSString stringWithFormat:@"%@\n%@\n点击查看详情>>",[messageDict objectForKey:@"msg_title"],[messageDict objectForKey:@"msg_desc"]];
    }else{
        message = [NSString stringWithFormat:@"%@\n%@",[messageDict objectForKey:@"msg_title"],[messageDict objectForKey:@"msg_content"]];
    }
    
    CGRect messageRect =[message boundingRectWithSize:CGSizeMake(160, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                              context:nil];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //左边日期背景
        UIImage *image = [UIImage imageNamed:@"bg_settingNews_leftData"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12,15,90,60)];
        imageView.image = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
        [cell.contentView addSubview:imageView];
        
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0,0,90,20)];
        [date setFont:[UIFont systemFontOfSize:14]];
        date.tag = DATA_LABLE_TAG;
        date.textColor = [UIColor whiteColor];
#ifdef __IPHONE_6_0
        [date setTextAlignment:NSTextAlignmentCenter];
#else
        [date setTextAlignment:UITextAlignmentCenter];
#endif
        date.text = @"2015-1-27";
        [imageView addSubview:date];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0,25,90,30)];
        [time setFont:[UIFont systemFontOfSize:20]];
        time.textColor = [UIColor blackColor];
        time.tag = TIME_LABLE_TAG;
#ifdef __IPHONE_6_0
        [time setTextAlignment:NSTextAlignmentCenter];
#else
        [time setTextAlignment:UITextAlignmentCenter];
#endif
        time.text = @"19:15";
        [imageView addSubview:time];
        
        UIImageView *textBg = [[UIImageView alloc] init];
        textBg.tag = TEXT_BG_TAG;
        UIImage *textBgImg =  [UIImage imageNamed:@"bg_settingNews_newsBg"];
        textBg.image = [textBgImg stretchableImageWithLeftCapWidth:textBgImg.size.width*0.5 topCapHeight:textBgImg.size.height *0.5];
        [cell.contentView addSubview:textBg];
        
        UILabel *text = [[UILabel alloc] init];
        text.tag = TEXT_LABLE_TAG;
        text.backgroundColor = [UIColor clearColor];
        text.numberOfLines = 0;
        [text setFont:[UIFont systemFontOfSize:16]];
        [cell.contentView addSubview:text];
        
        UIView *backGroundView = [[UIView alloc] init];
        backGroundView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
        cell.backgroundView = backGroundView;
        
        //分割线
        UIView *separator = [[UIView alloc] init];
        separator.tag = SEPARATOR_TAG;
        separator.backgroundColor = [ComponentsFactory createColorByHex:@"#dddddd"];
        [cell.backgroundView addSubview:separator];
        
        //圆点
        UIImageView *round = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_settingNews_round"]];
        round.tag = ROUND_TAG;
        [cell.backgroundView addSubview:round];
        
        //选中背景
        UIView *selbackgroundView = [[UIView alloc] init];
        selbackgroundView.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
        cell.selectedBackgroundView = selbackgroundView;
        
        //选中分割线
        UIView *separatorSel = [[UIView alloc] init];//WithFrame:CGRectMake(114,0,2,100)
        separatorSel.tag = SEPARATOR_SEL_TAG;
        separatorSel.backgroundColor = [ComponentsFactory createColorByHex:@"#dddddd"];
        [cell.selectedBackgroundView addSubview:separatorSel];
        
        //选中圆点
        UIImageView *roundSel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_settingNews_round_p"]];
        roundSel.tag = ROUND_SEL_TAG;
        [cell.selectedBackgroundView addSubview:roundSel];
    }
    
    UIView *separator = [cell.backgroundView viewWithTag:SEPARATOR_TAG];
    UIView *separatorSel = [cell.selectedBackgroundView viewWithTag:SEPARATOR_SEL_TAG];
    if (messageRect.size.height+40 >MIN_CELL_HEIGHT) {
        separator.frame = CGRectMake(114,0,2,messageRect.size.height+40);
        separatorSel.frame = CGRectMake(114,0,2,messageRect.size.height+40);
    }else{
        separator.frame = CGRectMake(114,0,2,MIN_CELL_HEIGHT);
        separatorSel.frame = CGRectMake(114,0,2,MIN_CELL_HEIGHT);
    }
    
    UIImageView *round = (UIImageView *)[cell.backgroundView viewWithTag:ROUND_TAG];
    UIImageView *roundSel = (UIImageView *)[cell.selectedBackgroundView viewWithTag:ROUND_SEL_TAG];
    round.center = CGPointMake(separator.frame.origin.x+1,30);
    roundSel.center = CGPointMake(separatorSel.frame.origin.x+1,30);

    UIImageView *textBg = (UIImageView *)[cell viewWithTag:TEXT_BG_TAG];

    if (messageRect.size.height<60) {
        textBg.frame = CGRectMake(130,15,180,65);
    }else{
        textBg.frame = CGRectMake(130,15,180,messageRect.size.height+15);
    }
    UILabel *text = (UILabel *)[cell viewWithTag:TEXT_LABLE_TAG];
    text.frame = CGRectMake(140,20,170,messageRect.size.height);

    if ([[messageDict objectForKey:@"msg_type"] intValue] == 10) {
        NSRange range = [message rangeOfString:@"点击查看详情>>"];
        if (range.location != NSNotFound &&range.length !=0) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[ComponentsFactory createColorByHex:@"#ff7900"] range:range];
            text.attributedText = attrStr;
        }else{
            text.text = message;
        }
    }else{
        text.text = message;
    }
    UILabel *dataLabel = (UILabel *)[cell viewWithTag:DATA_LABLE_TAG];
    UILabel *timeLabel = (UILabel *)[cell viewWithTag:TIME_LABLE_TAG];
    
    NSString *time = [messageDict objectForKey:@"msg_time"];
    NSArray *timeArr = [time componentsSeparatedByString:@" "];
    dataLabel.text = [timeArr firstObject];
    timeLabel.text = [timeArr lastObject];
    
    return cell;
}

#pragma mark
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *messageDict = [self.messages objectAtIndex:[indexPath row]];
    if ([[messageDict objectForKey:@"msg_type"] intValue] == 10){
        NSString *url = [messageDict objectForKey:@"clickUrl"];
        if (url != nil && ![url isEqualToString:@""]) {
            [UrlParser gotoNewVCWithUrl:url VC:self];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *messageDict = [self.messages objectAtIndex:[indexPath row]];
    NSString *message= nil;
    if ([[messageDict objectForKey:@"msg_type"] intValue] == 10) {
        message = [NSString stringWithFormat:@"%@\n%@",[messageDict objectForKey:@"msg_title"],[messageDict objectForKey:@"msg_desc"]];
    }else{
        message = [NSString stringWithFormat:@"%@\n%@",[messageDict objectForKey:@"msg_title"],[messageDict objectForKey:@"msg_content"]];
    }
    
    CGRect messageRect =[message boundingRectWithSize:CGSizeMake(160, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                                context:nil];
    return (messageRect.size.height)<MIN_CELL_HEIGHT?MIN_CELL_HEIGHT:messageRect.size.height;
}


#pragma mark
#pragma mark - TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - HttpBackDelegate
- (void)requestDidFinished:(NSDictionary *)info
{
    NSString* oKCode = @"0000";
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* errCode = [info objectForKey:@"errorCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[GetMsgCenterData getBizCode] isEqualToString:bizCode])
    {
        if([oKCode isEqualToString:errCode])
        {
            bussineDataService *buss = [bussineDataService sharedDataService];
            self.messages = [buss.rspInfo objectForKey:@"msgs"];
            UIImageView *imageView = (UIImageView *)[self.view viewWithTag:NO_CONTENT_IMAGEVIEW_TAG];
            if ([self.messages count] == 0) {
                imageView.hidden = NO;
            }else{
                imageView.hidden = YES;
            }
            UITableView *table = (UITableView *)[self.view viewWithTag:TABLE_VIEW_TAG];
            [table reloadData];
        }
        else
        {
            if (msg == nil || [msg isEqualToString:@""]) {
                msg = @"暂无消息记录！";
            }
            [self ShowProgressHUDwithMessage:msg];
        }
    }
}
- (void)requestFailed:(NSDictionary *)info
{
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    if([[GetMsgCenterData getBizCode] isEqualToString:bizCode])
    {
        if (msg == nil || [msg isEqualToString:@""]) {
                msg = @"暂无消息记录！";
        }
        [self ShowProgressHUDwithMessage:msg];
    }
}
#pragma mark - HUD
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

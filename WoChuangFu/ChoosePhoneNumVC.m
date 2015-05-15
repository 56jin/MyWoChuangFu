//
//  ChoosePhoneNumVC.m
//  WoChuangFu
//
//  Created by 李新新 on 15-1-29.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "ChoosePhoneNumVC.h"
#import "TitleBar.h"
#import "UIImage+LXX.h"
#import "MJRefresh.h"
#import <CoreLocation/CoreLocation.h>
#import "FilterView.h"

#define postion_y [UIScreen mainScreen].applicationFrame.origin.y
#define TITLE_HEIGHT (postion_y+TITLE_BAR_HEIGHT)
#define FOOT_VIEW_HEIGHT 44
#define ITEM_HEIGHT 44
#define LEFT_BTN_TAG 8000
#define LEFT_LABEL_TAG 8001
#define RIGHT_BTN_TAG 8002
#define RIGHT_LABEL_TAG 8003
#define TABLE_VIEW_TAG 8004
#define PAGE_COUNT @"20"
#define LEFT_FILTER_BTN_TAG 8005
#define RIGHT_FILTER_BTN_TAG 8006


@interface ChoosePhoneNumVC ()<UITableViewDataSource,UITableViewDelegate,HttpBackDelegate,CLLocationManagerDelegate,TitleBarDelegate,FilterViewDelegate>
{
    UIButton          *currentSelectedBtn;
    NSInteger         currentpageIndex;
    BOOL              isFirstRequest;
    BOOL              isSearch;
    CLLocationManager *locationManager; //定位器
    CLGeocoder        *geocoder;        // 反向地理解析
}

@property(nonatomic,strong) NSMutableArray      *phoneNumbers;      //号码信息字典数组
@property(nonatomic,strong) NSArray             *areas;             //地区信息字典数组
@property(nonatomic,strong) NSMutableArray      *types;             //类型信息字典数组
@property(nonatomic,strong) NSMutableDictionary *requestParamsDict; //网络请求参数字典
@property(nonatomic,copy)   NSString            *searchKey;

@end

@implementation ChoosePhoneNumVC

-(NSMutableDictionary *)requestParamsDict
{
    if (_requestParamsDict == nil) {
        _requestParamsDict = [NSMutableDictionary dictionary];
        [_requestParamsDict setObject:PAGE_COUNT forKey:@"pageCount"];
        [_requestParamsDict setObject:@"initSearch" forKey:@"requestType"];
    }
    return _requestParamsDict;
}

#pragma mark
#pragma mark - 初始化视图
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    [self initTitleBar];
    [self initMainContentView];
    [self initBackToTopBtn];
    [self initFootFilterView];
}

- (void)initTitleBar
{
    TitleBar *titlebar = [[TitleBar alloc] initWithFramShowHome:YES ShowSearch:YES TitlePos:1];
    titlebar.frame = CGRectMake(0,postion_y,[AppDelegate sharePhoneWidth],TITLE_BAR_HEIGHT);
    titlebar.title = @"选择号码";
    titlebar.target = self;
    [self.view addSubview:titlebar];
}

- (void)initMainContentView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT,[AppDelegate sharePhoneWidth],[AppDelegate sharePhoneHeight]-TITLE_HEIGHT-FOOT_VIEW_HEIGHT) style:UITableViewStylePlain];
    [tableView setBackgroundColor:[ComponentsFactory createColorByHex:@"#eeeeee"]];
    tableView.tag = TABLE_VIEW_TAG;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView addFooterWithCallback:^{
        [self getPhoneNumbers];
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
}

- (void)initFootFilterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0,[AppDelegate sharePhoneHeight]-FOOT_VIEW_HEIGHT, [AppDelegate sharePhoneWidth], FOOT_VIEW_HEIGHT)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    float itemWidth = ([AppDelegate sharePhoneWidth]-1)/2;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftBtn setTitle:@"地区" forState:UIControlStateNormal];
    leftBtn.tag = LEFT_FILTER_BTN_TAG;
    [leftBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = (CGRect){CGPointZero,{itemWidth,FOOT_VIEW_HEIGHT}};
    [footView addSubview:leftBtn];
    
    UIView *separtor = [[UIView alloc] initWithFrame:CGRectMake(itemWidth,4,1,36)];
    [separtor setBackgroundColor:[ComponentsFactory createColorByHex:@"#eeeeee"]];
    [footView addSubview:separtor];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    rightBtn.tag = RIGHT_FILTER_BTN_TAG;
    [rightBtn addTarget:self action:@selector(filterBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"靓号" forState:UIControlStateNormal];
    rightBtn.frame = (CGRect){{itemWidth+1,0},{itemWidth,FOOT_VIEW_HEIGHT}};
    [footView addSubview:rightBtn];
}
- (void)initBackToTopBtn
{
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBtn setImage:[UIImage imageNamed:@"btn_list_top_n"] forState:UIControlStateNormal];
    [topBtn setImage:[UIImage imageNamed:@"btn_list_top_p"] forState:UIControlStateHighlighted];
    [topBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setFrame:CGRectMake([AppDelegate sharePhoneWidth]-60,[AppDelegate sharePhoneHeight]-100,44,44)];
    [self.view addSubview:topBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstRequest = YES;
    currentpageIndex = 1 ;//当前第一页
    //初始化参数
    NSString *productId = [self.params objectForKey:@"productId"];
    if (productId != nil) {
        [self.requestParamsDict setObject:@"" forKey:@"phoneNum"];
        [self.requestParamsDict setObject:@"" forKey:@"areaId"];
        [self.requestParamsDict setObject:@"" forKey:@"cardType"];
        [self.requestParamsDict setObject:@"" forKey:@"numType"];
        [self.requestParamsDict setObject:[NSString stringWithFormat:@"%d",currentpageIndex] forKey:@"pageIndex"];
        [self.requestParamsDict setObject:productId forKey:@"productId"];
        if ([self getAreaList] == nil) {
            [self getPhoneNumbers];
        }else{
            self.areas = [self getAreaList];
            [self makeSureCurrentCity];
        }
    }
}

#pragma mark
#pragma mark - FileManage
- (NSString *)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    return documentPath;
}

- (NSArray *)getAreaList
{
    NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:@"AreaList"];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
//    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    return array;
}

- (void)saveAreaList:(NSArray *)list
{
    NSString *filePath = [[self getDocumentPath] stringByAppendingPathComponent:@"AreaList"];
    [NSKeyedArchiver archiveRootObject:list toFile:filePath];
//    [array writeToFile:filePath atomically:YES];
}

#pragma mark
#pragma mark - 确认当前城市
- (void)makeSureCurrentCity
{
    NSString *currentCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentCity"];
    if (currentCity != nil){
        for (int i = 0; i<self.areas.count; i++) {
            NSDictionary *area = self.areas[i];
            NSString *areaName = [area objectForKey:@"areaName"];
            NSRange range = [currentCity rangeOfString:areaName];
            if (range.location == NSNotFound ||range.length ==0){
                range = [areaName rangeOfString:currentCity];
                if (range.location!= NSNotFound &&range.length>0){
                    UIButton *btn = (UIButton *)[self.view viewWithTag:LEFT_FILTER_BTN_TAG];
                    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    [btn setTitle:[area objectForKey:@"areaName"] forState:UIControlStateNormal];
                    [self.requestParamsDict setObject:[area objectForKey:@"areaCode"] forKey:@"areaId"];
                    isFirstRequest = NO;
                    [self.phoneNumbers removeAllObjects];
                    [self getPhoneNumbers];
                    break;
                }
            }else{
                UIButton *btn = (UIButton *)[self.view viewWithTag:LEFT_FILTER_BTN_TAG];
                [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [btn setTitle:[area objectForKey:@"areaName"] forState:UIControlStateNormal];
                [self.requestParamsDict setObject:[area objectForKey:@"areaCode"] forKey:@"areaId"];
                isFirstRequest = NO;
                [self.phoneNumbers removeAllObjects];
                [self getPhoneNumbers];
                break;
            }
        }
    }else{
        [self startLocation];
        [self getPhoneNumbers];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark
#pragma mark - 滚回顶部
-(void)scrollToTop
{
    if (self.phoneNumbers == nil || [self.phoneNumbers count] == 0) {
        return;
    }
    UITableView *table = (UITableView *)[self.view viewWithTag:TABLE_VIEW_TAG];
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark
#pragma mark -TitleBarDelegate
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)homeAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)searchAction:(NSString *)key
{
    self.searchKey = key;
    if ([key isEqualToString:@""]) {
        isSearch = NO;
    }else{
        isSearch = YES;
    }
    currentpageIndex = 1;
    [self.requestParamsDict setObject:key forKey:@"phoneNum"];
    [self.requestParamsDict setObject:@"1" forKey:@"pageIndex"];
    self.phoneNumbers = nil;
    [self getPhoneNumbers];
}

#pragma mark
#pragma mark - 过滤
-(void)filterBtnClicked:(UIButton *)sender
{
    NSArray *data = nil;
    FilterViewDataType type;
    if (sender.tag == LEFT_FILTER_BTN_TAG) {
        data = self.areas;
        type = FilterViewDataTypeCity;
    }else if(sender.tag == RIGHT_FILTER_BTN_TAG){
        data = self.types;
        type = FilterViewDataTypeNumberType;
    }
    FilterView *filterView = [[FilterView alloc] initWithDataArray:data andType:type];
    filterView.delegate = self;
    [filterView showInView:self];
}
#pragma mark
#pragma mark - FilterViewDelegate
- (void)didSelectedRowAtIndex:(NSInteger)index withData:(NSDictionary *)data andType:(FilterViewDataType)type
{
    if (type == FilterViewDataTypeCity) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:LEFT_FILTER_BTN_TAG];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn setTitle:data[@"areaName"] forState:UIControlStateNormal];
        [self.requestParamsDict setObject:data[@"areaCode"] forKey:@"areaId"];;
    }else if (type == FilterViewDataTypeNumberType){
        UIButton *btn = (UIButton *)[self.view viewWithTag:RIGHT_FILTER_BTN_TAG];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [btn setTitle:data[@"typeName"] forState:UIControlStateNormal];
        [self.requestParamsDict setObject:data[@"typeId"] forKey:@"numType"];
    }
    [self.requestParamsDict setObject:@"1" forKey:@"pageIndex"];
    UITableView *table = (UITableView *)[self.view viewWithTag:TABLE_VIEW_TAG];
    [self.phoneNumbers removeAllObjects];
    [table reloadData];
    isFirstRequest = NO;
    [self getPhoneNumbers];
}
#pragma mark
#pragma mark - 网络请求
-(void)getPhoneNumbers
{
    bussineDataService *bus = [bussineDataService  sharedDataService];
    bus.target = self;
    [bus number:self.requestParamsDict];
}
#pragma mark
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.phoneNumbers count] %2 == 0) {
        return [self.phoneNumbers count]/2;
    }else{
        return [self.phoneNumbers count]/2+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PhoneNumberCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        float itemWidth = ([AppDelegate sharePhoneWidth]-1)/2;
        //左边
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_n"] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_hover"xPos:0.1 yPos:0.2] forState:UIControlStateSelected];
        [leftBtn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_hover"xPos:0.1 yPos:0.2] forState:UIControlStateHighlighted];
        leftBtn.frame = CGRectMake(0,0,itemWidth,ITEM_HEIGHT);
        leftBtn.tag = LEFT_BTN_TAG;
        [leftBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:leftBtn];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,itemWidth,ITEM_HEIGHT)];
        leftLabel.backgroundColor = [UIColor clearColor];
        [leftLabel setTextColor:[ComponentsFactory createColorByHex:@"#666666"]];
        leftLabel.tag = LEFT_LABEL_TAG;
#ifdef __IPHONE_6_0
        [leftLabel setTextAlignment:NSTextAlignmentCenter];
#else
        [leftLabel setTextAlignment:NSTextAlignmentCenter];
#endif
        [cell.contentView addSubview:leftLabel];
        
        //右边
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightBtn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_n"] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_hover"xPos:0.1 yPos:0.2] forState:UIControlStateSelected];
        [rightBtn setBackgroundImage:[UIImage resizedImage:@"bg_content_select_hover"xPos:0.1 yPos:0.2] forState:UIControlStateHighlighted];
        rightBtn.frame = CGRectMake(itemWidth+1,0,itemWidth,ITEM_HEIGHT);
        rightBtn.tag = RIGHT_BTN_TAG;
        [rightBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:rightBtn];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth+1,0,itemWidth,ITEM_HEIGHT)];
        [rightLabel setTextColor:[ComponentsFactory createColorByHex:@"#666666"]];
        
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.tag = RIGHT_LABEL_TAG;
#ifdef __IPHONE_6_0
        [rightLabel setTextAlignment:NSTextAlignmentCenter];
#else
        [rightLabel setTextAlignment:UITextAlignmentCenter];
#endif
        [cell.contentView addSubview:rightLabel];
    }
    
    UILabel *leftLabel = (UILabel *)[cell viewWithTag:LEFT_LABEL_TAG];
    UILabel *rightLabel = (UILabel *)[cell viewWithTag:RIGHT_LABEL_TAG];
    UIButton *leftBtn = (UIButton *)[cell viewWithTag:LEFT_BTN_TAG];
    UIButton *rightBtn = (UIButton *)[cell viewWithTag:RIGHT_BTN_TAG];
    leftBtn.selected = NO;
    rightBtn.selected = NO;
    rightLabel.hidden = NO;
    rightBtn.hidden = NO;
    
    if (isSearch) {
        //设置左边
        NSString *leftStr = self.phoneNumbers[indexPath.row*2][@"phoneNum"];
        NSRange range  = [leftStr rangeOfString:self.searchKey];
        NSMutableAttributedString *leftAttrStr = [[NSMutableAttributedString alloc] initWithString:leftStr];
        [leftAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
        leftLabel.attributedText = leftAttrStr;
        leftBtn.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row*2];
        
        if ([self.phoneNumbers count]%2==0) {
            
            NSString *rightStr = self.phoneNumbers[indexPath.row*2+1][@"phoneNum"];
            NSRange range  = [rightStr rangeOfString:self.searchKey];
            NSMutableAttributedString *rightAttrStr = [[NSMutableAttributedString alloc] initWithString:rightStr];
            [rightAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
            rightLabel.attributedText = leftAttrStr;
            rightBtn.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row*2+1];
        }else{
            if ([self.phoneNumbers count]/2 == indexPath.row) {
                rightLabel.hidden = YES;
                rightBtn.hidden = YES;
            }else{
                NSString *rightStr = self.phoneNumbers[indexPath.row*2+1][@"phoneNum"];
                NSRange range  = [rightStr rangeOfString:self.searchKey];
                NSMutableAttributedString *rightAttrStr = [[NSMutableAttributedString alloc] initWithString:rightStr];
                [rightAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
                rightLabel.attributedText = leftAttrStr;
                rightBtn.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row*2+1];
            }
        }
        
        
    }else{
        //设置左边
        leftLabel.text = self.phoneNumbers[indexPath.row*2][@"phoneNum"];
        leftBtn.titleLabel.text = [NSString stringWithFormat:@"%d",indexPath.row*2];
        
        if ([self.phoneNumbers count]%2==0) {
            rightBtn.titleLabel.text =[NSString stringWithFormat:@"%d",indexPath.row*2+1];
            rightLabel.text = self.phoneNumbers[indexPath.row*2+1][@"phoneNum"];
        }else{
            if ([self.phoneNumbers count]/2 == indexPath.row) {
                rightLabel.hidden = YES;
                rightBtn.hidden = YES;
            }else{
                rightBtn.titleLabel.text =[NSString stringWithFormat:@"%d",indexPath.row*2+1];
                rightLabel.text = self.phoneNumbers[indexPath.row*2+1][@"phoneNum"];
            }
        }
    }
    return cell;
}

#pragma mark
#pragma mark - 选中号码
- (void)btnClicked:(UIButton *)sender
{
    if (currentSelectedBtn != nil) {
        currentSelectedBtn.selected = NO;
    }
    currentSelectedBtn = sender;
    sender.selected = YES;
    NSDictionary *selectedPhoneNumber = [self.phoneNumbers objectAtIndex:[sender.titleLabel.text intValue]];
    if (self.handler) {
        self.handler(selectedPhoneNumber);
    }
    [self backAction];
}

#pragma mark
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ITEM_HEIGHT+1;
}

#pragma mark
#pragma mark - HttpBackDelegate
-(void)requestDidFinished:(NSDictionary *)info
{
    bussineDataService *bus=[bussineDataService sharedDataService];
    NSDictionary *rspDict = bus.rspInfo;
    if (rspDict[@"types"] != [NSNull null]) {
        self.types = rspDict[@"types"];
    }
    if (rspDict[@"areas"] !=[NSNull null]) {
        self.areas = rspDict[@"areas"];
        [self saveAreaList:self.areas];
    }
    if (rspDict[@"phoneNumObject"] !=[NSNull null]) {
        if (self.phoneNumbers == nil) {
            self.phoneNumbers = [NSMutableArray arrayWithCapacity:0];
        }
        [self.phoneNumbers addObjectsFromArray:rspDict[@"phoneNumObject"]];
        currentpageIndex += 1;
        [self.requestParamsDict setObject:[NSString stringWithFormat:@"%d",currentpageIndex] forKey:@"pageIndex"];
    }
//    if (isFirstRequest) {
//        [self makeSureCurrentCity];
//        isFirstRequest = NO;
//    }
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLE_VIEW_TAG];
    [tableView footerEndRefreshing];
    [tableView reloadData];
}

-(void)requestFailed:(NSDictionary *)info
{
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLE_VIEW_TAG];
    [tableView footerEndRefreshing];
    NSString* bizCode = [info objectForKey:@"bussineCode"];
    NSString* msg = [info objectForKey:@"MSG"];
    [MBProgressHUD hideHUDForView:[AppDelegate shareMyApplication].window animated:YES];
    
    if([[ChoosePackageMessage getBizCode] isEqualToString:bizCode]){
        if([info objectForKey:@"MSG"] == [NSNull null]){
            msg = @"获取数据失败！";
        }
        if(nil == msg){
            msg = @"获取数据失败！";
        }
        [self showAlertViewTitle:@"提示"
                         message:msg
                        delegate:self
                             tag:10101
               cancelButtonTitle:@"取消"
               otherButtonTitles:@"重试",nil];
        
    }
}

#pragma mark
#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if(alertView.tag==10101){
        if([buttonTitle isEqualToString:@"重试"]){
            bussineDataService *bus=[bussineDataService sharedDataService];
            bus.target=self;
            [bus number:self.requestParamsDict];
        }
    }
}

#pragma mark -
#pragma mark AlertView
-(void)showAlertViewTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate tag:(NSInteger)tag cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles,...
{
    NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    id arg;
    va_list argList;
    if(nil != otherButtonTitles){
        va_start(argList, otherButtonTitles);
        while ((arg = va_arg(argList,id))) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles,nil];
    alert.tag = tag;
    for(int i = 0; i < [argsArray count]; i++){
        [alert addButtonWithTitle:[argsArray objectAtIndex:i]];
    }
    [alert show];
}

-(void)showSimpleAlertView:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)startLocation
{
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
//#ifdef __IPHONE_8_0
        if(IOS8) {
            [locationManager requestAlwaysAuthorization];//添加这句®
        }

//#endif
    }
    [locationManager startUpdatingLocation];
}

#pragma mark
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // 停掉定位
    [locationManager stopUpdatingLocation];
    // 反向地理解析
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemark,NSError *error)
     {
         CLPlacemark *mark = [placemark objectAtIndex:0];
         [[NSUserDefaults standardUserDefaults] setObject:mark.locality forKey:@"currentCity"];
         [[NSUserDefaults standardUserDefaults] synchronize];
     }];
}

@end

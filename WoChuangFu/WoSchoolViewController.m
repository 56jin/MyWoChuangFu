//
//  WoSchoolViewController.m
//  WoChuangFu
//
//  Created by 陈亦海 on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "WoSchoolViewController.h"
#import "RFSegmentView.h"
#import "TitleBar.h"

//#define MainHeight  [[UIScreen mainScreen] bounds].size.height
//#define MainWidth   [[UIScreen mainScreen] bounds].size.width

@interface WoSchoolViewController ()<RFSegmentViewDelegate,TitleBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate> {
    UITableView *myTabView;
    UIView *oldView;  //老宽带用户
    UIScrollView *myScrollView; //新宽带用户页面
    UIView *allView;
    NSMutableArray *tableArray;  //table数据
    
    NSInteger selectInteger; //记住当前页面是老用户还是新用户  0代表新  1代表老

}

@end

@implementation WoSchoolViewController

-(void)loadView {
    [super loadView];
//    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    if (allView == nil) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,20, self.view.frame.size.width,self.view.frame.size.height)];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        allView = view;
        [self.view addSubview:allView];
     
    }

   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    selectInteger = 0;
    tableArray = [NSMutableArray array];
    [tableArray addObject:@"地市   请选择地市"];
    [tableArray addObject:@"街道   请输入小区/街道名称"];
    [tableArray addObject:@"套餐   请选择套餐"];
    
    
    TitleBar *titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [titleBar setLeftIsHiden:NO];
    titleBar.title = @"沃校园办理";
    titleBar.frame = CGRectMake(0,0, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [allView addSubview:titleBar];
    titleBar.target = self;
   

    
    
    RFSegmentView* segmentView = [[RFSegmentView alloc] initWithFrame:CGRectMake(40, 40, 240, 60) items:@[@"新装宽带用户",@"老宽带用户"]];
    segmentView.tintColor = [ComponentsFactory createColorByHex:@"#ff7e0c"];
    segmentView.delegate = self;
    [allView addSubview:segmentView];
    
    
    UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureOrderBtn setBackgroundColor:[UIColor orangeColor]];
    [sureOrderBtn setFrame:(CGRect){10,MainHeight - 70,MainWidth - 20,44}];
    [sureOrderBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
     sureOrderBtn.tag = 3000;
    [sureOrderBtn.layer setMasksToBounds:YES];
    [sureOrderBtn.layer setCornerRadius:4.0];
    [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:20 weight:20]];
    [sureOrderBtn addTarget:self action:@selector(sureOrderEven:) forControlEvents:UIControlEventTouchUpInside];
    [allView addSubview:sureOrderBtn];
    
    
    [self initWithNewView]; //新装宽带用户页面
    [self initWithOldView]; //老宽带用户页面
    // Do any additional setup after loading the view.
}

#pragma mark-    新装宽带用户页面
- (void)initWithNewView {
    
    CGFloat allHeight = 0;
    
    myScrollView = [[UIScrollView alloc]initWithFrame:(CGRect){0,95,MainWidth ,MainHeight - 180}];
    [myScrollView setBackgroundColor:[UIColor clearColor]];
    // 隐藏水平滚动条
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    // 用来记录scrollview滚动的位置
    //    scrollView.contentOffset = ;
    
    // 去掉弹簧效果
    myScrollView.bounces = NO;
    // 增加额外的滚动区域（逆时针，上、左、下、右）
    // top  left  bottom  right
    myScrollView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    
    UIView *newView = [self viewWith:2 andString:nil];
     [myScrollView addSubview:newView];

    allHeight += CGRectGetHeight(newView.frame);
    
    myTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, allHeight + 20, [UIScreen mainScreen].bounds.size.width, 44 * 3 ) style:UITableViewStylePlain];
    myTabView.delegate=self;
    myTabView.dataSource=self;
    myTabView.scrollEnabled=NO;
//    myTabView.separatorColor=[UIColor clearColor];
    [myScrollView addSubview:myTabView];

    allHeight += 50 * 3 + 10;
    
    UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureOrderBtn setBackgroundColor:[UIColor orangeColor]];
    [sureOrderBtn setFrame:(CGRect){10,allHeight ,MainWidth - 20,44}];
    [sureOrderBtn setTitle:@"身份证识别" forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    sureOrderBtn.tag = 2000;
    [sureOrderBtn.layer setMasksToBounds:YES];
    [sureOrderBtn.layer setCornerRadius:4.0];
    [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:20 weight:20]];
    [sureOrderBtn addTarget:self action:@selector(sureOrderEven:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:sureOrderBtn];
    allHeight += 44;
    
    for (int i = 0 ; i < 3; i++) {
        
        allHeight += 10;
        
        UIView *SFview = [[UIView alloc]init];
        SFview.backgroundColor = [UIColor whiteColor];
        [SFview.layer setMasksToBounds:YES];
        [SFview.layer setCornerRadius:4.0];
        [SFview.layer setBorderWidth:1.0f];
        [SFview.layer setBorderColor:[[UIColor groupTableViewBackgroundColor] CGColor]];
        [SFview setFrame:(CGRect){10,allHeight,MainWidth - 20,60}];
         allHeight += 60;
        
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0f];
        label.text = i == 0 ? @"姓名" : i == 1 ? @"身份证" : @"地址";
        [label setFrame:(CGRect){10,0,50,60}];
        [SFview addSubview:label];
        
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectZero];
        text.delegate = self;
       
        text.placeholder = i == 0 ? @"机主姓名" : i == 1 ? @"机主身份证号" :@"详细地址（在报装地址基础上加）";
        text.userInteractionEnabled = i == 2 ? YES : NO;
        
        text.tag = 4000 + i ;
        [text setBorderStyle:UITextBorderStyleNone];
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
        text.returnKeyType = UIReturnKeyDone;
        text.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        text.keyboardType = UIKeyboardTypeDefault;
        [text setFrame:(CGRect){70,5,MainWidth - 100 ,50}];
        text.adjustsFontSizeToFitWidth = YES;
        [SFview addSubview:text];
        
        [myScrollView addSubview:SFview];
        
        
        
    }
    
    allHeight += 30;
    
//    myScrollView.frame = CGRectMake(0, 100, MainWidth, allHeight);
    myScrollView.contentSize = CGSizeMake(MainWidth, allHeight);
    [allView addSubview:myScrollView];
    
}
#pragma mark-    老宽带用户页面
- (void)initWithOldView {
    oldView = [[UIView alloc]init];
    oldView.backgroundColor = [UIColor clearColor];
    [oldView setFrame:(CGRect){0,95,MainWidth ,MainHeight - 180}];
    
    UIView *newView = [self viewWith:3 andString:nil];
    [oldView addSubview:newView];
    
    UIView *SFview = [[UIView alloc]init];
    SFview.backgroundColor = [UIColor whiteColor];
    [SFview.layer setMasksToBounds:YES];
    [SFview.layer setCornerRadius:4.0];
    [SFview.layer setBorderWidth:1.0f];
    [SFview.layer setBorderColor:[[UIColor groupTableViewBackgroundColor] CGColor]];
    [SFview setFrame:(CGRect){0,CGRectGetHeight(newView.frame) + 30,MainWidth - 0,60}];
    
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.text = @"套餐";
    [label setFrame:(CGRect){10,0,50,60}];
    [SFview addSubview:label];
    
    UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureOrderBtn setBackgroundColor:[UIColor clearColor]];
    [sureOrderBtn setFrame:(CGRect){10,8 ,MainWidth - 20,44}];
    [sureOrderBtn setTitle:@"请选择套餐" forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    sureOrderBtn.tag = 6000;
    [sureOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(MainWidth - 220), 0, 0)];
//    [sureOrderBtn.layer setMasksToBounds:YES];
//    [sureOrderBtn.layer setCornerRadius:4.0];
    [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:20]];
    [sureOrderBtn addTarget:self action:@selector(sureOrderEven:) forControlEvents:UIControlEventTouchUpInside];
    [SFview addSubview:sureOrderBtn];

    
    [oldView addSubview:SFview];
    
    [allView addSubview:oldView];
    oldView.hidden = YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIView *)viewWith:(NSInteger)integer andString:(NSString *)string {
    //手机验证码页面
    UIView *NumView = [[UIView alloc]initWithFrame:(CGRect){0,10,MainWidth,67 * integer}];
    [NumView setBackgroundColor:[UIColor whiteColor]];
    for (int i = 0; i < integer; i++) {
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectZero];
        text.delegate = self;
        if (integer == 3) {
            text.placeholder = i == 0 ? @"宽带设备号" : i == 1 ? @"请输入手机号" :@"请输入短信验证码";
        }
        else if (integer == 2) {
            text.placeholder = i == 0 ? @"请输入手机号" : @"请输入短信验证码";
        }
        
        
        text.tag = 1000 + i + integer * 100;
        [text setBorderStyle:UITextBorderStyleNone];
        text.autocorrectionType = UITextAutocorrectionTypeNo;
        text.autocapitalizationType = UITextAutocapitalizationTypeNone;
        text.returnKeyType = UIReturnKeyDone;
        text.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时会出现个修改X
        text.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [text setFrame:(CGRect){10,63 * i + 8,MainWidth - 100 ,50}];
        [NumView addSubview:text];
        
        if (i == 0 || i == 2) {
            UILabel *label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [label setFrame:(CGRect){0, i == 0 ? 65 : 130,MainWidth,1}];
            [NumView addSubview:label];
            
        }
        
        if(i == 0 && integer == 3) {
            continue;
        }
        
        UIButton *sureOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureOrderBtn setBackgroundColor: i == 0 || (i == 1 && integer == 3) ? [UIColor clearColor] :[UIColor orangeColor]];
        [sureOrderBtn setFrame:(CGRect){MainWidth - 120,64 *i + 10,100,44}];
        [sureOrderBtn setTitle:i == 0 || (i == 1 && integer == 3) ? @"获取验证码" : @"确定" forState:UIControlStateNormal];
        [sureOrderBtn setTitleColor: i == 0 || (i == 1 && integer == 3) ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
        [sureOrderBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        sureOrderBtn.tag = 1000 + i + integer * 100;
        [sureOrderBtn.layer setMasksToBounds:YES];
        [sureOrderBtn.layer setCornerRadius:4.0];
        
        
        if ((i == 0 && integer == 2) || (i == 1 && integer == 3) ) {
            [sureOrderBtn.layer setBorderWidth:1.0f];
             [sureOrderBtn.layer setBorderColor:[[UIColor groupTableViewBackgroundColor] CGColor]];
        }
       
        [sureOrderBtn.titleLabel setFont:[UIFont systemFontOfSize:18 weight:20]];
        [sureOrderBtn addTarget:self action:@selector(sureOrGetCodeEven:) forControlEvents:UIControlEventTouchUpInside];
        [NumView addSubview:sureOrderBtn];
    }
   
    return NumView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    myTabView.delegate = nil;
    myTabView.dataSource = nil;
    myTabView = nil;
    myScrollView = nil;
    allView = nil;
    oldView = nil;
    
}

#pragma mark - 确定 与 获取验证码
- (void)sureOrGetCodeEven:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 确定下单3000 与 身份证识别 2000  6000 是选择套餐
- (void)sureOrderEven:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - RFSegmentViewDelegate 分段选择
- (void)segmentViewSelectIndex:(NSInteger)index
{
    [self.view endEditing:YES];
   selectInteger = index;
    NSLog(@"current index is %ld",(long)index);
    switch (index) {
        case 0:
            
            myScrollView.hidden = NO;
            oldView.hidden = YES;
            break;
            
        case 1:
            
            myScrollView.hidden = YES;
            oldView.hidden = NO;
            break;
            
        default:
            break;
    }
}

#pragma mark - RFSegmentViewDelegate 分段选择

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellStr = @"CellWithIdentifier";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if(Cell == nil){
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr];
        Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.backgroundColor=[UIColor whiteColor];
    }
    Cell.textLabel.text = tableArray[indexPath.row];
    Cell.textLabel.font = [UIFont systemFontOfSize:15];
    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //注意选择那个indexPath.row 返回来改变数据源对应的字符串
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textField 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 4002) {
        float Durationtime = 0.5;
        [UIView beginAnimations:@"alt" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:Durationtime];
        
        if([UIScreen mainScreen].bounds.size.height>=568){
            
            [self.view setFrame:CGRectMake(0, -245, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
            
        }else{
            
            [self.view setFrame:CGRectMake(0, -245, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        }
        [UIView commitAnimations];

    }
    
    else if (textField.tag == 1302) {
        
        float Durationtime = 0.5;
        [UIView beginAnimations:@"alt" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:Durationtime];
        
        if([UIScreen mainScreen].bounds.size.height>=568){
            
            [self.view setFrame:CGRectMake(0, -45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
            
        }else{
            
            [self.view setFrame:CGRectMake(0, -45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        }
        [UIView commitAnimations];

        
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 4002 || textField.tag == 1302) {
        float Durationtime = 0.3;
        [UIView beginAnimations:@"alt" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:Durationtime];
        
        [self.view setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        [UIView commitAnimations];
    }
   
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end

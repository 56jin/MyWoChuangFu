
//  SchoolViewTable.m
//  WoChuangFu
//
//  Created by 陈贵邦 on 15/6/17.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "SchoolViewTable.h"
#import "TitleBar.h"

@interface SchoolViewTable ()<TitleBarDelegate,UITableViewDataSource,UITableViewDelegate>

@end

@implementation SchoolViewTable
@synthesize areArr;
@synthesize tableViewm,handler,_titleBar;

- (void)viewDidLoad {
  
    [super viewDidLoad];
    [self initTitleBar];
    [self initTableView];
}


-(void)initTitleBar{
    _titleBar = [[TitleBar alloc] initWithFramShowHome:NO ShowSearch:NO TitlePos:0];
    [_titleBar setLeftIsHiden:NO];
    _titleBar.title = @"沃校园办理";
    _titleBar.frame = CGRectMake(0,0, self.view.frame.size.width,TITLE_BAR_HEIGHT);
    [self.view addSubview:_titleBar];
    _titleBar.target = self;
    CGRect tmpframe = _titleBar.frame;
    tmpframe.origin.y = 20;
    _titleBar.frame = tmpframe;
}

-(void)initTableView{
    tableViewm = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tableViewm.backgroundColor = [UIColor whiteColor];
    tableViewm.delegate = self;
    tableViewm.dataSource = self;
    [self.view addSubview:tableViewm];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [areArr count];;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellStr = @"CellWithIdentifier";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellStr];
    if(Cell == nil){
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStr];
//        Cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
        Cell.backgroundColor=[UIColor whiteColor];
    }
    
    Cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    Cell.textLabel.text = [[areArr objectAtIndex:indexPath.row] objectForKey:@"areaName"];//
    
//    Cell.textLabel.text = @"";
    Cell.textLabel.font = [UIFont systemFontOfSize:15];
    Cell.textLabel.numberOfLines = 0;
    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    NSString *areaCode = [[areArr objectAtIndex:indexPath.row] objectForKey:@"areaCode"];
//    
//    NSString *result =  [NSString stringWithFormat:@"%@",cell.textLabel.text];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:result,@"result",areaCode,@"cityCode", nil];

    
    handler([areArr objectAtIndex:indexPath.row]);
    [self backAction];
    
}


#pragma 返回按钮事件
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//-(void)viewWillDisappear:(BOOL)animated{
//    areArr = nil;
//    handler = nil;
//}

-(void)dealloc{
    [super dealloc];
    areArr = nil;
    handler = nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [tableViewm reloadData];
}


@end

#import "ChooseOrderVC.h"
#import "OrderCell.h"
#import "MyHeader.h"

@interface ChooseOrderVC ()<MyHeaderDelegate>

@property (strong, nonatomic) NSArray *dataList;

// 所有标题行的字典
@property (strong, nonatomic) NSMutableDictionary *sectionDict;

@end

@implementation ChooseOrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1. 初始化数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"friends" ofType:@"plist"];
    self.dataList = [NSArray arrayWithContentsOfFile:path];
    
    // 2. 设置标题行高
    [self.tableView setSectionHeaderHeight:kHeaderHeight];
    // 3. 设置表格行高
    [self.tableView setRowHeight:50];
    
    // 4. 初始化展开折叠字典
    self.sectionDict = [NSMutableDictionary dictionaryWithCapacity:self.dataList.count];
    
    // 5. 给表格注册可重用标题行
    [self.tableView registerClass:[MyHeader class] forHeaderFooterViewReuseIdentifier:@"MyHeader"];
    
    [self.tableView registerClass:[OrderCell class] forCellReuseIdentifier:@"MyCell"];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 如果字典中分组对应的折叠状态，返回0，否则返回数组的数量
    MyHeader *header = self.sectionDict[@(section)];
    BOOL isOpen = header.isOpen;
    
    if (isOpen) {
        return 1;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MyCell";
    
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    // 1. 从数组中取出indexPath.row对应的字典
    NSDictionary *dict = self.dataList[indexPath.section];
    
    // 2. 从字典中取出对应的好友数组
    NSArray *array = dict[@"friends"];
    
    // 3. 填充表格内容
    [cell.orderPrice setText:array[0]];
    [cell.orderPayType setText:array[1]];
    [cell.orderStatus setText:array[2]];
    [cell.orderStatus setText:array[3]];
    [cell.sendNum setText:array[4]];
    [cell.sendType setText:array[5]];
    
    return cell;
}

#pragma mark 表格标题栏
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *HeaderID = @"MyHeader";
    
    // 1. 在缓冲池查找可重用的标题行
    // 从字典中读取标题行
    MyHeader *header = self.sectionDict[@(section)];
    
    if (header == nil) {

        // 实例化表格标题，一定要用initWithReuseIdentifier方法
        header = [[MyHeader alloc]initWithReuseIdentifier:HeaderID];
        // 设置代理
        [header setDelegate:self];
        
        // 将自定义标题栏加入字典
        [self.sectionDict setObject:header forKey:@(section)];
    }
    
    NSDictionary *dict = self.dataList[section];
    NSString *groupName = dict[@"group"];
    
    header.textLabel.text = groupName;
    
    // 在标题栏自定义视图中记录对应的分组数
    [header setSection:section];
    
    return header;
}

#pragma mark - 自定义标题栏代理方法
- (void)myHeaderDidSelectedHeader:(MyHeader *)header
{
    // 处理展开折叠
    // 需要记录每个分组的展开折叠情况
    // 从字典中取出标题栏
    MyHeader *clickHeader = self.sectionDict[@(header.section)];
    BOOL isOpen = clickHeader.isOpen;
    [clickHeader setIsOpen:!isOpen];
    [clickHeader.textLabel setTextColor:!isOpen?[UIColor orangeColor]:[UIColor blackColor]];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.section] withRowAnimation:UITableViewRowAnimationFade];
    for (int i = 0;i <self.sectionDict.count; i++)
    {
        MyHeader *headerItem = self.sectionDict[@(i)];
        
        if (headerItem != clickHeader && headerItem.isOpen == YES)
        {
            headerItem.isOpen = NO;
            [headerItem.textLabel setTextColor:[UIColor blackColor]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:headerItem.section] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

@end

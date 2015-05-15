#import "TabBar.h"
#import "ComponentsFactory.h"

#define TABBAR_HEIGHT 33
#define UISCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface TabBar()

@property(nonatomic,strong) UIScrollView *contentView; //容器视图
@property(nonatomic,strong) UIView *lineView;          //下划线
@property(nonatomic,strong) NSMutableArray *buttons;

@end

@implementation TabBar

- (id)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame])
    {
        self.itemTitles = titles;
        [self initConfig];
    }
    return self;
    
}

- (void)initConfig
{
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,320, TABBAR_HEIGHT)];
    _contentView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_contentView];
    [self addButtons];
}

- (void)addButtons
{
    CGFloat buttonX = 0;
    CGFloat buttonW = UISCREENWIDTH / self.itemTitles.count;
    for (NSInteger i = 0; i < self.itemTitles.count; i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX,0,buttonW, TABBAR_HEIGHT);
        [button setTitle:_itemTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(buttonX, 5, 1.0f, TABBAR_HEIGHT-10)];
        UIImage *image = [UIImage imageNamed:@"list_nav_line_s@2x"];
        img.image = image;
        [_contentView addSubview:button];
        [_contentView addSubview:img];
        [self.buttons addObject:button];
        buttonX += buttonW;
    }
    [self addLineViewWithButtonWidth:buttonW];
    
    _currentItemIndex = 0;
    [self itemClicked:self.buttons[0]];
}

- (void)addLineViewWithButtonWidth:(CGFloat)width
{
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,TABBAR_HEIGHT - 3.0f, width, 3.0f)];
    [_lineView setBackgroundColor:[ComponentsFactory createColorByHex:@"#f96c00"]];
    [_contentView addSubview:_lineView];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [_lineView setBackgroundColor:_lineColor];
}

- (NSMutableArray *)buttons
{
    if (nil == _buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)itemClicked:(UIButton *)item
{
    [self.buttons[_currentItemIndex] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    NSInteger index = [_buttons indexOfObject:item];
    [item setTitleColor:[ComponentsFactory createColorByHex:@"#f96c00"] forState:UIControlStateNormal];
    _currentItemIndex = index;
    
    if ([_delegate respondsToSelector:@selector(tabBar:itemDidSelectedWithIndex:)])
        [_delegate tabBar:self itemDidSelectedWithIndex:index];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lineView.frame = CGRectMake(item.frame.origin.x,TABBAR_HEIGHT - 3.0f,item.frame.size.width,3.0f);
    }];
}
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    [self.buttons[_currentItemIndex] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _currentItemIndex = currentItemIndex;
    UIButton *button =  self.buttons[_currentItemIndex];
    [button setTitleColor:[ComponentsFactory createColorByHex:@"#f96c00"] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3f animations:^{
        self.lineView.frame = CGRectMake(button.frame.origin.x,TABBAR_HEIGHT - 3.0f,button.frame.size.width,3.0f);
    }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor lightGrayColor] set];
    //上分割线
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,rect.size.width, 0);
    CGContextStrokePath(context);
    
    //下分割线
    CGContextMoveToPoint(context,0,rect.size.height);
    CGContextAddLineToPoint(context,rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}
@end

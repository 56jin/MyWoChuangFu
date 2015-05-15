#import "CommonMacro.h"
#import "MyHeader.h"

@implementation MyHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderHeight)];
        // 设置渐变颜色
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-0.5,self.frame.size.width,0.5)];
        separator.backgroundColor = [ComponentsFactory createColorByHex:@"#eeeeee"];
        [self.contentView addSubview:separator];
        
        
        // 增加按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:self.bounds];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(290,13.5, 13, 8)];
        imgView.image = [UIImage imageNamed:@"btn_content_down_n.png"];
        [self.contentView addSubview:imgView];
        self.imageView = imgView;
        
        // 给按钮添加监听事件
        [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        self.button = button;
    }
    return self;
}
- (void)setRightHidden
{
    self.imageView.hidden= YES;
    self.button.hidden = YES;
}
- (void)setRightShow
{
    self.imageView.hidden= NO;
    self.button.hidden = NO;
}
- (void)clickButton
{
    // 通知代理执行协议方法
    [self.delegate myHeaderDidSelectedHeader:self];
}

#pragma mark 展开折叠的setter方法
- (void)setIsOpen:(BOOL)isOpen
{
    _isOpen = isOpen;
    self.imageView.image = [UIImage imageNamed:_isOpen?@"btn_content_up_n.png":@"btn_content_down_n.png"];
}

@end

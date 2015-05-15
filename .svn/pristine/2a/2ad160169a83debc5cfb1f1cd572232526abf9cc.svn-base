#import "MayYouLikeCell.h"
#import "FileHelpers.h"

#define CELL_WIDTH 100
#define CELL_HEIGHT 100
#define ICON_WIDTH 50
#define ICON_HEIGHT 50

@interface MayYouLikeCell()

@property(nonatomic,weak)UIImageView *maybeYourLikerImg;
@property(nonatomic,weak)UILabel     *maybeYourLikerName;
@property(nonatomic,weak)UILabel     *maybeYourLikerPrice;

@end

@implementation MayYouLikeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((CELL_WIDTH - ICON_WIDTH)/2, 0, ICON_WIDTH, ICON_HEIGHT);
    [self.contentView addSubview:imageView];
    self.maybeYourLikerImg = imageView;
    
    //名字
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = UITextAlignmentCenter;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.frame = CGRectMake(0, ICON_HEIGHT, CELL_WIDTH, 30);
    [self.contentView addSubview:nameLabel];
    self.maybeYourLikerName = nameLabel;
    
    //价格
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.frame = CGRectMake(0, ICON_HEIGHT + 30, CELL_WIDTH, 20);
    priceLabel.font = [UIFont systemFontOfSize:12];
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.textAlignment = UITextAlignmentCenter;
    [self.contentView addSubview:priceLabel];
    self.maybeYourLikerPrice = priceLabel;
}

- (void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.maybeYourLikerName.text = _dataDict[@"maybeYourLikerName"];
    self.maybeYourLikerPrice.text = _dataDict[@"maybeYourLikerPrice"];
    //异步图片
    if (hasCachedImage([NSURL URLWithString:_dataDict[@"maybeYourLikerImgUrl"]]))
    {
        [self.maybeYourLikerImg setImage:[UIImage imageWithContentsOfFile:pathForURL([NSURL URLWithString:_dataDict[@"maybeYourLikerImgUrl"]])]];
    }else{
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_dataDict[@"maybeYourLikerImgUrl"],@"url",self.maybeYourLikerImg,@"imageView",nil];
        [ComponentsFactory dispatch_process_with_thread:^{
            UIImage* ima = [self LoadImage:dic];
            return ima;
        } result:^(UIImage *ima){
            [self.maybeYourLikerImg setImage:ima];
        }];
    }
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor lightGrayColor] set];
    //左分割线
    CGContextMoveToPoint(context,0,0);
    CGContextAddLineToPoint(context,0,rect.size.height);
    CGContextStrokePath(context);
    //右分割线
    CGContextMoveToPoint(context,rect.size.width,0);
    CGContextAddLineToPoint(context,rect.size.width,rect.size.height);
    CGContextStrokePath(context);
}

-(UIImage *)LoadImage:(NSDictionary*)aDic
{
    UIView* view = [aDic objectForKey:@"imageView"];
    NSURL *aURL=[NSURL URLWithString:[aDic objectForKey:@"url"]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    if (image==nil)
    {
        return nil;
    }
    CGSize origImageSize= [image size];
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
    newRect.size.width=view.frame.size.width *2;
    newRect.size.height=view.frame.size.height*2;
    //缩放倍数
    float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    UIGraphicsBeginImageContext(newRect.size);
    CGRect projectRect;
    projectRect.size.width =ratio * origImageSize.width;
    projectRect.size.height=ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;
    [image drawInRect:projectRect];
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    //压缩比例
    NSData *smallData=UIImageJPEGRepresentation(small, 1);
    if (smallData)
    {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    UIGraphicsEndImageContext();
    return small;
}



@end

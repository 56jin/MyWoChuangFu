#import "StarView.h"

#define STAR_MARGIN 5

@interface StarView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation StarView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:5];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"star_-gray.png"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"star.png"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame score:(NSInteger)score
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = 5;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"star_-gray.png"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"star.png"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
        self.starForegroundView.frame = CGRectMake(0, 0,self.frame.size.width/self.numberOfStar * score, self.frame.size.height);
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width /self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}
- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    int score = (int)(p.x *self.numberOfStar/ self.frame.size.width) + 1;
    self.starForegroundView.frame = CGRectMake(0, 0,self.frame.size.width/self.numberOfStar * score, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starView:score:)])
    {
        [self.delegate starView:self score:score];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak StarView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
         
     }];
}

- (void)setCurrScore:(NSInteger)currScore
{
    _currScore = currScore;
    self.starForegroundView.frame = CGRectMake(0, 0,self.frame.size.width/self.numberOfStar * currScore, self.frame.size.height);
    self.userInteractionEnabled = NO;
}

@end

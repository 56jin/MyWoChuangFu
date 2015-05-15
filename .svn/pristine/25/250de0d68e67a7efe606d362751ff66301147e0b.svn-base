#import "EvaluateCell.h"
#import "ComponentsFactory.h"
#import "StarView.h"
#import "EvaluateCellFrame.h"
#import "EvaluateModel.h"

@interface EvaluateCell()
{
    UILabel *evaluateContent; //评价内容
    UILabel *evaluateUser;     //用户帐号
    UILabel *evaluateTime;    //评论时间
    StarView *evaluateStar;   //评分
    UITextView *replyContent;    //回复内容
    UILabel *replyName;       //回复人
    
}

@end

@implementation EvaluateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initConfig];
    }
    return self;
}

-(void)initConfig
{
    //评价内容
    evaluateContent = [[UILabel alloc] init];
    evaluateContent.font = [UIFont systemFontOfSize:16.0f];
    evaluateContent.numberOfLines = 0;
    [evaluateContent setTextColor:[ComponentsFactory createColorByHex:@"#1b1a1a"]];
    [self.contentView addSubview:evaluateContent];
    
    //用户帐号
    evaluateUser = [[UILabel alloc] init];
    [evaluateUser setFont:[UIFont systemFontOfSize:14]];
    [evaluateUser setTextColor:[ComponentsFactory createColorByHex:@"#b8b8b8"]];
    [self.contentView addSubview:evaluateUser];
    
    //评论时间
    evaluateTime = [[UILabel alloc] init];
    [evaluateTime setFont:[UIFont systemFontOfSize:14]];
    [evaluateTime setTextColor:[ComponentsFactory createColorByHex:@"#b8b8b8"]];
    [self.contentView addSubview:evaluateTime];
    
    //评价等级
    evaluateStar = [[StarView alloc] initWithFrame:CGRectMake(220, 45, 80, 20)];
    evaluateStar.userInteractionEnabled = NO;
    [self.contentView addSubview:evaluateStar];
    
    //回复内容
    replyContent = [[UITextView alloc] init];
    //replyContent.numberOfLines = 0;
    replyContent.font = [UIFont systemFontOfSize:15];
    replyContent.scrollEnabled = NO;
    [replyContent setTextColor:[ComponentsFactory createColorByHex:@"#414141"]];
    replyContent.backgroundColor = [ComponentsFactory createColorByHex:@"#fff4de"];
    [self.contentView addSubview:replyContent];
    
    //回复人
    replyName = [[UILabel alloc] init];
    replyName.textAlignment = UITextAlignmentRight;
    replyName.font = [UIFont systemFontOfSize:12];
    [replyName setTextColor:[ComponentsFactory createColorByHex:@"#b8b8b8"]];
    replyName.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:replyName];
}

- (void)setFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 2);
    [super setFrame:frame];
}

- (void)setMyEvaluateCellFrame:(EvaluateCellFrame *)myEvaluateCellFrame
{
    _myEvaluateCellFrame = myEvaluateCellFrame;
    
    evaluateContent.frame = _myEvaluateCellFrame.evaluateContentFrame;
    evaluateContent.text = _myEvaluateCellFrame.evaluateModel.evaluateContent;
    
    evaluateUser.frame = _myEvaluateCellFrame.evaluateUserFrame;
    evaluateUser.text = _myEvaluateCellFrame.evaluateModel.evaluateUser;
    
    evaluateTime.frame = _myEvaluateCellFrame.evalateTimeFrame;
    evaluateTime.text = _myEvaluateCellFrame.evaluateModel.evalateTime;
    
    evaluateStar.frame = _myEvaluateCellFrame.evaluatesStarFrame;
    evaluateStar.currScore = [_myEvaluateCellFrame.evaluateModel.evaluatesStar intValue];
    
    replyContent.frame = _myEvaluateCellFrame.replyContentFrame;
    replyContent.text = _myEvaluateCellFrame.evaluateModel.replyContent;
    
    replyName.frame = _myEvaluateCellFrame.replyNameFrame;
    replyName.text =_myEvaluateCellFrame.evaluateModel.replyName;
    
}

@end

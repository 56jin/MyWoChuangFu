#import "PropertyCell.h"

@implementation PropertyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15.0];
        self.textLabel.numberOfLines = 0;
        self.detailTextLabel.font =[UIFont systemFontOfSize:15.0];
        if (IOS7)
        {
            [self.textLabel setTintColor:[ComponentsFactory createColorByHex:@"#4a4a4a"]];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame = CGRectMake(frame.origin.x, frame.origin.y+1, frame.size.width, frame.size.height-1);
    [super setFrame:frame];
}

@end

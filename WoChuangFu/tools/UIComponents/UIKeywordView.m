//
//  UIKeywordView.m
//  SaleToolsKit
//
//  Created by wuyoujian on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIKeywordView.h"
#import "ComponentsFactory.h"

@implementation UIKeywordView
@synthesize beforeStr;
@synthesize keywordStr;
@synthesize behindStr;

-(void)dealloc{
    [beforeStr release];
    [keywordStr release];
    [behindStr release];
    [behind_label release];
    [before_label release];
    [keyword_label release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIFont *font = [UIFont systemFontOfSize:18.3];
        
        before_label = [[UILabel alloc] initWithFrame:CGRectZero];
		before_label.backgroundColor = [UIColor clearColor];
		before_label.numberOfLines = 1;
        before_label.textColor = [ComponentsFactory createColorByHex:@"#646464"];
        before_label.font = font;
		before_label.lineBreakMode = UILineBreakModeWordWrap;
		before_label.text = nil;
        
        keyword_label = [[UILabel alloc] initWithFrame:CGRectZero];
		keyword_label.backgroundColor = [UIColor clearColor];
		keyword_label.numberOfLines = 1;
        keyword_label.textColor = [ComponentsFactory createColorByHex:@"#646464"];
        keyword_label.font = font;
		keyword_label.lineBreakMode = UILineBreakModeWordWrap;
		keyword_label.text = nil;
        
        behind_label = [[UILabel alloc] initWithFrame:CGRectZero];
		behind_label.backgroundColor = [UIColor clearColor];
        behind_label.textColor = [ComponentsFactory createColorByHex:@"#646464"];
		behind_label.numberOfLines = 1;
        behind_label.font = font;
		behind_label.lineBreakMode = UILineBreakModeWordWrap;
		behind_label.text = nil;
		
		[self addSubview:before_label];
        [self addSubview:keyword_label];
        [self addSubview:behind_label];
        
    }
    return self;
}


-(void)reloadData
{
    UIFont *font = [UIFont systemFontOfSize:18.3];
	CGSize size1 = [self.beforeStr sizeWithFont:font
                             constrainedToSize:CGSizeMake(300.0f,800.0f)
                                 lineBreakMode:UILineBreakModeWordWrap];
    
    before_label.frame = CGRectMake(0,0, size1.width, size1.height);
    before_label.text = self.beforeStr;
    
    CGSize size2 = [self.keywordStr sizeWithFont:font
                              constrainedToSize:CGSizeMake(300.0f, 800.0f)
                                  lineBreakMode:UILineBreakModeWordWrap];
    
    keyword_label.frame = CGRectMake(size1.width,0, size2.width, size2.height);
    keyword_label.textColor = [UIColor orangeColor];
    keyword_label.text = self.keywordStr;
    keyword_label.font = font;
    
    CGSize size3 = [self.behindStr sizeWithFont:font
                               constrainedToSize:CGSizeMake(300.0f, 800.0f)
                                   lineBreakMode:UILineBreakModeWordWrap];
    
    behind_label.frame = CGRectMake(size2.width+size1.width,0, size3.width, size3.height);
    behind_label.text = self.behindStr;
    behind_label.font = font;
	
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size1.width + size2.width +size3.width, size1.height);
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

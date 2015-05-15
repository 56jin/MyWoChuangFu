//
//  PhotoScrollView.m
//  PaintSignature
//
//  Created by Wu YouJian on 10/31/11.
//  Copyright 2011 asiainfo-linkage. All rights reserved.
//

#import "PhotoScrollView.h"
#import "UITCLabel.h"
#import "RemoteImageView.h"

@implementation PhotoScrollView
@synthesize photoScrollView;
//@synthesize photoView;
@synthesize delegate;
@synthesize photoViewFrame;
@synthesize photoViewHeight;
@synthesize photoWidth;
@synthesize photoNameArr;
@synthesize textArr;
@synthesize font;
@synthesize firstSelected;
@synthesize textColor;
@synthesize textSelectedColor;
@synthesize colSpan;
@synthesize leftArrow;
@synthesize rightArrow;
#define KStartLabelTag 100
#define KImageTag 500
#define CLICK_LABEL_TAG  0



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.photoViewFrame = frame;
		self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)layoutPhotoView
{
	contentWidth = 0.0;
    float colspan = 3.0;
    if(colSpan && colSpan != 0) {
        colspan = colSpan;
    }
    NSInteger photoCount = 0;
    if ([self.textArr count] > 0) {
        photoCount = [self.textArr count];
    }else{
        photoCount = [photoNameArr count];
    }
    
	for (int i = 1 ; i <= photoCount; i ++ ) {
		contentWidth += (colspan + self.photoWidth);
	}
	contentWidth = contentWidth - colspan;
	
	//photoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, photoViewFrame.size.width, photoViewHeight)];
	photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,  photoViewFrame.size.width, photoViewHeight)];
	photoScrollView.backgroundColor = [UIColor clearColor];
	photoScrollView.contentSize = CGSizeMake(contentWidth,photoViewHeight);
	photoScrollView.delegate = self;
	//photoView.opaque = YES;
	photoScrollView.opaque = YES;
	photoScrollView.showsVerticalScrollIndicator = NO;
    photoScrollView.showsHorizontalScrollIndicator = YES;
//    float imageWidth = 9;
//    float imageHeight = 17.5;
//    leftArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scroll_left.png"]];
//    leftArrow.hidden = YES;
//    leftArrow.frame = CGRectMake(0-imageWidth-1, photoScrollView.frame.size.height/2-imageHeight/2, imageWidth, imageHeight);
//    rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scroll_right.png"]];
//    
//    rightArrow.frame = CGRectMake(photoScrollView.frame.size.width+1, photoScrollView.frame.size.height/2-imageHeight/2, imageWidth, imageHeight);
//    rightArrow.hidden= NO;
	//[photoScrollView addSubview:photoView];
//    [self addSubview:leftArrow];
//    [self addSubview:rightArrow];
	[self addSubview:photoScrollView];
}


-(void)fillData
{
	float columnOffset = 0.0;
    float colspan = 3.0;
    if(colSpan && colSpan != 0) {
        colspan = colSpan;
    }

	int nTitleLabelTag = KStartLabelTag;
	int nTitleBackImage = KImageTag;
	
	int count = [photoNameArr count];
	
	for (int i = 0 ; i < count; i++) {
		UITCLabel *l = [[UITCLabel alloc] initWithFrame:CGRectMake(columnOffset, 0, photoWidth, photoViewHeight)];
		l.backgroundColor = [UIColor clearColor];
		l.tag = nTitleLabelTag;
		l.userInteractionEnabled = YES;
		l.highlighted = YES;
        if (textArr &&  textArr.count > 0) {
            id text = [textArr objectAtIndex:i];
            if ([text isKindOfClass:[UIView class]]  ) {
                [l addSubview:text];
            } else {
                l.text = text;
            }
            if (firstSelected) {
                if(i == 0) {
                  l.textColor = textSelectedColor;
                  [l setIsSelected:YES];
                } else {
                    if(textColor) {
                        l.textColor = textColor;
                    } else {
                        l.textColor = [UIColor whiteColor];
                    }
                    [l setIsSelected:NO];
                }
            } else {
               if(textColor) {
                     l.textColor = textColor;
                } else {
                     l.textColor = [UIColor whiteColor];
                }
                [l setIsSelected:NO];
                
            }
            l.font = font;
            
            l.numberOfLines = 0;
            l.lineBreakMode = UILineBreakModeWordWrap;
        } 
		nTitleLabelTag++;
		nTitleBackImage++;
		[l LineNum:0 
		 ColumnNum:i
			target:self 
		   action1:@selector(tcLabelAction1:)
		   action2:@selector(tcLabelAction2:)];
		
		NSString* imageName = [photoNameArr objectAtIndex:i];
		UIImageView *tempView = [[UIImageView alloc]initWithFrame:CGRectMake(columnOffset, 0, photoWidth , photoViewHeight)];
		tempView.image = [UIImage imageNamed:imageName];
		tempView.tag = nTitleBackImage;
		[photoScrollView addSubview:tempView];
		[tempView release];
		
		[photoScrollView addSubview:l];
		columnOffset += photoWidth + colspan;
		
		[l release];
	}
   
    if (contentWidth <= photoScrollView.frame.size.width) {
        rightArrow.hidden = YES;
    }
}
- (void)fillImage 
{
    float columnOffset = 3.0;
    int nTitleBackImage = KImageTag;
    int count = [photoNameArr count];
//    for (UIView *oneView in [photoScrollView subviews]) {
//        if ([oneView isMemberOfClass:[UIImageView class]]) {
//            [oneView removeFromSuperview];
//        }
//    }
    
    for (int i = 0 ; i < count; i++) {
		NSString* imageName = [photoNameArr objectAtIndex:i];
		UIImageView *tempView = [[UIImageView alloc]initWithFrame:CGRectMake(columnOffset, 0, photoWidth , photoViewHeight)
                                                    ];
		tempView.image = [UIImage imageNamed:imageName];
		tempView.tag = nTitleBackImage;
		[photoScrollView addSubview:tempView];
		[tempView release];

		columnOffset += photoWidth + 3.0;
		 
	}
}

- (void)fillRemoteImage:(NSString *)defaultImage
{
    float columnOffset = 3.0;
    int nTitleBackImage = KImageTag;
    int count = [photoNameArr count];
    //    for (UIView *oneView in [photoScrollView subviews]) {
    //        if ([oneView isMemberOfClass:[UIImageView class]]) {
    //            [oneView removeFromSuperview];
    //        }
    //    }
    
    for (int i = 0 ; i < count; i++) {
		NSObject* imageName = [photoNameArr objectAtIndex:i];
		RemoteImageView *tempView = [[RemoteImageView alloc] initWithFrame:CGRectMake(columnOffset, 0, photoWidth , photoViewHeight)
                                                             withLocalFolder:nil
                                                              defaultImage:defaultImage];
        if (![imageName isEqual:[NSNull null]]) {
            [tempView loadImageNamed:(NSString *)imageName isRomate:YES];
        }
        
		tempView.tag = nTitleBackImage;
		[photoScrollView addSubview:tempView];
		[tempView release];
        
		columnOffset += photoWidth + 3.0;
        
	}
}


- (void)fillLabel
{
    float columnOffset = 3.0;
	int nTitleLabelTag = KStartLabelTag;
    int count = [photoNameArr count];
	
	for (int i = 0 ; i < count; i++) {
		UITCLabel *l = [[UITCLabel alloc] initWithFrame:CGRectMake(columnOffset, 0, photoWidth, photoViewHeight)];
		l.backgroundColor = [UIColor clearColor];
		l.tag = nTitleLabelTag;
		l.userInteractionEnabled = YES;
		l.highlighted = YES;
        if (textArr &&  textArr.count > 0) {
            l.text = [textArr objectAtIndex:i];
        }
		nTitleLabelTag++;
		[l LineNum:0 
		 ColumnNum:i
			target:self 
		   action1:@selector(tcLabelAction1:)
		   action2:@selector(tcLabelAction2:)];
		
		[photoScrollView addSubview:l];
		columnOffset += photoWidth + 3.0;
		[l release];
	}

}

- (void) fillView
{
    float columnOffset = 0.0;
    float colspan = 3.0;
    if(colSpan && colSpan != 0) {
        colspan = colSpan;
    }
    NSInteger cnt = [self.textArr count];
    for (int i=0; i<cnt; i++) {
        UITCLabel *l = [[UITCLabel alloc] initWithFrame:CGRectMake(columnOffset, 0, photoWidth, photoViewHeight)];
        l.tag = CLICK_LABEL_TAG+i;
		l.userInteractionEnabled = YES;
		l.highlighted = YES;
        id text = [self.textArr objectAtIndex:i];
        if ([text isKindOfClass:[UIView class]]) {
            [l addSubview:text];
        }
        [l LineNum:0 
		 ColumnNum:i
			target:self 
		   action1:@selector(tcLabelAction1:)
		   action2:@selector(tcLabelAction2:)];
        [self.photoScrollView addSubview:l];
		columnOffset += photoWidth + colspan;
		[l release];
    }
}

- (void) tcLabelAction1:(id) sender
{	
    NSLog(@"tcLabelAction1");
	//UITCLabel *tempLBL = (UITCLabel*)sender;
	//int tempLine = tempLBL.nLineNum;
	//int index = tempLBL.nColumnNum;
	if (delegate) {
		[delegate clickPhoto:self withSender:sender];
	}
}

- (void) tcLabelAction2:(id) sender
{	
    NSLog(@"tcLabelAction2");
	//UITCLabel *tempLBL = (UITCLabel*)sender;
	//int tempLine =	tempLBL.nLineNum;
	//int tempColumn = tempLBL.nColumnNum;
}

//-------------------------------以下为事件处发方法----------------------------------------
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
	
	
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (delegate) {
        [delegate scrollDidEnd:self withScrollView:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
      if (delegate) {
        [delegate scrollDidEnd:self withScrollView:scrollView];
      }
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (delegate) {
        [delegate scrollDidEnd:self withScrollView:scrollView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [photoScrollView release];
    [leftArrow release];
    [rightArrow release];
   // [photoView release];
   // [photoNameArr release];
    //[textArr release];
    [super dealloc];
}


@end

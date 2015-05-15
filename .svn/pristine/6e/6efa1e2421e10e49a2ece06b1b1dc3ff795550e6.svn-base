#import <UIKit/UIKit.h>

@class MayYouLikeView;
@protocol MayYouLikeViewDelegate <NSObject>

@optional

- (void)mayYouLikeView:(MayYouLikeView *)mayYouLikeView didSelectWithClickUrl:(NSString *)clickUrl;

@end

@interface MayYouLikeView : UIView

@property(nonatomic,strong) NSDictionary             *dataDict;
@property(nonatomic,weak) id<MayYouLikeViewDelegate> delegate;

@end

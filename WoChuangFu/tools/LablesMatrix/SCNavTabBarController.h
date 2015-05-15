#import <UIKit/UIKit.h>

@class SCNavTabBar;

@protocol SCNavTabBarControllerDelegate <NSObject>

@optional
- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end

@interface SCNavTabBarController : UIViewController

@property (nonatomic, assign)   BOOL        showArrowButton;            // Default value: YES
@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO
@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO

@property (nonatomic, strong)   NSArray     *subTitles;        // An array of children view controllers

@property (nonatomic, strong)   UIColor     *navTabBarColor;            // Could not set [UIColor clear], if you set, NavTabbar will show initialize color
@property (nonatomic, strong)   UIColor     *navTabBarLineColor;
@property (nonatomic, strong)   UIImage     *navTabBarArrowImage;

@property (nonatomic,weak) id<SCNavTabBarControllerDelegate> delegate;

- (id)initWithShowArrowButton:(BOOL)show;

- (id)initWithSubTitles:(NSArray *)subTitles;

- (id)initWithParentViewController:(UIViewController *)viewController;

- (id)initWithSubTitles:(NSArray *)SubTitles andParentViewController:(UIViewController *)viewController showArrowButton:(BOOL)show;
- (void)addParentController:(UIViewController *)viewController;


@end



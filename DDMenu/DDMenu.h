//
//  DDMenu.h
//  Syren
//
//  Created by Odie Edo-Osagie on 06/07/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    DDMenuShownState,
    DDMenuClosedState,
    DDMenuDisplayingState
    
}DDMenuState;

@interface DDMenuItem : NSObject


//The title of the menu item
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)UIImage *icon;
//completion handler
@property(nonatomic, strong)void (^completion)(BOOL);

//initialization methods
-(DDMenuItem *)initMenuItemWithTitle:(NSString *)title withCompletionHandler:(void (^)(BOOL))completion;
-(DDMenuItem *)initMenuItemWithTitle:(NSString *)title icon:(UIImage *)iconImage withCompletionHandler:(void (^)(BOOL))completion;

@end

@interface DDMenu : UIView<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic)DDMenuState      currentMenuState;
@property(nonatomic)NSUInteger       highLighedIndex;
@property(nonatomic)CGFloat          height;
@property(nonatomic, strong)UIColor *textColor;
@property(nonatomic, strong)UIFont  *titleFont;
@property(nonatomic, strong)UIColor *highLightTextColor;
@property(nonatomic, strong)UIImageView *headerImageView;
@property(nonatomic, strong)UIImageView *profileImageView;
@property(nonatomic, strong)UILabel *profileLabel;
@property(nonatomic, assign)BOOL hidesBorder;
@property(nonatomic, assign)float borderWidth;
@property(nonatomic, strong)UIColor *borderColor;
@property(nonatomic, strong)UIColor *selectedMenuItemColour;
//@property(nonatomic, strong)UIButton *topRightUtilityButton;
//@property(nonatomic, copy) void (^topRightUtilityButtonBlock)(UIButton *button);
@property(nonatomic, strong)UIImageView *topRightUtilityView;
@property(nonatomic, copy) void (^topRightUtilityButtonBlock)(UIView *utilityView);

//create Menu with white background
-(DDMenu *)initWithItems:(NSArray *)menuItems forViewController:(UIViewController *)viewController;

-(DDMenu *)initWithItems:(NSArray *)menuItems
               textColor:(UIColor *)textColor
     hightLightTextColor:(UIColor *)hightLightTextColor
         backgroundColor:(UIColor *)backGroundColor
       forViewController:(UIViewController *)viewController;

-(void)showMenu;
- (void)refresh;

@end

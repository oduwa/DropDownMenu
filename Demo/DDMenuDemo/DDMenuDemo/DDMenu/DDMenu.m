//
//  DDMenu.m
//  DDMenuBarDemo
//
//  Created by Odie Edo-Osagie on 06/07/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import "DDMenu.h"
#import "DDCollectionViewLayout.h"
#import "DDMenuCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define CELLIDENTIFIER          @"menubutton"
#define MENU_BOUNCE_OFFSET      10
#define PANGESTUREENABLE        1
#define VELOCITY_TRESHOLD       1000
#define AUTOCLOSE_VELOCITY      1200

@interface DDMenuItem ()

//the menuButton
@property(strong, nonatomic)UIButton *menuButton;


@end

@implementation DDMenuItem


-(DDMenuItem *)initMenuItemWithTitle:(NSString *)title
               withCompletionHandler:(void (^)(BOOL))completion;
{
    
    self.title = title;
    self.completion = completion;
    return self;
    
}

-(DDMenuItem *)initMenuItemWithTitle:(NSString *)title icon:(UIImage *)iconImage withCompletionHandler:(void (^)(BOOL))completion
{
    
    self.title = title;
    self.completion = completion;
    self.icon = iconImage;
    return self;
    
}

@end

@interface DDMenu ()


@property(nonatomic, strong)NSArray *menuItems;
@property(nonatomic, strong)UITableView *menuContentTable;
@property(nonatomic, strong)UICollectionView *menuContentCollectionView;
@property(nonatomic, weak)UIViewController *contentController;


@end

@implementation DDMenu

NSString *const MENU_ITEM_DEFAULT_FONTNAME    = @"HelveticaNeue-Light";
NSInteger const MENU_ITEM_DEFAULT_FONTSIZE    = 25;
NSInteger const STARTINDEX                    = 0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.highLighedIndex = STARTINDEX;
        self.currentMenuState = DDMenuClosedState;
        self.titleFont = [UIFont fontWithName:MENU_ITEM_DEFAULT_FONTNAME size:MENU_ITEM_DEFAULT_FONTSIZE];
        self.height = 260;
        self.borderWidth = 1.0;
        self.borderColor = [UIColor darkGrayColor];
        self.selectedMenuItemColour = [UIColor darkGrayColor];
    }
    return self;
}

#pragma mark initializers

-(DDMenu *)initWithItems:(NSArray *)menuItems
       forViewController:(UIViewController *)viewController
{
    
    return [self initWithItems:menuItems
                     textColor:[UIColor grayColor]
           hightLightTextColor:[UIColor blackColor]
               backgroundColor:[UIColor whiteColor]
             forViewController:viewController];
}

-(DDMenu *)initWithItems:(NSArray *)menuItems
               textColor:(UIColor *)textColor
     hightLightTextColor:(UIColor *)hightLightTextColor
         backgroundColor:(UIColor *)backGroundColor
       forViewController:(UIViewController *)viewController
{
    
    self = [[DDMenu alloc] init];
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), self.height);
    self.menuItems = menuItems;
    self.textColor = textColor;
    self.highLightTextColor = hightLightTextColor;
    self.backgroundColor = backGroundColor;
    self.contentController = viewController;
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.height/2)];
    self.headerImageView.image = [UIImage imageNamed:@"tape"];
    self.headerImageView.backgroundColor = [UIColor lightGrayColor];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headerImageView];
    
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headerImageView.frame.size.height/2, _headerImageView.frame.size.height/2)];
    self.profileImageView.center = CGPointMake(_headerImageView.center.x, _headerImageView.center.y);
    self.profileImageView.image = [UIImage imageNamed:@"friends"];
    [self roundImageView:_profileImageView];
    [self addSubview:_profileImageView];
    
    float xOffset = 5;
    float yOffset = 2;
    float imageBottomY = (_profileImageView.frame.origin.y + _profileImageView.frame.size.height);
    self.profileLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, imageBottomY+yOffset, [UIScreen mainScreen].bounds.size.width-(xOffset*2), 21)];
    self.profileLabel.textColor = [UIColor whiteColor];
    self.profileLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_profileLabel];
    
    /*
    float buttonSize = 20;
    self.topRightUtilityButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-buttonSize-xOffset, [UIApplication sharedApplication].statusBarFrame.size.height+2, buttonSize, buttonSize)];
    [self.topRightUtilityButton setImage:[UIImage imageNamed:@"cog"] forState:UIControlStateNormal];
    [self.topRightUtilityButton addTarget:self action:@selector(rightUtilityPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_topRightUtilityButton];
     */
    float buttonSize = 15;
    self.topRightUtilityView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-buttonSize-xOffset, [UIApplication sharedApplication].statusBarFrame.size.height+2, buttonSize, buttonSize)];
    _topRightUtilityView.image = [UIImage imageNamed:@"cog"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightUtilityPressed:)];
    [_topRightUtilityView addGestureRecognizer:tap];
    [self addSubview:_topRightUtilityView];
    _topRightUtilityView.image = [_topRightUtilityView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_topRightUtilityView setTintColor:[UIColor whiteColor]];
    _topRightUtilityView.userInteractionEnabled = YES;
    
    return self;
    
}

- (void) roundImageView:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 2.0;
    imageView.layer.masksToBounds = YES;
}

- (void) rightUtilityPressed:(UIView *)sender
{
    self.topRightUtilityButtonBlock(sender);
}

- (void) refresh
{
    [_menuContentCollectionView reloadData];
}

#pragma mark setter

-(void)setHeight:(CGFloat)height{
    
    if(_height != height){
        
        _height = height;
        CGRect menuFrame = CGRectMake(0, _height/2, [UIScreen mainScreen].bounds.size.width, _height/2);
        menuFrame.size.height = height/2;
        _menuContentTable.frame = menuFrame;
        _menuContentCollectionView.frame = menuFrame;
    }
    
    
}

-(void)setContentController:(UIViewController *)contentController{
    
    if(_contentController != contentController){
        
        if(contentController.navigationController)
            _contentController = contentController.navigationController;
        else
            _contentController = contentController;
        
        
        if(PANGESTUREENABLE)
            [_contentController.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                                           initWithTarget:self action:@selector(didPan:)]];
        
        [self setShadowProperties];
        [_contentController.view setAutoresizingMask:UIViewAutoresizingNone];
        UIViewController *menuController = [[UIViewController alloc] init];
        menuController.view = self;
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:menuController];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_contentController.view];
        
    }
    
    
}

-(void)setMenuContentCollectionView:(UICollectionView *)menuContentCollectionView
{
    
    if(_menuContentCollectionView != menuContentCollectionView){
        
        [menuContentCollectionView setDelegate:self];
        [menuContentCollectionView setDataSource:self];
        [menuContentCollectionView setShowsVerticalScrollIndicator:NO];
        [menuContentCollectionView setBackgroundColor:[UIColor whiteColor]];
        [menuContentCollectionView setAllowsMultipleSelection:NO];
        [menuContentCollectionView setBackgroundColor:self.backgroundColor];
        [menuContentCollectionView registerClass:[DDMenuCollectionViewCell class] forCellWithReuseIdentifier:CELLIDENTIFIER];
        _menuContentCollectionView = menuContentCollectionView;
        [self addSubview:_menuContentCollectionView];
        
    }
    
}

-(void)setShadowProperties{
    
    [_contentController.view.layer setShadowOffset:CGSizeMake(0, 1)];
    [_contentController.view.layer setShadowRadius:4.0];
    [_contentController.view.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [_contentController.view.layer setShadowOpacity:0.4];
    [_contentController.view.layer setShadowPath:[UIBezierPath
                                                  bezierPathWithRect:_contentController.view.bounds].CGPath];
    
}

#pragma mark layout method

-(void)layoutSubviews {
    
    self.currentMenuState = DDMenuClosedState;
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), self.height);
    self.contentController.view.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    [self setShadowProperties];
    self.menuContentTable = [[UITableView alloc] initWithFrame:self.frame];
    
    //UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    DDCollectionViewLayout *layout = [[DDCollectionViewLayout alloc] init];
    self.menuContentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.height/2, CGRectGetWidth([[UIScreen mainScreen] bounds]), self.height/2) collectionViewLayout:layout];
    
}


#pragma mark menu interactions

-(void)showMenu{
    
    if(self.currentMenuState == DDMenuShownState || self.currentMenuState == DDMenuDisplayingState){
        if(self.currentMenuState == DDMenuShownState || self.currentMenuState == DDMenuDisplayingState)
            [self animateMenuClosingWithCompletion:nil];
        
    }
    else{
        
        self.currentMenuState = DDMenuDisplayingState;
        [self animateMenuOpening];
        
    }
    
}

-(void)dismissMenu{
    
    if(self.currentMenuState == DDMenuShownState || self.currentMenuState == DDMenuDisplayingState){
        
        _contentController.view.frame = CGRectOffset(_contentController.view.frame, 0,
                                                     - _height + MENU_BOUNCE_OFFSET);
        self.currentMenuState = DDMenuClosedState;
        
    }
    
}



-(void)didPan:(UIPanGestureRecognizer *)panRecognizer{
    
    __block CGPoint viewCenter = panRecognizer.view.center;
    
    if(panRecognizer.state == UIGestureRecognizerStateBegan || panRecognizer.state ==
       UIGestureRecognizerStateChanged){
        CGPoint translation = [panRecognizer translationInView:panRecognizer.view.superview];
        
        if(viewCenter.y >= [[UIScreen mainScreen] bounds].size.height / 2 &&
           viewCenter.y <= (([[UIScreen mainScreen] bounds].size.height / 2 + _height) - MENU_BOUNCE_OFFSET)){
            
            self.currentMenuState = DDMenuDisplayingState;
            viewCenter.y = ABS(viewCenter.y + translation.y);
            
            if(viewCenter.y >= [[UIScreen mainScreen] bounds].size.height / 2 &&
               viewCenter.y < [UIScreen mainScreen].bounds.size.height / 2 + _height - MENU_BOUNCE_OFFSET)
                _contentController.view.center = viewCenter;
            
            [panRecognizer setTranslation:CGPointZero inView:_contentController.view];
            
        }
        
    }
    else if(panRecognizer.state == UIGestureRecognizerStateEnded) {
        
        
        CGPoint velocity = [panRecognizer velocityInView:panRecognizer.view.superview];
        if(velocity.y > VELOCITY_TRESHOLD)
            [self openMenuFromCenterWithVelocity:velocity.y];
        else if(velocity.y < -VELOCITY_TRESHOLD)
            [self closeMenuFromCenterWithVelocity:ABS(velocity.y)];
        else if( viewCenter.y <  ([[UIScreen mainScreen] bounds].size.height / 2 + (_height / 2)))
            [self closeMenuFromCenterWithVelocity:AUTOCLOSE_VELOCITY];
        else if(viewCenter.y <= ([[UIScreen mainScreen] bounds].size.height / 2 + _height - MENU_BOUNCE_OFFSET))
            [self openMenuFromCenterWithVelocity:AUTOCLOSE_VELOCITY];
        
    }
    
}

#pragma mark animation and menu operations

-(void)animateMenuOpening{
    
    if(self.currentMenuState != DDMenuShownState){
        
        [UIView animateWithDuration:.2 animations:^{
            
            //pushing the content controller down
            _contentController.view.center = CGPointMake(_contentController.view.center.x,
                                                         [[UIScreen mainScreen] bounds].size.height / 2 + _height);
        }completion:^(BOOL finished){
            
            [UIView animateWithDuration:.2 animations:^{
                
                _contentController.view.center = CGPointMake(_contentController.view.center.x,
                                                             [[UIScreen mainScreen] bounds].size.height / 2 + _height - MENU_BOUNCE_OFFSET);
                
            }completion:^(BOOL finished){
                
                self.currentMenuState = DDMenuShownState;
                
            }];
            
        }];
        
    }
    
    
}



-(void)animateMenuClosingWithCompletion:(void (^)(BOOL))completion{
    
    [UIView animateWithDuration:.2 animations:^{
        
        //pulling the contentController up
        _contentController.view.center = CGPointMake(_contentController.view.center.x,
                                                     _contentController.view.center.y + MENU_BOUNCE_OFFSET);
        
        
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:.2 animations:^{
            
            //pushing the menu controller down
            _contentController.view.center = CGPointMake(_contentController.view.center.x,
                                                         [[UIScreen mainScreen] bounds].size.height / 2);
            
        }completion:^(BOOL finished){
            
            if(finished){
                self.currentMenuState = DDMenuClosedState;
                if(completion)
                    completion(finished);
            }
            
        }];
        
    }];
    
    
}

-(void)closeMenuFromCenterWithVelocity:(CGFloat)velocity{
    
    CGFloat viewCenterY = [[UIScreen mainScreen] bounds].size.height / 2;
    self.currentMenuState = DDMenuDisplayingState;
    [UIView animateWithDuration:((_contentController.view.center.y - viewCenterY) / velocity)  animations:^{
        
        _contentController.view.center = CGPointMake(_contentController.view.center.x,
                                                     [[UIScreen mainScreen] bounds].size.height / 2);
        
    }completion:^(BOOL completed){
        
        self.currentMenuState = DDMenuClosedState;
        
    }];
    
}

-(void)openMenuFromCenterWithVelocity:(CGFloat)velocity{
    
    
    CGFloat viewCenterY = [[UIScreen mainScreen] bounds].size.height / 2 + _height - MENU_BOUNCE_OFFSET;
    self.currentMenuState = DDMenuDisplayingState;
    [UIView animateWithDuration:((viewCenterY - _contentController.view.center.y) / velocity)  animations:^{
        
        _contentController.view.center = CGPointMake(_contentController.view.center.x, viewCenterY);
        
    }completion:^(BOOL completed){
        
        self.currentMenuState = DDMenuShownState;
        
    }];
    
}


#pragma mark - CollectionView Delegates

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDMenuCollectionViewCell *menuCell = (DDMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELLIDENTIFIER forIndexPath:indexPath];

    menuCell.backgroundColor = collectionView.backgroundColor;
    
    if(!_hidesBorder){
        menuCell.layer.borderColor = _borderColor.CGColor;
        menuCell.layer.borderWidth = _borderWidth;
    }
    
    DDMenuItem *menuItem = (DDMenuItem *)[self.menuItems objectAtIndex:indexPath.row];
    menuCell.titleLabel.text =  menuItem.title;
    menuCell.titleLabel.textColor = _textColor;
    menuCell.titleLabel.font = [UIFont systemFontOfSize:10.0];
    menuCell.imageView.image = menuItem.icon;
    
    if(self.highLighedIndex == indexPath.row){
        menuCell.titleLabel.textColor = _highLightTextColor;
        menuCell.titleLabel.font = [UIFont systemFontOfSize:13.0];
        menuCell.backgroundColor = _selectedMenuItemColour;
        //menuCell.imageView.image = [menuCell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[menuCell.imageView setTintColor:_highLightTextColor];
    }
    else{
        //menuCell.imageView.image = [menuCell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[menuCell.imageView setTintColor:_textColor];
    }
    
    return menuCell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.highLighedIndex = indexPath.row;
    [self.menuContentCollectionView reloadData];
    DDMenuItem *selectedItem = [self.menuItems objectAtIndex:indexPath.row];
    [self animateMenuClosingWithCompletion:selectedItem.completion];
}

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DDMenuCollectionViewCell *menuCell = (DDMenuCollectionViewCell *)cell;
    
}




@end

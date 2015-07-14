# DropDownMenu
Animated drop down menu written in Objective-C


![Screenshot](https://github.com/oduwa/DropDownMenu/blob/master/phonescreen.png)

##Installation##

I haven't setup a pod for this project yet so for now, to install it just drag and drop the *DDMenu* folder into your XCode project. Pretty simple huh!


## Usage ##

First remember to import DDMenu where you want to use it (which should be in the Navigation Controller of your app). Basically, subclass UINavigation controller and use this subclass for your ViewControllers. The menu should then be setup within said Navigation Controller (See the included demo project for more details).

```objective-c
#import "DDMenu.h"
```
DDMenu is built on the RBMenu library so its API is very similar to that.

The DDMenu consists of 3 main things:
* HeaderView
* ProfilePictureView
* DDMenuItem

You can create Menu Items and add them to your menu as follows:

```objective-c
DDMenuItem *item1 = [[DDMenuItem alloc]initMenuItemWithTitle:@"SectionA" icon:[UIImage imageNamed:@"section_a_icon"] withCompletionHandler:^(BOOL finished){
        
        /* Instantiate the View Controller that the menu item should navigate to */
        SectionAViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SectionAViewController"];
        
        /* Navigate to it */
        [self setViewControllers:@[viewController] animated:NO];
        
    }];
```

Once you have created your menu items, its time create the actual menu and put it all together!

```objective-c
_menu = [[DDMenu alloc] initWithItems:@[item1, item2, item3] textColor:[UIColor lightGrayColor] hightLightTextColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]  forViewController:self];
```

## Customization ##

At the moment, the following features can be customized:

* @property(nonatomic)CGFloat height

* @property(nonatomic, strong)UIColor *textColor

* @property(nonatomic, strong)UIFont  *titleFont

* @property(nonatomic, strong)UIColor *highLightTextColor

* @property(nonatomic, assign)BOOL hidesBorder

* @property(nonatomic, assign)float borderWidth

* @property(nonatomic, strong)UIColor *borderColor;

* @property(nonatomic, strong)UIColor *selectedMenuItemColour:- set if you want to tint the selected icon a different colour from the remaining menu items' icons.

* @property(nonatomic, strong)UIImageView *headerImageView:- Image View for the header. Has all the customizability of any other UIImageView.

* @property(nonatomic, strong)UIImageView *profileImageView:- Image View for the profile picture. Has all the customizability of any other UIImageView.

* @property(nonatomic, strong)UILabel *profileLabel:- Text Label for the text beneath the profile picture. Has all the customizability of any other UILabel.

* @property(nonatomic, strong)UIImageView *topRightUtilityView:- Image View for the cog at the top right. Has all the customizability of any other UIImageView. The image defaults to a gear cog to be used for a "settings" section but can be changed to whatever other image you want.

* @property(nonatomic, copy) void (^topRightUtilityButtonBlock)(UIView *utilityView):- Block where you can specify what happens when the top right utility button (gear cog) is pressed.

An example of a DDMenu with some customization is shown below:

```objective-c
_menu.profileLabel.text = @"Russ Hanneman";
_menu.profileImageView.image = [UIImage imageNamed:@"profile_picture.jpg"];
_menu.headerImageView.image = [UIImage imageNamed:@"header_picture.jpg"];
_menu.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
_menu.hidesBorder = YES;
_menu.borderWidth = 0.5;
_menu.topRightUtilityButtonBlock = ^(UIView *topRightView){
        
    // Set what happens when top right button is pressed
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DDMenuDemo" 
                                              message:@"Top right button pressed" 
                                              delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
    [alert show];
        
};
```





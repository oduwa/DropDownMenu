//
//  MyNavigationController.m
//  DDMenuDemo
//
//  Created by Odie Edo-Osagie on 09/07/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import "MyNavigationController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "UIView+BlurEffect.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //creating the menu items
    FirstViewController *firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
    [self setViewControllers:@[firstViewController] animated:NO];
    
    DDMenuItem *item1 = [[DDMenuItem alloc]initMenuItemWithTitle:@"First" icon:[UIImage imageNamed:@"tape"] withCompletionHandler:^(BOOL finished){
        
        FirstViewController *firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
        [self setViewControllers:@[firstViewController] animated:NO];
        
    }];
    DDMenuItem *item2 = [[DDMenuItem alloc]initMenuItemWithTitle:@"Second" icon:[UIImage imageNamed:@"friends"] withCompletionHandler:^(BOOL finished){
        
        SecondViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"secondViewController"];
        [self setViewControllers:@[secondViewController] animated:NO];

    }];
    DDMenuItem *item3 = [[DDMenuItem alloc]initMenuItemWithTitle:@"Third" icon:[UIImage imageNamed:@"settings"] withCompletionHandler:^(BOOL finished){
        
        ThirdViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"thirdViewController"];
        [self setViewControllers:@[secondViewController] animated:NO];
        
    }];
    DDMenuItem *item4 = [[DDMenuItem alloc]initMenuItemWithTitle:@"Second First" icon:[UIImage imageNamed:@"tape"] withCompletionHandler:^(BOOL finished){
        
        FirstViewController *firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
        [self setViewControllers:@[firstViewController] animated:NO];
        
    }];
    DDMenuItem *item5 = [[DDMenuItem alloc]initMenuItemWithTitle:@"Second Second" icon:[UIImage imageNamed:@"friends"] withCompletionHandler:^(BOOL finished){
        
        SecondViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"secondViewController"];
        [self setViewControllers:@[secondViewController] animated:NO];
        
    }];
    DDMenuItem *item6 = [[DDMenuItem alloc]initMenuItemWithTitle:@"Second Third" icon:[UIImage imageNamed:@"settings"] withCompletionHandler:^(BOOL finished){
        
        ThirdViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"thirdViewController"];
        [self setViewControllers:@[secondViewController] animated:NO];
        
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    _menu = [[DDMenu alloc] initWithItems:@[item1, item2, item3, item4, item5, item6] textColor:[UIColor lightGrayColor] hightLightTextColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor]  forViewController:self];
    _menu.profileLabel.text = @"Russ Hanneman";
    _menu.profileImageView.image = [UIImage imageNamed:@"russ.jpg"];
    _menu.headerImageView.image = [UIView blurImage:[UIImage imageNamed:@"russ.jpg"]];//nil;
    _menu.headerImageView.backgroundColor = [UIColor yellowColor];
    _menu.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    _menu.hidesBorder = YES;
    _menu.borderWidth = 0.5;
    _menu.topRightUtilityButtonBlock = ^(UIView *topRightView){
        
        // Set what happens when top right button is pressed
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DDMenuDemo" message:@"Top right button pressed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu{
    
    [_menu showMenu];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

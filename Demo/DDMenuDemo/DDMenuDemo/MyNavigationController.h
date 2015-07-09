//
//  MyNavigationController.h
//  DDMenuDemo
//
//  Created by Odie Edo-Osagie on 09/07/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMenu.h"

@interface MyNavigationController : UINavigationController

@property(nonatomic, strong)DDMenu *menu;

- (void)showMenu;


@end

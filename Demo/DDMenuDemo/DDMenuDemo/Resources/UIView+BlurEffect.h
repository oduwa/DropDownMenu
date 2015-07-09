//
//  UIView+BlurEffect.h
//  Jive
//
//  Created by Odie Edo-Osagie on 11/07/2014.
//  Copyright (c) 2014 Odie Edo-Osagie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageEffects.h"

@interface UIView (BlurEffect)

-(UIImage *)blurredSnapshot;
+(UIImage *)blurImage:(UIImage *)image;
-(UIImage *)CoreImageBlur;

@end

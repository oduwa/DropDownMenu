//
//  DDMenuCollectionViewCell.m
//  RBMenuBarDemo
//
//  Created by Odie Edo-Osagie on 06/07/2015.
//  Copyright (c) 2015 Uniq Labs. All rights reserved.
//

#import "DDMenuCollectionViewCell.h"

@implementation DDMenuCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        float imageSize = [self getImageSizeForFrame:frame];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize, imageSize)];
        _imageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:_imageView];
        _imageView.image = [UIImage imageNamed:@"settings"];
        
        float spaceBelowImage = frame.size.height - (_imageView.frame.origin.y + _imageView.frame.size.height);
        float imageBottomY = (_imageView.frame.origin.y + _imageView.frame.size.height);
        float xOffset = 5;
        float yOffset = 2;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, imageBottomY+yOffset, frame.size.width-(xOffset*2), spaceBelowImage*0.5)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (float) getImageSizeForFrame:(CGRect)frame
{
    float imageSize = 0;
    if(frame.size.height > frame.size.width){
        imageSize = frame.size.height/2;
    }
    else{
        imageSize = frame.size.width/2;
    }
    
    return imageSize;
}

@end

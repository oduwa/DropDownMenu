//
//  DDCollectionViewLayout.m
//  DDMenuBarDemo
//
//  Created by Odie Edo-Osagie on 06/07/2015.
//  Copyright (c) 2015 Odie Edo-Osagie. All rights reserved.
//

#import "DDCollectionViewLayout.h"

@interface DDCollectionViewLayout ()

@property (strong, nonatomic) NSMutableArray *itemAttributes;
@property (nonatomic, assign) CGSize contentSize;

@end

@implementation DDCollectionViewLayout

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setItemOffset:UIOffsetMake(10.0, 6.0)];
        //[self setItemOffset:UIOffsetMake(0.0, 0.0)];
    }
    return self;
}

-(void)prepareLayout
{
    [self setItemAttributes:nil];
    _itemAttributes = [[NSMutableArray alloc] init];
    
    NSUInteger column = 0;    // Current column inside row
    
    //_itemOffset = UIOffsetMake(self.collectionView.bounds.size.width*0.05, self.collectionView.bounds.size.width*0.05);
    _itemOffset = UIOffsetMake(0, 0);
    
    CGFloat xOffset = _itemOffset.horizontal;
    CGFloat yOffset = _itemOffset.vertical;
    CGFloat rowHeight = 0.0;
    
    CGFloat contentWidth = 0.0;         // Used to determine the contentSize
    CGFloat contentHeight = 0.0;        // Used to determine the contentSize
    
    // Set number of items for each row
    NSUInteger numberOfColumnsInRow = [self.collectionView numberOfItemsInSection:0];
    
    // Loop through all items and calculate the UICollectionViewLayoutAttributes for each one
    NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger index = 0; index < numberOfItems; index++)
    {
        CGSize itemSize = CGSizeZero;
        
        //itemSize = CGSizeMake(self.collectionView.bounds.size.width*0.3-_itemOffset.horizontal-(_itemOffset.horizontal/2), self.collectionView.bounds.size.width*0.3-_itemOffset.horizontal-(_itemOffset.horizontal/2));
        itemSize = CGSizeMake(self.collectionView.bounds.size.width/3-_itemOffset.horizontal, self.collectionView.bounds.size.height);
        
        //if (itemSize.height > rowHeight)
        rowHeight = itemSize.height;
        
        // Create the actual UICollectionViewLayoutAttributes and add it to your array. We'll use this later in layoutAttributesForItemAtIndexPath:
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
        [_itemAttributes addObject:attributes];
        
        
        xOffset = xOffset+itemSize.width;
        column++;
        
        // Create a new row if this was the last column
        if (column == numberOfColumnsInRow)
        {
            if (xOffset > contentWidth)
                contentWidth = xOffset;
            
            // Reset values
            column = 0;
            xOffset = _itemOffset.horizontal;
            yOffset += rowHeight+_itemOffset.vertical;
            
            // Determine how much columns the new row will have
            numberOfColumnsInRow = 3;//arc4random() % 6+3;
        }
    }
    
    // Get the last item to calculate the total height of the content
    UICollectionViewLayoutAttributes *attributes = [_itemAttributes lastObject];
    contentHeight = attributes.frame.origin.y+attributes.frame.size.height;
    
    // Return this in collectionViewContentSize
    _contentSize = CGSizeMake(contentWidth, contentHeight);
}

-(CGSize)collectionViewContentSize
{
    return _contentSize;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [_itemAttributes objectAtIndex:indexPath.row];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [_itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

-(BOOL)shouldInvalidateLayoutFoDDoundsChange:(CGRect)newBounds
{
    return YES;
}




#pragma mark - Helpers

-(CGSize)sizeForItemWithColumnType:(NSUInteger)columnType
{
    /*
     if (columnType == kColumnTypeDefault)
     return CGSizeMake(self.collectionView.bounds.size.width*0.33-_itemOffset.horizontal, self.collectionView.bounds.size.width*0.35);
     
     if (columnType == kColumnTypeLarge)
     return CGSizeMake(self.collectionView.bounds.size.width*0.66-_itemOffset.horizontal, self.collectionView.bounds.size.width*0.4);
     
     return CGSizeZero;
     */
    
    
    if(columnType == 1){
        return CGSizeMake(self.collectionView.bounds.size.width-_itemOffset.horizontal, self.collectionView.bounds.size.width*0.65);
    }
    else if(columnType == 2){
        return CGSizeMake(self.collectionView.bounds.size.width*0.5-_itemOffset.horizontal, self.collectionView.bounds.size.width*0.45);
    }
    else{
        return CGSizeMake(self.collectionView.bounds.size.width*0.3333-_itemOffset.horizontal, self.collectionView.bounds.size.width*0.35);
    }
    
    return CGSizeZero;
    
}

@end

//
//  Bubble.m
//  BubblePopper
//
//  Created by Matthew Voss on 2/28/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "Bubble.h"

@implementation Bubble




-(Bubble *)getNewBubble;
{
    Bubble *newBubble = [Bubble new];
    
    newBubble.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[newBubble.imageView]];
    newBubble.itemBehavior.elasticity = 1.0;
    
    return newBubble;
}


@end

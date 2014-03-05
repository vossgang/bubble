//
//  Bubble.h
//  BubblePopper
//
//  Created by Matthew Voss on 2/28/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bubble : NSObject

@property (nonatomic, strong) UIImageView               *imageView;
@property (nonatomic, strong) UIDynamicItemBehavior     *itemBehavior;

-(Bubble *)getNewBubble;


@end

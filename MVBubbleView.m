//
//  MVBubbleView.m
//  BubbleView
//
//  Created by Matthew Voss on 3/2/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVBubbleView.h"
#import "Bubble.h"



@implementation MVBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        CGRect newFrame = frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = 0;
        
        self.mainBubble = [[UIImageView alloc] initWithFrame:newFrame];
        self.mainBubble.image = [UIImage imageNamed:@"b4.png"];
        [self addSubview:self.mainBubble];
        
        self.layer.cornerRadius = frame.size.width / 2;
        self.clipsToBounds = YES;
        
        [self setUpMiniBubbles];
        [self setUpGravity];
        [self setUpCollision];
        [self setUpAnimator];
        [self setUpItemBehavior];
        [self addItemBehaviorToAnimator];
        
    }
    return self;
}



-(void)setUpGravity;
{
    self.gravity = [UIGravityBehavior new];
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= .707;
    [self.gravity setGravityDirection:direction];
    for (int i = 0 ; i < self.bubbles.count; i++) {
        if (!(i % 2)) {
            Bubble *newBubble = [self.bubbles objectAtIndex:i];
            [self.gravity addItem:newBubble.imageView];
        }
    }
}

-(void)setUpItemBehavior
{
    for (int i = 0; i < self.bubbles.count; i++) {
        Bubble *newBubble = [self.bubbles objectAtIndex:i];
        UIDynamicItemBehavior *newBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[newBubble.imageView]];
        newBubble.itemBehavior = newBehavior;
        newBubble.itemBehavior.elasticity = 1.0;
    }
}


-(void)setUpCollision
{
    self.collision = [UICollisionBehavior new];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    for (int i = 0; i < self.bubbles.count; i++) {
        Bubble *newBubble = [self.bubbles objectAtIndex:i];
        [self.collision addItem:newBubble.imageView];
    }
    
}

-(void)addItemBehaviorToAnimator
{
    for (int i = 0; i < self.bubbles.count; i++) {
        Bubble *newBubble = [self.bubbles objectAtIndex:i];
        [self.animator addBehavior:newBubble.itemBehavior];
    }
}

-(void)setUpAnimator
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    [self addItemBehaviorToAnimator];
    
}


-(void)setUpMiniBubbles
{
    NSMutableArray *newArray = [NSMutableArray new];
    
    for (int i = 0; i < 2; i++) {
        Bubble *miniBubble  = [Bubble new];
        CGRect newFrame = self.frame;
        newFrame.size.height = (self.frame.size.height * .250);
        newFrame.size.width  = (self.frame.size.width  * .250);

        newFrame.origin.x = (self.frame.size.height * (.2 * (i + 1)));
        newFrame.origin.y = (self.frame.size.width  * (.2 * (i + 1)));
        miniBubble.imageView = [[UIImageView alloc] initWithFrame:newFrame];
        miniBubble.imageView.image = [UIImage imageNamed:@"b5.png"];
        miniBubble.imageView.layer.cornerRadius = miniBubble.imageView.frame.size.width / 2;
        miniBubble.imageView.clipsToBounds = YES;
        [self addSubview:miniBubble.imageView];
        [newArray addObject:miniBubble];
    }
    self.bubbles = newArray;
}



-(void)removeBubbleFromArray
{
    if (self.bubbles.count) {
        Bubble *newBubble = [Bubble new];
        newBubble = [self.bubbles objectAtIndex:0];
        [newBubble.imageView removeFromSuperview];
        [self.bubbles removeObjectAtIndex:0];
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

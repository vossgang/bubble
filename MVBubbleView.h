//
//  MVBubbleView.h
//  BubbleView
//
//  Created by Matthew Voss on 3/2/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVBubbleView : UIView


@property (nonatomic, strong) NSMutableArray            *bubbles;
@property (nonatomic, strong) UITapGestureRecognizer    *tap;
@property (nonatomic, strong) UIDynamicAnimator         *animator;
@property (nonatomic, strong) UIGravityBehavior         *gravity;
@property (nonatomic, strong) UICollisionBehavior       *collision;
@property (nonatomic, strong) UIDynamicItemBehavior     *behavior;
@property (nonatomic, strong) UIImageView               *mainBubble;

-(void)removeBubbleFromArray;

@end

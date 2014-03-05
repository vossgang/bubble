//
//  MVViewController.m
//  BubbleView
//
//  Created by Matthew Voss on 3/2/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVViewController.h"
#import "MVBubbleView.h"
#import "Bubble.h"

@interface MVViewController () <UICollisionBehaviorDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIDynamicAnimator     *animator;
@property (nonatomic, strong) UIGravityBehavior     *gravity;
@property (nonatomic, strong) UICollisionBehavior   *collision;
@property (weak, nonatomic)   UILabel               *scoreLabel;
@property (nonatomic)         NSInteger              score;
@property (nonatomic)         NSInteger              totalBubbleViews;
@property (nonatomic)         CGRect                 screenRect;
@property (nonatomic)         CGFloat                screenWidth;
@property (nonatomic)         CGFloat                screenHeight;
@property (nonatomic, strong) NSMutableArray        *bubbleViews;

@end

@implementation MVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.score = 0;
    self.totalBubbleViews = 5;
    
    self.screenRect = [[UIScreen mainScreen] bounds];
    self.screenWidth = self.screenRect.size.width;
    self.screenHeight = self.screenRect.size.height;

    [self putScoreLabel];
    [self startUp];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)putScoreLabel
{
    UILabel *label = [UILabel new];
    label.frame = CGRectMake((self.screenWidth - 120), (self.screenHeight - 44), 100, 44);
    self.scoreLabel = label;
    [self.view addSubview:self.scoreLabel];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    self.scoreLabel.text = [NSString stringWithFormat:@"popped %d", (int)self.score];
    
}

-(void)setUpBubbleViewsArray
{
    NSMutableArray *newArray = [NSMutableArray new];
    
    for (int i = 0; i < self.totalBubbleViews; i++) {
        int size = ((arc4random() % 64) + 64);
        int locationX = (arc4random() % 192);
        int locationY = (arc4random() % 352);
        MVBubbleView *newBubbleView = [[MVBubbleView alloc] initWithFrame:CGRectMake(locationX, locationY, size, size)];
        [newArray addObject:newBubbleView];
        [self.view addSubview:newBubbleView];
    }
    self.bubbleViews = newArray;
}

-(void)setUpItemBehavior
{
    for (int i = 0; i < self.bubbleViews.count; i++) {
        MVBubbleView *newBubbleView = [self.bubbleViews objectAtIndex:i];
        UIDynamicItemBehavior *newBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[newBubbleView]];
        newBubbleView.behavior = newBehavior;
        newBubbleView.behavior.elasticity = 1.0;
    }
    [self addItemBehaviorToAnimator];
}

-(void)addItemBehaviorToAnimator
{
    for (int i = 0; i < self.bubbleViews.count; i++) {
        MVBubbleView *newBubbleView = [self.bubbleViews objectAtIndex:i];
        [self.animator addBehavior:newBubbleView.behavior];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpGravity;
{
    self.gravity = [UIGravityBehavior new];
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= .707;
    [self.gravity setGravityDirection:direction];
    for (int i = 0 ; i < self.bubbleViews.count; i++) {
        if (!(i % 2)) {
            MVBubbleView *newBubbleViews = [self.bubbleViews objectAtIndex:i];
            [self.gravity addItem:newBubbleViews];
        }
    }
    
}

-(void)setUpCollision
{
    self.collision = [UICollisionBehavior new];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    for (int i = 0 ; i < self.bubbleViews.count; i++) {
            MVBubbleView *newBubbleViews = [self.bubbleViews objectAtIndex:i];
            [self.collision addItem:newBubbleViews];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    CGVector direction;
    direction = self.gravity.gravityDirection;
    direction.dy *= -1.0;
    
    MVBubbleView *newbubbleView = [self.bubbleViews objectAtIndex:0];
    
    if (item == newbubbleView) {
        
        [self.gravity setGravityDirection:direction];
    }
    
}

-(void)setUpAnimator
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.animator addBehavior:self.gravity];
    [self.animator addBehavior:self.collision];
    
}

-(void)setUpTap
{
    for (int i = 0; i < self.bubbleViews.count; i++) {
        MVBubbleView *newBubbleView = [self.bubbleViews objectAtIndex:i];
        newBubbleView.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [newBubbleView setUserInteractionEnabled:YES];
        [newBubbleView addGestureRecognizer:newBubbleView.tap];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < self.bubbleViews.count; i++) {
        MVBubbleView *newBubbleView = [self.bubbleViews objectAtIndex:i];
        if (newBubbleView.tap == sender) {
            if (newBubbleView.bubbles.count) {
                [self updateScore];
                [newBubbleView removeBubbleFromArray];
            } else if (![self compareImage:newBubbleView.mainBubble.image toImage:[UIImage imageNamed:@"DB3.png"]]) {
                newBubbleView.mainBubble.image = [UIImage imageNamed:@"DB3.png"];
            } else {
                [newBubbleView removeFromSuperview];
                [self.bubbleViews removeObjectAtIndex:i];
                [self updateScore];
            }
        }
    }
    if (self.bubbleViews.count == 0) {
        [self startUp];
    }
    
}

-(void)updateScore
{
    self.score++;
    self.scoreLabel.text = [NSString stringWithFormat:@"Popped %d", (int)self.score];
    
}

- (BOOL)compareImage:(UIImage *)image1 toImage:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)setBackGroundColor
{
    
    CGFloat r = arc4random_uniform(100) / (float)100;
    CGFloat g = arc4random_uniform(100) / (float)100;
    CGFloat b = arc4random_uniform(100) / (float)100;
    
    self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
    
}


- (IBAction)editGameControl:(id)sender {
    
    UIActionSheet *actoinSheet = [[UIActionSheet alloc] initWithTitle:@"Game Set Up"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Reset", @"Add More Bubbles", nil];
    [actoinSheet showFromBarButtonItem:sender animated:YES];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Reset"]) {
        [self removeEverything];
        self.totalBubbleViews= 5;
        self.score = 0;
        [self startUp];
    } else if ([buttonTitle isEqualToString:@"Add More Bubbles"]){
        if (self.totalBubbleViews < 10) {
            self.totalBubbleViews++;
            [self addBubbleToAll];
        }
    }
}

-(void)removeEverything
{
    
    while (self.bubbleViews.count) {
        MVBubbleView *newBubbleView = [self.bubbleViews objectAtIndex:0];
        while (newBubbleView.bubbles.count) {
            [newBubbleView removeBubbleFromArray];
        }
        [newBubbleView removeFromSuperview];
        [self.collision removeItem:newBubbleView];
        [self.animator removeBehavior:newBubbleView.behavior];
        [self.bubbleViews removeObjectAtIndex:0];
    }
    
}

-(void)addBubbleToAll
{
    int size = ((arc4random() % 64) + 64);
    int locationX = (arc4random() % 192);
    int locationY = (arc4random() % 352);
    MVBubbleView *newBubbleView = [[MVBubbleView alloc] initWithFrame:CGRectMake(locationX, locationY, size, size)];
    [self.view addSubview:newBubbleView];
    
    newBubbleView.behavior.elasticity = 1.0;
    
    [self.animator addBehavior:newBubbleView.behavior];
    [self.gravity addItem:newBubbleView];
    
    newBubbleView.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [newBubbleView setUserInteractionEnabled:YES];
    [newBubbleView addGestureRecognizer:newBubbleView.tap];
    
    [self.collision addItem:newBubbleView];
    
    [self.bubbleViews addObject:newBubbleView];
    
    
}

-(void)startUp
{
    
    [self setBackGroundColor];

    [self setUpBubbleViewsArray];
    [self setUpCollision];
    self.collision.collisionDelegate = self;
    [self setUpGravity];
    [self setUpAnimator];
    [self setUpItemBehavior];
    [self setUpTap];
    [self accountForToolBar];
    self.scoreLabel.textColor = self.view.backgroundColor;


    
}

-(void)accountForToolBar
{
    
    CGPoint toolBar = CGPointMake(0, (self.screenHeight - 44));
    CGPoint edge    = CGPointMake(self.screenWidth, (self.screenHeight - 44));
    [self.collision addBoundaryWithIdentifier:@"ToolBar" fromPoint:toolBar toPoint:edge];
    
}



@end

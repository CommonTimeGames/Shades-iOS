//
//  SHMyScene.m
//  Shades
//
//  Created by Nigel Brady on 7/30/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHMyScene.h"
#define MAX_ROUNDS 15
#define SHOW_COLOR_TIME 5

typedef enum {
    kShowingColor,
    kChoosingColor,
    kChangingColors,
    kPaused,
    kGameOver
} GameState;

float randFloat()
{
    return (float)arc4random() / UINT_MAX ;
}

@interface SHMyScene ()

@property (nonatomic) GameState state;

@property (nonatomic) int rowCount;
@property (nonatomic) int columnCount;

@property (nonatomic) SKColor *currentColor;
@property (nonatomic) SKNode *correctNode;

@property (nonatomic) int rounds;
@property (nonatomic) int score;

@property (strong, nonatomic) SKLabelNode *promptLabel;
@property (strong, nonatomic) SKSpriteNode *promptSquare;

@property (nonatomic) CGRect boardFrame;
@property (nonatomic) NSMutableArray *squares;

@end

@implementation SHMyScene

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blackColor];
    self.currentColor = [self randomColor];
    
    self.squares = [NSMutableArray array];

    self.rounds = 1;
    [self updateNodePositionsAndChangeColor:YES];
    
    SKSpriteNode *firstSquare = (SKSpriteNode *)self.squares[0];
    firstSquare.color = self.currentColor;
    firstSquare.name = @"correctNode";
    self.correctNode = firstSquare;
    
    self.state = kShowingColor;
}

-(void)updateNodePositionsAndChangeColor:(BOOL)changeColor
{
    CGPoint origin = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
    
    CGFloat minDimension = MIN(self.frame.size.width,
                               self.frame.size.height);
    
    
    self.boardFrame = CGRectMake(origin.x - minDimension/2,
                                 origin.y - minDimension/2,
                                 minDimension,
                                 minDimension);
    
    
    int rowCount = self.rounds;
    int columnCount = self.rounds;
    
    [self growSquares];
    
    for(int i = 0; i < rowCount; i++){
        for(int j = 0; j < columnCount; j++){
            int index = i * rowCount + j;
            SKSpriteNode *node = self.squares[i * rowCount + j];
            
            if(changeColor){
                node.color = [SKColor colorWithRed:randFloat()
                                             green:randFloat()
                                              blue:randFloat()
                                             alpha:1.0];
            }
            
            node.position = [self positionForSquareAtIndex:index numberOfRounds:self.rounds];
            node.size = [self sizeForSquareWithNumberOfRounds:self.rounds];
        }
    }
    
    if(!self.promptSquare){
        self.promptSquare = [SKSpriteNode node];
        self.promptSquare.name = @"promptSquare";
        self.promptSquare.zPosition = 1;
        [self addChild:self.promptSquare];
    }
    
    if(!self.promptLabel){
        self.promptLabel = [SKLabelNode labelNodeWithFontNamed:@"Avenir Next"];
        self.promptLabel.name = @"promptLabel";
        [self.promptSquare addChild:self.promptLabel];
    }
    
    self.promptLabel.text = @"Memorize the Color!";
    self.promptLabel.fontSize = 30;
    self.promptLabel.position = CGPointZero;

    self.promptSquare.color = self.currentColor;
    self.promptSquare.position = origin;
    self.promptSquare.size = self.boardFrame.size;
}

-(CGPoint) positionForSquareAtIndex: (int)index numberOfRounds: (int)rounds
{
    int row = index / rounds;
    int column = index % rounds;
    int columnSize = self.boardFrame.size.width / rounds;
    int rowSize = self.boardFrame.size.height / rounds;
    return CGPointMake(columnSize * column + self.boardFrame.origin.x,
                       rowSize * row + self.boardFrame.origin.y);
}

-(CGSize) sizeForSquareWithNumberOfRounds: (int)rounds
{
    return CGSizeMake(self.boardFrame.size.width / rounds,
                      self.boardFrame.size.height / rounds);
}

-(void)didChangeSize:(CGSize)oldSize
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSLog(@"Scene Frame: Origin: %.1f, %.1f, Size: %.1f, %1f",
          self.frame.origin.x,
          self.frame.origin.y,
          self.frame.size.width,
          self.frame.size.height);
    
    [self updateNodePositionsAndChangeColor:NO];
}

-(void)animateSquare:(SKSpriteNode *) node
         withIndex: (int)index
            andColor:(SKColor *) color
            rounds:(int)rounds
          duration: (NSTimeInterval) duration
{
    CGSize newSize = [self sizeForSquareWithNumberOfRounds:rounds];
    
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.boardFrame) - newSize.width/2,
                                 CGRectGetMidY(self.boardFrame) - newSize.height/2);
    
    if(CGPointEqualToPoint(node.position, CGPointZero)){
        node.position = center;
    }
    
    CGPoint destination = [self positionForSquareAtIndex:index
                                          numberOfRounds:rounds];
    
    
    SKAction *moveTo = [SKAction moveTo:center duration:duration];
    SKAction *shrink = [SKAction resizeToWidth:newSize.width
                                        height:newSize.height
                                      duration:duration];
    
    SKAction *wait = [SKAction waitForDuration:duration/2];
    SKAction *moveToDest = [SKAction moveTo:destination
                                   duration:duration];
    SKAction *changeColor = [SKAction colorizeWithColor:color colorBlendFactor:1.0 duration:duration];
    
    SKAction *moveGroup = [SKAction group:@[moveTo, shrink, changeColor]];
    SKAction *sequence = [SKAction sequence:@[moveGroup, wait, moveToDest]];
    
    [node runAction:sequence];
}

-(void)nextRound
{
    self.rounds = MIN(MAX_ROUNDS, self.rounds + 1);
    [self growSquares];
    
    int curIndex = [self.squares indexOfObject:self.correctNode];
    int newIndex = arc4random() % self.squares.count;
    
    [self.squares exchangeObjectAtIndex:curIndex withObjectAtIndex:newIndex];
    
    for(int i = 0; i < self.squares.count; i++){
        SKSpriteNode *node = self.squares[i];
        
        SKColor *color;
        
        if(node == self.correctNode){
            color = self.currentColor;
        } else {
            color = [self randomColor];
        }
        
        [self animateSquare:node withIndex:i
                   andColor: color
                     rounds:self.rounds duration:0.5];
    }

}
-(void)setState:(GameState)state
{
    _state = state;
    switch(state){
        case kShowingColor:
            [self showColor];
            break;
        case kChoosingColor:
            break;
        case kChangingColors:
            break;
        case kGameOver:
            break;
        case kPaused:
            break;

    }
}

-(void)showColor
{
    self.promptSquare.hidden = NO;
    self.promptLabel.hidden = NO;
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.50];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.50];
    SKAction *fadeSequence = [SKAction sequence:@[fadeOut, fadeIn]];
    
    [self.promptSquare runAction:[SKAction repeatAction:fadeSequence count:10 ] completion:^{
        [self.promptSquare removeFromParent];
        [self nextRound];
        self.state = kChoosingColor;
    }];
}

-(void)growSquares
{
    int numSquares = pow(self.rounds, 2.0);
    
    while(self.squares.count < numSquares){
        SKSpriteNode *node = [SKSpriteNode node];
        
        node.color = [SKColor clearColor];
        node.position = CGPointZero;
        node.anchorPoint = CGPointZero;
        node.size = CGSizeZero;
        node.name = [NSString stringWithFormat:@"square %d", self.squares.count + 1];
        
        [self addChild:node];
        [self.squares addObject:node];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Touch location: %.1f, %.1f", location.x, location.y);
        
        SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
        
        if(node == self.promptSquare){
            
        } else if(node == self.correctNode){
            NSLog(@"Tapped square: %@", node.name);
            [self nextRound];
        } else {
            NSLog(@"Wrong square!");
        }
    }
}

-(SKColor *)randomColor
{
    return [SKColor colorWithRed:randFloat()
                           green:randFloat()
                            blue:randFloat()
                           alpha:1.0];
}

@end

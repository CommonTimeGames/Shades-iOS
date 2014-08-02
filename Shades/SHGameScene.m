//
//  SHMyScene.m
//  Shades
//
//  Created by Nigel Brady on 7/30/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHGameScene.h"
#define MAX_ROUNDS 15
#define SHOW_COLOR_TIME 5

float randFloat()
{
    return (float)arc4random() / UINT_MAX ;
}

@interface SHGameScene ()

@end

@implementation SHGameScene

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blackColor];
    [self restart];
    
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
        self.promptLabel.zPosition = 1;
        [self addChild:self.promptLabel];
    }
    
    if(!self.scoreLabel){
        self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Avenir Next"];
        self.scoreLabel.name = @"scoreLabel";
        self.scoreLabel.zPosition = 1;
        [self addChild:self.scoreLabel];
    }
    
    if(!self.restartLabel){
        self.restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Avenir Next"];
        self.restartLabel.name = @"restartLabel";
        self.restartLabel.zPosition = 1;
        [self addChild:self.restartLabel];
    }
    
    self.promptLabel.text = @"Memorize the Color!";
    self.promptLabel.fontSize = 30;
    self.promptLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame));
    
    self.scoreLabel.text = @"Score: 0";
    self.scoreLabel.fontSize = 30;
    self.scoreLabel.position = CGPointMake(65,
                                           self.frame.size.height - 50);
    
    self.restartLabel.text = @"Restart";
    self.restartLabel.fontSize = 30;
    self.restartLabel.position = CGPointMake(self.frame.size.width - 55,
                                           self.frame.size.height - 50);

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
    
    SKAction *changeColor = [SKAction colorizeWithColor:color
                                       colorBlendFactor:1.0
                                               duration:duration];
    
    SKAction *moveGroup = [SKAction group:@[moveTo, shrink, changeColor]];
    SKAction *sequence = [SKAction sequence:@[moveGroup, wait, moveToDest]];
    
    [node runAction:sequence];
}

-(void)nextRound
{
    self.rounds = MIN(MAX_ROUNDS, self.rounds + 1);
    [self growSquares];
    
    NSUInteger curIndex = [self.squares indexOfObject:self.correctNode];
    NSUInteger newIndex = arc4random() % self.squares.count;
    
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
            self.promptLabel.hidden = NO;
            self.promptLabel.text = @"Game Over!";
            self.promptLabel.fontSize = 45;
            self.promptLabel.fontColor = [SKColor whiteColor];
            break;
        case kPaused:
            break;

    }
}
-(void)setScore:(int)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", _score];
}

-(void)showColor
{
    self.promptSquare.hidden = NO;
    self.promptLabel.hidden = NO;
    
    self.promptLabel.text = @"Memorize the Color!";
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.50];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.50];
    SKAction *fadeSequence = [SKAction sequence:@[fadeOut, fadeIn]];
    
    [self.promptLabel runAction:[SKAction repeatAction:fadeSequence count:10 ] completion:^{
        self.promptLabel.hidden = YES;
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
        node.name = [NSString stringWithFormat:@"square %d",
                     self.squares.count + 1];
        
        [self addChild:node];
        [self.squares addObject:node];
    }
}

-(SKColor *)randomColor
{
    return [SKColor colorWithRed:randFloat()
                           green:randFloat()
                            blue:randFloat()
                           alpha:1.0];
}

-(void)restart
{
    [self.promptLabel removeAllActions];
    
    for(SKSpriteNode *square in self.squares){
        [square removeFromParent];
    }
    
    self.currentColor = [self randomColor];
    self.squares = [NSMutableArray array];
    self.rounds = 1;
    [self updateNodePositionsAndChangeColor:YES];
    
    self.promptLabel.fontColor = [self colorForTextWithBackgroundColor:self.currentColor];
    
    SKSpriteNode *firstSquare = (SKSpriteNode *)self.squares[0];
    firstSquare.color = self.currentColor;
    firstSquare.name = @"correctNode";
    self.correctNode = firstSquare;
    
    self.state = kShowingColor;
}

-(SKColor *)colorForTextWithBackgroundColor:(SKColor *)color
{
    CGFloat r = 0.0;
    CGFloat g = 0.0;
    CGFloat b = 0.0;
    CGFloat a = 0.0;
    
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    float brightness = ((r*255*299)+(g*255*587)+(b*255*114))/1000;
    
    NSLog(@"Brightness value: %f", brightness);
    
    return brightness >= 128 ? [SKColor blackColor] : [SKColor whiteColor];
}

@end

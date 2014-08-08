/*
 #
 # Copyright 2007 Nigel Brady, Konstantin Uroskin
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 # http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 
 */

#import "SHGameScene.h"
#define MAX_ROUNDS 15
#define SHOW_COLOR_TIME 10.0

float randFloat()
{
    return (float)arc4random() / UINT_MAX ;
}

@interface SHGameScene ()

@property (nonatomic) NSTimeInterval timeRemaining;
@property (nonatomic) CFTimeInterval lastTime;

@end

@implementation SHGameScene

-(void)didMoveToView:(SKView *)view
{
    self.backgroundColor = [SKColor blackColor];
    self.lastTime = CACurrentMediaTime();
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
        self.promptLabel.zPosition = 2;
        self.promptLabel.userInteractionEnabled = NO;
        [self addChild:self.promptLabel];
    }
    
    if(!self.timerLabel){
        self.timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Avenir Next"];
        self.timerLabel.name = @"timerLabel";
        self.timerLabel.zPosition = 2;
        self.timerLabel.userInteractionEnabled = NO;
        [self addChild:self.timerLabel];
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
    
    self.timerLabel.text = @"10";
    self.timerLabel.fontSize = 25;
    self.timerLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                            CGRectGetMidY(self.frame) - 30);
    
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
    
    SKAction *changeState = [SKAction runBlock:^{
        self.state = kChoosingColor;
    }];
    
    SKAction *sequence = [SKAction sequence:@[moveGroup, wait, moveToDest, changeState]];
    
    [node runAction:sequence];
}

-(void)revealCorrectSquare
{
    NSTimeInterval duration = 0.5;
    
    CGPoint center = self.boardFrame.origin;
    
    SKAction *moveTo = [SKAction moveTo:center duration:duration];
    
    SKAction *wait = [SKAction waitForDuration:duration];
    
    SKAction *grow = [SKAction resizeToWidth:self.boardFrame.size.width
                                        height:self.boardFrame.size.height
                                      duration:duration];
    
    SKAction *sequence = [SKAction sequence:@[moveTo, wait, grow]];
    self.correctNode.zPosition = 1;
    [self.correctNode runAction:sequence];
}

-(void)nextRound
{
    self.state = kChangingColors;
    
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
            color = [SHGameScene randomColor];
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
            [self addGameOverUI];
            break;
        case kPaused:
            break;

    }
}

-(void)addGameOverUI
{
    SKColor *textColor =
    [self colorForTextWithBackgroundColor:self.currentColor];

    if(!self.promptLabel.parent){
        [self addChild:self.promptLabel];
    }
    
    self.promptLabel.text = @"Game Over!";
    self.promptLabel.fontSize = 45;
    self.promptLabel.fontColor = textColor;
    
    CGPoint quitLabelPosition =
        CGPointMake(self.promptLabel.position.x,
                    self.promptLabel.position.y - 45);
    
    
    self.quitLabel = [self UILabelNodeWithText:@"Quit"
                                         color:textColor
                                      position:quitLabelPosition];
    self.quitLabel.fontSize = 30;
    
    NSString *twitterImageName;
    NSString *facebookImageName;
    
    if(textColor == [SKColor blackColor]){
        twitterImageName =  @"twitter-blue";
        facebookImageName = @"fb-blue";
    } else {
        twitterImageName =  @"twitter-white";
        facebookImageName = @"fb-white";
    }
    
    CGFloat tbHeight = 30.0;
    
    if([self shouldShowSocialIcons]){
        self.twitterButton = [SKSpriteNode spriteNodeWithImageNamed:twitterImageName];
        self.twitterButton.size = CGSizeMake(1.23 * tbHeight,tbHeight);
        self.twitterButton.anchorPoint = CGPointZero;
        self.twitterButton.position =
        CGPointMake(self.boardFrame.origin.x + 20,
                    self.boardFrame.origin.y + 20);
        
        
        CGFloat facebookButtonSize = 30;
        self.facebookButton = [SKSpriteNode spriteNodeWithImageNamed:facebookImageName];
        self.facebookButton.size = CGSizeMake(facebookButtonSize, facebookButtonSize);
        self.facebookButton.anchorPoint = CGPointZero;
        self.facebookButton.position =
        CGPointMake(self.boardFrame.origin.x
                    + self.boardFrame.size.width - 20
                    - facebookButtonSize,
                    self.boardFrame.origin.y + 20);
        
        self.twitterButton.zPosition = 2;
        self.facebookButton.zPosition = 2;
        
        [self addChild:self.twitterButton];
        [self addChild:self.facebookButton];
    }
    [self addChild:self.quitLabel];
}

-(SKLabelNode *)UILabelNodeWithText: (NSString *)text color:(SKColor *)color position:(CGPoint )position
{
    SKLabelNode *label = [SKLabelNode node];
    
    label.fontName = @"Avenir Next";
    label.text = text;
    label.fontSize = 30;
    label.fontColor = color;
    label.zPosition = 1;
    label.position = position;
    
    return label;
}

-(void)setScore:(int)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", _score];
}

-(void)showColor
{
    self.promptSquare.hidden = NO;
    
    if(!self.promptLabel.parent){
        [self addChild:self.promptLabel];
    }
    if(!self.timerLabel.parent){
        [self addChild:self.timerLabel];
    }
    
    self.promptLabel.text = @"Memorize the Color!";
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.50];
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.50];
    SKAction *fadeSequence = [SKAction sequence:@[fadeOut, fadeIn]];
    
    [self.promptLabel runAction:[SKAction repeatActionForever:fadeSequence]];
}

-(void)hidePrompt
{
    [self.promptLabel removeAllActions];
    [self.promptLabel removeFromParent];
    [self.timerLabel removeFromParent];
    [self.promptSquare removeFromParent];
    
    [self nextRound];
    
    self.state = kChoosingColor;
}
-(void)growSquares
{
    int numSquares = pow(self.rounds, 2.0);
    
    while(self.squares.count < numSquares){
        SKSpriteNode *node = [SKSpriteNode node];
        
        NSUInteger nodeCount = self.squares.count + 1;
        node.color = [SKColor clearColor];
        node.position = CGPointZero;
        node.anchorPoint = CGPointZero;
        node.size = CGSizeZero;
        node.name = [NSString stringWithFormat:@"square %lu",(unsigned long)nodeCount];
        
        [self addChild:node];
        [self.squares addObject:node];
    }
}

+(SKColor *)randomColor
{
    return [SKColor colorWithRed:randFloat()
                           green:randFloat()
                            blue:randFloat()
                           alpha:1.0];
}

-(void)restart
{
    if(!self.promptLabel.parent){
        [self addChild:self.promptLabel];
    }
    if(!self.timerLabel.parent){
        [self addChild:self.timerLabel];
    }
    
    [self.promptLabel removeAllActions];

    for(SKSpriteNode *square in self.squares){
        [square removeFromParent];
    }
    
    [self.quitLabel removeFromParent];
    
    if([self shouldShowSocialIcons]){
        [self.twitterButton removeFromParent];
        [self.facebookButton removeFromParent];
    }
    
    self.currentColor = [SHGameScene randomColor];
    self.squares = [NSMutableArray array];
    self.rounds = 1;
    self.score = 0;
    [self updateNodePositionsAndChangeColor:YES];
    
    self.promptLabel.fontColor = [self colorForTextWithBackgroundColor:self.currentColor];
    self.timerLabel.fontColor = self.promptLabel.fontColor;
    
    SKSpriteNode *firstSquare = (SKSpriteNode *)self.squares[0];
    firstSquare.color = self.currentColor;
    firstSquare.name = @"correctNode";
    self.correctNode = firstSquare;
    
    self.timeRemaining = SHOW_COLOR_TIME;
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

-(void)quitGame
{
    
}
-(void)tweet
{
    
}
-(void)postToFacebook
{
    
}

-(BOOL)shouldShowSocialIcons
{
    return YES;
}

-(void)userDidTouchLocation: (CGPoint)location
{
    SKNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if(node){
        NSLog(@"Touched node: %@", node.name);
    }
    
    if(node == self.quitLabel){
        [self quitGame];
    } else if(node == self.restartLabel){
        [self restart];
    } else if(node == self.twitterButton){
        [self tweet];
    } else if(node == self.facebookButton){
        [self postToFacebook];
    } else if(self.state == kGameOver){
        return;
    } else if(node == self.promptSquare){
        return;
    } else if(node == self.correctNode
              && self.state == kChoosingColor){
        NSLog(@"Correct square!");
        self.score++;
        [self nextRound];
    } else if([node.name rangeOfString:@"square"].location != NSNotFound
              && self.state == kChoosingColor){
        NSLog(@"Wrong square!");
        [self revealCorrectSquare];
        self.state = kGameOver;
    }
}

-(void)update:(NSTimeInterval)currentTime
{
    CFTimeInterval delta = currentTime - self.lastTime;
    
    if(self.state == kShowingColor){
        self.timeRemaining -= delta;
        
        if(self.timeRemaining <= 0){
            [self hidePrompt];
        } else {
            self.timerLabel.text = [NSString stringWithFormat:@"%.1f", self.timeRemaining];
        }
    }
    
    self.lastTime = currentTime;
}

@end

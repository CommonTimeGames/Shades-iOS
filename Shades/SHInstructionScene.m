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

#import "SHInstructionScene.h"
#define ROUND_LIMIT 4

@implementation SHInstructionScene

NSString *const choosePrompt = @"Choose the Color!";

-(void)updateNodePositionsAndChangeColor:(BOOL)changeColor
{
    [super updateNodePositionsAndChangeColor:changeColor];
    
    if(!self.instructionBackground){
        CGFloat labelSize = 50;
        self.instructionBackground = [SKSpriteNode node];
        self.instructionBackground.color = [SKColor whiteColor];
        self.instructionBackground.anchorPoint = CGPointZero;
        self.instructionBackground.size = CGSizeMake(self.frame.size.width, labelSize);
        
        self.instructionBackground.position =
                    CGPointMake(0, CGRectGetMidY(self.frame)-labelSize/2);
        
        self.instructionBackground.userInteractionEnabled = NO;
        
        self.instructionBackground.alpha = 0.8;
        self.instructionBackground.zPosition = 1;
        [self addChild:self.instructionBackground];
        
        self.instructionBackground.hidden = YES;
    }
    
    self.promptLabel.hidden = NO;
    self.timerLabel.hidden = NO;
    self.restartLabel.text = @"Back";
    self.scoreLabel.hidden = YES;
}

-(void)userDidSelectCorrectSquare: (BOOL)correctSquare
{
    NSString *flashText;
    NSString *originalText = choosePrompt;
    NSString *soundFile;
    
    if(correctSquare){
        flashText = @"Good Job!";
        soundFile = @"correct.m4a";
    } else {
        flashText = @"Try Again!";
        soundFile = @"gameover.mp3";
    }
    
    SKAction *playSound = [SKAction playSoundFileNamed:soundFile waitForCompletion:NO];
    
    SKAction *changeText = [SKAction runBlock:^{
        self.instructionLabel.text = flashText;
    }];
    
    SKAction *changeBack = [SKAction runBlock:^{
        self.instructionLabel.text = originalText;
    }];
    
    SKAction *wait = [SKAction waitForDuration:2.0];
    SKAction *sequence = [SKAction sequence:@[playSound, changeText, wait, changeBack]];
    
    [self.instructionLabel removeAllActions];
    [self.instructionLabel runAction:sequence];
}

-(void)setState:(GameState)state
{
    [super setState:state];
    
    if(state == kChoosingColor){
        if(!self.instructionLabel){
            self.instructionLabel = [SKLabelNode node];
            self.instructionLabel.fontName = @"Avenir Next";
            self.instructionLabel.text = choosePrompt;
            self.instructionLabel.fontSize = 30;
            self.instructionLabel.userInteractionEnabled = NO;
            
            self.instructionLabel.position =
                CGPointMake(self.instructionBackground.size.width/2,
                            self.instructionBackground.size.height/2 - 10);
            
            self.instructionLabel.fontColor = [SKColor blackColor];
            
            [self.instructionBackground addChild:self.instructionLabel];
        }
        
        self.instructionBackground.hidden = NO;
    }
}

-(void)userDidTouchLocation:(CGPoint)location
{
    SKNode *node = (SKSpriteNode *)[self nodeAtPoint:location];

    if(node == self.restartLabel){
        [self quitGame];
        return;
    } else if(node == self.instructionBackground
       || node == self.instructionLabel){
        return;
    } else if(self.rounds > ROUND_LIMIT){
        return;
    }
    
    if(self.state == kChoosingColor){
        if(node == self.correctNode){
            [self nextRound];
            [self userDidSelectCorrectSquare:YES];
            
            if(self.rounds > ROUND_LIMIT){
                SKAction *changeText =
                    [SKAction runBlock:^{
                        self.instructionLabel.text = @"You Are Ready!";
                    }];
                SKAction *playSound = [SKAction playSoundFileNamed:@"correct.m4a" waitForCompletion:NO];
                SKAction *sequence = [SKAction sequence:@[playSound, changeText]];
                [self.instructionLabel removeAllActions];
                [self.instructionLabel runAction:sequence];
            }
        } else {
            [self userDidSelectCorrectSquare:NO];
        }
    }
}

@end

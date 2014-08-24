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

#import <AVFoundation/AVFoundation.h>
#import "SHTitleScene.h"
#import "SHGameScene.h"

@interface SHTitleScene ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation SHTitleScene

-(void)didMoveToView:(SKView *)view
{
    self.titleLabel = [SKLabelNode node];
    self.titleLabel.fontName = @"Avenir Next";
    self.titleLabel.text = @"Shades:";
    self.titleLabel.fontSize = 60;
    self.titleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame) + 100);
    
    self.titleLabel.fontColor = [SKColor whiteColor];
    self.titleLabel.zPosition = 1;
    
    self.subTitleLabel = [SKLabelNode node];
    self.subTitleLabel.fontName = @"Avenir Next";
    self.subTitleLabel.text = @"A Game of Colors";
    self.subTitleLabel.fontSize = 30;
    self.subTitleLabel.position = CGPointMake(self.titleLabel.position.x,
                                              self.titleLabel.position.y - 45);
    
    self.subTitleLabel.fontColor = [SKColor whiteColor];
    self.subTitleLabel.zPosition = 1;

    self.playLabel = [SKLabelNode node];
    self.playLabel.fontName = @"Avenir Next";
    self.playLabel.text = @"Play";
    self.playLabel.fontSize = 30;
    self.playLabel.position = CGPointMake(self.titleLabel.position.x,
                                              self.subTitleLabel.position.y - 80);
    
    self.playLabel.fontColor = [SKColor whiteColor];
    self.playLabel.zPosition = 1;

    
    self.instructionLabel = [SKLabelNode node];
    self.instructionLabel.fontName = @"Avenir Next";
    self.instructionLabel.text = @"Instructions";
    self.instructionLabel.fontSize = 30;
    self.instructionLabel.position = CGPointMake(self.titleLabel.position.x,
                                          self.subTitleLabel.position.y - 125);
    
    self.instructionLabel.fontColor = [SKColor whiteColor];
    self.instructionLabel.zPosition = 1;

    
    [self addChild:self.titleLabel];
    [self addChild:self.subTitleLabel];
    [self addChild:self.playLabel];
    [self addChild:self.instructionLabel];
    
    SKAction *generateSquare = [SKAction runBlock:^{
        [self generateSquareAtLocation:CGPointZero];

    }];
    
    SKAction *wait = [SKAction waitForDuration:1.0 withRange:1.0];
    SKAction *sequence = [SKAction sequence:@[generateSquare, wait]];
    SKAction *repeat = [SKAction repeatActionForever:sequence];
    
    [self runAction:repeat];
    
    [self performSelector:@selector(playMusic) withObject:self afterDelay:0.5];
}

-(void)generateSquareAtLocation:(CGPoint)location
{
    SKSpriteNode *square = [SKSpriteNode node];
    square.color = [SHGameScene randomColor];
    square.size = CGSizeMake(self.frame.size.width/4,
                             self.frame.size.width/4);
    
    if(CGPointEqualToPoint(location, CGPointZero)){
        square.position = CGPointMake((arc4random() % 4) * self.frame.size.width/4,
                                      (arc4random() % 8) * self.frame.size.width/4);
    } else {
        square.position = location;
    }
   
    //NSLog(@"Square position: %f, %f", square.position.x, square.position.y);
    
    square.anchorPoint = CGPointZero;
    square.alpha = 0.0;
    square.name = @"randomSquare";
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];

    SKAction *fadeOut = [SKAction fadeOutWithDuration:1.0];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[fadeIn,fadeOut,remove]];
    
    [self addChild:square];
    [square runAction:sequence];
}

-(CGPoint)randomStartingPosition
{
    return CGPointMake(fmod(arc4random(), self.frame.size.width), 0);
}

-(void)playGame
{
    NSLog(@"Start game!");
    [self stopMusic];
}

-(void)instructions
{
    NSLog(@"View instructions!");
    [self stopMusic];
}

-(void)touchInLocation:(CGPoint) location
{
    SKNode *node = [self nodeAtPoint:location];
    
    if(node == self.playLabel){
        NSLog(@"Play Game!");
        [self playGame];
    } else if(node == self.instructionLabel){
        NSLog(@"Instructions!");
        [self instructions];
    } else if([node.name isEqualToString:@"randomSquare"]){
        SKAction *rotate = [SKAction rotateByAngle:M_PI duration:1.0];
        [node runAction:rotate];
    } else {
        [self generateSquareAtLocation:location];
    }
}

-(void)playMusic
{
    NSError *error;
	NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"title" withExtension:@"mp3"];
    
    if(self.audioPlayer.isPlaying){
        [self.audioPlayer stop];
    }
    
	self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&error];
	self.audioPlayer.numberOfLoops = -1;
	self.audioPlayer.volume = 0.40f;
	[self.audioPlayer prepareToPlay];
	[self.audioPlayer play];
}

-(void)stopMusic
{
    [self.audioPlayer stop];
}

@end

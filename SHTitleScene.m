//
//  SHTitleScene.m
//  Shades
//
//  Created by Nigel Brady on 8/2/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHTitleScene.h"
#import "SHGameScene.h"

@implementation SHTitleScene

-(void)didMoveToView:(SKView *)view
{
    self.titleLabel = [SKLabelNode node];
    self.titleLabel.fontName = @"Avenir Next";
    self.titleLabel.text = @"Shades:";
    self.titleLabel.fontSize = 60;
    self.titleLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame) + 50);
    
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
   
    NSLog(@"Square position: %f, %f", square.position.x, square.position.y);
    
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
    NSLog(@"Change scene!");
}

-(void)touchInLocation:(CGPoint) location
{
    SKNode *node = [self nodeAtPoint:location];
    
    if(node == self.playLabel){
        NSLog(@"Play Game!");
        [self playGame];
    } else if(node == self.instructionLabel){
        NSLog(@"Instructions!");
        
    } else if([node.name isEqualToString:@"randomSquare"]){
        SKAction *rotate = [SKAction rotateByAngle:M_PI duration:1.0];
        [node runAction:rotate];
    } else {
        [self generateSquareAtLocation:location];
    }
}

@end

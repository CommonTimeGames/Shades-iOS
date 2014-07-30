//
//  SHMyScene.m
//  Shades
//
//  Created by Nigel Brady on 7/30/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHMyScene.h"

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

@property (nonatomic) int score;

@property (nonatomic) SKLabelNode *promptLabel;
@property (nonatomic) NSMutableArray *squares;

@end

@implementation SHMyScene


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [self randomColor];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Avenir Next"];
        
        
        
        myLabel.text = @"Memorize the Color!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        SKAction *changeColor = [SKAction runBlock:^{
            self.backgroundColor = [self randomColor];
        }];
        
        SKAction *wait = [SKAction waitForDuration:2 withRange:3];
        SKAction *sequence = [SKAction sequence:@[wait, changeColor]];
        [myLabel runAction:[SKAction repeatActionForever:sequence]];

        
        self.state = kShowingColor;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(SKColor *)randomColor
{
    return [SKColor colorWithRed:randFloat()
                           green:randFloat()
                            blue:randFloat()
                           alpha:1.0];
}

@end

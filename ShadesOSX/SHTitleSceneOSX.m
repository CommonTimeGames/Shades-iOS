//
//  SHTitleSceneOSX.m
//  Shades
//
//  Created by Nigel Brady on 8/3/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHInstructionSceneOSX.h"
#import "SHTitleSceneOSX.h"
#import "SHGameSceneOSX.h"

@implementation SHTitleSceneOSX

-(void)mouseDown:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    CGPoint location = [theEvent locationInNode:self];
    NSLog(@"Click location: %.1f, %.1f", location.x, location.y);
    [self touchInLocation:location];
}

-(void)playGame
{
    SKTransition *reveal = [SKTransition doorwayWithDuration:1.0];
    /* Pick a size for the scene */
    SKScene *scene = [SHGameSceneOSX sceneWithSize:CGSizeMake(1024, 768)];
    
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.view presentScene:scene transition:reveal];
}

-(void)instructions
{
    SKTransition *reveal = [SKTransition doorwayWithDuration:1.0];
    /* Pick a size for the scene */
    SKScene *scene = [SHInstructionSceneOSX sceneWithSize:CGSizeMake(1024, 768)];
    
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    [self.view presentScene:scene transition:reveal];
}

@end

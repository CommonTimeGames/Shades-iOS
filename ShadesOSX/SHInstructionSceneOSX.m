//
//  SHInstructionSceneOSX.m
//  Shades
//
//  Created by Nigel Brady on 8/3/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHTitleSceneOSX.h"
#import "SHInstructionSceneOSX.h"

@implementation SHInstructionSceneOSX

-(void)mouseDown:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    CGPoint location = [theEvent locationInNode:self];
    NSLog(@"Click location: %.1f, %.1f", location.x, location.y);
    [self userDidTouchLocation:location];
}

-(void)quitGame
{
    SKTransition *reveal = [SKTransition flipVerticalWithDuration:1.0];
    /* Pick a size for the scene */
    SKScene *scene = [SHTitleSceneOSX sceneWithSize:CGSizeMake(1024, 768)];
    
    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    [self.view presentScene:scene transition:reveal];
}

@end

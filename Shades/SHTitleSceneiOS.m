//
//  SHTitleSceneiOS.m
//  Shades
//
//  Created by Nigel Brady on 8/3/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHTitleSceneiOS.h"
#import "SHGameSceneiOS.h"

@implementation SHTitleSceneiOS

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Touch location: %.1f, %.1f", location.x, location.y);
        [self touchInLocation:location];
    }
}

-(void)playGame
{
    SKTransition *reveal = [SKTransition doorwayWithDuration:1.0];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SKScene * scene = [SHGameSceneiOS sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    [self.view presentScene:scene transition:reveal];
}

@end

//
//  SHGameSceneOSX.m
//  Shades
//
//  Created by Nigel Brady on 8/2/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import "SHGameSceneOSX.h"

@implementation SHGameSceneOSX

-(void)mouseDown:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
    CGPoint location = [theEvent locationInNode:self];
    NSLog(@"Touch location: %.1f, %.1f", location.x, location.y);
    
    SKNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if(node == self.restartLabel){
        [self restart];
    } else if(self.state == kGameOver){
        return;
    } else if(node == self.promptSquare){
        
    } else if(node == self.correctNode
                && self.state == kChoosingColor){
        NSLog(@"Correct square!");
        self.score++;
        [self nextRound];
    } else {
        NSLog(@"Wrong square!");
        self.state = kGameOver;
    }
}

@end

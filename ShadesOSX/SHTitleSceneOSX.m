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

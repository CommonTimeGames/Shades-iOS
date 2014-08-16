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

#import "SHGameCenterManager.h"
#import "SHInstructionSceneiOS.h"
#import "SHTitleSceneiOS.h"
#import "SHGameSceneiOS.h"

@interface SHTitleSceneiOS ()

@property (strong, nonatomic) SKLabelNode *gameCenterLabel;

@end
@implementation SHTitleSceneiOS

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSLog(@"Touch location: %.1f, %.1f", location.x, location.y);
        [self touchInLocation:location];
    }
}

-(void)touchInLocation:(CGPoint)location
{
    SKNode *node = [self nodeAtPoint:location];
    
    if(node == self.gameCenterLabel){
        NSLog(@"Launch Game Center!");
        [[SHGameCenterManager sharedInstance] showLeaderboard];
    } else {
        [super touchInLocation:location];
    }
}

-(void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.gameCenterLabel = [SKLabelNode node];
    self.gameCenterLabel.fontName = @"Avenir Next";
    self.gameCenterLabel.text = @"Game Center";
    self.gameCenterLabel.fontSize = 30;
    self.gameCenterLabel.position = CGPointMake(self.titleLabel.position.x,
                                                 self.subTitleLabel.position.y - 170);
    
    self.gameCenterLabel.fontColor = [SKColor whiteColor];
    self.gameCenterLabel.zPosition = 1;
    
    [self addChild:self.gameCenterLabel];
}

-(void)playGame
{
    [super playGame];
    
    SKTransition *reveal = [SKTransition doorwayWithDuration:1.0];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SHGameSceneiOS * scene = [SHGameSceneiOS sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeFill;
    scene.viewController = self.viewController;
    
    [self.view presentScene:scene transition:reveal];
}

-(void)instructions
{
    [super instructions];
    SKTransition *reveal = [SKTransition doorwayWithDuration:1.0];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    SHInstructionSceneiOS * scene =
        [SHInstructionSceneiOS sceneWithSize:skView.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeFill;
    scene.viewController = self.viewController;
    
    [self.view presentScene:scene transition:reveal];
}

@end

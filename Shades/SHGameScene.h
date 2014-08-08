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

#import <SpriteKit/SpriteKit.h>

typedef enum {
    kShowingColor,
    kChoosingColor,
    kChangingColors,
    kPaused,
    kGameOver
} GameState;


@interface SHGameScene : SKScene

@property (nonatomic) GameState state;

@property (nonatomic) int rowCount;
@property (nonatomic) int columnCount;

@property (strong, nonatomic) SKSpriteNode *twitterButton;
@property (strong, nonatomic) SKSpriteNode *facebookButton;
@property (strong, nonatomic) SKSpriteNode *gameCenterButton;

@property (strong, nonatomic) SKLabelNode *promptLabel;
@property (strong, nonatomic) SKLabelNode *timerLabel;
@property (strong, nonatomic) SKLabelNode *quitLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *restartLabel;

@property (strong, nonatomic) SKSpriteNode *promptSquare;

@property (nonatomic) CGRect boardFrame;
@property (nonatomic) NSMutableArray *squares;

@property (nonatomic) int rounds;
@property (nonatomic) int score;

@property (nonatomic) SKColor *currentColor;
@property (nonatomic) SKSpriteNode *correctNode;

+(SKColor *)randomColor;

-(void)restart;
-(void)nextRound;
-(void)quitGame;
-(void)updateNodePositionsAndChangeColor:(BOOL)changeColor;
-(void)userDidTouchLocation: (CGPoint)location;
-(void)tweet;
-(void)postToFacebook;
-(BOOL)shouldShowSocialIcons;

@end

//
//  SHMyScene.h
//  Shades
//

//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

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

@property (strong, nonatomic) SKLabelNode *promptLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *restartLabel;

@property (strong, nonatomic) SKSpriteNode *promptSquare;

@property (nonatomic) CGRect boardFrame;
@property (nonatomic) NSMutableArray *squares;

@property (nonatomic) int rounds;
@property (nonatomic) int score;

@property (nonatomic) SKColor *currentColor;
@property (nonatomic) SKNode *correctNode;

-(void)restart;
-(void)nextRound;

@end

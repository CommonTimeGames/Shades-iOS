//
//  SHTitleScene.h
//  Shades
//
//  Created by Nigel Brady on 8/2/14.
//  Copyright (c) 2014 Common Time Games. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SHTitleScene : SKScene

@property (strong, nonatomic) SKLabelNode *titleLabel;
@property (strong, nonatomic) SKLabelNode *subTitleLabel;
@property (strong, nonatomic) SKLabelNode *playLabel;
@property (strong, nonatomic) SKLabelNode *instructionLabel;

-(void)touchInLocation:(CGPoint) location;
-(void)playGame;
-(void)instructions;

@end

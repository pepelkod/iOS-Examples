//
//  SKSlider.m
//  Mold
//
//  Created by Douglas Pepelko on 2/28/14.
//  Copyright (c) 2014 Douglas Pepelko. All rights reserved.
//

#import "SKSlider.h"


@interface SKSlider()

@property (nonatomic) SKSpriteNode*		dotSpriteNode;
@property	 (nonatomic) SKSpriteNode*		slideSpriteNode;
@property (nonatomic) id							valueChangedTarget;
@property	(nonatomic) SEL						valueChangedAction;
@property (nonatomic) id							touchDownTarget;
@property	(nonatomic) SEL						touchDownAction;
@property (nonatomic) id							touchUpTarget;
@property	(nonatomic) SEL						touchUpAction;

@end

@implementation SKSlider


-(id)initWithSlideImageNamed:(NSString*)slideImageName andDotName:(NSString*)dotImageName{
	SKTexture*		slideTexture = [SKTexture textureWithImageNamed:slideImageName];
	SKTexture*		dotTexture = [SKTexture textureWithImageNamed:dotImageName];
	
	return [self initWithSlideTexture:slideTexture andDotTexture:dotTexture];
}
-(id)initWithSlideTexture:(SKTexture*)slideTexture andDotTexture:(SKTexture*)dotTexture{
	self = [super init];
	if(self != nil){
		self.slideSpriteNode = [[SKSpriteNode alloc]initWithTexture:slideTexture	];
		[self addChild:self.slideSpriteNode];
		
		self.dotSpriteNode = [[SKSpriteNode alloc]initWithTexture:dotTexture];
		self.dotSpriteNode.color = [SKColor lightGrayColor];
		self.dotSpriteNode.colorBlendFactor = 1.0;
		[self addChild:self.dotSpriteNode];
		
		[self setUserInteractionEnabled:YES];
		
	}
	return self;
}

- (void)addTargetForValueChanged:(id)target action:(SEL)action {
	self.valueChangedTarget = target;
	self.valueChangedAction = action;
}
- (void)addTargetForTouchDown:(id)target action:(SEL)action {
	self.touchDownTarget = target;
	self.touchDownAction = action;
}
- (void)addTargetForTouchUp:(id)target action:(SEL)action {
	self.touchUpTarget = target;
	self.touchUpAction = action;
}
// for setting position relative to corner
-(void)setCornerPosition:(CGPoint)cornerPos{
	CGPoint	 newCenterPos = CGPointMake(cornerPos.x + self.slideSpriteNode.size.width/2, cornerPos.y + self.slideSpriteNode.size.height/2);
	self.position = newCenterPos;
}
-(void)setDotAngle{
	CGFloat		angle = self.value * M_PI * 2;
	SKAction*	rotateAction = [SKAction rotateToAngle:angle duration:0.1];
	[self.dotSpriteNode runAction:rotateAction];
}
-(void)setDotPosition:(NSSet *)touches withEvent:(UIEvent *)event{
	CGFloat xpos;
	CGFloat touchXpos;
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInNode:self.parent];
	
	touchXpos = touchPoint.x - self.dotSpriteNode.size.width/2;
	
	if(touchXpos > self.slideSpriteNode.size.width){
		xpos = self.slideSpriteNode.size.width;
	}else if(touchXpos <= 0){
		xpos = 0;
	}else{
		xpos = touchXpos;
	}
	xpos -= self.slideSpriteNode.size.width/2;
	
	CGPoint pos = CGPointMake(xpos, self.dotSpriteNode.position.y);
	SKAction* moveToAction = [SKAction moveTo:pos duration:0.1];
	[self.dotSpriteNode runAction:moveToAction];
	// convert to a 0.0-1.0 value
	_value = [self calculateValueFromXpos:xpos];
	// make it rotate
	[self setDotAngle];
	// notify target
	[self callTarget:self.valueChangedTarget withAction:self.valueChangedAction];
}

-(void)callTarget:(id)target withAction:(SEL)action{
	if(target != nil){
		if(action != nil){
			if([target respondsToSelector:action]){
				IMP imp = [target methodForSelector:action];
				void (*func)(id, SEL, id) = (void *)imp;
				func(self.valueChangedTarget, self.valueChangedAction, self);
			}
		}
	}
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setDotPosition:touches withEvent:event	];
	[self callTarget:self.touchDownTarget withAction:self.touchDownAction];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setDotPosition:touches withEvent:event	];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self callTarget:self.touchUpTarget withAction:self.touchUpAction];
}

-(CGFloat)calculateValueFromXpos:(CGFloat)xpos{
	xpos += self.slideSpriteNode.size.width/2;
	CGFloat value = xpos/self.slideSpriteNode.size.width;
	return value;
}
-(void)setValue:(CGFloat)value{
	CGFloat		xpos;
	// range limit
	if(value < 0){
		value = 0;
	}else if(value > 1.0){
		value = 1.0;
	}
	_value = value;
	[self setDotAngle];
	
	// now move slider to match
	xpos = value * self.slideSpriteNode.size.width;
	xpos -= self.slideSpriteNode.size.width/2;

	CGPoint newpos = CGPointMake(xpos, self.dotSpriteNode.position.y);
	self.dotSpriteNode.position = newpos;

	// notify target
	[self callTarget:self.valueChangedTarget withAction:self.valueChangedAction];
}


@end

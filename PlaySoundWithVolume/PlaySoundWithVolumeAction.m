//
//  PlaySoundWithVolumeAction.m
//  Mold
//
//  Created by Douglas Pepelko on 2/28/14.
//  Copyright (c) 2014 Douglas Pepelko. All rights reserved.
//

#import "PlaySoundWithVolumeAction.h"

// ...

@interface PlaySoundWithVolumeAction()

@end
@implementation PlaySoundWithVolumeAction

+(SKAction*)playSoundFileNamed:(NSString*)fileName atVolume:(CGFloat)volume waitForCompletion:(BOOL)wait{
	// setup audio
	NSString*	nameOnly = [fileName stringByDeletingPathExtension];
	NSString*	extension = [fileName pathExtension];
	NSURL *soundPath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:nameOnly ofType:extension]];
	AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:soundPath error:NULL];
	[player setVolume:volume];
	[player prepareToPlay];

	SKAction*	playAction = [SKAction runBlock:^{
		[player play];
	}];
	if(wait == YES){
		SKAction*	waitAction = [SKAction waitForDuration:player.duration];
		SKAction* groupActions = [SKAction group:@[playAction, waitAction]];
	 	return groupActions;
	}
	return playAction;
}

@end

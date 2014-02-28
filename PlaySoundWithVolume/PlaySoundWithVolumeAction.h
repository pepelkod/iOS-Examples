//
//  PlaySoundWithVolumeAction.h
//  Mold
//
//  Created by Douglas Pepelko on 2/28/14.
//  Copyright (c) 2014 Douglas Pepelko. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface PlaySoundWithVolumeAction : SKAction  <AVAudioPlayerDelegate>

+(SKAction*)playSoundFileNamed:(NSString*)fileName atVolume:(CGFloat)volume waitForCompletion:(BOOL)wait;

@end

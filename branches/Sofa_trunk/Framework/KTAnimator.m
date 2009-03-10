//
//  BWAnimator.m
//  Photoshoot
//
//  Created by Cathy Shive on 7/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "KTAnimator.h"

@interface NSObject (KTAnimatorDelegate)
- (void)animatorIsUpdatingAnimation:(NSDictionary*)theAnimation;
- (void)animatorStarted;
- (void)animatorEnded;
@end


@interface KTAnimator (Private)
- (void)updateAnimation;
- (void)startTimer;
- (void)endTimer;
@end

@implementation KTAnimator
@synthesize animationType = mAnimationType;
@synthesize frameRate = mFrameRate;
@synthesize delegate = wDelegate;
- (id)init
{
	if(self = [super init])
	{
		mAnimationTimer = nil;	
		mAnimationQueue = [[NSMutableArray alloc] init];
		mFrameRate = 1.0/60;
	}
	return self;
}

- (void)dealloc
{
	if([mAnimationTimer isValid])
		[mAnimationTimer invalidate];
	[mAnimationTimer release];
	[mAnimationQueue release];
	wDelegate = nil;
	[super dealloc];
}

- (void)removeAllAnimations
{
	if([mAnimationTimer isValid])
		[mAnimationTimer invalidate];
	[mAnimationQueue removeAllObjects];
}

- (void)animateObject:(NSMutableDictionary*)theAnimationProperties
{
	NSNumber * aCurrentValue = [[theAnimationProperties valueForKey:@"object"] valueForKey:[theAnimationProperties valueForKey:@"keyPath"]];
	NSNumber * aStartValue = [theAnimationProperties valueForKey:@"startValue"];
	NSNumber * anEndValue = [theAnimationProperties valueForKey:@"endValue"];
	
	
	// animations can either be set with a duration or a speed
	// if the speed is set, we ignore a duration if it's set as well
	if([theAnimationProperties valueForKey:@"speed"]!=nil)
	{
		if([theAnimationProperties valueForKey:@"duration"]!=nil)
		{
			NSLog(@"%@ found a speed setting and a durration setting, removing the durations", self);
			[theAnimationProperties removeObjectForKey:@"duration"];
		}
	}
	
	if([theAnimationProperties valueForKey:@"duration"]!=nil)
	{
		// adjust the duration if it's necessary
		if([aCurrentValue floatValue] != [aStartValue floatValue])
		{
			float aDistance = [anEndValue floatValue] - [aStartValue floatValue];
			float aDiff = [aCurrentValue floatValue] - [aStartValue floatValue];
			float aPct = 0;
			if(aDistance!=0)
				aPct = aDiff/aDistance;
			float aDuration = [[theAnimationProperties valueForKey:@"duration"]floatValue];
			aDuration *= aPct;
			[theAnimationProperties setValue:[NSNumber numberWithFloat:aPct] forKey:@"duration"];
		}
	}
	
	// check to see if we're already animating this value for this object
	int anAnimationCount = [mAnimationQueue count];
	int i;
	id	anObjectToRemove = nil;
	for(i = 0; i < anAnimationCount; i++)
	{
		id	anObject = [theAnimationProperties valueForKey:@"object"];
		id	aCurrentObject = [[mAnimationQueue objectAtIndex:i] valueForKey:@"object"];
		if(aCurrentObject == anObject)
		{
			if([[theAnimationProperties valueForKey:@"keyPath"] isEqualToString:[[mAnimationQueue objectAtIndex:i] valueForKey:@"keyPath"]])
			{
				// we have the same object and the same keypath
				// remove the object in the queue, we don't care about this animation anymore
				anObjectToRemove = [mAnimationQueue objectAtIndex:i];
			}
		}
	}
	
	
	NSLog(@"#########################################################");
	if(anObjectToRemove!=nil)
	{
		NSLog(@"already animating this value for the same object: removing %d animation from queue", 1);
		[mAnimationQueue removeObject:anObjectToRemove];
	}
	
	// add object to queue
	NSLog(@"adding new animation to queue");
	[mAnimationQueue addObject:theAnimationProperties];
	
	// if this is the first object and the timer isn't already going, start the timer
	if(		[mAnimationQueue count] == 1 
		&&  ![mAnimationTimer isValid] )	  
	{
		[self startTimer];
	}
}


- (void)performUpdateAnimation:(NSTimer*)theTimer
{
	[self performSelectorOnMainThread:@selector(updateAnimation) withObject:nil waitUntilDone:NO];
//	[self updateAnimation];
}


- (void)updateAnimation
{
	NSMutableArray *	aListOfAnimationsToRemove = [[NSMutableArray alloc] init];
	NSLog(@"***************************************************************************************");
	// update animations in the queue
	int anAnimationCount = [mAnimationQueue count];
	int i;
	for(i = 0; i < anAnimationCount; i++)
	{
		NSDictionary *		anAnimationObject = [mAnimationQueue objectAtIndex:i];
		CGFloat				aCurrentValue = [[[anAnimationObject valueForKey:@"object"] valueForKey:[anAnimationObject valueForKey:@"keyPath"]]floatValue];
		CGFloat				anEndValue = [[anAnimationObject valueForKey:@"endValue"] floatValue];
		CGFloat				aStartValue = [[anAnimationObject valueForKey:@"startValue"] floatValue];
		CGFloat				aNewValue = 0;
		BOOL				anAnimationIsComplete = NO;
		
		// speed-based animation
		if([anAnimationObject valueForKey:@"speed"]!=nil)
		{
			// xeno's paradox
			//distance = endvalue - currentvalue;
			//currentvalue += distance/2
			CGFloat aDistanceToEnd = anEndValue - aCurrentValue;
			aNewValue = aCurrentValue + (aDistanceToEnd*.2);
			
			if(aCurrentValue==aNewValue)
				anAnimationIsComplete = YES;
				
			NSLog(@"-----------------------------------");
			NSLog(@"aDistanceToEnd: %f", aDistanceToEnd);
			NSLog(@"an end value: %f", anEndValue);
			NSLog(@"a current value: %f", aCurrentValue);
			NSLog(@"a new value: %f", aNewValue);
			NSLog(@"anAnimationIsComplete:%d", anAnimationIsComplete);
			NSLog(@"-----------------------------------");
		}
		
		// duration-based animation
		else if([anAnimationObject valueForKey:@"duration"]!=nil)
		{
			// if there's no start date, make one
			if([anAnimationObject valueForKey:@"startDate"]==nil)
			{
				NSDate * aDate = [NSDate date];
				[anAnimationObject setValue:aDate forKey:@"startDate"]; 
			}
			
			CGFloat aDuration = [[anAnimationObject valueForKey:@"duration"]floatValue];
			CFTimeInterval	anElapsedTime = [[anAnimationObject valueForKey:@"startDate"] timeIntervalSinceNow];
			switch(mAnimationType)
			{
				case kKTAnimationType_Linear:
					aNewValue = aStartValue + ((aStartValue - anEndValue) * (anElapsedTime / aDuration));
				break;
				default:
					NSLog(@"animator doesn't support duration-based animation types other than linear at the moment.");
				break;
			}
			
			if(aStartValue < anEndValue)
			{
				if(	aNewValue >= anEndValue)
				{
					aNewValue = anEndValue;
					anAnimationIsComplete = YES;
				}
			}
			else
			{
				if(	aNewValue <= anEndValue)
				{
					aNewValue = anEndValue;
					anAnimationIsComplete = YES;
				}
			}
		}
		else
		{
			NSLog(@"cannot update animation, there is no duration or speed set");
		}
		
		// set the value
		[[anAnimationObject valueForKey:@"object"] setValue:[NSNumber numberWithFloat:aNewValue] forKey:[anAnimationObject valueForKey:@"keyPath"]];
		// let delegate know we've updated
		if(wDelegate)
		{
			if([wDelegate respondsToSelector:@selector(animatorIsUpdatingAnimation:)])
				[wDelegate animatorIsUpdatingAnimation:anAnimationObject];
		}
		if(anAnimationIsComplete)
			[aListOfAnimationsToRemove addObject:anAnimationObject];
	}
	

	// remove any objects that need to be removed
	if([aListOfAnimationsToRemove count] > 0)
	{
		NSLog(@"removing %d animations from queue", [aListOfAnimationsToRemove count]);
		[mAnimationQueue removeObjectsInArray:aListOfAnimationsToRemove];
	}
	[aListOfAnimationsToRemove release];
	
	// if queue is empty, stop the timer
	if([mAnimationQueue count] == 0)
	{
		[self endTimer];
	}
}

- (void)startTimer
{
	// start the timer
	mAnimationTimer = [[NSTimer scheduledTimerWithTimeInterval:mFrameRate
										  target:self 
										  selector:@selector(performUpdateAnimation:)
										  userInfo:nil
										  repeats:YES] retain];

	[[NSRunLoop currentRunLoop] addTimer:mAnimationTimer forMode:NSDefaultRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:mAnimationTimer forMode:NSModalPanelRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer:mAnimationTimer forMode:NSEventTrackingRunLoopMode];
	
	if([wDelegate respondsToSelector:@selector(animatorStarted)])
		[wDelegate animatorStarted];
}

- (void)endTimer
{
	if([mAnimationTimer isValid])
	{
		[mAnimationTimer invalidate];
		[mAnimationTimer release];
		mAnimationTimer=nil;
	}
	
	if([wDelegate respondsToSelector:@selector(animatorEnded)])
		[wDelegate animatorEnded];
}

- (void)setFrameRate:(CGFloat)theFrameRate
{
	mFrameRate = theFrameRate;
	[self endTimer];
	[self startTimer];
}


- (void)setDelegate:(id)theDelegate
{
	wDelegate = theDelegate;
}


- (void)doubleDurationOfAllAnimations
{
	mDoubleDuration = YES;
}
@end

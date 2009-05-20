//
//  KTSplitViewDivider.m
//  KTUIKit
//
//  Created by Cathy on 30/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import "KTSplitViewDivider.h"
#import "KTSplitView.h"
#import "KTAnimator.h"
#import <Quartz/Quartz.h>

@interface NSObject (KTSplitViewDividerSplitView)
- (void)dividerAnimationDidEnd;

@end

@interface KTSplitViewDivider (Private)
- (void)_resetTrackingArea;
@end

@implementation KTSplitViewDivider
@synthesize splitView = wSplitView;
@synthesize isInDrag = mIsInDrag;

//=========================================================== 
// - initWithSplitView
//===========================================================
- (id)initWithSplitView:(KTSplitView*)theSplitView
{
	if(self = [self initWithFrame:NSZeroRect])
	{
		wSplitView = theSplitView;
	}
	return self;
}


//=========================================================== 
// - initWithFrame
//===========================================================
- (id)initWithFrame:(NSRect)theFrame
{
	if(self = [super initWithFrame:theFrame])
	{
		mAnimator = nil;
		[self _resetTrackingArea];

	}
	return self;
}

//=========================================================== 
// - dealloc
//===========================================================
- (void)dealloc
{
	[mAnimator release];
	[mTrackingArea release];
	[super dealloc];
}


//=========================================================== 
// - _resetTrackingArea
//===========================================================
- (void)_resetTrackingArea
{
	if(mTrackingArea)
	{
		[self removeTrackingArea:mTrackingArea];
		[mTrackingArea release];
	}
	NSRect aTrackingRect = [self frame];
	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
		if(aTrackingRect.size.height<3)
			aTrackingRect.size.height = 3;
	}
	else
	{
		if(aTrackingRect.size.width < 3)
			aTrackingRect.size.width = 3;
	}
	mTrackingArea = [[NSTrackingArea alloc] initWithRect:aTrackingRect
												options:(NSTrackingActiveInActiveApp | NSTrackingCursorUpdate | NSTrackingAssumeInside) 
												owner:self userInfo:nil];
	[self addTrackingArea:mTrackingArea];	
}

//=========================================================== 
// - animateDividerToPosition:time
//===========================================================
- (void)animateDividerToPosition:(float)thePosition time:(float)theTimeInSeconds
{		
	if(mAnimator == nil)
	{
		CGPoint aPositionToSet = NSPointToCGPoint([self frame].origin);
		if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			aPositionToSet.y = thePosition;
		else
			aPositionToSet.x = thePosition;
		NSRect aNewFrame = [self frame];
		aNewFrame.origin = NSPointFromCGPoint(aPositionToSet);
											
		NSArray * anAnimationArray = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self, NSViewAnimationTargetKey,
																										 [NSValue valueWithRect:[self frame]], NSViewAnimationStartFrameKey,
																										 [NSValue valueWithRect:aNewFrame], NSViewAnimationEndFrameKey, nil]];
		mAnimator = [[NSViewAnimation alloc] initWithViewAnimations:anAnimationArray];			
		[mAnimator setDelegate:self];																						
		[mAnimator setDuration: theTimeInSeconds];
		[mAnimator setAnimationCurve:NSAnimationEaseInOut];
		[mAnimator setAnimationBlockingMode: NSAnimationBlocking];
		[mAnimator startAnimation];
	}
}


//=========================================================== 
// - animatorEnded
//===========================================================
- (void)animatorEnded
{
	[[self splitView] resetResizeInformation];	
	[[self splitView] dividerAnimationDidEnd];
}

//=========================================================== 
// - animationDidEnd
//===========================================================
- (void)animationDidEnd:(NSAnimation *)theAnimation
{
	if(theAnimation == mAnimator)
	{
		[mAnimator release];
		mAnimator = nil;	
		[[self splitView] resetResizeInformation];	
		[[self splitView] dividerAnimationDidEnd];
	}
}

//=========================================================== 
// - setFrame:time
//===========================================================
- (void)setFrame:(NSRect)theFrame
{	
	//NSLog(@"%@ setFrame:", self);
	if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Vertical)
	{
		// clip min & max positions
		float aPositionToCheck = 0;//[self minPosition];
		
		if(		aPositionToCheck > 0
			&&	theFrame.origin.x <= aPositionToCheck)
		{
			theFrame.origin.x = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeRightCursor] set];
		}
		
		aPositionToCheck = 0;//[self maxPosition];
		if(		aPositionToCheck > 0
			&&	theFrame.origin.x >= aPositionToCheck)
		{
			theFrame.origin.x = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeLeftCursor] set];
		}
	}
	else if([[self splitView] dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
		float aPositionToCheck = 0;//[self minPosition];
		if(		aPositionToCheck > 0
			&&	theFrame.origin.y < aPositionToCheck)
		{
			theFrame.origin.y = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeUpCursor] set];
		}	
		
		aPositionToCheck = 0;//[self maxPosition];
		if(		aPositionToCheck > 0
			&&	theFrame.origin.y >= aPositionToCheck)
		{
			theFrame.origin.y = aPositionToCheck;
			if(mIsInDrag == YES)
				[[NSCursor resizeDownCursor] set];
		}
	}
	[self _resetTrackingArea];
	[super setFrame:theFrame];
	[[self splitView] layoutViews];
}




//=========================================================== 
// - mouseDown
//===========================================================
- (void)mouseDown:(NSEvent*)theEvent
{
	if([[self splitView] userInteractionEnabled] == NO)
		return;
}


//=========================================================== 
// - mouseDragged
//===========================================================
- (void)mouseDragged:(NSEvent*)theEvent
{
	if([[self splitView] userInteractionEnabled] == NO)
		return;
		
	NSPoint	aMousePoint = [[self splitView] convertPoint:[theEvent locationInWindow] fromView:nil];
	NSRect	aSplitViewBounds = [[self splitView] bounds];
	NSRect	aSplitViewFrame = [[self splitView] frame];
	NSRect	aDividerBounds = [self bounds];
	NSRect	aDividerFrame = [self frame];
	
	if([[self splitView] dividerOrientation]  == KTSplitViewDividerOrientation_Horizontal)
	{
		float aPoint = floor(aMousePoint.y - aDividerBounds.size.height*.5);
		
		if(		aPoint >= aSplitViewBounds.origin.x 
			&&	aPoint <= aSplitViewFrame.size.height-aDividerBounds.size.height )
		{
			
			[[NSCursor resizeUpDownCursor] set];
			NSRect aRect = aDividerFrame;
			[self setFrame:NSMakeRect(aRect.origin.x, aPoint,
									  aRect.size.width, aRect.size.height) ];
		}
	}
	else 
	{
		float aPoint = floor(aMousePoint.x-aDividerBounds.size.width*.5);
		if(aPoint >= aSplitViewBounds.origin.y && aPoint <= aSplitViewFrame.size.width-aDividerBounds.size.width)
		{
			[[NSCursor resizeLeftRightCursor] set];
			NSRect aRect = aDividerFrame;
			[self setFrame:NSMakeRect(aPoint, aRect.origin.y,
									  aRect.size.width, aRect.size.height) ];
			
		}
	}
	[[self splitView] layoutViews];
	mIsInDrag = YES;
}



//=========================================================== 
// - mouseUp
//===========================================================
- (void)mouseUp:(NSEvent*)theEvent
{
	NSLog(@"%@ mouseUP", self);
//	[[NSCursor arrowCursor] set];
	mIsInDrag = NO;
	[[self splitView] resetResizeInformation];
}

- (void)mouseEntered:(NSEvent*)theEvent
{
	NSLog(@"%@ mouseEntered", self);
}

- (void)mouseExited:(NSEvent*)theEvent
{
	NSLog(@"%@ mouseExited", self);
}

- (void)cursorUpdate:(NSEvent *)theEvent
{
	NSLog(@"%@ cursorUpdate", self);
	
}
@end

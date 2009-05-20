//
//  KTSplitView.m
//  KTUIKit
//
//  Created by Cathy on 30/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import "KTSplitView.h"
#import "KTSplitViewDivider.h"



@interface KTSplitView ()
@property (nonatomic, readwrite, retain) KTSplitViewDivider * divider;
@end

@interface KTSplitView (Private)
- (KTView*)firstView;
- (KTView*)secondView;
@end

@implementation KTSplitView
//=========================================================== 
// - synths
//===========================================================
@synthesize delegate = wDelegate;
@synthesize dividerOrientation = mDividerOrientation;
@synthesize resizeBehavior = mResizeBehavior;
@synthesize adjustable = mAdjustable;
@synthesize userInteractionEnabled = mUserInteractionEnabled;
@synthesize divider = mDivider;


//=========================================================== 
// - initWithFrame:dividerOrientation
//===========================================================
- (id)initWithFrame:(NSRect)theFrame dividerOrientation:(KTSplitViewDividerOrientation)theDividerOrientation
{
	if(self = [self initWithFrame:theFrame])
	{
		[self setDividerOrientation:theDividerOrientation];
	}
	return self;
}


//=========================================================== 
// - initWithFrame
//===========================================================
- (id)initWithFrame:(NSRect)theFrame
{
//	NSLog(@"Split View initWithFrame:%@", NSStringFromRect(theFrame));
	if(self = [super initWithFrame:theFrame])
	{
		mFirstView = [[KTView alloc] initWithFrame:NSZeroRect];
		[self addSubview:mFirstView];
		mSecondView = [[KTView alloc] initWithFrame:NSZeroRect];
		[self addSubview:mSecondView];
		mDivider = [[KTSplitViewDivider alloc] initWithSplitView:self];
		[self addSubview:mDivider];
		
		//	This flag won't change until the first time the split view has a width/height.
		//	If the position is set before the flag changes, we'll cache the value and apply it later.
		mCanSetDividerPosition = NO; 
		[self setUserInteractionEnabled:YES];
	}
	return self;
}


//=========================================================== 
// - initWithCoder:
//=========================================================== 
- (id)initWithCoder:(NSCoder*)theCoder
{
//	NSLog(@"Split View initWithCoder");
	
	if (![super initWithCoder:theCoder])
		return nil;
//	NSLog(@"subviews: %@", [self subviews]);
		
	mCanSetDividerPosition = NO; 
	mFirstView = [[theCoder decodeObjectForKey:@"firstView"] retain];
//	NSLog(@"mFirstView: %@", mFirstView);
	
	mSecondView = [[theCoder decodeObjectForKey:@"secondView"] retain];
//	NSLog(@"mSecondView: %@", mSecondView);
	
	mDivider = [[theCoder decodeObjectForKey:@"divider"] retain];
	[mDivider setSplitView:self];
//	NSLog(@"mDivider: %@", mDivider);
		
	[self setDividerOrientation:[[theCoder decodeObjectForKey:@"dividerOrienation"] intValue]];	
	[self setUserInteractionEnabled:[[theCoder decodeObjectForKey:@"userInteractionEnabled"] boolValue]];
	
			
	return self;
}

//=========================================================== 
// - encodeWithCoder:
//=========================================================== 
- (void)encodeWithCoder:(NSCoder*)theCoder
{	
	[super encodeWithCoder:theCoder];
	
	//[mFirstView removeFromSuperview];
	[theCoder encodeObject:mFirstView forKey:@"firstView"];
	//[self addSubview:mFirstView];
	
	//[mSecondView removeFromSuperview];
	[theCoder encodeObject:mSecondView forKey:@"secondView"];
	//[self addSubview:mSecondView];
	
	//[mDivider removeFromSuperview];
	[theCoder encodeObject:mDivider forKey:@"divider"];
	//[self addSubview:mDivider];

	[theCoder encodeObject:[NSNumber numberWithBool:[self userInteractionEnabled]] forKey:@"userInteractionEnabled"];
	[theCoder encodeObject:[NSNumber numberWithInt:[self dividerOrientation]] forKey:@"dividerOrientation"];
}



//=========================================================== 
// - dealloc
//===========================================================
- (void)dealloc
{
	[mFirstView release];
	[mSecondView release];
	[mDivider release];
	[super dealloc];
}




#pragma mark -
#pragma mark Resizing 
//=========================================================== 
// - setFrame
//===========================================================
- (void)setFrame:(NSRect)theFrame
{
//	NSLog(@"%@ setFrame", self);
	// when the split view's frame is set, we need to 
	// check the desired resizing behavior to determine where to position the divider
	// after the frame is set, we'll refresh our layout so that all the views are sized/positioned correctly

	// Save old dimensions first
	NSRect anOldViewFrame = [self frame];
	NSRect anOldDividerFrame = [[self divider] frame];
	
	// We need to have a width and height to do this
	if(		theFrame.size.width <= 0
		||	theFrame.size.height <= 0 
		||	anOldViewFrame.size.width <= 0
		||	anOldViewFrame.size.height <= 0)
	{
		[super setFrame:theFrame];
		return;
	}
	
	// if we've been waiting to set the divider position, do it now
	if(	mCanSetDividerPosition == NO )
	{
		mCanSetDividerPosition = YES;
		[self setDividerPosition:mDividerPositionToSet relativeToView:mPositionRelativeToViewFlag];
		anOldDividerFrame = [[self divider] frame];
	}
	

	// Now check the resize behavior and the orientation of the divider to set the divider's position within our new frame
	switch([self resizeBehavior])
	{
		case KTSplitViewResizeBehavior_MaintainProportions:
		{
			if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			{
				// if this is the first resize after the divider last moved, we need to cache the information
				// we need to calculate the position of the divider during a live resize
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = anOldDividerFrame.origin.y / anOldViewFrame.size.height;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(anOldDividerFrame.origin.x, floor(theFrame.size.height * mResizeInformation), theFrame.size.width, anOldDividerFrame.size.height)];
			}
			else
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = anOldDividerFrame.origin.x / anOldViewFrame.size.width;
					mResetResizeInformation = NO;
				}
				[[self divider]  setFrame:NSMakeRect(floor(theFrame.size.width * mResizeInformation), anOldDividerFrame.origin.y, anOldDividerFrame.size.width, theFrame.size.height)];
			}
		}
		break;
		
		case KTSplitViewResizeBehavior_MaintainFirstViewPosition:
		{
			if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self firstView] frame].size.height;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(anOldDividerFrame.origin.x, theFrame.size.height-mResizeInformation-anOldDividerFrame.size.height, theFrame.size.width, anOldDividerFrame.size.height)];
			}
			else
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self firstView] frame].origin.x+[[self firstView]  frame].size.width;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(mResizeInformation, anOldDividerFrame.origin.y, anOldDividerFrame.size.width, theFrame.size.height)];
			}
		}
		break;
		
		case KTSplitViewResizeBehavior_MaintainFirstViewSize:
		{
			if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self firstView] frame].size.height;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(anOldDividerFrame.origin.x, theFrame.size.height-mResizeInformation-anOldDividerFrame.size.height, theFrame.size.width, anOldDividerFrame.size.height)];
			}
			else
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self firstView] frame].origin.x+[[self firstView]  frame].size.width;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(mResizeInformation, anOldDividerFrame.origin.y, anOldDividerFrame.size.width, theFrame.size.height)];
			}
		}		
		break;
		
		case KTSplitViewResizeBehavior_MaintainSecondViewPosition:
			if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self secondView] frame].size.height;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(anOldDividerFrame.origin.x, mResizeInformation, theFrame.size.width, anOldDividerFrame.size.height)];
			}
			else
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self secondView] frame].size.width;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(theFrame.size.width-mResizeInformation-anOldDividerFrame.size.width, anOldDividerFrame.origin.y, anOldDividerFrame.size.width, theFrame.size.height)];
			}
		break;
		
		case KTSplitViewResizeBehavior_MaintainSecondViewSize:
			if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self secondView] frame].size.height;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(anOldDividerFrame.origin.x, mResizeInformation, theFrame.size.width, anOldDividerFrame.size.height)];
			}
			else
			{
				if(mResetResizeInformation == YES)
				{
					mResizeInformation = [[self secondView] frame].size.width;
					mResetResizeInformation = NO;
				}
				[[self divider] setFrame:NSMakeRect(theFrame.size.width-mResizeInformation-anOldDividerFrame.size.width, anOldDividerFrame.origin.y, anOldDividerFrame.size.width, theFrame.size.height)];
			}		
		
		break;
		
		default:
		break;
	}
	
	// Set our own frame
	[super setFrame:theFrame];	
	[self layoutViews];
}



//=========================================================== 
// - layoutViews
//===========================================================
- (void)layoutViews
{

//	NSLog(@"split view layout views");
	// this gets called by the divider whenever it's position changes
	NSRect aSplitViewBounds = [self bounds];
	NSRect aDividerFrame = [[self divider] frame];
	
	if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
				
		[[self firstView] setFrame:NSMakeRect( aSplitViewBounds.origin.x,
												aDividerFrame.origin.y + aDividerFrame.size.height,
												aSplitViewBounds.size.width,
												aSplitViewBounds.size.height - aDividerFrame.origin.y)];
		
		
		[[self secondView] setFrame:NSMakeRect( aSplitViewBounds.origin.x,
												aSplitViewBounds.origin.y,
												aSplitViewBounds.size.width,
												aDividerFrame.origin.y)];
	
	}
	else
	{
		CGFloat aHeight = aSplitViewBounds.size.height;
		CGFloat aWidth = aDividerFrame.origin.x;

		
		[[self firstView]  setFrame:NSMakeRect( aSplitViewBounds.origin.x,
												aSplitViewBounds.origin.y,
												aWidth,
												aHeight)];
										 
		[[self secondView] setFrame:NSMakeRect( aWidth+aDividerFrame.size.width,
												aSplitViewBounds.origin.y,
												aSplitViewBounds.size.width - NSMaxX(aDividerFrame),
												aSplitViewBounds.size.height)];
	}	
	[self setNeedsDisplay:YES];
}


//=========================================================== 
// - resetResizeInformation
//===========================================================
- (void)resetResizeInformation
{
	mResetResizeInformation = YES;
	mResizeInformation = 0;
}





#pragma mark -
#pragma mark Divider Position

/*
	The divider position must be set with a "focused view". 
	This allows users to specify a divider position relative to any side of the split view
	We'll take care of calculating what that position is really
*/
#pragma mark -
#pragma mark DEPRECATED
//=========================================================== 
// - setDividerPosition:fromView
//===========================================================
- (void)setDividerPosition:(float)thePosition fromView:(KTSplitViewFocusedViewFlag)theView
{
	if(mCanSetDividerPosition == NO) // we can't set the divider's position until the split view has a width & height
	{
		// save the position and the relative view so that we can set it 
		// when we are certain that the split view has dimensions
		mDividerPositionToSet = thePosition;
		mPositionRelativeToViewFlag = theView;
	}	
	else // we have a width & height, so we are free to update the divider's position
	{
		NSRect aDividerFrame = [[self divider] frame];
		if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
		{
			if(theView == KTSplitViewFocusedViewFlag_FirstView)
					thePosition = [self bounds].size.height - thePosition;
			
			[[self divider] setFrame:NSMakeRect(aDividerFrame.origin.x, thePosition, aDividerFrame.size.width, aDividerFrame.size.height)];
		}
		else
		{
			if(theView == KTSplitViewFocusedViewFlag_SecondView)
					thePosition = [self bounds].size.width - thePosition;
			[[self divider] setFrame:NSMakeRect(thePosition, aDividerFrame.origin.y, aDividerFrame.size.width, aDividerFrame.size.height)];
		}
	}
	[self resetResizeInformation];
	[self layoutViews];
}




//=========================================================== 
// - setDividerPosition:fromView:animate:time
//===========================================================
- (void)setDividerPosition:(float)thePosition fromView:(KTSplitViewFocusedViewFlag)theView animate:(BOOL)theBool time:(float)theTimeInSeconds
{
	if(theBool == NO)
		[self setDividerPosition:thePosition relativeToView:theView];
	else
	{
		if(mCanSetDividerPosition == NO) // we can't set the divider's position until the split view has a width & height
		{
			// save the position and the relative view so that we can set it 
			// when we are certain that the split view has dimensions
			mDividerPositionToSet = thePosition;
			mPositionRelativeToViewFlag = theView;
			[self resetResizeInformation];
		}
		else // we have a width & height, so we are free to update the divider's position
		{	
			if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			{
				if(theView == KTSplitViewFocusedViewFlag_FirstView)
					thePosition = [self bounds].size.height - thePosition;
					
				[[self divider] animateDividerToPosition:thePosition time:theTimeInSeconds];
			}
			else
			{
				if(theView == KTSplitViewFocusedViewFlag_SecondView)
					thePosition = [self bounds].size.width - thePosition;
				[[self divider]  animateDividerToPosition:thePosition time:theTimeInSeconds];
			}
		}
	}
	[self layoutViews];
}



//=========================================================== 
// - dividerPositionFromView
//===========================================================
- (float)dividerPositionFromView:(KTSplitViewFocusedViewFlag)theFocusedViewFlag
{
	float aDividerPosition = 0;
	
	if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
		if(theFocusedViewFlag == KTSplitViewFocusedViewFlag_FirstView)
			aDividerPosition = [self bounds].size.height - [[self divider]  frame].origin.y;
		else
			aDividerPosition = [[self divider] frame].origin.y;
	}
	else
	{
		if(theFocusedViewFlag == KTSplitViewFocusedViewFlag_FirstView)
			aDividerPosition = [[self divider]  frame].origin.x;
		else
			aDividerPosition = [self bounds].size.width - [[self divider]  frame].origin.x;
	}
	return aDividerPosition;
}

- (void)setAdjustable:(BOOL)theBool
{
	[self setUserInteractionEnabled:theBool];
}

- (BOOL)adjustable
{
	return [self userInteractionEnabled];
}

#pragma mark -

//=========================================================== 
// - setDividerPosition:relativeToView
//===========================================================
- (void)setDividerPosition:(CGFloat)thePosition relativeToView:(KTSplitViewFocusedViewFlag)theView
{
	if(mCanSetDividerPosition == NO) // we can't set the divider's position until the split view has a width & height
	{
		// save the position and the relative view so that we can set it 
		// when we are certain that the split view has dimensions
		mDividerPositionToSet = thePosition;
		mPositionRelativeToViewFlag = theView;
	}	
	else // we have a width & height, so we are free to update the divider's position
	{
		NSRect aDividerFrame = [[self divider] frame];
		if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
		{
			if(theView == KTSplitViewFocusedViewFlag_FirstView)
					thePosition = [self bounds].size.height - thePosition;
			
			[[self divider] setFrame:NSMakeRect(aDividerFrame.origin.x, thePosition, aDividerFrame.size.width, aDividerFrame.size.height)];
		}
		else
		{
			if(theView == KTSplitViewFocusedViewFlag_SecondView)
					thePosition = [self bounds].size.width - thePosition;
			[[self divider] setFrame:NSMakeRect(thePosition, aDividerFrame.origin.y, aDividerFrame.size.width, aDividerFrame.size.height)];
		}
	}
	[self resetResizeInformation];
	[self layoutViews];

}


//=============================================================== 
// - setDividerPosition:relativeToView:animate:animationDuration
//===============================================================
- (void)setDividerPosition:(CGFloat)thePosition relativeToView:(KTSplitViewFocusedViewFlag)theView animate:(BOOL)theBool animationDuration:(float)theTimeInSeconds;
{
	if(theBool == NO)
		[self setDividerPosition:thePosition relativeToView:theView];
	else
	{
		if(mCanSetDividerPosition == NO) // we can't set the divider's position until the split view has a width & height
		{
			// save the position and the relative view so that we can set it 
			// when we are certain that the split view has dimensions
			mDividerPositionToSet = thePosition;
			mPositionRelativeToViewFlag = theView;
			[self resetResizeInformation];
		}
		else // we have a width & height, so we are free to update the divider's position
		{	
			if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
			{
				if(theView == KTSplitViewFocusedViewFlag_FirstView)
					thePosition = [self bounds].size.height - thePosition;
					
				[[self divider] animateDividerToPosition:thePosition time:theTimeInSeconds];
			}
			else
			{
				if(theView == KTSplitViewFocusedViewFlag_SecondView)
					thePosition = [self bounds].size.width - thePosition;
				[[self divider]  animateDividerToPosition:thePosition time:theTimeInSeconds];
			}
		}
	}
	[self layoutViews];
}


//=============================================================== 
// - dividerPositionRelativeToView
//===============================================================
- (CGFloat)dividerPositionRelativeToView:(KTSplitViewFocusedViewFlag)theFocusedViewFlag
{
	float aDividerPosition = 0;
	
	if([self dividerOrientation] == KTSplitViewDividerOrientation_Horizontal)
	{
		if(theFocusedViewFlag == KTSplitViewFocusedViewFlag_FirstView)
			aDividerPosition = [self bounds].size.height - [[self divider]  frame].origin.y;
		else
			aDividerPosition = [[self divider] frame].origin.y;
	}
	else
	{
		if(theFocusedViewFlag == KTSplitViewFocusedViewFlag_FirstView)
			aDividerPosition = [[self divider]  frame].origin.x;
		else
			aDividerPosition = [self bounds].size.width - [[self divider]  frame].origin.x;
	}
	return aDividerPosition;	
}



//=========================================================== 
// - dividerAnimationDidEnd
//===========================================================
- (void)dividerAnimationDidEnd
{
	if([[self delegate] respondsToSelector:@selector(splitViewDivderAnimationDidEnd:)])
		[[self delegate] splitViewDivderAnimationDidEnd:self];
}



#pragma mark -
#pragma mark Building the SplitView

#pragma mark -
#pragma mark DEPRECATED
//=========================================================== 
// - addViewToFirstView
//===========================================================
- (void)addViewToFirstView:(NSView<KTView>*)theView
{
	[[self firstView] addSubview:theView];
}



//=========================================================== 
// - addViewToSecondView
//===========================================================
- (void)addViewToSecondView:(NSView<KTView>*)theView
{
	[[self secondView] addSubview:theView];
}

//=========================================================== 
// - addViewToFirstView:secondView:
//===========================================================
- (void)addViewToFirstView:(NSView<KTView>*)theFirstView secondView:(NSView<KTView>*)theSecondView
{
	[self setFirstView:theFirstView];
	[self setSecondView:theSecondView];
}
#pragma mark -




//=========================================================== 
// - setFirstView
//===========================================================
- (void)setFirstView:(NSView<KTView>*)theView
{
	[[self firstView] addSubview:theView];	
}

//=========================================================== 
// - setSecondView
//===========================================================
- (void)setSecondView:(NSView<KTView>*)theView
{
	[[self secondView] addSubview:theView];	
}

//=========================================================== 
// - setFirstView:secondView:
//===========================================================
- (void)setFirstView:(NSView<KTView>*)theFirstView secondView:(NSView<KTView>*)theSecondView
{
	[self setFirstView:theFirstView];
	[self setSecondView:theSecondView];
}

//=========================================================== 
// - firstView
//===========================================================
- (KTView*)firstView
{
	return mFirstView;
}

//=========================================================== 
// - secondView
//===========================================================
- (KTView*)secondView
{
	return mSecondView;
}

//=========================================================== 
// - setDivider:
//===========================================================
- (void)setDivider:(KTSplitViewDivider*)theDivider
{
	if(theDivider != mDivider)
	{
		[theDivider retain];
		[mDivider removeFromSuperview];
		[mDivider release];
		mDivider = theDivider;
		[self addSubview:mDivider];
	}
}



#pragma mark -
#pragma mark Configuring the Divider
//=========================================================== 
// - setDividerOrientation
//===========================================================
- (void)setDividerOrientation:(KTSplitViewDividerOrientation)theOrientation
{
//	NSLog(@"set divider orientation:%d", theOrientation);
	CGFloat aCurrentDividerThickness = [self dividerThickness];
	mDividerOrientation = theOrientation;
	if(mDividerOrientation==KTSplitViewDividerOrientation_Horizontal)
	{
		NSRect aFrame = NSMakeRect(0, [self frame].size.height*.5, [self frame].size.width, aCurrentDividerThickness);
		[[self divider] setFrame:aFrame];
		[self layoutViews];
	}
	else if(mDividerOrientation==KTSplitViewDividerOrientation_Vertical)
	{
		NSRect aFrame = NSMakeRect([self frame].size.width*.5, 0, aCurrentDividerThickness, [self frame].size.height);
		[[self divider] setFrame:aFrame];
		[self layoutViews];
	}
	[self setNeedsDisplay:YES];
}


//=========================================================== 
// - setDividerThickness
//===========================================================
- (void)setDividerThickness:(CGFloat)theThickness
{
	NSRect aDividerFrame = [mDivider frame];
	if(mDividerOrientation==KTSplitViewDividerOrientation_Horizontal)
		aDividerFrame.size.height = theThickness;
	else
		aDividerFrame.size.width = theThickness;
	[mDivider setFrame:aDividerFrame];	
	[self setNeedsDisplay:YES];
}



//=========================================================== 
// - dividerThickness
//===========================================================
- (CGFloat)dividerThickness
{
	CGFloat aThicknessToReturn = 0;
	if(mDividerOrientation==KTSplitViewDividerOrientation_Horizontal)
		aThicknessToReturn = [mDivider frame].size.height;
	else
		aThicknessToReturn = [mDivider frame].size.width;
	return aThicknessToReturn;
}

//=========================================================== 
// - setDividerFillColor
//===========================================================
- (void)setDividerFillColor:(NSColor*)theColor
{
	[[[self divider] styleManager] setBackgroundColor:theColor];
	[self setNeedsDisplay:YES];
}

//=========================================================== 
// - setDividerBackgroundGradient
//===========================================================
- (void)setDividerBackgroundGradient:(NSGradient*)theGradient
{
	[[[self divider] styleManager] setBackgroundGradient:theGradient angle:180];	
	[self setNeedsDisplay:YES];
}

//=========================================================== 
// - setDividerStrokeColor
//===========================================================
- (void)setDividerStrokeColor:(NSColor*)theColor
{
	KTStyleManager * aDividerStyleManager = [mDivider styleManager];
	if(mDividerOrientation == KTSplitViewDividerOrientation_Horizontal)
	{
		[aDividerStyleManager setBorderWidthTop:1 right:0 bottom:1 left:0];
		[aDividerStyleManager setBorderColorTop:theColor right:nil bottom:theColor left:nil];
	}
	else
	{
		[aDividerStyleManager setBorderWidthTop:0 right:1 bottom:0 left:1];
		[aDividerStyleManager setBorderColorTop:nil right:theColor bottom:nil left:theColor];	
	}
	[self setNeedsDisplay:YES];
}



//=========================================================== 
// - setDividerFirstStrokeColor
//===========================================================
- (void)setDividerFirstStrokeColor:(NSColor*)theFirstColor secondColor:(NSColor*)theSecondColor
{
	KTStyleManager * aDividerStyleManager = [mDivider styleManager];
	if(mDividerOrientation == KTSplitViewDividerOrientation_Horizontal)
	{
		[aDividerStyleManager setBorderWidthTop:1 right:0 bottom:1 left:0];
		[aDividerStyleManager setBorderColorTop:theFirstColor right:nil bottom:theSecondColor left:nil];
	}
	else
	{
		[aDividerStyleManager setBorderWidthTop:0 right:1 bottom:0 left:1];
		[aDividerStyleManager setBorderColorTop:nil right:theFirstColor bottom:nil left:theSecondColor];	
	}
	[self setNeedsDisplay:YES];
}
@end

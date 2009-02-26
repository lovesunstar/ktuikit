//
//  KTOpenGLLayer.m
//  KTUIKit
//
//  Created by Cathy on 19/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "KTOpenGLLayer.h"
#import <OpenGL/glu.h>
#import "KTLayoutManager.h"
#import "KTOpenGLView.h"

@implementation KTOpenGLLayer

@synthesize frame = mFrame;
@synthesize viewLayoutManager = mLayoutManager;
@synthesize sublayers = mSublayers;
@synthesize superlayer = mSuperlayer;
@synthesize view = wView;
//=========================================================== 
// - initWithFrame
//===========================================================
- (id)initWithFrame:(NSRect)theFrame
{
	if(self = [super init])
	{
		mFrame = theFrame;
		mSublayers = [[NSMutableArray alloc] init];
		mLayoutManager = [[KTLayoutManager alloc] initWithView:self];
		wView = nil;
	}
	return self;
}


//=========================================================== 
// - dealloc
//===========================================================
- (void)dealloc
{
	[mSublayers release];
	[mLayoutManager release];
	wView = nil;
	[super dealloc];
}

//=========================================================== 
// - addSublayer
//===========================================================
- (void)addSublayer:(KTOpenGLLayer*)theSublayer
{
	if(theSublayer)
	{
		// take care of the responder chain
		[theSublayer setNextResponder:self];
		// tell sublayer about its super layer
		[theSublayer setSuperlayer:self];
		// tell the sublayer about its view
		[theSublayer setView:[self view]];
		
		// add
		[mSublayers addObject:theSublayer];
	}
}


//=========================================================== 
// - removeSublayer
//===========================================================
- (void)removeSublayer:(KTOpenGLLayer*)theSublayer
{
	if(theSublayer)
		[mSublayers removeObject:theSublayer];
}


//=========================================================== 
// - drawLayers
//===========================================================
- (void)drawLayers
{
	// draw ourself
	[self draw];
	
	// draw sublayers
	for(KTOpenGLLayer * aSublayer in [self sublayers])
		[aSublayer drawLayers];
}


//=========================================================== 
// - draw
//===========================================================
- (void)draw
{
	
}

//=========================================================== 
// - setNeedsDisplay
//===========================================================
- (void)setNeedsDisplay:(BOOL)theBool
{
	[[self view] setNeedsDisplay:YES];
}


//=========================================================== 
// - setView
//===========================================================
- (void)setView:(KTOpenGLView*)theView
{
	wView = theView;
	[mSublayers makeObjectsPerformSelector:@selector(setView:) withObject:theView];
}


#pragma mark Events
//=========================================================== 
// - hitTest
//===========================================================
- (KTOpenGLLayer*)hitTest:(NSPoint)thePoint
{
	KTOpenGLLayer * aLayerToReturn = nil;
	
	for(KTOpenGLLayer * aSublayer in [self sublayers])
	{
		aLayerToReturn = [aSublayer hitTest:thePoint];
		if(aLayerToReturn)
			break;
	}
	
	if(aLayerToReturn == nil)
	{
		if(NSPointInRect(thePoint, [self frame]))
			aLayerToReturn = self;
	}
	return aLayerToReturn;
}






#pragma mark KTLayoutManager protocol
//=========================================================== 
// - setFrame
//===========================================================
- (void)setFrame:(NSRect)theFrame
{
	mFrame = theFrame;
	for(KTOpenGLLayer * aSublayer in [self sublayers])
		[[aSublayer viewLayoutManager] refreshLayout];
}

//=========================================================== 
// - frame
//===========================================================
- (NSRect)frame
{
	return mFrame;
}

//=========================================================== 
// - bounds
//===========================================================
- (NSRect)bounds
{
	return NSMakeRect(0, 0, mFrame.size.width, mFrame.size.height);
}

//=========================================================== 
// - parent
//===========================================================
- (id<KTViewLayout>)parent
{
	id<KTViewLayout> aParent = nil;
	if(mSuperlayer!=nil)
		aParent = mSuperlayer;
	else if(wView != nil)
		aParent = wView;
		
	return aParent;
}

//=========================================================== 
// - children
//===========================================================
- (NSArray*)children
{
	return mSublayers;
}


@end
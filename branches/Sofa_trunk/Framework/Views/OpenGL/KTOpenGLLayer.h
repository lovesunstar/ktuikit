//
//  KTOpenGLLayer.h
//  KTUIKit
//
//  Created by Cathy on 19/02/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTViewLayout.h"

@class KTOpenGLView;
@class KTLayoutManager;

@interface KTOpenGLLayer : NSResponder <KTViewLayout> 
{
	@private
		KTLayoutManager *		mLayoutManager;
		NSRect					mFrame;
		NSMutableArray *		mSublayers;
		KTOpenGLLayer *			mSuperlayer;
		KTOpenGLView *			mView;
}

@property (readwrite, assign) NSRect frame;
@property (readwrite, retain) KTLayoutManager * viewLayoutManager;
@property (readwrite, assign) KTOpenGLView * view;
@property (readwrite, assign) KTOpenGLLayer * superlayer;
@property (readwrite, retain) NSMutableArray * sublayers;

- (id)initWithFrame:(NSRect)theFrame;

- (void)addSublayer:(KTOpenGLLayer*)theSublayer;
- (void)removeSublayer:(KTOpenGLLayer*)theSublayer;

- (void)drawLayers;
- (void)draw;

- (KTOpenGLLayer*)hitTest:(NSPoint)thePoint;
- (void)setNeedsDisplay:(BOOL)theBool;
@end

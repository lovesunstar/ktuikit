//
//  KTSplitViewDivider.h
//  KTUIKit
//
//  Created by Cathy on 30/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTView.h"

@class KTSplitView;

@interface KTSplitViewDivider : KTView 
{
	KTSplitView *		wSplitView;
	BOOL				mIsInDrag;
	NSViewAnimation *	mAnimator;
	NSTrackingArea *	mTrackingArea;
}
@property (nonatomic, readwrite, assign) KTSplitView * splitView;
- (id)initWithSplitView:(KTSplitView*)theSplitView;
- (void)animateDividerToPosition:(float)thePosition time:(float)theTimeInSeconds;
@end

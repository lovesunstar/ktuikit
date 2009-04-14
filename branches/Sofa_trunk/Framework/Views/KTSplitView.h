//
//  KTSplitView.h
//  KTUIKit
//
//  Created by Cathy on 30/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KTView.h"


@class KTSplitView;

@protocol KTSplitView
- (void)layoutViews;
- (void)resetResizeInformation;
@end

@interface NSObject (KTSplitViewAdditions)
- (void)animationDidEndForSplitView:(KTSplitView*)theSplitView;
- (void)dividerPositionDidChangeForSplitView:(KTSplitView*)theSplitView;
@end

typedef enum
{
	KTSplitViewResizeBehavior_MaintainProportions = 0,
	KTSplitViewResizeBehavior_MaintainFirstViewPosition,
	KTSplitViewResizeBehavior_MaintainSecondViewPosition
	
}KTSplitViewResizeBehavior;

typedef enum
{	
	KTSplitViewDividerOrientation_NoSet = 0,
	KTSplitViewDividerOrientation_Horizontal,
	KTSplitViewDividerOrientation_Vertical
	
}KTSplitViewDividerOrientation;

typedef enum
{
	KTSplitViewFocusedViewFlag_FirstView = 0,
	KTSplitViewFocusedViewFlag_SecondView
	
}KTSplitViewFocusedViewFlag;

@class KTSplitViewDivider;

@interface KTSplitView : KTView <KTSplitView>
{
	@private
	id									wDelegate;
	
	KTSplitViewDivider *				mDivider;
	NSView<KTView>*						mFirstView;
	NSView<KTView>*						mSecondView;
	
	KTSplitViewDividerOrientation		mDividerOrientation;
	KTSplitViewResizeBehavior			mResizeBehavior;
	BOOL								mAdjustable;
	
	KTSplitViewFocusedViewFlag			mPositionRelativeToViewFlag;
	BOOL								mCanSetDividerPosition;
	CGFloat								mDividerPositionToSet;
	BOOL								mResetResizeInformation;
	CGFloat								mResizeInformation;
	
	
	
}

@property (readwrite, assign) id delegate;
@property (readwrite, assign) KTSplitViewDividerOrientation dividerOrientation;
@property (readwrite, assign) KTSplitViewResizeBehavior resizeBehavior;
@property (readwrite, assign) BOOL adjustable;
@property (readwrite, assign) CGFloat dividerThickness;

- (id)initWithFrame:(NSRect)theFrame dividerOrientation:(KTSplitViewDividerOrientation)theDividerOrientation;
- (void)addViewToFirstView:(NSView<KTView>*)theView;
- (void)addViewToSecondView:(NSView<KTView>*)theView;
- (void)addViewToFirstView:(NSView<KTView>*)theFirstView secondView:(NSView<KTView>*)theSecondView;
- (void)setDividerPosition:(float)thePosition fromView:(KTSplitViewFocusedViewFlag)theView;
- (void)setDividerPosition:(float)thePosition fromView:(KTSplitViewFocusedViewFlag)theView animate:(BOOL)theBool time:(float)theTimeInSeconds;
- (float)dividerPositionFromView:(KTSplitViewFocusedViewFlag)theFocusedViewFlag;
- (void)setDividerFillColor:(NSColor*)theColor;

@end

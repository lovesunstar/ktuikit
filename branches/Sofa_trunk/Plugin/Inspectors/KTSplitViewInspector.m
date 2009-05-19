//
//  KTSplitViewInspector.m
//  KTUIKit
//
//  Created by Cathy on 15/05/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import "KTSplitViewInspector.h"
#import <KTUIKit/KTUIKit.h>

@implementation KTSplitViewInspector

- (NSString *)viewNibName {
    return @"KTSplitViewInspector";
}

- (void)refresh 
{
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

- (IBAction)setOrientation:(id)theSender
{
	if([[self inspectedObjects] count] < 1)
		return;
	KTSplitView * aSplitView = [[self inspectedObjects] objectAtIndex:0];
	[aSplitView setDividerOrientation:[[theSender selectedItem] tag]];
}

- (IBAction)setDividerThickness:(id)theSender
{
	if([[self inspectedObjects] count] < 1)
		return;
		
	KTSplitView * aSplitView = [[self inspectedObjects] objectAtIndex:0];
	[aSplitView setDividerThickness:[theSender floatValue]];
}

- (IBAction)setDividerBackgroundColor:(id)theSender
{
	if([[self inspectedObjects] count] < 1)
		return;
		
	KTSplitView * aSplitView = [[self inspectedObjects] objectAtIndex:0];
	[aSplitView setDividerFillColor:[mBackgroundColorWell color]];
}

- (IBAction)setDividerFirstBorderColor:(id)theSender
{
	if([[self inspectedObjects] count] < 1)
		return;
		
	KTSplitView * aSplitView = [[self inspectedObjects] objectAtIndex:0];
	[aSplitView setDividerFirstStrokeColor:[mFirstStrokeColorWell color] secondColor:[mSecondStrokeColorWell color]];
}

- (IBAction)setDividerSecondBorderColor:(id)theSender
{
	if([[self inspectedObjects] count] < 1)
		return;
		
	KTSplitView * aSplitView = [[self inspectedObjects] objectAtIndex:0];
	[aSplitView setDividerFirstStrokeColor:[mFirstStrokeColorWell color] secondColor:[mSecondStrokeColorWell color]];
}

- (IBAction)setResizeBehavior:(id)theSender
{
	if([[self inspectedObjects] count] < 1)
		return;
		
	KTSplitView * aSplitView = [[self inspectedObjects] objectAtIndex:0];
	[aSplitView setResizeBehavior:[[theSender selectedItem] tag]];	
}

@end

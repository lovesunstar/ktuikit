//
//  KTLayoutManagerInspector.m
//  KTUIKit
//
//  Created by Cathy Shive on 5/25/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KTLayoutManagerInspector.h"
#import "KTLayoutManagerControl.h"
#import <KTUIKit/KTUIKit.h>

@implementation KTLayoutManagerInspector
- (void)awakeFromNib
{
	[[oRow1View styleManager] setBackgroundColor:[NSColor colorWithCalibratedWhite:.8 alpha:.7]];
	[[oRow1View styleManager] setBorderWidthTop:1 right:0 bottom:1 left:0];
	[[oRow1View styleManager] setBorderColorTop:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
	[[oRow1View styleManager] setBorderColorBottom:[NSColor colorWithCalibratedWhite:.5 alpha:1]];
}

- (NSString *)viewNibName 
{
    return @"KTLayoutManagerInspector";
}

+ (BOOL)supportsMultipleObjectInspection
{
	return YES;
}


- (void)refresh 
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	
	if([anInspectedObjectsList count] > 0)
	{
		id <KTViewLayout> aFirstView = [anInspectedObjectsList objectAtIndex:0];
		
		CGFloat	aFirstViewXPosition = [aFirstView frame].origin.x;
		CGFloat	aFirstViewYPosition = [aFirstView frame].origin.y;
		CGFloat aFirstViewWidth = [aFirstView frame].size.width;
		CGFloat aFirstViewHeight = [aFirstView frame].size.height;
		
		for(id<KTViewLayout> anInspectedView in anInspectedObjectsList)
		{
			NSRect aViewFrame = [anInspectedView frame];
			
			CGFloat	aViewXPosition = aViewFrame.origin.x;
			CGFloat	aViewYPosition = aViewFrame.origin.y;
			CGFloat aViewWidth = aViewFrame.size.width;
			CGFloat aViewHeight = aViewFrame.size.height;	
		
			if(aViewWidth == aFirstViewWidth)
			{
				[oWidth setIntValue:aViewFrame.size.width];
				if(aViewFrame.size.width <= 0)
					[oWidth setTextColor:[NSColor redColor]];
				else
					[oWidth setTextColor:[NSColor blackColor]];
			}
			else
			{
				[oWidth setStringValue:@"---"];
			}
			
			if(aViewHeight == aFirstViewHeight)
			{
				[oHeight setIntValue:aViewFrame.size.height];
				if(aViewFrame.size.height <= 0)
					[oHeight setTextColor:[NSColor redColor]];
				else
					[oHeight setTextColor:[NSColor blackColor]];
			}
			else
			{
				[oHeight setStringValue:@"---"];
			}	
			
			if(aViewXPosition == aFirstViewXPosition)
			{
				[oXPosition setIntValue:aViewFrame.origin.x];	
				if(		aViewFrame.origin.x < 0
					||	aViewFrame.origin.x > NSMaxX([[anInspectedView parent]frame]))
					[oXPosition setTextColor:[NSColor redColor]];
				else
					[oXPosition setTextColor:[NSColor blackColor]];
			}
			else
			{
				[oXPosition setStringValue:@"---"];
			}	
			
			if(aViewYPosition == aFirstViewYPosition)
			{
				[oYPosition setIntValue:aViewFrame.origin.y];
				if(		aViewFrame.origin.y < 0
					||	aViewFrame.origin.y > NSMaxY([[anInspectedView parent]frame]))
					[oYPosition setTextColor:[NSColor redColor]];
				else
					[oYPosition setTextColor:[NSColor blackColor]];	
			}
			else
			{
				[oYPosition setStringValue:@"---"];
			}		
			
		
						
			if(		[anInspectedView parent]!=nil
				&&	[[anInspectedView parent] isKindOfClass:[NSSplitView class]]==NO)
			{
				[oWidth setEnabled:YES];
				[oHeight setEnabled:YES];
				[oXPosition setEnabled:YES];
				[oYPosition setEnabled:YES];
				[oLayoutControl setIsEnabled:YES];
				[oFillWidthButton setEnabled:YES];
				[oFillHeightButton setEnabled:YES];
				[oCenterVerticallyButton setEnabled:YES];
				[oCenterHorizontallyButton setEnabled:YES];
				[oFlushTopButton setEnabled:YES];
				[oFlushRightButton setEnabled:YES];
				[oFlushBottomButton setEnabled:YES];
				[oFlushLeftButton setEnabled:YES];
			}
			else
			{
				[oWidth setEnabled:NO];
				[oHeight setEnabled:NO];
				[oXPosition setEnabled:NO];
				[oYPosition setEnabled:NO];
				[oLayoutControl setIsEnabled:NO];
				[oFillWidthButton setEnabled:NO];
				[oFillHeightButton setEnabled:NO];
				[oCenterVerticallyButton setEnabled:NO];
				[oCenterHorizontallyButton setEnabled:NO];
				[oFlushTopButton setEnabled:NO];
				[oFlushRightButton setEnabled:NO];
				[oFlushBottomButton setEnabled:NO];
				[oFlushLeftButton setEnabled:NO];
			}
		}
		[oLayoutControl refresh];
	}
	[super refresh];
}


#pragma mark -
#pragma mark KTView Configuration

- (IBAction)setXPosition:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.origin.x = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}
- (IBAction)setYPosition:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.origin.y = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}

- (IBAction)setWidth:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.size.width = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}

- (IBAction)setHeight:(id)theSender
{
	NSArray *	anInspectedObjectsList = [self inspectedObjects];
	int i;
	for(i = 0; i < [anInspectedObjectsList count]; i++)
	{
		id<KTViewLayout>	anInspectedView = [anInspectedObjectsList objectAtIndex:i];
		NSRect				aCurrentViewFrame = [anInspectedView frame];
		aCurrentViewFrame.size.height = [theSender floatValue];
		[anInspectedView setFrame:aCurrentViewFrame];
	}
}

- (IBAction)fillCurrentWidth:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aNewFrame = [anInspectedView frame];
		aNewFrame.origin.x = 0;
		aNewFrame.size.width = NSWidth([[anInspectedView parent]frame]);
		[anInspectedView setFrame:aNewFrame];
	}
}

- (IBAction)fillCurrentHeight:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aNewFrame = [anInspectedView frame];
		aNewFrame.origin.y = 0;
		aNewFrame.size.height = NSHeight([[anInspectedView parent]frame]);
		[anInspectedView setFrame:aNewFrame];
	}
}

- (IBAction)centerHorizontally:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aParentFrame = [[anInspectedView parent] frame];
		NSRect aViewFrame = [anInspectedView frame];
		
		aViewFrame.origin.x = NSMidX(aParentFrame) - NSWidth(aViewFrame)*.5;
		[anInspectedView setFrame:aViewFrame];
	}
	[self refresh];
}

- (IBAction)centerVertically:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aParentFrame = [[anInspectedView parent] frame];
		NSRect aViewFrame = [anInspectedView frame];
		
		aViewFrame.origin.y = NSMidY(aParentFrame) - NSHeight(aViewFrame)*.5;
		[anInspectedView setFrame:aViewFrame];
	}
	[self refresh];
}

- (IBAction)flushTop:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aParentFrame = [[anInspectedView parent] frame];
		NSRect aViewFrame = [anInspectedView frame];
		
		aViewFrame.origin.y = NSMaxY(aParentFrame) - NSHeight(aViewFrame);
		[anInspectedView setFrame:aViewFrame];
	}
	[self refresh];
}

- (IBAction)flushBottom:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aViewFrame = [anInspectedView frame];
		aViewFrame.origin.y = 0;
		[anInspectedView setFrame:aViewFrame];
	}
	[self refresh];
}

- (IBAction)flushLeft:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aViewFrame = [anInspectedView frame];
		aViewFrame.origin.x = 0;
		[anInspectedView setFrame:aViewFrame];
	}
	[self refresh];
}

- (IBAction)flushRight:(id)theSender
{
	for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
	{
		NSRect aParentFrame = [[anInspectedView parent] frame];
		NSRect aViewFrame = [anInspectedView frame];
		
		aViewFrame.origin.x = NSMaxX(aParentFrame) - NSWidth(aViewFrame);
		[anInspectedView setFrame:aViewFrame];
	}
	[self refresh];
}

- (BOOL)control:(NSControl *)theControl textView:(NSTextView *)theTextView  doCommandBySelector:(SEL)theCommandSelector
{
	if(theCommandSelector==@selector(moveUp:))
	{
		for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
		{
			NSRect aCurrentViewFrame = [anInspectedView frame];
			if(theControl==oXPosition)
				aCurrentViewFrame.origin.x++;
			else if(theControl==oYPosition)
				aCurrentViewFrame.origin.y++;
			else if(theControl==oWidth)
				aCurrentViewFrame.size.width++;
			else if(theControl==oHeight)
				aCurrentViewFrame.size.height++;
			[anInspectedView setFrame:aCurrentViewFrame];
		}
		return YES;
	}
	else if(theCommandSelector==@selector(moveDown:))
	{
		for(id<KTViewLayout> anInspectedView in [self inspectedObjects])
		{
			NSRect aCurrentViewFrame = [anInspectedView frame];
			if(theControl==oXPosition)
				aCurrentViewFrame.origin.x--;
			else if(theControl==oYPosition)
				aCurrentViewFrame.origin.y--;
			else if(theControl==oWidth)
				aCurrentViewFrame.size.width--;
			else if(theControl==oHeight)
				aCurrentViewFrame.size.height--;
			[anInspectedView setFrame:aCurrentViewFrame];
		}
		return YES;
	}
	else
		return NO;
}


- (NSArray*)inspectedViews
{
	return [self inspectedObjects];
}

@end

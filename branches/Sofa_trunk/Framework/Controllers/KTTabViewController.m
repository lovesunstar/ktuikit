//
//  KTTabViewController.m
//  KTUIKit
//
//  Created by Cathy on 18/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import "KTTabViewController.h"
#import "KTTabItem.h"
#import "KTView.h"

@interface NSObject (KTTabViewControllerDelegate)
- (void)tabViewController:(KTTabViewController*)theTabViewController didSelectTabItem:(KTTabItem*)theTabItem;
@end

@implementation KTTabViewController


@synthesize delegate = wDelegate;
@synthesize selectedTabIndex = mSelectedTabIndex;
@synthesize tabItemArrayController = mTabItemArrayController;

//=========================================================== 
// - initWithNibName:bundle:windowController
//===========================================================
- (id)initWithNibName:(NSString*)theNibName bundle:(NSBundle*)theBundle windowController:(KTWindowController*)theWindowController
{
	if(self = [super initWithNibName:theNibName bundle:theBundle windowController:theWindowController])
	{
		// create the 'content view' - when we switch tabs
		// we'll be adding/removing views to and from this 'content' view
		wContentView = [[[KTView alloc] initWithFrame:NSZeroRect] autorelease];
		[[wContentView viewLayoutManager] setWidthType:KTSizeFill];
		[[wContentView viewLayoutManager] setHeightType:KTSizeFill];
		[self setView:wContentView];
		
		mTabItemArrayController = [[NSArrayController alloc] init];
		[mTabItemArrayController addObserver:self forKeyPath:@"selectionIndex"options:0 context:nil];
	}
	return self;
}

//=========================================================== 
// - dealloc
//===========================================================
- (void)dealloc
{
	[mTabItemArrayController release];
	[super dealloc];
}

//=========================================================== 
// - removeObservations
//===========================================================
- (void)removeObservations
{
	[mTabItemArrayController removeObserver:self forKeyPath:@"selectionIndex"];
	[super removeObservations];
}

//=========================================================== 
// - observeValueForKeyPath
//===========================================================
- (void)observeValueForKeyPath:(NSString *)theKeyPath ofObject:(id)theObject change:(NSDictionary *)theChange context:(void *)theContext
{
	if(theObject == mTabItemArrayController)
	{
		if([theKeyPath isEqualToString:@"selectionIndex"])
		{
			NSInteger aSelectedIndex = [mTabItemArrayController selectionIndex];
			NSLog(@"%@ tab items selected index:%d", self, aSelectedIndex);
			if(aSelectedIndex!=NSNotFound)
				[self selectTabAtIndex:aSelectedIndex];
		}
	}
}

#pragma mark -
#pragma mark Managing Tabs
//=========================================================== 
// - addTabItem
//===========================================================
- (void)addTabItem:(KTTabItem*)theTabItem
{
	[self addSubcontroller:[theTabItem viewController]];
	[mTabItemArrayController addObject:theTabItem];
	[theTabItem setTabViewController:self];
}


//=========================================================== 
// - removeTabItem
//===========================================================
- (void)removeTabItem:(KTTabItem*)theTabItem
{
	NSInteger	anIndexOfTabItemToRemove = [[mTabItemArrayController arrangedObjects] indexOfObject:theTabItem];
	KTTabItem * aNewTabToSelect = nil;
	
	if(anIndexOfTabItemToRemove!=NSNotFound)
	{
		NSInteger aTabItemCount = [[mTabItemArrayController arrangedObjects] count];
		// if the tab we're going to remove is selected and it is *not* the last item in the 
		// tab array controller, we need to manually select a new tab - NSArrayController already handles the 
		// case where the item that is removed is the last item and it's selected
		if(		anIndexOfTabItemToRemove!=aTabItemCount-1
			&&	[self selectedTabIndex]!=anIndexOfTabItemToRemove)
		{
			NSInteger aNewSelectionIndex = anIndexOfTabItemToRemove+1;
			// get the tab at this index, after we change the content of the array, we want to select this
			// object at its new index
			aNewTabToSelect = [[mTabItemArrayController arrangedObjects] objectAtIndex:aNewSelectionIndex];
		}
		
		[self removeSubcontroller:[theTabItem viewController]];
		[theTabItem setTabViewController:nil];
		[mTabItemArrayController removeObject:theTabItem];
		if(aNewTabToSelect!=nil)
		{
//			[mTabItemArrayController willChangeValueForKey:@"selectionIndex"];
//			[mTabItemArrayController willChangeValueForKey:@"selectionIndexes"];
			[mTabItemArrayController setSelectionIndex:[[mTabItemArrayController arrangedObjects] indexOfObject:aNewTabToSelect]];
//			[mTabItemArrayController setSelectedObjects:[NSArray arrayWithObject:aNewTabToSelect]];
//			[mTabItemArrayController didChangeValueForKey:@"selectionIndex"];
//			[mTabItemArrayController didChangeValueForKey:@"selectionIndexes"];
		}
	}
}

//=========================================================== 
// - insertTabItem
//===========================================================
- (void)insertTabItem:(KTTabItem*)theTabItem atIndex:(NSInteger)theIndex
{
	[self addSubcontroller:[theTabItem viewController]];
	[theTabItem setTabViewController:self];
	[mTabItemArrayController insertObject:theTabItem atArrangedObjectIndex:theIndex];
}



//=========================================================== 
// - addTabAtIndex:forViewController
//===========================================================
- (void)addTabAtIndex:(NSInteger)theTabIndex forViewController:(KTViewController*)theViewController
{
//	[self insertSubcontroller:theViewController atIndex:theTabIndex];
}

//=========================================================== 
// - removeTabAtIndex
//===========================================================
- (void)removeTabAtIndex:(NSInteger)theTabIndex
{
//	if(		theTabIndex < [[self subcontrollers] count]
//		&&	theTabIndex >= 0)
//	{
//		KTViewController * aViewController = [[self subcontrollers] objectAtIndex:theTabIndex];
//		[self removeTabForViewController:aViewController];
//	}
}

//=========================================================== 
// - addTabForViewController
//===========================================================
- (void)addTabForViewController:(KTViewController*)theViewController
{
//	[self addSubcontroller:theViewController];
}

//=========================================================== 
// - removeTabForViewController
//===========================================================
- (void)removeTabForViewController:(KTViewController*)theViewController
{	
//	// if this is the current selected controller, we need to select the controller before it
//	NSInteger anIndexOfViewController = [[self subcontrollers] indexOfObject:theViewController];
//	if(anIndexOfViewController == [self selectedTabIndex])
//	{
//		if(anIndexOfViewController > 0)
//			[self selectTabAtIndex:anIndexOfViewController-1];
//		else if(anIndexOfViewController < [self numberOfTabs]-1)
//			[self selectTabAtIndex:anIndexOfViewController+1];
//		else
//			[[theViewController view] removeFromSuperview];
//	}
//	[self removeSubcontroller:theViewController];
}


//=========================================================== 
// - numberOfTabs
//===========================================================
- (NSInteger)numberOfTabs
{
	return 0;//[[self subcontrollers] count];
}


//=========================================================== 
// - viewControllers
//===========================================================
- (NSArray*)viewControllers
{
	return nil;//[self subcontrollers];
}

//=========================================================== 
// - tabs
//===========================================================
- (NSArray*)tabItems
{
	return [mTabItemArrayController arrangedObjects];
}



#pragma mark -
#pragma mark Selection

- (KTTabItem*)selectedTabItem
{
	return [[mTabItemArrayController selectedObjects]lastObject];
}

//=========================================================== 
// - selectTab
//===========================================================
- (IBAction)selectTab:(id)theSender
{
	if([theSender respondsToSelector:@selector(tag)])
	{	
		NSInteger aSelectedTag = [theSender tag];
		if(		aSelectedTag >= 0
			&&	aSelectedTag < [self numberOfTabs])
			[self selectTabAtIndex:aSelectedTag];
		else
			NSLog(@"[%@] error: cannot select tab for tag:%d - out of bounds", self, aSelectedTag);
	}
	else
	{
		NSLog(@"[%@] error: cannot select tab for sender without tag property", self);
	}
}

//=========================================================== 
// - selectTabAtIndex
//===========================================================
- (void)selectTabAtIndex:(NSInteger)theTabIndex
{
	KTViewController * aViewControllerToSelect = [[self subcontrollers] objectAtIndex:theTabIndex];
	[self selectTabForViewController:aViewControllerToSelect];
}


//=========================================================== 
// - selectTabForViewController
//===========================================================
- (void)selectTabForViewController:(KTViewController*)theViewController
{
	if([[self subcontrollers] containsObject:theViewController])
	{
		id aViewForTab = [theViewController view];
		[wContentView setSubviews:[NSArray array]];
		[wContentView addSubview:aViewForTab];	
		[[aViewForTab viewLayoutManager] setWidthType:KTSizeFill];
		[[aViewForTab viewLayoutManager] setHeightType:KTSizeFill];
		[[wContentView viewLayoutManager] refreshLayout];	
		if([wDelegate respondsToSelector:@selector(tabViewController:didSelectTabItem:)])
			[wDelegate tabViewController:self didSelectTabItem:[self selectedTabItem]];
	}
}










@end

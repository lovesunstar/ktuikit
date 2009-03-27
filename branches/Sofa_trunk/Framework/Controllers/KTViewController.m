//
//  KTViewController.m
//  View Controllers
//
//  Created by Jonathan Dann and Cathy Shive on 14/04/2008.
//
// Copyright (c) 2008 Jonathan Dann and Cathy Shive
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// If you use it, acknowledgement in an About Page or other appropriate place would be nice.
// For example, "Contains "View Controllers" by Jonathan Dann and Cathy Shive" will do.


/*
	(Cathy 11/10/08) NOTE:
	I've made the following changes that need to be documented:
	• When a child is removed, its view is removed from its superview and it is sent a "removeObservations" message
	• Added 'removeChild:(KTViewController*)theChild' method to remove specific subcontrollers
	• Added 'loadNibNamed' and 'releaseNibObjects' to support loading more than one nib per view controller.  These take care
	of releasing the top level nib objects for those nib files. Users have to unbind any bindings in those nibs in the view
	controller's removeObservations method.
	• Added class method, 'viewControllerWithWindowController'
	• I'm considering overriding 'view' and 'setView:' so that the view controller only deals with KTViews.
*/

/* (Jon 6/12/08) NOTE:
	• Udpated -dealloc to release the ivars themselves rather than calling the accessors. This should always be done incase the get accessor returns an autoreleased copy of the ivar. For example a class that stores stuff internally in a mutable array but returns an (immutable) autoreleased copy of said array. In -dealloc if one calls [self.array release], in this case the returned object would be overreleased and the ivar itself would leak.
	• Changed the (private) setChildren method to update the responder chain and declared the writability of the property in a class continuation.
*/ 

#import "KTViewController.h"
#import "KTWindowController.h"
#import "KTLayerController.h"

#pragma mark Private API

@interface KTViewController ()
@property(readwrite,copy) NSMutableArray *subcontrollers;

@end

@interface KTViewController (Private)
- (void)setSubcontrollers:(NSMutableArray *)newChildren;
- (void)releaseNibObjects;
- (KTViewController*)parent;
- (void)setParent:(KTViewController*)theParent;

@end

@implementation KTViewController (Private)

- (void)setSubcontrollers:(NSMutableArray *)newChildren;
{
	if (_subcontrollers == newChildren)
		return;
	NSMutableArray *newChildrenCopy = [newChildren mutableCopy];
	[_subcontrollers release];
	_subcontrollers = newChildrenCopy;
	[self.windowController patchResponderChain];
}

- (void)releaseNibObjects
{
	int i;
	for( i = 0; i < [_topLevelNibObjects count]; i++)
	{
		[[_topLevelNibObjects objectAtIndex:i] release];
	}
	[_topLevelNibObjects release];
}


- (KTViewController*)parent
{
	return _parent;
}


- (void)setParent:(KTViewController*)theParent
{
	_parent = theParent;
}


@end
 
#pragma mark -
#pragma mark Public API

@implementation KTViewController
+ (id)viewControllerWithWindowController:(KTWindowController*)theWindowController
{
	return [[[self alloc] initWithNibName:nil bundle:nil windowController:theWindowController] autorelease];
}

#pragma mark Accessors

//@synthesize parent = _parent;
@synthesize windowController = _windowController;
@synthesize subcontrollers = _subcontrollers;

@dynamic rootController;
@dynamic descendants;

#pragma mark Designated Initialiser

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle windowController:(KTWindowController *)windowController;
{
	if (![super initWithNibName:name bundle:bundle])
		return nil;
	self.windowController = windowController; // non-retained to avoid retain cycles
	self.subcontrollers = [NSMutableArray array]; // set up a blank mutable array
	_topLevelNibObjects = [[NSMutableArray alloc] init];
	mLayerControllers = [[NSMutableArray alloc] init];
	return self;
}

// ---------------------------------
// This is the NSViewController's designated initialiser, which we override to call our own. Any subclasses that call this will then set up our intance variables properly.
// ---------------------------------
- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle;
{
	[NSException raise:@"KTViewControllerException" format:[NSString stringWithFormat:@"An instance of an KTViewController concrete subclass was initialized using the NSViewController method -initWithNibName:bundle: all view controllers in the enusing tree will have no reference to an KTWindowController object and cannot be automatically added to the responder chain"]];
	return nil;
}

- (void)dealloc;
{
	//NSLog(@"%@ dealloc", self);
	[self releaseNibObjects];
	[_subcontrollers release];
	[mLayerControllers release];
	[super dealloc];
}

- (void)setWindowController:(KTWindowController*)theWindowController
{
	_windowController = theWindowController;
	[[self subcontrollers] makeObjectsPerformSelector:@selector(setWindowController:) withObject:theWindowController];
	[[self windowController] patchResponderChain];
}



//#pragma mark -
//#pragma mark View
//- (NSView<KTView>*)view
//{
//	return (NSView<KTView>*)[super view];
//}
//
//- (void)setView:(NSView<KTView>*)theView
//{
//	[super setView:theView];
//}


#pragma mark Subcontrollers

- (NSUInteger)countOfSubcontrollers;
{
	return [self.subcontrollers count];
}

- (KTViewController *)subcontrollerAtIndex:(NSUInteger)index;
{
	return [self.subcontrollers objectAtIndex:index];
}


- (void)addSubcontroller:(KTViewController *)viewController;
{
	[self insertSubcontroller:viewController atIndex:[self.subcontrollers count]];
}

- (void)removeSubcontroller:(KTViewController *)viewController;
{
	[viewController removeObservations];
	[self.subcontrollers removeObject:viewController];
	[self.windowController patchResponderChain];
}

- (void)removeSubcontrollerAtIndex:(NSUInteger)index;
{
	KTViewController *	aChildToRemove = [self.subcontrollers objectAtIndex:index];
	[aChildToRemove removeObservations];
	[self.subcontrollers removeObjectAtIndex:index];
	[self.windowController patchResponderChain]; // each time a controller is removed then the repsonder chain needs fixing
}

- (void)insertSubcontroller:(KTViewController *)viewController atIndex:(NSUInteger)index;
{
	[self.subcontrollers insertObject:viewController atIndex:index];
	[viewController setParent:self];
	[self.windowController patchResponderChain];
}

- (void)insertSubcontrollers:(NSArray *)viewControllers atIndexes:(NSIndexSet *)indexes;
{
	[self.subcontrollers insertObjects:viewControllers atIndexes:indexes];
	[viewControllers makeObjectsPerformSelector:@selector(setParent:) withObject:self];
	[self.windowController patchResponderChain]; 
}

- (void)insertSubcontrollers:(NSArray *)viewControllers atIndex:(NSUInteger)index;
{
	[self insertSubcontrollers:viewControllers atIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)removeAllSubcontrollers
{
	[self setSubcontrollers:[NSArray array]];
	[[self windowController] patchResponderChain];
}


- (void)addLayerController:(KTLayerController*)theLayerController
{
	[mLayerControllers addObject:theLayerController];
	[[self windowController] patchResponderChain];
}

- (void)removeLayerController:(KTLayerController*)theLayerController
{
	[mLayerControllers removeObject:theLayerController];
	[[self windowController] patchResponderChain];
}

- (NSArray*)layerControllers
{
	return mLayerControllers;
}

# pragma mark Utilities
// ------------------------------------------
// This method is not used in the example but does demonstrates an important point of our setup: the root controller in the tree should have parent = nil.  If you'd rather set the parent of the root node to the window controller, this method must be modified to check the class of the parent object.
// ------------------------------------------
- (KTViewController *)rootController;
{
	KTViewController *root = self.parent;
	if (!root) // we are the top of the tree
		return self;
	while (root.parent) // if this is nil then there is no parent, the whole system is based on the idea that the top of the tree has nil parent, not the windowController as its parent.
		root = root.parent;
	return root;
}

// ---------------------------------------
// A top-down tree sorting method.  Recursively calls itself to build up an array of all the nodes in the tree. If one thinks of a file and folder setup, then this would add all the contents of a folder to the array (ad infinitum) to the array before moving on to the next folder at the same level
// ----------------------------------------
- (NSArray *)descendants;
{
	NSMutableArray *array = [NSMutableArray array];
	for (KTViewController *child in self.subcontrollers) {
		[array addObject:child];
		if ([child countOfSubcontrollers] > 0)
			[array addObjectsFromArray:[child descendants]];
	}
	for(KTLayerController * aLayerController in mLayerControllers)
	{
		[array addObject:aLayerController];
		if([[aLayerController subcontrollers] count] > 0)
			[array addObjectsFromArray:[aLayerController descendants]];
	}
	return [[array copy] autorelease]; // return an immutable array
}


#pragma mark -
#pragma mark KVO/Bindings

// --------------------------------------
// Any manual KVO or bindings that you have set up (other than to the representedObject) should be removed in this method.  It is called by the window controller on in the -windowWillClose: method.  After this the window controller can safely call -dealloc without any warnings that it is being deallocated while observers are still registered.
// --------------------------------------
- (void)removeObservations
{
	// subcontrollers
	[self.subcontrollers makeObjectsPerformSelector:@selector(removeObservations)];
	// layer controllers
	[mLayerControllers makeObjectsPerformSelector:@selector(removeObservations)];
}

// --------------------------------------
// Load any extra nib files (not loaded through the initializer) using this method.  It will add the nib's objects to a list and they will be released during dealloc
// --------------------------------------
- (BOOL)loadNibNamed:(NSString*)theNibName bundle:(NSBundle*)theBundle
{
	BOOL		aSuccess;
	NSArray *	anObjectList = nil;
	NSNib *		aNib = [[[NSNib alloc] initWithNibNamed:theNibName bundle:theBundle] autorelease];
	aSuccess = [aNib instantiateNibWithOwner:self topLevelObjects:&anObjectList];
	if(aSuccess)
	{
		int i;
		for(i = 0; i < [anObjectList count]; i++)
			[_topLevelNibObjects addObject:[anObjectList objectAtIndex:i]];
	}
	return aSuccess;
}

@end

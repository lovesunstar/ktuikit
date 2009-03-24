//
//  KTTabItem.m
//  KTUIKit
//
//  Created by Cathy on 18/03/2009.
//  Copyright 2009 Sofa. All rights reserved.
//

#import "KTTabItem.h"


@implementation KTTabItem
@synthesize label = mLabel;
@synthesize identifier = mIdentifier;
@synthesize tabViewController = wTabViewController;
@synthesize viewController = mViewController;
@synthesize representedObjectForViewController = mRepresentedObjectForViewController;

- (void)dealloc
{
	[mLabel release];
	[mIdentifier release];
	[mViewController release];
	[mRepresentedObjectForViewController release];
	[super dealloc];
}

@end

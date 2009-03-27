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


- (id)initWithViewController:(KTViewController*)theViewController
{
	if(theViewController==nil)
	{
		[self release];
		return nil;
	}
	
	if(self = [super init])
	{
		mViewController = theViewController;
	}
	return self;
}
- (void)dealloc
{
	NSLog(@"%@ dealloc", self);
	[mLabel release];
//	[mIdentifier release];
//	[mViewController release];
	[super dealloc];
}

@end

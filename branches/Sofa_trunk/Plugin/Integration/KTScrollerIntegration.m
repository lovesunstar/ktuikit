//
//  KTScrollerIntegration.m
//  KTUIKit
//
//  Created by Jonathan on 11/03/2009.
//  Copyright 2009 espresso served here. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

// Import your framework view and your inspector 
// #import <MyFramework/MyView.h>
// #import "MyInspector.h"
#import "KTScroller.h"
#import "KTLayoutManagerInspector.h"

@implementation KTScroller ( KTScrollerIntegration )

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
    [super ibPopulateKeyPaths:keyPaths];

	// Remove the comments and replace "MyFirstProperty" and "MySecondProperty" 
	// in the following line with a list of your view's KVC-compliant properties.
    [[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects:/* @"MyFirstProperty", @"MySecondProperty",*/ nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
    [super ibPopulateAttributeInspectorClasses:classes];
	// Replace "KTScrollerIntegrationInspector" with the name of your inspector class.
    [classes addObject:[KTLayoutManagerInspector class]];
}

@end

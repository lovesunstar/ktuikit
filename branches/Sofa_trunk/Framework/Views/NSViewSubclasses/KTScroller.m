//
//  KTScroller.m
//  KTUIKit
//
//  Created by Jonathan on 11/03/2009.
//  Copyright 2009 espresso served here. All rights reserved.
//

#import "KTScroller.h"
#import "KTLayoutManager.h"
#import "KTLayoutDynamicImplementation.h"

@interface KTScroller ()

@end

@interface KTScroller (Private)

@end

@implementation KTScroller
#include "../Layout/SharedCode/KTViewLayoutSharedImplementation_ChildlessNSView.m"
//@dynamic viewLayoutManager; 
//@dynamic parent;
//@dynamic children;
//@dynamic frame;

//+ (void)initialize;
//{
//	if (self == [self class]) {
//		class_replaceMethod(self, @selector(initWithFrame:), (IMP)initWithFrameDynamicIMP, "@@:{_nsrect=ff}");
//		class_replaceMethod(self, @selector(initWithCoder:), (IMP)initWithFrameDynamicIMP, "@@:@");
//		class_replaceMethod(self, @selector(encodeWithCoder:), (IMP)encodeWithCoderDynamicIMP, "v@:@");
//		class_replaceMethod(self, @selector(dealloc), (IMP)deallocDynamicIMP, "v@:");
//	}
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)selector;
//{
//	if (selector == @selector(viewLayoutManager)) {
//		class_addMethod([self class], selector, (IMP)layoutManagerDynamicMethodIMP, "@@:");
//		return YES;
//	} else if (selector == @selector(setViewLayoutManager:)) {
//		class_addMethod([self class], selector, (IMP)setLayoutManagerDynamicMethodIMP, "v@:@");
//		return YES;
//	} else if (selector == @selector(parent)) {
//		class_addMethod([self class], selector, (IMP)parentDynamicMethodIMP, "@@:");
//		return YES;
//	}  else if (selector == @selector(children)) {
//		class_addMethod([self class], selector, (IMP)childrenDynamicMethodIMP, "@@:");
//		return YES;
//	}
//	return [super resolveInstanceMethod:selector];
//}

@end

@implementation KTScroller (Private)

@end

## KTUIKit 0.9.1 (Pre-Alpha) Release Notes ##


**WARNING:** This version of the project is not compatible with the previous version.  If you need the source to the previous version, you can download it [here](http://katidev.com/blog/wp-content/uploads/2009/05/ktuikit-source-0901.zip).

Also, if you already have a working copy of KTUIKit, I suggest deleting it and checking out a fresh copy.


---

## KTUIKit Interface Builder Plugin ##

### Layout Inspector ###

![http://katidev.com/blog/wp-content/uploads/2009/05/picture-151.png](http://katidev.com/blog/wp-content/uploads/2009/05/picture-151.png)

**Enhancements:**

  * Multiple selection working for all values
  * Added auto alignment, placement
  * Can edit the margin values inside the resizing control
  * Live resizing works properly now - the resizing doesn't lag and mess up the layout.
  * You can switch off the live resizing while you're laying out (this is a global property, applies to all the views, not just the inspected view).

**Bugs:**

  * Auto alignment and placement not yet using "IBInset" values or "baseline" values, so controls like the default aqua button aren't aligned/placed as expected.
  * Flipped coordinate systems are not accounted for in KTLayoutManager - the calculations are always from the bottom/left of the superview

### Style Inspector ###

![http://katidev.com/blog/wp-content/uploads/2009/05/picture-16.png](http://katidev.com/blog/wp-content/uploads/2009/05/picture-16.png)

**Enhancements:**

**Multiple selection working for all values**

**To Do:**

  * Add ability to set background image
  * The layout and overall design of the style inspector still sucks.
  * Color picker interaction - especially with the gradient control - still sucks.

**General Plugin Issues:**

**To Do:**
  * Proper icons for the Library objects
  * Proper styling for the Gradient Picker control


---

## KTUIKit Framework ##

### Window Controllers ###

**Enhancements and Changes:**

  * Commented out the code that tells view controllers to "removeObservations" in "windowWillClose:".  It is now totally up to the surrounding application architecture to coordinate this message being sent though the controller hierarchy.

### View Controllers ###

**Enhancements and Changes:**

  * Added a "hidden" property to KTViewController - if a view controller is flagged as hidden, it is removed from the responder chain and vice versa.  However,  if the view controller is observing anything or bound to anything, those connections remain while the view is hidden until a good solution is found. NOTE: this hidden property has absolutely no relationship to NSView's "hidden" property.  When a view controller is hidden, it's view is not removed from the view hierarchy or set to hidden.  I'm very hesitant to make such a direct connection between the view controller hierarchy and the actual view hierarchy.

  * API changes
    * Changed language so that it uses the term "subcontrollers" instead of "child".  For example, -addSubcontroller: instead of -addChild:
    * Removed the indexed accessors so that dealing with the view controller hierarchy is more like the view hierarchy.
    * There is no longer a "Parent" ivar.  I absolutely want to discourage traversing the view controller hierarchy to access view controllers - this makes for bad application architecture.
    * Added list of "layer controllers" and addLayerController:/removeLayerController: methods, which ties KTLayerController into the current controller system.

### KTTabViewController ###

  * Added KTTabViewController class.  It's still in a very experimental phase.

  * The tab view controller is designed with a similar API as an NSTabView
    * There are tab items (KTTabItem) for each view controller you want to switch between
    * Adding tabs means creating a tab item and adding it to the tab view controller
    * The tab items are kept in an NSArrayController property of the tab view controller.  The goal of this is to allow a tab view controller's array controller of tab items to be bound to standard controls like a pop up button (through normal NSPopUpButton/NSArrayController bindings) or a custom tab view that you create.  NOTE: This model of tabbing views with view controllers is not compatible with NSTabView, don't try to use an NSTabView with a tab view controller.
    * Selecting a view controller means that the previous selection's view is removed from the view controller's view and the new view controller's view is added.  In an application, you'd just add the tab view controller's view to the view hierarchy and select tab items to see the views switch.
    * When view controllers are selected/deselected the view controllers are properly added/removed from the responder chain using KTViewController's new "hidden" property.  For now, bindings/observations remain for view controllers that aren't selected.
    * The whole workflow is still a little clunky, but I'm working it out as I'm using it in an application right now....

### Layer Controllers ###
  * KTLayerController is a controller for "layers", which are typed id.  They can be used with CALayers - or any other class that you have with a similar concept.
  * KTLayerController works seamlessly with the current controller design, you can start to build a hierarchy of layers by adding a "layer controller" to KTViewController's list of layer controllers in the same way that a view controller hierarchy begins by adding "view controllers" to KTWindowController's list of view controllers.
  * KTLayerControllers are added to the responder chain and have a -removeObservations method just like KTViewControllers.
  * KTLayerControllers maintain a weak refrerence to the hosting view controller just like the view controller holds a reference to its hosting window controller.
  * KTLayerController has a "representedObject" property.
  * KTLayerController has a "layer" property that is analogous to NSViewController's "view" property.

### KTView ###

**Enhancements and Changes:**

  * To lesson the need to subclass views for simple configurations, added ability to set properties for:
    * opaque
    * mouseDownCanMoveWindow
    * canBecomeKeyView
    * canBecomeFirstResponder

  * Moved the code that triggers KTLayoutManager auto-layout of subviews to "setFrameSize:" instead of "setFrame:"

**Bugs:**

  * The ability to tell Cocoa that a mouse down in a view can move a window doesn't seem to work with a hierarchy of KTViews.

### KTStyleManager ###

**Enhancements and Changes:**

  * Optimizations:
    * Most of the drawing code now checks the "dirty rect" to determine if it needs to draw styles, can still be optimized further.
    * When a background color is set, style manager checks the opacity and if the background is opaque, it sets the view to be opaque.

**To Do:**

  * Add ability to configure styles for different view/window key states

### KTSplitView ###

  * Added a custom split view class.  The IB plugin is not ready to release yet.  Documentation on this class will come in a future update.

### NSBezierPathAdditions ###

  * Additions for drawing partial rounded rects
    * bezierPathWithTopRoundedRect
    * bezierPathWithRightRoundedRect
    * bezierPathWithBottomRoundedRect
    * bezierPathWithLeftRoundedRect

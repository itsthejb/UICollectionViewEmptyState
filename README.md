[![Build Status](https://travis-ci.org/itsthejb/UICollectionViewEmptyState.svg?branch=develop)](https://travis-ci.org/itsthejb/UICollectionViewEmptyState)
[![Build Status](https://travis-ci.org/itsthejb/UICollectionViewEmptyState.svg?branch=master)](https://travis-ci.org/itsthejb/UICollectionViewEmptyState)

# UICollectionView+EmptyState

Want to display an arbitrary `UIView` on your `UICollectionView` when in an *empty* state, and in a loosely-coupled fashion? Look no further.

## Usage

`#import "UICollectionView+EmptyState.h"` and simply set the property `emptyState_view` on your `UICollectionView` instance. We do the rest. Note that your view will be resized to overlay the `UICollectionView` so be sure to properly configure beforehand.

## Properties

* `@property (nonatomic, strong) UIView *emptyState_view;` set your overlay view.
* `@property (nonatomic, assign) BOOL emptyState_shouldRespectSectionHeader;` when used with `UICollectionViewFlowLayout`, setting this property to `YES` causes the overlay to be laid-out beneath the first section's header view. This would be useful if your first section's header contains controls that affect the collection's content in some way. We don't want to block those. The demo application has a switch in its header view to demonstrate that the section header will be available for user interaction.
* `@property (nonatomic, assign) NSTimeInterval emptyState_showAnimationDuration;`, `@property (nonatomic, assign) NSTimeInterval emptyState_hideAnimationDuration;` the overlay can be faded in and out using these properties. Set either to 0 for no animation.
* `UICollectionViewEmptyStateDelegate` protocol can be used for further customisation of the view as it's added and removed.
* A convenience method `setEmptyStateImageViewWithImage:` creates a `UIImageView` with the provided image, sets it as `emptyState_view`, and returns it for any further customisation required.

## Notes

* The overlay does not rotate terribly well at this time.


## What's new

### 1.4.4
 * Added `shouldNilViewIfNotRequired` flag, to automatically `nil` the empty state view if it is not added as part of the next layout cycle.
 
### 1.4.2
* Added new delegate method that allows modification of the proposed overlay frame.

### 1.3.1
 * Permit Autolayout, by removing call to `-setTranslatesAutoresizingMaskIntoConstraints:`.

### 1.3.0
* Changed *swizzling* solution to [Aspects](https://github.com/steipete/Aspects), in order to only swizzle `-layoutSubviews` for `UICollectionView` instances with an empty state view set.
* Improved some other property and layout logic, including in the demo.

### 1.2.1
* Fixed an incorrect pointer bug.

### 1.2.0
* Proper overhaul with recreated project. No more test suite demons.
* `will~` delegate methods are now called from within animation blocks.
* Better sizing when respecting the collection's first section header. Takes account of header sizing for the layout *and* delegate. Does not access the actual header view at all.
* Demo is prettier and more functional.
* Tidying up podspec dependencies.

### 1.1.0
* Much-needed spring clean.
* Properly respects the collection view's `contentInsets` for better iOS 7 compatibility.
* Accesses the collection view's section 0 header view directly for more robust layout with `emptyState_shouldRespectSectionHeader`.
* Scrolling of the collection view is now disabled when the overlay is visible.
* Scrolls the collection back to the top when the overlay is presented.

### 1.0.9
* Dependency updates.

### 1.0.8
* Updated depedencies for changes in `libextobjc`.

### 1.0.7
* Fixed missing QuartzCore import.

### 1.0.6
* Checks the animation keys for the `emptyState_view` explicitly so should protect against multiple nested add/remove operations and generally smoother operation.

### 1.0.5
* Added `emptyState_showDelay` and `emptyState_hideDelay` properties to add a delay to show/hide of the overlay.
* Possibly fixed a retain cycle-related crash issue.
* Test target currently broken and no time to fix... :(

### 1.0.3
* Dependency updates.

### 1.0.2
* Fixed dependency error.

### 1.0.1
* Tidying of methods.
* Existing empty views are always removed when a new view is set. Allows for more dynamic changing of empty state views. 

### 1.0.0
* Added `UICollectionViewEmptyStateDelegate` protocol.
* Added `setEmptyStateImageViewWithImage:`.
* 0.0.1 - Initial release

 
**Have fun!**

---

<jon.crooke@gmail.com>





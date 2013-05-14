#UICollectionView+EmptyState

Want to display an arbitrary `UIView` on your `UICollectionView` when in an *empty* state, and in a loosely-coupled fashion? Look no further.

##Usage

`#import "UICollectionView+EmptyState.h"` and simply set the property `emptyState_view` on your `UICollectionView` instance. We do the rest. Note that your view will be resized to overlay the `UICollectionView` so be sure to properly configure beforehand.

##Category properties

* **@property (nonatomic, strong) UIView *emptyState_view;** set your overlay view.
* **@property (nonatomic, assign) BOOL emptyState_shouldRespectSectionHeader;** when used with `UICollectionViewFlowLayout`, setting this property to `YES` causes the overlay to be laid-out beneath the first section's header view. This would be useful if your first section's header contains controls that affect the collection's content in some way. We don't want to block those.
* **@property (nonatomic, assign) NSTimeInterval emptyState_showAnimationDuration;**, **@property (nonatomic, assign) NSTimeInterval emptyState_hideAnimationDuration;** the overlay can be faded in and out using these properties. Set either to 0 for no animation.

##Notes

`UICollectionView` is a complex beast, and there are quite likely to be plenty of edge cases I haven't considered here. If you find a gremlin, please let me know!

**Have fun!**

<joncrooke@gmail.com>





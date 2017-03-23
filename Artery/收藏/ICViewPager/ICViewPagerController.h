//
//  ICViewPagerController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STHomeViewController.h"

/**
 * Every option has a default value.
 * 
 * ViewPagerOptionTabHeight: Tab bar's height, defaults to 44.0
 * ViewPagerOptionTabOffset: Tab bar's offset from left, defaults to 56.0
 * ViewPagerOptionTabWidth: Any tab item's width, defaults to 128.0
 * ViewPagerOptionTabLocation: 1.0: Top, 0.0: Bottom, Defaults to Top
 * ViewPagerOptionStartFromSecondTab: 1.0: YES, 0.0: NO, defines if view should appear with the 1st or 2nd tab. Defaults to NO
 * ViewPagerOptionCenterCurrentTab: 1.0: YES, 0.0: NO, defines if tabs should be centered, with the given tabWidth. Defaults to NO
 * ViewPagerOptionFixFormerTabsPositions: 1.0: YES, 0.0: NO, defines if the active tab should be placed margined by the offset amount to the left. Effects only the former tabs. If set 1.0 (YES), first tab will be placed at the same position with the second one, leaving space before itself. Defaults to NO
 * ViewPagerOptionFixLatterTabsPositions: 1.0: YES, 0.0: NO, like ViewPagerOptionFixFormerTabsPositions, but effects the latter tabs, making them leave space after themselves. Defaults to NO
 */
typedef NS_ENUM(NSUInteger, ICViewPagerOption) {
    ICViewPagerOptionTabHeight,
    ICViewPagerOptionTabOffset,
    ICViewPagerOptionTabWidth,
    ICViewPagerOptionTabLocation,
    ICViewPagerOptionStartFromSecondTab,
    ICViewPagerOptionCenterCurrentTab,
    ICViewPagerOptionFixFormerTabsPositions,
    ICViewPagerOptionFixLatterTabsPositions
};

/**
 * Main parts of the ICViewPagerController
 *
 * ViewPagerIndicator: The colored line in the view of the active tab
 * ViewPagerTabsView: The tabs view itself
 * ViewPagerContent: Provided views goes here as content
 */
typedef NS_ENUM(NSUInteger, ICViewPagerComponent) {
    ICViewPagerIndicator,
    ICViewPagerTabsView,
    ICViewPagerContent
};

@protocol ICViewPagerDataSource;
@protocol ICViewPagerDelegate;

@interface ICViewPagerController : STHomeViewController

/**
 * The object that acts as the data source of the receiving viewPager
 * @discussion The data source must adopt the ViewPagerDataSource protocol. The data source is not retained.
 */
@property (weak) id <ICViewPagerDataSource> dataSource;
/**
 * The object that acts as the delegate of the receiving viewPager
 * @discussion The delegate must adopt the ViewPagerDelegate protocol. The delegate is not retained.
 */
@property (weak) id <ICViewPagerDelegate> delegate;

#pragma mark Methods
/**
 * Reloads all tabs and contents
 */
- (void)reloadData;

/**
 * Selects the given tab and shows the content at this index
 *
 * @param index The index of the tab that will be selected
 */
- (void)selectTabAtIndex:(NSUInteger)index;

/**
 * Reloads the appearance of the tabs view. 
 * Adjusts tabs' width, offset, the center, fix former/latter tabs cases.
 * Without implementing the - viewPager:valueForOption:withDefault: delegate method, 
 * this method does nothing.
 * Calling this method without changing any option will affect the performance.
 */
- (void)setNeedsReloadOptions;

/**
 * Reloads the colors.
 * You can make ViewPager to reload its components colors.
 * Changing `ViewPagerTabsView` and `ViewPagerContent` color will have no effect to performance,
 * but `ViewPagerIndicator`, as it will need to iterate through all tabs to update it.
 * Calling this method without changing any color won't affect the performance, 
 * but will cause your delegate method (if you implemented it) to be called three times.
 */
- (void)setNeedsReloadColors;

/**
 * Call this method to get the value of a given option.
 * Returns NAN for any undefined option.
 *
 * @param option The option key. Keys are defined in ICViewPagerController.h
 *
 * @return A CGFloat, defining the setting for the given option
 */
- (CGFloat)valueForOption:(ICViewPagerOption)option;

/**
 * Call this method to get the color of a given component.
 * Returns [UIColor clearColor] for any undefined component.
 *
 * @param component The component key. Keys are defined in ICViewPagerController.h
 *
 * @return A UIColor for the given component
 */
- (UIColor *)colorForComponent:(ICViewPagerComponent)component;

@end

#pragma mark dataSource
@protocol ICViewPagerDataSource <NSObject>
/**
 * Asks dataSource how many tabs will there be.
 *
 * @param viewPager The viewPager that's subject to
 * @return Number of tabs
 */
- (NSUInteger)numberOfTabsForViewPager:(ICViewPagerController *)viewPager;
/**
 * Asks dataSource to give a view to display as a tab item.
 * It is suggested to return a view with a clearColor background.
 * So that un/selected states can be clearly seen.
 * 
 * @param viewPager The viewPager that's subject to
 * @param index The index of the tab whose view is asked
 *
 * @return A view that will be shown as tab at the given index
 */
- (UIView *)viewPager:(ICViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index;

@optional
/**
 * The content for any tab. Return a view controller and ViewPager will use its view to show as content.
 * 
 * @param viewPager The viewPager that's subject to
 * @param index The index of the content whose view is asked
 *
 * @return A viewController whose view will be shown as content
 */
- (UIViewController *)viewPager:(ICViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index;
/**
 * The content for any tab. Return a view and ViewPager will use it to show as content.
 *
 * @param viewPager The viewPager that's subject to
 * @param index The index of the content whose view is asked
 *
 * @return A view which will be shown as content
 */
- (UIView *)viewPager:(ICViewPagerController *)viewPager contentViewForTabAtIndex:(NSUInteger)index;

@end

#pragma mark delegate
@protocol ICViewPagerDelegate <NSObject>

@optional
/**
 * delegate object must implement this method if wants to be informed when a tab changes
 *
 * @param viewPager The viewPager that's subject to
 * @param index The index of the active tab
 */
- (void)viewPager:(ICViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index;
/**
 * Every time -reloadData method called, ViewPager will ask its delegate for option values.
 * So you don't have to set options from ViewPager itself.
 * You don't have to provide values for all options. 
 * Just return the values for the interested options and return the given 'value' parameter for the rest.
 *
 * @param viewPager The viewPager that's subject to
 * @param option The option key. Keys are defined in ICViewPagerController.h
 * @param value The default value for the given option
 *
 * @return A CGFloat, defining the setting for the given option
 */
- (CGFloat)viewPager:(ICViewPagerController *)viewPager valueForOption:(ICViewPagerOption)option withDefault:(CGFloat)value;

/**
 * Use this method to customize the look and feel.
 * viewPager will ask its delegate for colors for its components.
 * And if they are provided, it will use them, otherwise it will use default colors.
 * Also not that, colors for tab and content views will change the tabView's and contentView's background 
 * (you should provide these views with a clearColor to see the colors),
 * and indicator will change its own color.
 *
 * @param viewPager The viewPager that's subject to
 * @param component The component key. Keys are defined in ICViewPagerController.h
 * @param color The default color for the given component
 *
 * @return A UIColor for the given component
 */
- (UIColor *)viewPager:(ICViewPagerController *)viewPager colorForComponent:(ICViewPagerComponent)component withDefault:(UIColor *)color;

@end

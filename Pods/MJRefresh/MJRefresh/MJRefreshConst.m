//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
#import <UIKit/UIKit.h>

const CGFloat MJRefreshHeaderHeight = 54.0;
const CGFloat MJRefreshFooterHeight = 44.0;
const CGFloat MJRefreshFastAnimationDuration = 0.25;
const CGFloat MJRefreshSlowAnimationDuration = 0.4;

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

NSString *const MJRefreshHeaderLastUpdatedTimeKey = @"MJRefreshHeaderLastUpdatedTimeKey";

NSString *const MJRefreshHeaderIdleText = @"下拉还有更多好店";
NSString *const MJRefreshHeaderPullingText = @"松开就有值得品味的美食";
NSString *const MJRefreshHeaderRefreshingText = @"全城疯狂搜罗中...";

NSString *const MJRefreshAutoFooterIdleText = @"点击或上拉一下，吃货何止于此";
NSString *const MJRefreshAutoFooterRefreshingText = @"全城疯狂搜罗中 ...";
NSString *const MJRefreshAutoFooterNoMoreDataText = @"您真是个大吃货！本页已经被你刷完啦";

NSString *const MJRefreshBackFooterIdleText = @"上拉一下，吃货何止于此";
NSString *const MJRefreshBackFooterPullingText = @"松开就有值得品味的美食";
NSString *const MJRefreshBackFooterRefreshingText = @"全城疯狂搜罗中 ...";
NSString *const MJRefreshBackFooterNoMoreDataText = @"您真是个大吃货！本页已经被你刷完啦！";
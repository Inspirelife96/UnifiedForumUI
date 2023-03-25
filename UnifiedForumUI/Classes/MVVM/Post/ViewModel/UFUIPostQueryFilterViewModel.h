//
//  UFUIPostQueryFilterViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/12.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UFUIPostQueryFilterType) {
    UFUIPostQueryFilterTypeAll,
    UFUIPostQueryFilterTypeTopicHostOnly
};

typedef NS_ENUM(NSInteger, UFUIPostQueryOrderType) {
    UFUIPostQueryOrderTypeAscend,
    UFUIPostQueryOrderTypeDescend
};

NS_ASSUME_NONNULL_BEGIN

@interface UFUIPostQueryFilterViewModel : NSObject

@property (nonatomic, assign) UFUIPostQueryFilterType postQueryFilterType;
@property (nonatomic, assign) UFUIPostQueryOrderType postQueryOrderType;

- (void)filterToAll;
- (void)filterToTopicHostOnly;
- (void)ascend;
- (void)descend;

@end

NS_ASSUME_NONNULL_END

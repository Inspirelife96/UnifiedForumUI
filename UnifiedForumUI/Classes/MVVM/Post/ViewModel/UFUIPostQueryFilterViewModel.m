//
//  UFUIPostQueryFilterViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/12.
//

#import "UFUIPostQueryFilterViewModel.h"

@implementation UFUIPostQueryFilterViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.postQueryFilterType = UFUIPostQueryFilterTypeAll;
        self.postQueryOrderType = UFUIPostQueryOrderTypeAscend;
    }
    
    return self;
}

- (void)filterToAll {
    self.postQueryFilterType = UFUIPostQueryFilterTypeAll;
}

- (void)filterToTopicHostOnly {
    self.postQueryFilterType = UFUIPostQueryFilterTypeTopicHostOnly;
}

- (void)ascend {
    self.postQueryOrderType = UFUIPostQueryOrderTypeAscend;
}

- (void)descend {
    self.postQueryOrderType = UFUIPostQueryOrderTypeDescend;
}

@end

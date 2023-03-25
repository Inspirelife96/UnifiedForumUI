//
//  UFUIPostQueryViewController+UFUIPostQueryFilterViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/12.
//

#import "UFUIPostQueryViewController+UFUIPostQueryFilterViewDelegate.h"

#import "UFUIPostQueryFilterView.h"

#import "UFUIPostQueryFilterViewModel.h"

@implementation UFUIPostQueryViewController (UFUIPostQueryFilterViewDelegate)

- (void)clickFilterToAllButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView {
    [postQueryFilterView.postQueryFilterVM filterToAll];
    [self loadFirstPage];
}

- (void)clickFilterToTopicHostOnlyButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView {
    [postQueryFilterView.postQueryFilterVM filterToTopicHostOnly];
    [self loadFirstPage];
}

- (void)clickAscendButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView {
    [postQueryFilterView.postQueryFilterVM ascend];
    [self loadFirstPage];
}

- (void)clickDescendButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView {
    [postQueryFilterView.postQueryFilterVM descend];
    [self loadFirstPage];
}

@end

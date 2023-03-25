//
//  UFUITimeLineCellViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/20.
//

#import "UFUIObjectCellViewModel.h"

@class UFMTimeLineModel;
@class UFUITimeLineHeaderViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUITimeLineCellViewModel : UFUIObjectCellViewModel

@property (nonatomic, strong) UFUITimeLineHeaderViewModel *timeLineHeaderVM;

@property (nonatomic, strong) UFMTimeLineModel *timeLineModel;

@end

NS_ASSUME_NONNULL_END

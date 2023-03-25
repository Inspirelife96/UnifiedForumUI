//
//  UFUITimeLineHeaderViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUITimeLineHeaderViewModel : NSObject

@property (nonatomic, copy, nullable) NSString *avatarUrlString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *timeInfo;

@end

NS_ASSUME_NONNULL_END

//
//  UFUIReplyQueryViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/18.
//

#import "UFUIReplyQueryViewModel.h"

#import "UFUIReplyQueryHeaderViewModel.h"

#import "UFUIPostQueryAddReplyToPostViewModel.h"

#import "UFUIReplyCell.h"
#import "UFUIReplyCellViewModel.h"

@implementation UFUIReplyQueryViewModel

- (instancetype)initWithPostModel:(UFMPostModel *)postModel {
    if (self = [self init]) {
        self.postModel = postModel;
        
        self.replyQueryHeaderVM = [[UFUIReplyQueryHeaderViewModel alloc] initWithPostModel:postModel];
        
        // 注意：下面这两个成员没有设定
        // 需要在个字触发相应的交互时进行初始化
        // self.addReplyToPostVM
        // self.addReplyToReplyVM

        // 父类的成员，在这里必须设置，此时已经知道对应的Cell有哪些
        self.objectCellClassArray = @[
            [UFUIReplyCell class]
        ];
        
        // 具体的Query API，根据条件不同可以进行修改
        // Todo:warning!这种写法会不会在多线程中引起冲突，需要观察测试！
        WEAKSELF
        self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            STRONGSELF
            return [UFMService findReplyModelArrayToPost:postModel orderBy:@"CreatedAt" isOrderByAscending:NO page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
        };
    }
    
    return self;
}


#pragma mark Public Methods

- (Class)objectCellViewModelClassForObjectModel:(UFMObjectModel *)objectModel {
    return [UFUIReplyCellViewModel class];
}

@end

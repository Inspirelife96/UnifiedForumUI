//
//  UFMPostModel.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMPostModel.h"

#import "UFMTopicModel.h"
#import "UFMUserModel.h"
#import "UFMFileModel.h"
#import "UFMReplyModel.h"

@implementation UFMPostModel

- (instancetype)initWithMetaData:(id)metaData error:(NSError **)error {
    if (self = [super initWithMetaData:metaData error:error]) {
        
        // 如果metaData是INSPost类型，则可以进行如下的转换
        if ([metaData isKindOfClass:[UFPFPost class]]) {
            UFPFPost *post = (UFPFPost *)metaData;
            
            self.postId = post.objectId;
            
            self.content = post.content;
            
            NSMutableArray *fileModelMutableArray = [[NSMutableArray alloc] init];
            [post.mediaFileObjects enumerateObjectsUsingBlock:^(PFFileObject * _Nonnull fileObject, NSUInteger idx, BOOL * _Nonnull stop) {
                UFMFileModel *fileModel = [[UFMFileModel alloc] initWithMetaData:fileObject error:nil];
                [fileModelMutableArray addObject:fileModel];
            }];
            self.fileModelArray = [fileModelMutableArray copy];
            
            NSMutableArray *replyModelMutableArray = [[NSMutableArray alloc] init];
            NSArray *replies = post.replies;
            for (NSInteger i = 0; i < replies.count; i++) {
                UFPFReply *reply = replies[i];
                [reply fetchIfNeeded:error];
                if (*error) {
                    return nil;
                }
                
                UFMReplyModel *replyModel = [[UFMReplyModel alloc] initWithMetaData:reply error:error];
                if (*error) {
                    return nil;
                }
                
                [replyModelMutableArray addObject:replyModel];
            }
            self.replyModelArray = [replyModelMutableArray copy];
            
            self.replyCount = [post.replyCount integerValue];
            
            self.likeCount = [post.likeCount integerValue];
            
            self.createdAt = post.createdAt;
            
            PFUser * fromUser = post.fromUser;
            [fromUser fetchIfNeeded:error];
            if (*error) {
                return nil;
            }
            
            self.fromUserModel = [[UFMUserModel alloc] initWithMetaData:fromUser error:error];
            if (*error) {
                return nil;
            }
        }
    }
    
    return self;
}


- (instancetype)initWithContent:(NSString *)content
                 fileModelArray:(NSArray<UFMFileModel *> * _Nullable)fileModelArray
                       fileType:(NSString *)fileType
                  fromUserModel:(UFMUserModel *)fromUserModel
                   toTopicModel:(UFMTopicModel *)topicModel
                          error:(NSError **)error {
    if (self = [super init]) {
        self.content = content;
        self.fileModelArray = fileModelArray;
        self.fileType = fileType;
        self.fromUserModel = fromUserModel;
        self.replyModelArray = @[];
        self.replyCount = 0;
        self.likeCount = 0;
        self.toTopicModel = topicModel;
        self.fromUserModel = fromUserModel;
        self.isDeleted = NO;
        self.isApproved = YES;
                
        UFPFPost *post = [[UFPFPost alloc] init];

        [self _savePost:post error:error];
        
        if (!*error) {
            self.metaData = post;
            self.postId = post.objectId;
            self.createdAt = post.createdAt;
        } else {
            return nil;
        }
    }
    
    return self;
}

- (void)save:(NSError **)error {
    if ([self.metaData isKindOfClass:[UFPFPost class]]) {
        UFPFPost *post = (UFPFPost *)self.metaData;
        [self _savePost:post error:error];
    }
}

- (BOOL)isLikedByUserModel:(UFMUserModel *)userModel error:(NSError **)error {
    UFPFPost *post = (UFPFPost *)self.metaData;
    PFUser *user = (PFUser *)userModel.metaData;
    
    return [UFPFService isPost:post likedbyUser:user error:error];
}

- (void)_savePost:(UFPFPost *)post error:(NSError **)error {
    post.content = self.content;
    if (self.fileModelArray) {
        post.mediaFileObjects = [UFMObjectModel generateFileObjectArrayFromFileModelArray:self.fileModelArray];
    }
    post.mediaFileType = self.fileType;
    post.fromUser = (PFUser *)self.fromUserModel.metaData;
    post.toTopic = (UFPFTopic *)self.toTopicModel.metaData;
    
    post.likeCount = @(self.likeCount);
    
    post.replies = [UFMObjectModel generateReplyArrayFromReplyModelArray:self.replyModelArray];
    post.replyCount = @(self.replyCount);

    post.isDeleted = self.isDeleted;
    post.isApproved = self.isApproved;
    
    [post save:error];
}

@end

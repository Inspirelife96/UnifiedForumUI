//
//  UFMTopicModel.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMTopicModel.h"

#import "UFMService.h"

#import "UFMFileModel.h"
#import "UFMUserModel.h"

@implementation UFMTopicModel

- (instancetype)initWithMetaData:(id)metaData error:(NSError **)error {
    if (self = [super initWithMetaData:metaData error:error]) {
        // 如果是metaData是UFPFTopic类型的，可以进行如下的转换
        if ([metaData isKindOfClass:[UFPFTopic class]]) {
            UFPFTopic *topic = (UFPFTopic *)metaData;
            
            self.topicId = topic.objectId;
            self.title = topic.title;
            self.content = topic.content;
            self.fileModelArray = [self _generateFileModelArrayFromFileObjectArray:topic.mediaFileObjects];
            
            PFUser *fromUser = topic.fromUser;
            [fromUser fetchIfNeeded:error];
            if (*error) {
                return nil;
            }
            
            self.fromUserModel = [[UFMUserModel alloc] initWithMetaData:fromUser error:error];
            if (*error) {
                return nil;
            }

            self.postCount = [topic.postCount integerValue];
            self.likeCount = [topic.likeCount integerValue];
            self.shareCount = [topic.shareCount integerValue];
            self.createdAt = topic.createdAt;
            self.category = topic.category;
            self.tags = [topic.tags copy];
            self.isLocked = topic.isLocked;
            self.isDeleted = topic.isDeleted;
            self.isPrivate = topic.isPrivate;
            self.isApproved = topic.isApproved;
            self.isPopular = topic.isPopular;
        }
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
               fileModelArray:(NSArray<UFMFileModel *> * _Nullable)fileModelArray
                     fileType:(NSString *)fileType
                fromUserModel:(UFMUserModel *)fromUserModel
                     category:(NSString * _Nullable)category
                         tags:(NSArray<NSString *> * _Nullable)tags
                        error:(NSError **)error; {
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.fileModelArray = fileModelArray;
        self.fileType = fileType;
        self.fromUserModel = fromUserModel;
        self.category = category;
        self.tags = tags;
        self.isLocked = NO;
        self.isDeleted = NO;
        self.isPrivate = NO;
        self.isApproved = NO;
        self.isPopular = NO;
        
        UFPFTopic *topic = [[UFPFTopic alloc] init];

        [self _saveTopic:topic error:error];
        
        if (!*error) {
            self.metaData = topic;
            self.topicId = topic.objectId;
            self.createdAt = topic.createdAt;
        } else {
            return nil;
        }
    }
    
    return self;
}

- (void)save:(NSError **)error {
    if ([self.metaData isKindOfClass:[UFPFTopic class]]) {
        UFPFTopic *topic = (UFPFTopic *)self.metaData;
        [self _saveTopic:topic error:error];
    }
}

- (BOOL)isLikedByUserModel:(UFMUserModel *)userModel error:(NSError **)error {
    UFPFTopic *topic = (UFPFTopic *)self.metaData;
    PFUser *user = (PFUser *)userModel.metaData;
    
    return [UFPFService isTopic:topic likedbyUser:user error:error];
}

- (void)_saveTopic:(UFPFTopic *)topic error:(NSError **)error {
    topic.title = self.title;
    topic.content = self.content;
    if (self.fileModelArray) {
        topic.mediaFileObjects = [self _generateFileObjectArrayFromFileModelArray:self.fileModelArray];
    }
    topic.mediaFileType = self.fileType;
    topic.fromUser = (PFUser *)self.fromUserModel.metaData;
    topic.category = self.category;
    topic.tags = self.tags;
    topic.postCount = @(self.postCount);
    topic.likeCount = @(self.likeCount);
    topic.shareCount = @(self.shareCount);
    topic.isLocked = self.isLocked;
    topic.isPopular = self.isPopular;
    topic.isPrivate = self.isPrivate;
    topic.isDeleted = self.isDeleted;
    topic.isApproved = self.isApproved;
    
    [topic save:error];
}

- (NSArray *)_generateFileObjectArrayFromFileModelArray:(NSArray<UFMFileModel *> *)fileModelArray {
    NSMutableArray<PFFileObject *> *fileObjectMutableArray = [[NSMutableArray alloc] initWithCapacity:fileModelArray.count];
    [fileModelArray enumerateObjectsUsingBlock:^(UFMFileModel * _Nonnull fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([fileModel.metaData isKindOfClass:[PFFileObject class]]) {
            [fileObjectMutableArray addObject:((PFFileObject*)fileModel.metaData)];
        }
    }];
    
    return [fileObjectMutableArray copy];
}

- (NSArray<UFMFileModel *> *)_generateFileModelArrayFromFileObjectArray:(NSArray *)fileObjectArray {
    NSMutableArray *fileModelMutableArray = [[NSMutableArray alloc] init];
    [fileObjectArray enumerateObjectsUsingBlock:^(NSObject * _Nonnull fileObject, NSUInteger idx, BOOL * _Nonnull stop) {
        UFMFileModel *fileModel = [[UFMFileModel alloc] initWithMetaData:fileObject error:nil];
        [fileModelMutableArray addObject:fileModel];
    }];
    
    return [fileModelMutableArray copy];
}

@end

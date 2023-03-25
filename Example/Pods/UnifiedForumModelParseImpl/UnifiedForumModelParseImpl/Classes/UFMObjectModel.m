//
//  UFMObjectModel.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMObjectModel.h"

#import "UFMFileModel.h"
#import "UFMReplyModel.h"

@implementation UFMObjectModel

//- (instancetype)init {
//    return [self initWithMetaData:@{}];
//}

- (instancetype)initWithMetaData:(id)metaData {
    NSError *error = nil;
    return [self initWithMetaData:metaData error:&error];
}

- (instancetype)initWithMetaData:(id)metaData error:(NSError *__autoreleasing  _Nullable *)error {
    if (self = [super init]) {
        self.metaData = metaData;
    }
    
    return self;
}

+ (NSArray *)generateFileObjectArrayFromFileModelArray:(NSArray<UFMFileModel *> *)fileModelArray {
    NSMutableArray<PFFileObject *> *fileObjectMutableArray = [[NSMutableArray alloc] initWithCapacity:fileModelArray.count];
    [fileModelArray enumerateObjectsUsingBlock:^(UFMFileModel * _Nonnull fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([fileModel.metaData isKindOfClass:[PFFileObject class]]) {
            [fileObjectMutableArray addObject:((PFFileObject*)fileModel.metaData)];
        }
    }];
    
    return [fileObjectMutableArray copy];
}

+ (NSArray<UFMFileModel *> *)generateFileModelArrayFromFileObjectArray:(NSArray *)fileObjectArray {
    NSMutableArray *fileModelMutableArray = [[NSMutableArray alloc] init];
    [fileObjectArray enumerateObjectsUsingBlock:^(NSObject * _Nonnull fileObject, NSUInteger idx, BOOL * _Nonnull stop) {
        UFMFileModel *fileModel = [[UFMFileModel alloc] initWithMetaData:fileObject error:nil];
        [fileModelMutableArray addObject:fileModel];
    }];
    
    return [fileModelMutableArray copy];
}

+ (NSArray *)generateReplyArrayFromReplyModelArray:(NSArray<UFMReplyModel *> *)replyModelArray {
    NSMutableArray<UFPFReply *> *replyMutableArray = [[NSMutableArray alloc] initWithCapacity:replyModelArray.count];
    [replyModelArray enumerateObjectsUsingBlock:^(UFMReplyModel * _Nonnull replyModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([replyModel.metaData isKindOfClass:[UFPFReply class]]) {
            [replyMutableArray addObject:((UFPFReply*)replyModel.metaData)];
        }
    }];
    
    return [replyMutableArray copy];
}

@end

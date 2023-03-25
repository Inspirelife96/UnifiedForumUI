//
//  UFMObjectModel.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import <Foundation/Foundation.h>

@class UFMReplyModel;
@class UFMFileModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMObjectModel : NSObject

@property (nonatomic, strong) id metaData; // 原始数据，类型不确定

- (instancetype)init;
- (instancetype)initWithMetaData:(id)metaData error:(NSError **)error;
- (instancetype)initWithMetaData:(id)metaData;

+ (NSArray *)generateFileObjectArrayFromFileModelArray:(NSArray<UFMFileModel *> *)fileModelArray;

+ (NSArray<UFMFileModel *> *)generateFileModelArrayFromFileObjectArray:(NSArray *)fileObjectArray;

+ (NSArray *)generateReplyArrayFromReplyModelArray:(NSArray<UFMReplyModel *> *)replyModelArray;



@end

NS_ASSUME_NONNULL_END

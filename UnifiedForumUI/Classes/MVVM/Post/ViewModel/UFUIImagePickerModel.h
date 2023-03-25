//
//  UFUIImagePickerModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIImagePickerModel : NSObject

@property (nonatomic, strong) NSMutableArray *selectedPhotos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) NSInteger maxSelectedPhotoCount;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@end

NS_ASSUME_NONNULL_END

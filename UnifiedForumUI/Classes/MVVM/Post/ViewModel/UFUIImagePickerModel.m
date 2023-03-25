//
//  UFUIImagePickerModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/25.
//

#import "UFUIImagePickerModel.h"

@implementation UFUIImagePickerModel

- (instancetype)init {
    if (self = [super init]) {
        _selectedPhotos = [[NSMutableArray alloc] init];
        _selectedAssets = [[NSMutableArray alloc] init];
        _maxSelectedPhotoCount = 9;
        _isSelectOriginalPhoto = NO;
    }
    
    return self;
}

@end

//
//  UFPFService.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "UFPFService.h"

@implementation UFPFService

+ (PFFileObject *)addImageData:(NSData *)imageData error:(NSError **)error {
    PFFileObject *fileObject = [PFFileObject fileObjectWithName:@"image.jpg" data:imageData];
    [fileObject save:error];
    
    return fileObject;
}

@end



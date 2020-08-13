//
//  VideoEncoder.h
//  RTSPApp
//
//  Created by CloudStream on 4/16/20.
//  Copyright © 2020 CloudStream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVAssetWriter.h"
#import "AVFoundation/AVAssetWriterInput.h"
#import "AVFoundation/AVMediaFormat.h"
#import "AVFoundation/AVVideoSettings.h"

@interface VideoEncoder : NSObject
{
    AVAssetWriter* _writer;
    AVAssetWriterInput* _writerInput;
    NSString* _path;
}

@property NSString* path;

+ (VideoEncoder*) encoderForPath:(NSString*) path Height:(int) height andWidth:(int) width;

- (void) initPath:(NSString*)path Height:(int) height andWidth:(int) width;
- (void) finishWithCompletionHandler:(void (^)(void))handler;
- (BOOL) encodeFrame:(CMSampleBufferRef) sampleBuffer;
@end

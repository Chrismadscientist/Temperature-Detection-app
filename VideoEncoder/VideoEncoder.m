//
//  VideoEncoder.m
//  RTSPApp
//
//  Created by CloudStream on 4/16/20.
//  Copyright © 2020 CloudStream. All rights reserved.
//

#import "VideoEncoder.h"
#import "RTSPSetting.h"

@implementation VideoEncoder

@synthesize path = _path;

+ (VideoEncoder*) encoderForPath:(NSString*) path Height:(int) height andWidth:(int) width
{
    VideoEncoder* enc = [VideoEncoder alloc];
    [enc initPath:path Height:height andWidth:width];
    return enc;
}


- (void) initPath:(NSString*)path Height:(int) height andWidth:(int) width
{
    self.path = path;
    
    
    [[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
    NSURL* url = [NSURL fileURLWithPath:self.path];
        
//    float uQuality = 1.0;
//    switch ([RTSPSetting loadFromPreferences].nQuality) {
//        case 0:
//            uQuality = 0.2;
//            break;
//        case 1:
//            uQuality = 0.6;
//            break;
//        case 2:
//            uQuality = 1.0;
//            break;
//        default:
//            break;
//    }
    
    _writer = [AVAssetWriter assetWriterWithURL:url fileType:AVFileTypeQuickTimeMovie error:nil];
//    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
//                              AVVideoCodecH264, AVVideoCodecKey,
//                              [NSNumber numberWithInt: width], AVVideoWidthKey,
//                              [NSNumber numberWithInt:height], AVVideoHeightKey,
//                              [NSDictionary dictionaryWithObjectsAndKeys:
//                                    @YES, AVVideoAllowFrameReorderingKey, [NSNumber numberWithFloat:uQuality], AVVideoQualityKey, nil],
//                                    AVVideoCompressionPropertiesKey,
//                              nil];

//    [NSNumber numberWithFloat:uQuality], AVVideoQualityKey,
    NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                AVVideoCodecH264, AVVideoCodecKey,
                                [NSNumber numberWithInt: width], AVVideoWidthKey,
                                [NSNumber numberWithInt:height], AVVideoHeightKey,
                                [NSDictionary dictionaryWithObjectsAndKeys:
                                      @YES, AVVideoAllowFrameReorderingKey, nil],
                                      AVVideoCompressionPropertiesKey,
                                nil];
    
    _writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:settings];
    _writerInput.expectsMediaDataInRealTime = YES;
    [_writer addInput:_writerInput];
}

- (void) finishWithCompletionHandler:(void (^)(void))handler
{
    [_writer finishWritingWithCompletionHandler: handler];
}

- (BOOL) encodeFrame:(CMSampleBufferRef) sampleBuffer
{
    if (CMSampleBufferDataIsReady(sampleBuffer))
    {
        if (_writer.status == AVAssetWriterStatusUnknown)
        {
            CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            [_writer startWriting];
            [_writer startSessionAtSourceTime:startTime];
        }
        if (_writer.status == AVAssetWriterStatusFailed)
        {
            NSLog(@"writer error %@", _writer.error.localizedDescription);
            return NO;
        }
        if (_writerInput.readyForMoreMediaData == YES)
        {
            [_writerInput appendSampleBuffer:sampleBuffer];
            return YES;
        }
    }
    return NO;
}

@end

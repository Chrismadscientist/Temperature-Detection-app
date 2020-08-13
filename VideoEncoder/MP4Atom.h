//
//  MP4Atom.h
//  RTSPApp
//
//  Created by CloudStream on 4/16/20.
//  Copyright © 2020 CloudStream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MP4Atom : NSObject
{
    NSFileHandle* _file;
    int64_t _offset;
    int64_t _length;
    OSType _type;
    int64_t _nextChild;
}
@property OSType type;
@property int64_t length;

+ (MP4Atom*) atomAt:(int64_t) offset size:(int) length type:(OSType) fourcc inFile:(NSFileHandle*) handle;
- (BOOL) init:(int64_t) offset size:(int) length type:(OSType) fourcc inFile:(NSFileHandle*) handle;
- (NSData*) readAt:(int64_t) offset size:(int) length;
- (BOOL) setChildOffset:(int64_t) offset;
- (MP4Atom*) nextChild;
- (MP4Atom*) childOfType:(OSType) fourcc startAt:(int64_t) offset;
@end

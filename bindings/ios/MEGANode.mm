/**
 * @file MEGANode.mm
 * @brief Represents a node (file/folder) in the MEGA account
 *
 * (c) 2013-2014 by Mega Limited, Auckland, New Zealand
 *
 * This file is part of the MEGA SDK - Client Access Engine.
 *
 * Applications using the MEGA API must present a valid application key
 * and comply with the the rules set forth in the Terms of Service.
 *
 * The MEGA SDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * @copyright Simplified (2-clause) BSD License.
 *
 * You should have received a copy of the license along with this
 * program.
 */
#import "MEGANode.h"
#import "megaapi.h"

using namespace mega;

@interface MEGANode()

@property MegaNode *megaNode;
@property BOOL cMemoryOwn;

@end

@implementation MEGANode

- (instancetype)initWithMegaNode:(MegaNode *)megaNode cMemoryOwn:(BOOL)cMemoryOwn {
    self = [super init];
    
    if (self != nil) {
        _megaNode = megaNode;
        _cMemoryOwn = cMemoryOwn;
    }
    
    return self;
}

- (void)dealloc {
    if (self.cMemoryOwn) {
        delete _megaNode;
    }
}

- (instancetype)clone {
    return self.megaNode ? [[MEGANode alloc] initWithMegaNode:self.megaNode->copy() cMemoryOwn:YES] : nil;
}

- (MegaNode *)getCPtr {
    return self.megaNode;
}

- (MEGANodeType)type {
    return (MEGANodeType) (self.megaNode ? self.megaNode->getType() : MegaNode::TYPE_UNKNOWN);
}

- (NSString *)name {
    if(!self.megaNode) return nil;
    
    return self.megaNode->getName() ? [[NSString alloc] initWithUTF8String:self.megaNode->getName()] : nil;
}

- (NSString *)base64Handle {
    if (!self.megaNode) return nil;
    
    const char *val = self.megaNode->getBase64Handle();
    if (!val) return nil;
    
    NSString *ret = [[NSString alloc] initWithUTF8String:val];
    
    delete val;
    return ret;
}

- (NSNumber *)size {
    return self.megaNode ? [[NSNumber alloc] initWithUnsignedLongLong:self.megaNode->getSize()] : nil;
}

- (NSDate *)creationTime {
    return self.megaNode ? [[NSDate alloc] initWithTimeIntervalSince1970:self.megaNode->getCreationTime()] : nil;
}

- (NSDate *)modificationTime {
    return self.megaNode ? [[NSDate alloc] initWithTimeIntervalSince1970:self.megaNode->getModificationTime()] : nil;
}

- (uint64_t)handle {
    return self.megaNode ? self.megaNode->getHandle() : ::mega::INVALID_HANDLE;
}

- (uint64_t)parentHandle {
    return self.megaNode ? self.megaNode->getParentHandle() : ::mega::INVALID_HANDLE;
}

- (NSInteger)tag {
    return self.megaNode ? self.megaNode->getTag() : 0;
}

- (BOOL)isFile {
    return self.megaNode ? self.megaNode->isFile() : NO;
}

- (BOOL)isFolder {
    return self.megaNode ? self.megaNode->isFolder() : NO;
}

- (BOOL)isRemoved {
    return self.megaNode ? self.megaNode->isRemoved() : NO;
}

- (BOOL)hasThumbnail {
    return self.megaNode ? self.megaNode->hasThumbnail() : NO;
}

- (BOOL)hasPreview {
    return self.megaNode ? self.megaNode->hasPreview() : NO;
}

- (BOOL)isPublic {
    return self.megaNode ? self.megaNode->isPublic() : NO;
}

@end

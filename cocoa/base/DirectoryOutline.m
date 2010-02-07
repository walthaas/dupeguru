/* 
Copyright 2010 Hardcoded Software (http://www.hardcoded.net)

This software is licensed under the "HS" License as described in the "LICENSE" file, 
which should be included with this package. The terms are also available at 
http://www.hardcoded.net/licenses/hs_license
*/

#import "DirectoryOutline.h"

@implementation DirectoryOutline
- (id)initWithPyParent:(id)aPyParent view:(HSOutlineView *)aOutlineView
{
    self = [super initWithPyClassName:@"PyDirectoryOutline" pyParent:aPyParent view:aOutlineView];
    [outlineView registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
    return self;
}

- (PyDirectoryOutline *)py
{
    return (PyDirectoryOutline *)py;
}

/* Delegate */
- (NSDragOperation)outlineView:(NSOutlineView *)outlineView validateDrop:(id < NSDraggingInfo >)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
    sourceDragMask = [info draggingSourceOperationMask];
    pboard = [info draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        if (sourceDragMask & NSDragOperationLink)
            return NSDragOperationLink;
    }
    return NSDragOperationNone;    
}

- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(id)item childIndex:(NSInteger)index
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask; 
    sourceDragMask = [info draggingSourceOperationMask];
    pboard = [info draggingPasteboard];
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
        if (!(sourceDragMask & NSDragOperationLink))
            return NO;
        for (NSString *filename in filenames) {
            [[self py] addDirectory:filename];
        }
    }
    return YES;
}

- (void)outlineView:(NSOutlineView *)aOutlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{ 
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        NSTextFieldCell *textCell = cell;
        NSIndexPath *path = item;
        BOOL selected = [path isEqualTo:[outlineView selectedPath]];
        if (selected) {
            [textCell setTextColor:[NSColor blackColor]];
            return;
        }
        NSInteger state = [self intProperty:@"state" valueAtPath:path];
        if (state == 1) {
            [textCell setTextColor:[NSColor blueColor]];
        }
        else if (state == 2) {
            [textCell setTextColor:[NSColor redColor]];
        }
        else {
            [textCell setTextColor:[NSColor blackColor]];
        }
    }
}
@end
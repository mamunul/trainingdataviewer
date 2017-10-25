//
//  ViewController.h
//  TrainingDataViewer
//
//  Created by Mamunul on 10/24/17.
//  Copyright © 2017 Mamunul. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface ViewController : NSViewController<NSWindowDelegate,NSMenuDelegate>

@property (weak) IBOutlet NSButton *previousButton;

@property (weak) IBOutlet NSImageView *imageView;

@property (weak) IBOutlet NSButton *nextButton;

@end


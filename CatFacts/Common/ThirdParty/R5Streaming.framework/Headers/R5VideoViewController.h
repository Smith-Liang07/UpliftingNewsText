//
//  R5VideoViewController.h
//  Red5Pro
//
//  Created by Andy Zupko on 9/17/14.
//  Copyright (c) 2014 Andy Zupko. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "R5Stream.h"

/**
 *  @brief The VideoView for all R5Streaming.  When publishing, it will contain the camera view.  While subscribing it will render all incoming stream data.  Streams will be cropped to fit the aspect ratio of the view.
 */
@interface R5VideoViewController : UIViewController<GLKViewDelegate>
	

/**
 *  Desired FPS to render the video at.  FPS lower than the streaming FPS will result in dropped frames.
 */
@property int preferredFPS;

/**
 *  Set a stream to render using this View
 *
 *  @param videoStream Stream to render
 */
-(void) attachStream:(R5Stream *)videoStream;

/**
 *  Reset the GLES context and setup rendering loop
 */
-(void) resetContext;

/**
 *  Show the publish camera preview.  You can use this to show the preview before the Stream is publishing.
 *
 *  @param visible Set the visibility
 */
-(void) showPreview:(BOOL)visible;

/**
 *  Overlay the view with a log of textual debugging information.
 *
 *  @param debug Set the visibility of the debug panel
 */
-(void) showDebugInfo:(BOOL)debug;

@end

//
//  CameraDemoViewController.m
//  cgeDemo
//
//  Created by WangYang on 15/8/31.
//  Copyright (c) 2015年 wysaid. All rights reserved.
//
#import "CameraDemoViewController.h"
#import "cgeUtilFunctions.h"
#import "cgeVideoCameraViewHandler.h"
#import "demoUtils.h"
#import "cgeCustomFilters.h"
#import <ixprez-Swift.h>

#define SHOW_FULLSCREEN 0
#define RECORD_WIDTH 480
#define RECORD_HEIGHT 640
#define NAVIGATION_HEIGHT 64
#define BOTTOMFILTER_HEIGHTBG 200

#define _MYAVCaptureSessionPreset(w, h) AVCaptureSessionPreset ## w ## x ## h
#define MYAVCaptureSessionPreset(w, h) _MYAVCaptureSessionPreset(w, h)

static const char* const s_functionList[] = {

    "Antique",
    "Lomo",
    "Darker",
    "Process",
    "Chrome",
    "Blur",
    "Dync Wave",
    "Stat Wave",
    "Sketch",
    "Contrast",
    "Dotted",
    "Charcoal",
    "Fire",
    "Hatch",
    "Thermal",
    "Sepia",
    "Aqua",
    "Vintage",
    
};

static const int s_functionNum = sizeof(s_functionList) / sizeof(*s_functionList);

@interface CameraDemoViewController() <CGEFrameProcessingDelegate> {
    CMTime time;
    UIImage *thumbnailVideo;
}
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet UISlider *intensitySlider;
@property CGECameraViewHandler* myCameraViewHandler;
@property (nonatomic) UIScrollView* myScrollView;
@property (nonatomic) GLKView* glkView;
@property (nonatomic) int currentFilterIndex;
@property (nonatomic) NSURL* movieURL;
@property (nonatomic)IBOutlet UIView* bottonFilterView;
@property (nonatomic) IBOutlet UIView* videoButtonBG;
@property (nonatomic) IBOutlet UIButton* videoButton;
@property (nonatomic) BOOL isVideoButtonSelected;
@property (nonatomic) NSTimer* videoTimer;
@property (nonatomic) int countDownTime;
@property (nonatomic)IBOutlet UILabel* countdownLabel;

@end

@implementation CameraDemoViewController
- (IBAction)quitBtnClicked:(id)sender {
    NSLog(@"Camera Demo Quit...");
    [[[_myCameraViewHandler cameraRecorder] cameraDevice] stopCameraCapture];
    [self dismissViewControllerAnimated:true completion:nil];
    //safe clear to avoid memLeaks.
    [_myCameraViewHandler clear];
    _myCameraViewHandler = nil;
    [CGESharedGLContext clearGlobalGLContext];
}
- (IBAction)intensityChanged:(UISlider*)sender {
    float currentIntensity = [sender value] * 3.0f - 1.0f; //[-1, 2]
    [_myCameraViewHandler setFilterIntensity: currentIntensity];
}

- (IBAction)takePicture:(id)sender {
    [_myCameraViewHandler takePicture:^(UIImage* image){
        [DemoUtils saveImage:image];
        NSLog(@"Take Picture OK, Saved To The Album!\n");
        
    } filterConfig:g_effectConfig[_currentFilterIndex] filterIntensity:1.0f isFrontCameraMirrored:YES];
}

- (IBAction)recordingBtnClicked:(UIButton*)sender {
    
    [sender setEnabled:NO];
    
    if([_myCameraViewHandler isRecording])
    {
        void (^finishBlock)(void) = ^{
            NSLog(@"End recording...\n");
            
            [CGESharedGLContext mainASyncProcessingQueue:^{
                [sender setTitle:@"Rec OK" forState:UIControlStateNormal];
                [sender setEnabled:YES];
            }];
            
            [DemoUtils saveVideo:_movieURL];
            
        };
        
//        [_myCameraViewHandler endRecording:nil];
//        finishBlock();
        [_myCameraViewHandler endRecording:finishBlock withCompressionLevel:0];
    }
    else
    {
        unlink([_movieURL.path UTF8String]);
        [_myCameraViewHandler startRecording:_movieURL size:CGSizeMake(RECORD_WIDTH, RECORD_HEIGHT)];
        [sender setTitle:@"Recording" forState:UIControlStateNormal];
        [sender setEnabled:YES];
    }
}

- (IBAction)switchFlashLight:(id)sender {
    static AVCaptureFlashMode flashLightList[] = {
        AVCaptureFlashModeOff,
        AVCaptureFlashModeOn,
        AVCaptureFlashModeAuto
    };
    static int flashLightIndex = 0;
    
    ++flashLightIndex;
    flashLightIndex %= sizeof(flashLightList) / sizeof(*flashLightList);
    
    [_myCameraViewHandler setCameraFlashMode:flashLightList[flashLightIndex]];
}

// This method will reset the video filter 
-(IBAction)resetButtonAction:(id)sender {
    
    [_myCameraViewHandler setFilterWithConfig:nil];
}


-(IBAction)instantButtonAction:(id)sender {
    
    [self setCustomFilter:CGE_CUSTOM_FILTER_3];
    
}

-(IBAction)invertButtonAction:(id)sender {
    [self setCustomFilter:CGE_CUSTOM_FILTER_1];
}


-(IBAction)textureButtonAction:(id)sender {
    
    [self setCustomFilter:CGE_CUSTOM_FILTER_2];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _movieURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"]];
    _videoButtonBG.layer.cornerRadius = _videoButtonBG.frame.size.width/2;
    _videoButtonBG.clipsToBounds = true;
    self.title = [[NSUserDefaults standardUserDefaults] valueForKey:@"feelingsLabelValue"];
    CGRect rt = [[UIScreen mainScreen] bounds];
    
    CGRect sliderRT = [_intensitySlider bounds];
    sliderRT.size.width = rt.size.width - 20;
    [_intensitySlider setBounds:sliderRT];
    
#if SHOW_FULLSCREEN
    
    _glkView = [[GLKView alloc] initWithFrame:rt];
    
#else
    
    CGFloat x, y, w = RECORD_WIDTH, h = RECORD_HEIGHT;
    
    CGFloat scaling = MIN(rt.size.width / (float)w, rt.size.height / (float)h);
    
    w *= scaling;
    h *= scaling;
    
    x = (rt.size.width - w) / 2.0;
    y = (rt.size.height - h) / 2.0;
    
    _glkView = [[GLKView alloc] initWithFrame: CGRectMake(x, NAVIGATION_HEIGHT, w, RECORD_HEIGHT)];
    
#endif

    _myCameraViewHandler = [[CGECameraViewHandler alloc] initWithGLKView:_glkView];

    if([_myCameraViewHandler setupCamera: MYAVCaptureSessionPreset(RECORD_HEIGHT, RECORD_WIDTH) cameraPosition:AVCaptureDevicePositionFront isFrontCameraMirrored:YES authorizationFailed:^{
        NSLog(@"Not allowed to open camera and microphone, please choose allow in the 'settings' page!!!");
    }])
    {
        [[_myCameraViewHandler cameraDevice] startCameraCapture];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The Camera Is Not Allowed!"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [self.view addSubview:_glkView];
    _bottonFilterView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
    [self.view bringSubviewToFront:_bottonFilterView];
    CGRect scrollRT = rt;
    scrollRT.origin.y = scrollRT.size.height - 140;
    scrollRT.size.height = 50;
    _myScrollView = [[UIScrollView alloc] initWithFrame:scrollRT];
    
    CGRect frame = CGRectMake(0, 0, 95, 45);
    
    for(int i = 0; i != s_functionNum; ++i)
    {
        MyButton* btn = [[MyButton alloc] initWithFrame:frame];
        [btn setTitle:[NSString stringWithUTF8String:s_functionList[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [btn.layer setBorderColor:[UIColor redColor].CGColor];
        [btn.layer setBorderWidth:1.0f];
        btn.titleLabel.font = [UIFont fontWithName:@"MoskSemi-Bold600" size:16.0];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.alpha = 0.5;
//        [btn.layer setCornerRadius:11.0f];
        [btn setIndex:i];
        [btn addTarget:self action:@selector(functionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_myScrollView addSubview:btn];
        frame.origin.x += frame.size.width;
    }
    
    frame.size.width = 70;
    
//    for(int i = 0; i != g_configNum; ++i)
//    {
//        MyButton* btn = [[MyButton alloc] initWithFrame:frame];
//        
//        if(i == 0)
//            [btn setTitle:@"Origin" forState:UIControlStateNormal];
//        else
//            [btn setTitle:[NSString stringWithFormat:@"filter%d", i] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [btn.layer setBorderColor:[UIColor blueColor].CGColor];
//        [btn.layer setBorderWidth:1.5f];
//        [btn.layer setCornerRadius:10.0f];
//        [btn setIndex:i];
//        [btn addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_myScrollView addSubview:btn];
//        frame.origin.x += frame.size.width;
//    }
    
    _myScrollView.contentSize = CGSizeMake(frame.origin.x, 50);
    
    [self.view addSubview:_myScrollView];
    
    [CGESharedGLContext globalSyncProcessingQueue:^{
        [CGESharedGLContext useGlobalGLContext];
        void cgePrintGLInfo();
        cgePrintGLInfo();
    }];
    
    [_myCameraViewHandler fitViewSizeKeepRatio:YES];

    //Set to the max resolution for taking photos.
    [[_myCameraViewHandler cameraRecorder] setPictureHighResolution:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    _countDownTime = 40;
//    _countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 270, 100, 40)];
    _countdownLabel.text = @"00 : 40";
    _countdownLabel.textColor = [UIColor whiteColor];
    _countdownLabel.font = [UIFont fontWithName:@"MoskSemi-Bold600" size:20.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"view appear.");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"view disappear.");
}

-(UIImage *)loadImage : (NSURL*)url {
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
     time.value =  1.0;
    CGImageRef imgData = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    thumbnailVideo = [UIImage imageWithCGImage:imgData];
    return thumbnailVideo;
}

// This method will switch the camera postion Front to rear
-(IBAction) cameraSwitchButtonAction : (UIButton*)sender {
    [_myCameraViewHandler switchCamera :YES]; //Pass YES to mirror the front camera.
    
    CMVideoDimensions dim = [[[_myCameraViewHandler cameraDevice] inputCamera] activeFormat].highResolutionStillImageDimensions;
    NSLog(@"Max Photo Resolution: %d, %d\n", dim.width, dim.height);
}


// This method will check video recording is playing or not.
-(IBAction)videoRecordStartButtonAction: (UIButton*)sender {
    
    if([_myCameraViewHandler isRecording])
    {
        void (^finishBlock)(void) = ^{
            NSLog(@"End recording...\n");
            
            [CGESharedGLContext mainASyncProcessingQueue:^{
//                [sender setTitle:@"Rec OK" forState:UIControlStateNormal];
                [sender setEnabled:YES];
                [_videoTimer invalidate];
                _isVideoButtonSelected = false;
                _countdownLabel.text = nil;
                _videoButtonBG.backgroundColor = [UIColor colorWithRed:84.0/255.0 green:198.0/255.0 blue:231.0/255.0 alpha:1.0];
                [_videoButton setImage:[UIImage imageNamed:@"VideoCameraIcon"] forState:UIControlStateNormal];
                UIStoryboard *storyboardStop = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                XPVideoRecordingStopViewController  *stopView = [storyboardStop instantiateViewControllerWithIdentifier:@"XPVideoRecordingStopViewController"];
                stopView.videoFileURLPath = _movieURL;
                stopView.thumbImageView = thumbnailVideo;
                [self.navigationController pushViewController:stopView animated:true];
            }];
//            [DemoUtils saveVideo:_movieURL];
//            [self loadImage:_movieURL];
            
            
        };
        
        //        [_myCameraViewHandler endRecording:nil];
        //        finishBlock();
        [_myCameraViewHandler endRecording:finishBlock withCompressionLevel:0];
    }
    else
    {
        unlink([_movieURL.path UTF8String]);
        [_myCameraViewHandler startRecording:_movieURL size:CGSizeMake(RECORD_WIDTH, RECORD_HEIGHT)];
//        [sender setTitle:@"Recording" forState:UIControlStateNormal];
        [sender setEnabled:YES];
        _videoButtonBG.backgroundColor = [UIColor orangeColor];
        _isVideoButtonSelected = true;
        //        [_videoButton setBackgroundImage:[UIImage imageNamed:@"MicrophonePlayingImage"] forState:UIControlStateNormal];
        [_videoButton setImage:[UIImage imageNamed:@"MicrophonePlayingImage"] forState:UIControlStateNormal];
        _videoTimer = [[NSTimer alloc] init];
        _videoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTimer) userInfo:nil repeats:true];
    }
    
  /*  if(_isVideoButtonSelected) {
        [_videoTimer invalidate];
        _isVideoButtonSelected = false;
        _countdownLabel.text = nil;
        _videoButtonBG.backgroundColor = [UIColor colorWithRed:84.0/255.0 green:198.0/255.0 blue:231.0/255.0 alpha:1.0];
        [_videoButton setImage:[UIImage imageNamed:@"VideoCameraIcon"] forState:UIControlStateNormal];
        UIStoryboard *storyboardStop = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        XPVideoRecordingStopViewController  *stopView = [storyboardStop instantiateViewControllerWithIdentifier:@"XPVideoRecordingStopViewController"];
        stopView.videoFileURLPath = _movieURL;
        [self.navigationController pushViewController:stopView animated:true];
        
    } else {
        _videoButtonBG.backgroundColor = [UIColor orangeColor];
        _isVideoButtonSelected = true;
        //        [_videoButton setBackgroundImage:[UIImage imageNamed:@"MicrophonePlayingImage"] forState:UIControlStateNormal];
        [_videoButton setImage:[UIImage imageNamed:@"MicrophonePlayingImage"] forState:UIControlStateNormal];
        _videoTimer = [[NSTimer alloc] init];
        _videoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownTimer) userInfo:nil repeats:true];
        
        // Video will start record
        [sender setEnabled:NO];
        if([_myCameraViewHandler isRecording])
        {
            void (^finishBlock)(void) = ^{
                NSLog(@"End recording...\n");
                
                [CGESharedGLContext mainASyncProcessingQueue:^{
                    //                    [sender setTitle:@"Rec OK" forState:UIControlStateNormal];
                    [sender setEnabled:YES];
                }];
                
                // [DemoUtils saveVideo:_movieURL];
                
            };
            
            //        [_myCameraViewHandler endRecording:nil];
            //        finishBlock();
            [_myCameraViewHandler endRecording:finishBlock withCompressionLevel:0];
        }
        else
        {
            unlink([_movieURL.path UTF8String]);
            [_myCameraViewHandler startRecording:_movieURL size:CGSizeMake(RECORD_WIDTH, RECORD_HEIGHT)];
            // [sender setTitle:@"Recording" forState:UIControlStateNormal];
            [sender setEnabled:YES];
        }
        
    } */
        
    
}

-(void)videoRecordingStopButtonAction: (UIButton*)sender {
    
}

-(void)countDownTimer {
    
    if (_countDownTime > 0) {
        _countDownTime = _countDownTime - 1;
        NSString *countTimeString = [NSString stringWithFormat:@"%d", _countDownTime];
        _countdownLabel.text = [@"00 : " stringByAppendingString:countTimeString];
    } else {
        if([_myCameraViewHandler isRecording])
        {
            void (^finishBlock)(void) = ^{
                NSLog(@"End recording...\n");
                
                [CGESharedGLContext mainASyncProcessingQueue:^{
                    //                [sender setTitle:@"Rec OK" forState:UIControlStateNormal];
//                    [sender setEnabled:YES];
                    [_videoTimer invalidate];
                    _isVideoButtonSelected = false;
                    _countdownLabel.text = nil;
                    _videoButtonBG.backgroundColor = [UIColor colorWithRed:84.0/255.0 green:198.0/255.0 blue:231.0/255.0 alpha:1.0];
                    [_videoButton setImage:[UIImage imageNamed:@"VideoCameraIcon"] forState:UIControlStateNormal];
                    UIStoryboard *storyboardStop = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    XPVideoRecordingStopViewController  *stopView = [storyboardStop instantiateViewControllerWithIdentifier:@"XPVideoRecordingStopViewController"];
                    stopView.videoFileURLPath = _movieURL;
                    stopView.thumbImageView = thumbnailVideo;
                    [self.navigationController pushViewController:stopView animated:true];
                }];
//                [DemoUtils saveVideo:_movieURL];
//                [self loadImage:_movieURL];
                
                
            };
            
            //        [_myCameraViewHandler endRecording:nil];
            //        finishBlock();
            [_myCameraViewHandler endRecording:finishBlock withCompressionLevel:0];
        }
    }
    
}

- (void)filterButtonClicked: (MyButton*)sender
{
    _currentFilterIndex = [sender index];
    NSLog(@"Filter %d Clicked...\n", _currentFilterIndex);
    
    const char* config = g_effectConfig[_currentFilterIndex];
    [_myCameraViewHandler setFilterWithConfig:config];
}

- (void)setMask
{
    CGRect rt = [[UIScreen mainScreen] bounds];
    
    CGFloat x, y, w = RECORD_WIDTH, h = RECORD_HEIGHT;
    
    if([_myCameraViewHandler isUsingMask])
    {
        [_myCameraViewHandler setMaskUIImage:nil];
    }
    else
    {
        UIImage* img = [UIImage imageNamed:@"mask1.png"];
        w = img.size.width;
        h = img.size.height;
        [_myCameraViewHandler setMaskUIImage:img];        
    }
    
    float scaling = MIN(rt.size.width / (float)w, rt.size.height / (float)h);
    
    w *= scaling;
    h *= scaling;
    
    x = (rt.size.width - w) / 2.0;
    y = (rt.size.height - h) / 2.0;
    
    [_myCameraViewHandler fitViewSizeKeepRatio:YES];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
#if SHOW_FULLSCREEN
    
    [_glkView setFrame:rt];
    
#else
    
    [_glkView setFrame:CGRectMake(x, y, w, h)];
    
#endif
    
    [UIView commitAnimations];
}

#pragma mark - CGEFrameProcessingDelegate

- (BOOL)bufferRequestRGBA
{
    return NO;
}

// Draw your own content!
// The content would be shown in realtime, and can be recorded to the video.
- (void)drawProcResults:(void *)handler
{
    // unmark below, if you can use cpp. (remember #include "cgeImageHandler.h")
//    using namespace CGE;
//    CGEImageHandler* cppHandler = (CGEImageHandler*)handler;
//    cppHandler->setAsTarget();
    
    static float x = 0;
    static float dx = 10.0f;
    glEnable(GL_SCISSOR_TEST);
    x += dx;
    if(x < 0 || x > 500)
        dx = -dx;
    glScissor(x, 100, 200, 200);
    glClearColor(1, 0.5, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    glDisable(GL_SCISSOR_TEST);
}

//The realtime buffer for processing. Default format is YUV, and you can change the return value of "bufferRequestRGBA" to recieve buffer of format-RGBA.
- (BOOL)processingHandleBuffer:(CVImageBufferRef)imageBuffer
{
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [touches enumerateObjectsUsingBlock:^(UITouch* touch, BOOL* stop) {
        CGPoint touchPoint = [touch locationInView:_glkView];
        CGSize sz = [_glkView frame].size;
        CGPoint transPoint = CGPointMake(touchPoint.x / sz.width, touchPoint.y / sz.height);
        
        [_myCameraViewHandler focusPoint:transPoint];
        NSLog(@"touch position: %g, %g, transPoint: %g, %g", touchPoint.x, touchPoint.y, transPoint.x, transPoint.y);
    }];
}

- (void)switchTorchMode
{
    AVCaptureTorchMode mode[3] = {
        AVCaptureTorchModeOff,
        AVCaptureTorchModeOn,
        AVCaptureTorchModeAuto
    };
    
    static int torchModeIndex = 0;
    
    ++torchModeIndex;
    torchModeIndex %= 3;
    
    [_myCameraViewHandler setTorchMode:mode[torchModeIndex]];
}

- (void)switchResolution
{
    NSString* resolutionList[] = {
        AVCaptureSessionPresetPhoto,
        AVCaptureSessionPresetHigh,
        AVCaptureSessionPresetMedium,
        AVCaptureSessionPresetLow,
        AVCaptureSessionPreset352x288,
        AVCaptureSessionPreset640x480,
        AVCaptureSessionPreset1280x720,
        AVCaptureSessionPreset1920x1080,
        AVCaptureSessionPreset3840x2160,
        AVCaptureSessionPresetiFrame960x540,
        AVCaptureSessionPresetiFrame1280x720,
        AVCaptureSessionPresetInputPriority
    };

    static const int listNum = sizeof(resolutionList) / sizeof(*resolutionList);
    static int index = 0;

    if([[_myCameraViewHandler cameraDevice] captureSessionPreset] != resolutionList[index])
    {
        [_myCameraViewHandler setCameraSessionPreset:resolutionList[index]];
    }

    CMVideoDimensions dim = [[[_myCameraViewHandler cameraDevice] inputCamera] activeFormat].highResolutionStillImageDimensions;
    NSLog(@"Preset: %@, max resolution: %d, %d\n", [[_myCameraViewHandler cameraDevice] captureSessionPreset], dim.width, dim.height);

    [[_myCameraViewHandler cameraRecorder] setPictureHighResolution:YES];

    ++index;
    index %= listNum;
}

//This example shows how to record the specified area of your camera view.
- (void)cropRecording: (MyButton*)sender
{
    if([_myCameraViewHandler isRecording])
    {
        void (^finishBlock)(void) = ^{
            NSLog(@"End recording...\n");
            
            [CGESharedGLContext mainASyncProcessingQueue:^{
                [sender setTitle:@"录制完成" forState:UIControlStateNormal];
                [sender setEnabled:YES];
            }];
            
            [DemoUtils saveVideo:_movieURL];
            
        };
        [_myCameraViewHandler endRecording:finishBlock withCompressionLevel:2];
    }
    else
    {
        unlink([_movieURL.path UTF8String]);
        
        CGRect rts[] = {
            CGRectMake(0.25, 0.25, 0.5, 0.5), //Record a quarter of the camera view in the center.
            CGRectMake(0.5, 0.0, 0.5, 1.0), //Record the right (half) side of the camera view.
            CGRectMake(0.0, 0.0, 1.0, 0.5), //Record the up (half) side of the camera view.
        };
        
        CGRect rt = rts[rand() % sizeof(rts) / sizeof(*rts)];
        
        CGSize videoSize = CGSizeMake(RECORD_WIDTH * rt.size.width, RECORD_HEIGHT * rt.size.height);
        
        NSLog(@"Crop area: %g, %g, %g, %g, record resolution: %g, %g", rt.origin.x, rt.origin.y, rt.size.width, rt.size.height, videoSize.width, videoSize.height);
        
        [_myCameraViewHandler startRecording:_movieURL size:videoSize cropArea:rt];
        [sender setTitle:@"Rec stopped" forState:UIControlStateNormal];
        [sender setEnabled:YES];
    }
}

- (void)setCustomFilter:(CustomFilterType)type
{
    void* customFilter = cgeCreateCustomFilter(type, 1.0f, _myCameraViewHandler.cameraRecorder.sharedContext);
    [_myCameraViewHandler.cameraRecorder setFilterWithAddress:customFilter];
}

- (void)functionButtonClick: (MyButton*)sender
{
    NSLog(@"Function Button %d Clicked...\n", [sender index]);
    
    switch ([sender index])
    {
        case 0:
            [self setCustomFilter:CGE_CUSTOM_FILTER_0];
            break;
        case 1:
            [self setCustomFilter:CGE_CUSTOM_FILTER_1];
            break;
        case 2:
            [self setCustomFilter:CGE_CUSTOM_FILTER_2];
            break;
        case 3:
            [self setCustomFilter:CGE_CUSTOM_FILTER_3];
            break;
        case 4:
            [self setCustomFilter:CGE_CUSTOM_FILTER_4];
            break;
        case 5:
            _currentFilterIndex = [sender index];

            const char* config = g_effectConfig[0];
            [_myCameraViewHandler setFilterWithConfig:config];
            break;
        case 6:
            _currentFilterIndex = [sender index];
            
            const char* config1 = g_effectConfig[1];
            [_myCameraViewHandler setFilterWithConfig:config1];
            break;
        case 7:
            _currentFilterIndex = [sender index];
            
            const char* config2 = g_effectConfig[2];
            [_myCameraViewHandler setFilterWithConfig:config2];
            break;
        case 8:
            _currentFilterIndex = [sender index];
            
            const char* config3 = g_effectConfig[3];
            [_myCameraViewHandler setFilterWithConfig:config3];
            break;
        case 9:
            _currentFilterIndex = [sender index];
            
            const char* config4 = g_effectConfig[4];
            [_myCameraViewHandler setFilterWithConfig:config4];
            break;
        case 10:
            _currentFilterIndex = [sender index];
            
            const char* config5 = g_effectConfig[5];
            [_myCameraViewHandler setFilterWithConfig:config5];
            break;
        case 11:
            _currentFilterIndex = [sender index];
            
            const char* config6 = g_effectConfig[6];
            [_myCameraViewHandler setFilterWithConfig:config6];
            break;
        case 12:
            _currentFilterIndex = [sender index];
            
            const char* config7 = g_effectConfig[7];
            [_myCameraViewHandler setFilterWithConfig:config7];
            break;
//        case 13:
//            _currentFilterIndex = [sender index];
//            
//            const char* config8 = g_effectConfig[8];
//            [_myCameraViewHandler setFilterWithConfig:config8];
//            break;
        case 13:
            _currentFilterIndex = [sender index];
            
            const char* config8 = g_effectConfig[8];
            [_myCameraViewHandler setFilterWithConfig:config8];
            break;
//        case 15:
//            _currentFilterIndex = [sender index];
//            
//            const char* config10 = g_effectConfig[10];
//            [_myCameraViewHandler setFilterWithConfig:config10];
//            break;
        case 14:
            _currentFilterIndex = [sender index];
            
            const char* config9 = g_effectConfig[9];
            [_myCameraViewHandler setFilterWithConfig:config9];
            break;
        case 15:
            _currentFilterIndex = [sender index];
            
            const char* config10 = g_effectConfig[10];
            [_myCameraViewHandler setFilterWithConfig:config10];
            break;
        case 16:
            _currentFilterIndex = [sender index];
            
            const char* config11 = g_effectConfig[11];
            [_myCameraViewHandler setFilterWithConfig:config11];
            break;
        case 17:
            _currentFilterIndex = [sender index];
            
            const char* config12 = g_effectConfig[12];
            [_myCameraViewHandler setFilterWithConfig:config12];
            break;
        case 18:
            _currentFilterIndex = [sender index];
            
            const char* config13 = g_effectConfig[13];
            [_myCameraViewHandler setFilterWithConfig:config13];
            break;
            
        default:
            break;
    }
}

@end

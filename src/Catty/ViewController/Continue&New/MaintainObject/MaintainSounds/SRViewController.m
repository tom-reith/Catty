/**
 *  Copyright (C) 2010-2023 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

#import "SRViewController.h"
#import "UIDefines.h"
#import "CBFileManager.h"
#import "TimerLabel.h"
#import "Util.h"
#import "Pocket_Code-Swift.h"

@interface SRViewController ()
@property (nonatomic,strong)Sound *sound;
@property (nonatomic,strong)NSString *filePath;
@property (nonatomic,weak) IBOutlet TimerLabel* timerLabel;
@property (nonatomic,strong) AVAudioRecorder* recorder;
@property (nonatomic,strong) AVAudioSession* session;
@property (nonatomic,assign) BOOL isSaved;

@end

@implementation SRViewController

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(saveSound)];
    self.navigationController.toolbarHidden = YES;

    self.navigationItem.rightBarButtonItem = save;
    self.record.frame = CGRectMake(self.view.frame.size.width / 2.0 - (self.view.frame.size.height * 0.4 / 2.0f), self.view.frame.size.height * 0.4, self.view.frame.size.height * 0.4, self.view.frame.size.height * 0.4);
    
    self.timerLabel.timerType = TimerLabelTypeStopWatch;
    [self.view addSubview:self.timerLabel];
    self.timerLabel.timeLabel.backgroundColor = UIColor.clearColor;
    self.timerLabel.timeLabel.font = [UIFont systemFontOfSize:28.0f];
    self.timerLabel.timeLabel.textColor = UIColor.globalTint;
    self.timerLabel.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(recording:)];
    [self.timerLabel addGestureRecognizer:recognizer];
    
    self.view.backgroundColor = UIColor.background;
    
    self.isRecording = NO;
    self.isSaved = NO;
    [self prepareRecorder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.recorder stop];
    [self.timerLabel reset];
    [self.record setSelected:NO];
    self.recorder = nil;
    if (self.sound.name && !self.isSaved) {
        [self.delegate showSaveSoundAlert:self.sound];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Recorder

- (void)prepareRecorder
{
    CBFileManager *fileManager = [CBFileManager sharedManager];
    NSString *fileName =[[NSString uuid] stringByAppendingString:@".m4a"];
    self.filePath = [NSString stringWithFormat:@"%@/%@", fileManager.documentsDirectory, fileName];
    self.sound = [[Sound alloc] initWithName:fileName andFileName:fileName];
    NSURL* outputFileUrl = [NSURL fileURLWithPath:self.filePath isDirectory:NO];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc]init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    self.recorder = [[AVAudioRecorder alloc]initWithURL:outputFileUrl settings:recordSetting error:NULL];
    
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    
    [self.recorder prepareToRecord];
}

#pragma mark Tap/Click events

- (IBAction)recording:(id)sender {
    [self recordClicked];
}

- (void)recordClicked
{
    if (!self.isRecording) {
        [self.record setSelected:YES];
        [self.timerLabel start];
        self.isRecording = YES;
        [self.session setActive:YES error:nil];
        CBFileManager *fileManager = [CBFileManager sharedManager];
        [self.recorder recordForDuration:(([fileManager freeDiskspace]/1024ll)/256.0)];
        self.sound.name = kLocalizedRecording;
    } else {
        [self.recorder pause];
        [self.timerLabel pause];
        [self.record setSelected:NO];
        self.isRecording = NO;
    }
}

- (void)saveSound
{
    [self.recorder stop];
    [self.timerLabel reset];
    [self.record setSelected:NO];
    self.recorder = nil;
    if (self.sound.name) {
        [self.delegate addSound:self.sound];
    }
    self.isSaved = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (!flag) {
        [Util alertWithTitle:kLocalizedError andText:kLocalizedMemoryWarning];
    }
    [self.record setTitle:kLocalizedRecording forState:UIControlStateNormal];
}

@end

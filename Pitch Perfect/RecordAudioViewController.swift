//
//  ReacordAudioViewController.swift
//  Pitch Perfect
//
//  Created by X.I. Losada on 13/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var startRecordingButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        recordLabel.text = "Tap to Record"
        stopRecordingButton.hidden = true
        pauseRecordingButton.hidden = true
        pauseRecordingButton.setImage(UIImage(named: "pause"), forState: UIControlState())
        startRecordingButton.enabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton) {
        //Show text "Recording" and change the state of th UI elements
        recordLabel.text = "Recording"
        pauseRecordingButton.hidden = false
        stopRecordingButton.hidden = false
        startRecordingButton.enabled = false
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "voice_sample.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func toggleRecording(sender: UIButton) {
        //Allow to pause and resume recording.
        if(audioRecorder.recording){
            audioRecorder.pause()
            recordLabel.text = "Paused"
            pauseRecordingButton.setImage(UIImage(named: "record"), forState: UIControlState())
        }else{
            audioRecorder.record()
            recordLabel.text = "Recording"
            pauseRecordingButton.setImage(UIImage(named: "pause"), forState: UIControlState())
        }
    }
    @IBAction func stopRecording(sender: UIButton) {
        stopRecordingButton.hidden = true
        pauseRecordingButton.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //Called after the audio has been processed
        if(flag){
            recordedAudio = RecordedAudio(path: recorder.url,title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("finishRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "finishRecording"){
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
}


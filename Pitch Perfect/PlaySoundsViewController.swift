//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by X.I. Losada on 14/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {

    let _slowAudioRateValue: Float = 0.5;
    let _fastAudioRateValue: Float = 2.0;
    let _chipMunkPitchValue: Float = 1000;
    let _vaderPitchValue: Float = -600;
    let _wetDryMixValue: Float = 60;
    let _echoDelayValue: Float = 1;
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = try!
            AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resetPlayer(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playRatedAudio(rate: Float){
        resetPlayer()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        playAudioNode(changePitchEffect)
    }
    
    func playAudioWithEcho(delayTime: Float){
        //based on http://stackoverflow.com/questions/29619087
        let echoNode = AVAudioUnitDelay()
        echoNode.delayTime = NSTimeInterval(delayTime)
        playAudioNode(echoNode)
    }
    
    func playAudioWithReverb(wetDryMix: Float){
        //based on http://stackoverflow.com/questions/29619087
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = wetDryMix
        playAudioNode(reverbNode)
    }
    
    func playAudioNode(node: AVAudioNode){
        resetPlayer()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(node)
        audioEngine.connect(audioPlayerNode, to: node, format: nil)
        audioEngine.connect(node, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playRatedAudio(_slowAudioRateValue)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playRatedAudio(_fastAudioRateValue)
    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(_chipMunkPitchValue)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(_vaderPitchValue)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithEcho(_echoDelayValue)
    }
    
    @IBAction func playRebervAudio(sender: UIButton) {
        playAudioWithReverb(_wetDryMixValue)
    }
    
    @IBAction func stopSound(sender: AnyObject) {
        resetPlayer()
    }

}

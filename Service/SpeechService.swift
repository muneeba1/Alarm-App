//
//  SpeechService.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/7/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechService
{
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    var voiceToUse: AVSpeechSynthesisVoice = {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices
        {
            if voice.name == "Samantha (Enhanced)"  && voice.quality == .enhanced
            {
                return voice
            }
        }
        return AVSpeechSynthesisVoice.init()
    }()
    
    func speakString (text:String)
    {
        myUtterance = AVSpeechUtterance(string:text)
        myUtterance.rate = 0.4
        myUtterance.voice = voiceToUse
        synth.speak(myUtterance)
    }
}


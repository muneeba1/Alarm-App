//
//  SpeechService.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 8/7/17.
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
        let ud = UserDefaults.standard
        let language: String = ud.object(forKey: "language") as? String ?? "en-gb"
        for voice in voices
        {
            //            if  voice.quality == .enhanced && voice.language == language
            if voice.language == language
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
        myUtterance.voice?.name
    }
}


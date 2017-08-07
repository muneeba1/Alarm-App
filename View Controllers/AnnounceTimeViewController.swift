//
//  AnnounceTimeViewController.swift
//  Alarm App
//
//  Created by Muneeba Khatoon on 7/5/17.
//  Copyright © 2017 Muneeba Khatoon. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AnnounceTimeViewController: UIViewController
{
  
    //IBOutlets
    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var voicePickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem)
    {
        let ud = UserDefaults.standard
        ud.set(selectedVoiceLanguage, forKey: "language")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //variables
    var arrVoiceLanguages: [Dictionary<String, String?>] = []
    var selectedVoiceLanguage: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-gb"
    var selectedVoice: String = ""
    var languageDict: [String: String] = [:]
    //var language: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-gb"
    var keyArray: [String] = []
    var voices: [String: [String]] = [:]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // print(AVSpeechSynthesisVoice.speechVoices())
        
        prepareVoiceList()
    }
    
    func prepareVoiceList()
    {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language
            
            let languageName = (Locale.current as NSLocale).displayName(forKey: NSLocale.Key.identifier, value: voiceLanguageCode)
            
            print(languageName!)
            if voices[voiceLanguageCode] != nil
            {
                voices[voiceLanguageCode]?.append(voice.name)
            }
            else
            {
                voices[voiceLanguageCode] = [voice.name]
            }
            
            languageDict[languageName!] = voiceLanguageCode
            
            keyArray.append(languageName!)
            
            arrVoiceLanguages.append(languageDict)
            
        }
    }
    
}

extension AnnounceTimeViewController: UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView == languagePickerView
        {
            print(keyArray.count)
            return keyArray.count
        }
        else
        {
            return voices[selectedVoiceLanguage]!.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == languagePickerView
        {
            return keyArray[row]
        }
        else
        {
            print("NAMESRUBWUEB \(voices[selectedVoiceLanguage]![0])")
            return voices[selectedVoiceLanguage]![0]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView == languagePickerView
        {
            selectedVoiceLanguage = languageDict[keyArray[row]]!
            self.voicePickerView.reloadAllComponents()
        }
        else
        {
            selectedVoice = voices[selectedVoiceLanguage]![row]
        }
    }
    
}


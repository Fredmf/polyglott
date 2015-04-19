//
//  AppDelegate.swift
//  polyglott
//
//  Created by Fred Flügge on 19.04.15.
//  Copyright (c) 2015 Fred Flügge. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)//NSVariableStatusItemLength
    
    var voices = [voiceDoc]()
    var lastSender: NSMenuItem = NSMenuItem()
    
    
    
    func shell(args: String...) -> Int32 {
        let task = NSTask()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
    
    func switchVoice(name: String) {
        var voiceSynthID:Int = 0
        var voiceID:Int = 0
        
        for element in voices{
            if(element.data.name == name){
                voiceID = element.data.id
                voiceSynthID = element.data.synthID
            }
        }
        
        //change the settings
        let changeSettingString = "defaults write com.apple.speech.voice.prefs 'SelectedVoiceCreator' -int \(voiceSynthID);defaults write com.apple.speech.voice.prefs 'SelectedVoiceID' -int \(voiceID);defaults write com.apple.speech.voice.prefs 'SelectedVoiceName' -string " + name
        shell("sh","-c",changeSettingString)
        
        //restart the SpeechSynthesisServer --OK
        shell("killall","SpeechSynthesisServer")
        shell("open","/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/SpeechSynthesis.framework/Versions/A/SpeechSynthesisServer.app")
    }
    
    func scannVoices(){
        var counter = voices.count
        while (counter > 0) {
            statusMenu.removeItemAtIndex(0)
            counter--
        }
        
        voices = []
        let currentVoice = NSSpeechSynthesizer.defaultVoice()
        let currentVoiceAttributes = NSSpeechSynthesizer.attributesForVoice(currentVoice) as? Dictionary<String, AnyObject>
        let currentVoiceName = currentVoiceAttributes?["VoiceName"] as? String
        
        var voicesAvaliable = NSSpeechSynthesizer.availableVoices()
        var total = 0
        if let voicesList = voicesAvaliable as? [String] {
            for element in voicesList {
                let voiceAttributes = NSSpeechSynthesizer.attributesForVoice(element) as? Dictionary<String, AnyObject>
                let voiceLang = voiceAttributes?["VoiceLanguage"] as? String
                let voiceName = voiceAttributes?["VoiceName"] as? String
                let voiceID = voiceAttributes?["VoiceNumericID"] as? Int
                let voiceSynthID = voiceAttributes?["VoiceSynthesizerNumericID"] as? Int
                
                var voiceGender = voiceAttributes?["VoiceGender"] as? String //VoiceGenderFemale or VoiceGenderMale
                voiceGender = voiceGender!.stringByReplacingOccurrencesOfString("VoiceGenderFemale", withString: "f");
                voiceGender = voiceGender!.stringByReplacingOccurrencesOfString("VoiceGenderMale", withString: "m");
                voiceGender = voiceGender!.stringByReplacingOccurrencesOfString("VoiceGenderNeuter", withString: "");
    
                var isPremium = false
                if element.rangeOfString(".premium") != nil{
                    isPremium = true
                }
                
                if (isPremium){
                    voices.append(voiceDoc(name: voiceName!, gender: voiceGender!, lang: voiceLang!, id: voiceID!, synthID: voiceSynthID!))
                }
            }
        }
        var posIndex = 0
        for element in voices {
            var menuItem: NSMenuItem = NSMenuItem()
            menuItem.title = element.data.name
            menuItem.image = element.flag
            menuItem.target = self
            menuItem.action = Selector("menuClicked:")
            if (element.data.name == currentVoiceName){
                menuItem.state = NSOnState
                lastSender = menuItem
            }
            statusMenu.insertItem(menuItem, atIndex: posIndex)
            posIndex++
        }
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let icon = NSImage(named: "statusIcon")
        icon?.setTemplate(true)
        statusItem.image = icon
        statusItem.menu = statusMenu
        statusItem.highlightMode = true
        
        scannVoices()
    }

    @IBAction func refreshClicked(sender: NSMenuItem) {
        scannVoices()
        switchVoice("test")
    }
    @IBAction func quitClocked(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
    @IBAction func menuClicked(sender: NSMenuItem) {
        lastSender.state = NSOffState
        lastSender = sender
        sender.state = NSOnState
        switchVoice(sender.title)
    }
}


//
//  AppDelegate.swift
//  polyglott
//
//  Created by Fred Flügge on 19.04.15.
//  Copyright (c) 2015 Fred Flügge. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!

    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    private var voices: [voiceDoc] = []
    private var lastSender: NSMenuItem?

    @discardableResult
    private func shell(_ args: String...) -> Int32 {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        task.arguments = args

        do {
            try task.run()
            task.waitUntilExit()
            return task.terminationStatus
        } catch {
            NSLog("Failed to run command %@: %@", args.joined(separator: " "), error.localizedDescription)
            return -1
        }
    }

    private func switchVoice(name: String) {
        guard let voice = voices.first(where: { $0.data.name == name }) else {
            return
        }

        let escapedName = name.replacingOccurrences(of: "\"", with: "\\\"")
        let changeSettingString = "defaults write com.apple.speech.voice.prefs 'SelectedVoiceCreator' -int \(voice.data.synthID); defaults write com.apple.speech.voice.prefs 'SelectedVoiceID' -int \(voice.data.id); defaults write com.apple.speech.voice.prefs 'SelectedVoiceName' -string \"\(escapedName)\""

        _ = shell("sh", "-c", changeSettingString)

        _ = shell("killall", "SpeechSynthesisServer")
        _ = shell(
            "open",
            "/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/SpeechSynthesis.framework/Versions/A/SpeechSynthesisServer.app"
        )
    }

    private func scanVoices() {
        statusMenu.removeAllItems()
        voices.removeAll()

        let currentVoice = NSSpeechSynthesizer.defaultVoice
        let currentVoiceAttributes = currentVoice.flatMap { NSSpeechSynthesizer.attributes(forVoice: $0) }
        let currentVoiceName = currentVoiceAttributes?[NSSpeechSynthesizer.VoiceAttributeKey.name] as? String

        for voiceIdentifier in NSSpeechSynthesizer.availableVoices {
            guard
                let attributes = NSSpeechSynthesizer.attributes(forVoice: voiceIdentifier),
                let voiceLang = attributes["VoiceLanguage"] as? String,
                let voiceName = attributes["VoiceName"] as? String,
                let voiceID = attributes["VoiceNumericID"] as? NSNumber,
                let voiceSynthID = attributes["VoiceSynthesizerNumericID"] as? NSNumber
            else {
                continue
            }

            var voiceGender = (attributes["VoiceGender"] as? String) ?? ""
            voiceGender = voiceGender.replacingOccurrences(of: "VoiceGenderFemale", with: "f")
            voiceGender = voiceGender.replacingOccurrences(of: "VoiceGenderMale", with: "m")
            voiceGender = voiceGender.replacingOccurrences(of: "VoiceGenderNeuter", with: "")

            voices.append(
                voiceDoc(
                    name: voiceName,
                    gender: voiceGender,
                    lang: voiceLang,
                    id: voiceID.intValue,
                    synthID: voiceSynthID.intValue
                )
            )
        }

        voices.sort { $0.data.name.localizedCaseInsensitiveCompare($1.data.name) == .orderedAscending }

        for (index, element) in voices.enumerated() {
            let menuItem = NSMenuItem(title: element.data.name, action: #selector(menuClicked(sender:)), keyEquivalent: "")
            menuItem.image = element.flag
            menuItem.target = self

            if element.data.name == currentVoiceName {
                menuItem.state = .on
                lastSender = menuItem
            }

            statusMenu.insertItem(menuItem, at: index)
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.button?.image = icon
        statusItem.menu = statusMenu

        scanVoices()
    }

    @IBAction func refreshClicked(_ sender: NSMenuItem) {
        scanVoices()
    }

    @IBAction func quitClocked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    @IBAction func menuClicked(sender: NSMenuItem) {
        lastSender?.state = .off
        lastSender = sender
        sender.state = .on
        switchVoice(name: sender.title)
    }
}

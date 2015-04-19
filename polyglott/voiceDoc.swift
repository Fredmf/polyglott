//
//  voiceDoc.swift
//  polyglott
//
//  Created by Fred Flügge on 19.04.15.
//  Copyright (c) 2015 Fred Flügge. All rights reserved.
//

import Cocoa

class voiceDoc: NSObject {
    var data: voiceData
    var flag: NSImage?
    
    override init() {
        self.data = voiceData()
    }
    
    init(name: String, gender: String, lang: String, id: Int, synthID: Int){
        self.data = voiceData(name: name, gender: gender, lang: lang, id: id, synthID: synthID)
        switch lang {
        case "de-DE":
            flag = NSImage(named: "DE")
        case "ar":
            flag = NSImage(named: "SA")
        case "zh-Hans":
            flag = NSImage(named: "CN")
        case "zh-Hant":
            if(name=="Mei-Jia"){
                flag = NSImage(named: "TW")
            }else{
                flag = NSImage(named: "HK")
            }
        case "da-DK":
            flag = NSImage(named: "DK")
        case "en-AU":
            flag = NSImage(named: "AU")
        case "en-IE":
            flag = NSImage(named: "IE")
        case "en-US":
            if (name == "Fiona"){
                flag = NSImage(named: "GB-SCT")
            }else if(name == "Tessa"){
                flag = NSImage(named: "ZA")
            }else if(name == "Veena"){
                flag = NSImage(named: "INUK")
            }else{
                flag = NSImage(named: "US")
            }
        case "en-GB":
            flag = NSImage(named: "GB")
        case "fi-FI":
            flag = NSImage(named: "FI")
        case "fr-FR":
            flag = NSImage(named: "FR")
        case "fr-CA":
            flag = NSImage(named: "CA")
        case "el-GR":
            flag = NSImage(named: "GR")
        case "he-IL":
            flag = NSImage(named: "IL")
        case "hi-IN":
            flag = NSImage(named: "IN")
        case "id":
            flag = NSImage(named: "ID")
        case "it-IT":
            flag = NSImage(named: "IT")
        case "ja-JP":
            flag = NSImage(named: "JP")
        case "ko-KR":
            flag = NSImage(named: "KR")
        case "nl-BE":
            flag = NSImage(named: "BE")
        case "nl-NL":
            flag = NSImage(named: "NL")
        case "nb-NO":
            flag = NSImage(named: "NO")
        case "pl-PL":
            flag = NSImage(named: "PL")
        case "pt-BR":
            flag = NSImage(named: "BR")
        case "pt-PT":
            flag = NSImage(named: "PT")
        case "ro-RO":
            flag = NSImage(named: "RO")
        case "ru-RU":
            flag = NSImage(named: "RU")
        case "sv-SE":
            flag = NSImage(named: "SE")
        case "sk-SK":
            flag = NSImage(named: "SK")
        case "es-ES":
            if (name == "Diego"){
                flag = NSImage(named: "AR")
            }else if ((name == "Carlos") || (name == "Soledad") ){
                flag = NSImage(named: "CO")
            }else{
                flag = NSImage(named: "ES")
            }
        case "es-419":
            flag = NSImage(named: "MX")
        case "th-TH":
            flag = NSImage(named: "TH")	
        case "cs-CZ":
            flag = NSImage(named: "CZ")	
        case "tr-TR":
            flag = NSImage(named: "TR")	
        case "hu-HU":
            flag = NSImage(named: "HU")
            
        default:
            println("unknown Language")
        }
    }
}

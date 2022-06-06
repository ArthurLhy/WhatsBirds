//
//  AudioRecord.swift
//  WhatsBirds
//
//  Created by Hangyu Liu on 2022/5/8.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class  AudioRecord: NSObject,ObservableObject {
    
    let objectWillChange = PassthroughSubject<AudioRecord, Never>()
    var audioRecord: AVAudioRecorder!
    var records = [Recording]()
    
    var record = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    override init() {
        super.init()
        getRecords()
    }
    
    func startRecord(){
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        }
        catch {
            print("Recording failed at initialize state.")
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let now = Date.now
        let time = now.ISO8601Format()
        let audiofile = path.appendingPathComponent("\(time).wav")
        
        let audioFormat = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey:44100,
            AVNumberOfChannelsKey:1,
            AVVideoQualityKey:AVAudioQuality.high.rawValue
        ] as [String:Any]
        
        do {
            audioRecord = try AVAudioRecorder(url: audiofile, settings: audioFormat)
            audioRecord.record()
            record = true
        }
        catch {
            print("Recording failed")
        }
    }
    
    func stopRecord(){
        audioRecord.stop()
        record = false
        
        getRecords()
    }
    
    func getRecords(){
        records.removeAll()
        
        let fileManger = FileManager.default
        let path = fileManger.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let contents = try! fileManger.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        for content in contents {
            let recording = Recording(filepath: content, createTime: getDate(for: content))
            records.append(recording)
        }
        
        records.sort(by: {$0.createTime.compare($1.createTime) == .orderedDescending})
        objectWillChange.send(self)
    }
}

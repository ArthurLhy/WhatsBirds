//
//  Player.swift
//  WhatsBirds
//
//  Created by Hangyu Liu on 2022/5/19.
//

import Foundation
import SwiftUI
import Combine
import AVFAudio
import RosaKit
import TensorFlowLite

struct Result {
    let label: String
    let confidence:Float
}

class Player: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let birdsType = ["Red Crossbill", "Common Raven", "House Sparrow", "Northern Cardinal", "Barn Swallow", "House Wren", "Song Sparrow", "Gray-breasted Wood-Wren", "European Starling", "Spotted Towhee", "Curve-billed Thrasher", "Red-winged Blackbird", "Mallard", "American Robin", "Bewick's Wren", "Carolina Wren", "Swainson's Thrush", "Rufous-browed Peppershrike", "Brown-crested Flycatcher", "Rufous-collared Sparrow"]
    
    
    let objectWillChange = PassthroughSubject<Player, Never>()
    
    var player : AVAudioPlayer!
    
    var isPlay = false {
        didSet{
            objectWillChange.send(self)
        }
    }
    
    func startPlay(file: URL) {
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }
        catch {
            print("failed to play in speaker.")
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: file)
            player.play()
            isPlay = true
        }
        catch {
            print("Fail to play.")
        }
    }
    
    func stopPlay() {
        isPlay = false
        player.stop()
    }
    
    func showImage(file: URL) -> [Result] {
        let modelPath = Bundle.main.path(forResource: "mobile_model", ofType: "tflite")!
        
        var spectrograms = [[Double]]()
        do {
            let data = (try? Data(contentsOf: file))!
            let rawfile = try? WavFileManager().readWavFile(data: data)
            let dataCount = rawfile?.data.count ?? 0
            let sampleRate = rawfile?.sampleRate ?? 44100
            let bytesPerSample = rawfile?.bytesPerSample ?? 0
                        
            let chunksize = 7200000
            let chunksCount = dataCount/(chunksize*bytesPerSample) - 1
            let rawData = rawfile?.data.int16Array
            for index in 0..<chunksCount-1 {
                let samples = Array(rawData?[chunksize*index..<chunksize*(index+1)] ?? []).map { Double($0)}
                let powerSpectrogram = samples.melspectrogram(nFFT: 1024, hopLength: 941, sampleRate: Int(sampleRate), melsCount: 64).map { $0.normalizeAudioPower() }
                spectrograms.append(contentsOf: powerSpectrogram)
            }
        }

        do {
            
            let interpreter = try Interpreter(modelPath: modelPath)
            try interpreter.allocateTensors()
            for spectrogram in spectrograms {
                try interpreter.copy(withUnsafeBytes(of: spectrogram) { Data($0) }, toInputAt: 0)
                try interpreter.invoke()
                let outputTensor = try interpreter.output(at: 0)
                let outputSize = outputTensor.shape.dimensions.reduce(1, {x, y in x * y})
                let outputData = UnsafeMutableBufferPointer<Float32>.allocate(capacity: outputSize)
                let zippedResults = zip(birdsType.indices, outputData)
                let sortedResults = zippedResults.sorted { $0.1 > $1.1 }
                return sortedResults.map {result in Result(label: birdsType[result.0], confidence: result.1) }
            }
        } catch {
            print("interpreter loading failed.")
        }
        return [Result(label: "Swainson's Thrush", confidence: 0.0)]
    }
}

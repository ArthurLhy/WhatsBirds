//
//  Row.swift
//  WhatsBirds
//
//  Created by Hangyu Liu on 2022/5/19.
//

import SwiftUI
import Foundation

struct Row: View {
    
    var filePath: URL
    var audioRecord: AudioRecord
    
    var body: some View {
        VStack {
            Text("\(filePath.lastPathComponent)")
            NavigationLink(destination: SoundClassiferDetailView(audioRecord: audioRecord, filepath: filePath)) {
                
            }
            
        }
    }
}

struct SoundClassiferDetailView: View {
    var audioRecord: AudioRecord
    var filepath: URL
    @ObservedObject var player = Player()
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                Button (action: {}) {//
                    Image(systemName: "circle.fill")
                }
                Button(action: {
                    detailAlertView(filepath:filepath)
                    print("Show the detail of result")
                }) {
                    HStack {
                        Text("Show detail")
                            .font(.custom("Avenir-Medium", size: 20))
                            .foregroundColor(.white)
                    }
                }.frame(width: 220, height: 20).padding().background(Color.blue).cornerRadius(10.0)
                
                if player .isPlay == false {
                    Button(action: {
                        self.player.startPlay(file: filepath)
                    }) {
                        Image(systemName: "play.circle").imageScale(.large)
                    }
                }
                else {
                    Button(action: {
                        self.player.stopPlay()
                    }) {
                        Image(systemName: "stop.circle").imageScale(.large)
                    }
                }
            }
        }
        
    }
}

struct detailAlertView : View {
    
    var filepath : URL
    @ObservedObject var player = Player()
    
    var body: some View {
        VStack (spacing: 25) {
            let name = self.player.showImage(file: filepath)[0].label
            let confidence = String(self.player.showImage(file: filepath)[0].confidence) +  " confidence"
            Image(name)
            Text(confidence)
            Text(name)
            
        }
    }
}

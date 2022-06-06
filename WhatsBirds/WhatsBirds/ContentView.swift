//
//  ContentView.swift
//  WhatsBirds
//
//  Created by Hangyu Liu on 2022/5/8.
//
import Foundation
import SwiftUI


struct ContentView: View {
    @ObservedObject var audioRecord: AudioRecord
    
    var body: some View {
        
        Image("background")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .overlay(
            NavigationView {
                VStack {
                    RecordsList(audioRecord: audioRecord)
                    if audioRecord.record == false {
                        Button(action: {self.audioRecord.startRecord()}){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .padding(.horizontal, 10)
                            .foregroundColor(.green)
                            .clipped()
                        }
                    }
                    else {
                        Button(action: {self.audioRecord.stopRecord()}) {
                            Image(systemName: "stop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .padding(.horizontal, 10)
                                .foregroundColor(.red)
                                .clipped()
                        }
                    }
                }.navigationTitle("WhatsBirds")
            }.opacity(0.5))
        }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(audioRecord: AudioRecord())
    }
    let contentView = ContentView(audioRecord: AudioRecord())
    
}

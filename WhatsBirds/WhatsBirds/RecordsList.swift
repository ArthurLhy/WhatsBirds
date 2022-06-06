//
//  RecordsList.swift
//  WhatsBirds
//
//  Created by Hangyu Liu on 2022/5/16.
//

import SwiftUI

struct RecordsList: View {
    @ObservedObject var audioRecord: AudioRecord
    var body: some View {
        NavigationView {
            List {
                ForEach(audioRecord.records, id: \.createTime) {
                    Recording in Row(filePath: Recording.filepath, audioRecord: audioRecord)
                }
            }
        }
    }
}



struct RecordsList_Previews: PreviewProvider {
    static var previews: some View {
        RecordsList(audioRecord: AudioRecord())
    }
}

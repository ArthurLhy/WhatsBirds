//
//  WhatsBirdsApp.swift
//  WhatsBirds
//
//  Created by Hangyu Liu on 2022/5/8.
//

import SwiftUI

@main
struct WhatsBirdsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(audioRecord: AudioRecord())
        }
    }
}

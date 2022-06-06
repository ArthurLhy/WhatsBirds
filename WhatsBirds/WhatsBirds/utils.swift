//
//  utils.swift
//  WhatsBirds
//
//  Created by Hangyu Liu on 2022/5/19.
//

import Foundation

func getDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}

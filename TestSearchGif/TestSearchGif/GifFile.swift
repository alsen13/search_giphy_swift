//
//  GifFile.swift
//  TestSearchGif
//
//  Created by admin on 7/20/19.
//  Copyright © 2019 Alexey Sen. All rights reserved.
//

import Foundation

struct GifFile: Codable {
    var data: [Gif]
}

struct Gif: Codable {
    var images: OriginalStill
}

struct OriginalStill: Codable {
    var original_still: ResUrl
}

struct ResUrl: Codable {
    var url: String
}




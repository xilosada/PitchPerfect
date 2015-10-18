//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by X.I. Losada on 14/10/15.
//  Copyright © 2015 XiLosada. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    /*This model holds a NSURL and a title of one audio file*/
    var filePathUrl: NSURL!
    var title: String!
    
    init(path: NSURL, title: String){
        self.title = title
        filePathUrl = path
    }
}
//
//  Kanji.swift
//  Kanji Book 5
//
//  Created by Ivan on 10/08/2018.
//

import UIKit

class Kanji: NSObject {
    private var _section: Int
    private var _index: Int
    private var _image: String
    private var _meaning: String
    private var _onyomi: [String]
    private var _kunyomi: [String]
    private var _isLearned: Bool
    
    init(image: String,
         section: Int,
         index: Int,
         isLearned: Bool,
         meaning: String,
         onyomi: [String],
         kunyomi: [String]) {
        self._image = image
        self._section = section
        self._index = index
        self._isLearned = isLearned
        self._meaning = meaning
        self._onyomi = onyomi
        self._kunyomi = kunyomi
    }
    
    var section: Int {
        set{
            _section = newValue
        }
        get {
            return _section
        }
    }
    
    var index: Int {
        set{
            _index = newValue
        }
        get {
            return _index
        }
    }
    
    var image: String {
        set {
            _image = newValue
        }
        get {
            return _image
        }
    }
    
    var meaning: String {
        set {
            _meaning = newValue
        }
        get {
            return _meaning
        }
    }
    
    var onyomi: [String] {
        set {
            _onyomi = newValue
        }
        get {
            return _onyomi
        }
    }
    
    var kunyomi: [String] {
        set {
            _kunyomi = newValue
        }
        get {
            return _kunyomi
        }
    }
    
    var isLearned: Bool {
        set{
            _isLearned = newValue
        }
        get {
            return _isLearned
        }
    }
    
    
    
}

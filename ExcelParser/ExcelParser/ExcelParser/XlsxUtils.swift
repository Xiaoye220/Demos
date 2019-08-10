//
//  XlsxUtils.swift
//  XlsxReader
//
//  Created by YZF on 9/8/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation

class XlsxUtils {
    
    static let numTransAlphabet = [1: "A", 2: "B", 3: "C", 4: "D", 5: "E", 6: "F", 7: "G", 8: "H", 9: "I", 10: "J", 11: "K", 12: "L", 13: "M", 14: "N", 15: "O", 16: "P", 17: "Q", 18: "R", 19: "S", 20: "T", 21: "U", 22: "V", 23: "W", 24: "X", 25: "Y", 0: "Z"]
    
    static let alphabetTransNum = ["A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9, "J": 10, "K": 11, "L": 12, "M": 13, "N": 14, "O": 15, "P": 16, "Q": 17, "R": 18, "S": 19, "T": 20, "U": 21, "V": 22, "W": 23, "X": 24, "Y": 25, "Z": 26]
    
    /// 根据 row,column 获取 reference
    /// row = 10, column = 1 -> refenrence = A10
    class func RCToR(_ row: Int, column: Int) -> String {
        var result = String()
        var col = column
        
        while col > 26 {
            result = numTransAlphabet[col % 26]! + result
            col = (col -  1) / 26
        }
        result = numTransAlphabet[col % 26]! + result
        result = result + String(row)
        return result
    }
    
    /// 根据 reference 获取 row,column
    /// refenrence = A10 -> row = 10, column = 1
    class func RToRC(_ refernce: String) -> (row: Int, column: Int) {
        var row = 0
        var column = 0
        var rowIndex = 0
        let characters = Array(refernce)
        for (index, c) in characters.enumerated() {
            if let _ = Int(String(c)) {
                rowIndex = index
                break
            }
        }
        
        for i in 0 ..< rowIndex {
            column += Int(pow(Double(26), Double((rowIndex - i - 1)))) * alphabetTransNum[String(characters[i])]!
        }
        
        row = Int((refernce as NSString).substring(from: rowIndex))!
        
        return (row, column)
    }
    
}

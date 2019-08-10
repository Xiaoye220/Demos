//
//  XlsxUnzip.swift
//  XlsxReader
//
//  Created by YZF on 4/8/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation

class XlsxReader: NSObject, SSZipArchiveDelegate {
    
    static let shared = XlsxReader()
    
    let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    
    var cacheFilePath: String!
    
    func open(_ contentsOfFile: String) -> XlsxWorkbook {
        
        cacheFilePath = cacheDirectory + "/Xlsx/" + contentsOfFile.components(separatedBy: "/").last!

        SSZipArchive.unzipFile(atPath: contentsOfFile, toDestination: cacheFilePath)
        let workbook = XlsxXmlReader(cacheFilePath).readWorkbook()
        
        deleteCacheDirectory()
        
        return workbook
    }
    
    
    
    
    
    func deleteCacheDirectory() {
        
        if FileManager.default.fileExists(atPath: cacheFilePath) {
            do {
                try FileManager.default.removeItem(atPath: cacheFilePath)
            } catch {
                fatalError("file delete error")
            }
        }
    }
    
}

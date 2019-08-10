//
//  XlsxXmlReader.swift
//  XlsxReader
//
//  Created by YZF on 8/8/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import SwiftyXMLParser

class XlsxXmlReader {
    
    enum Path: String {
        case sharedStrings = "/xl/sharedStrings.xml"
        case workbook = "/xl/workbook.xml"
        case workbookRels = "/xl/_rels/workbook.xml.rels"
    }
    
    let rootPath: String
    
    var sharedStrings: [Int: String] = [:]
    
    init(_ rootPath: String) {
        self.rootPath = rootPath
    }
    
    func readWorkbook() -> XlsxWorkbook {
        readSharedStrings()
        
        var workbook = XlsxWorkbook()
        workbook.name = rootPath.components(separatedBy: "/").last
        workbook.sheets = readSheets()
        
        return workbook
    }
    
    func readSheets() -> [XlsxSheet] {
        var sheets: [XlsxSheet] = []
        
        let path = rootPath + Path.workbook.rawValue
        let xml: XML.Accessor
        
        do {
            let string = try String(contentsOfFile: path)
            xml = try XML.parse(string)
            //print(string)
        } catch  {
            fatalError("read workbook.xml error")
        }
        
        if let xmlSheets = xml["workbook"]["sheets"]["sheet"].all {
            for xmlSheet in xmlSheets {
                var sheet = XlsxSheet()
                sheet.name = xmlSheet.attributes["name"]
                sheet.rid = xmlSheet.attributes["r:id"]
                sheet.row = readRows(sheet.rid!)
                sheets.append(sheet)
            }
        }
        
        return sheets
    }
    
    
    func readRows(_ sheetRid: String) -> [XlsxRow] {
        var rows: [XlsxRow] = []
        
        let workbookRelsPath = rootPath + Path.workbookRels.rawValue
        let workbookRelsXml: XML.Accessor
        
        do {
            let string = try String(contentsOfFile: workbookRelsPath)
            workbookRelsXml = try XML.parse(string)
        } catch  {
            fatalError("read workbook.xml.rels error")
        }
        
        let xmlRels = workbookRelsXml["Relationships"]["Relationship"].all?.filter{ return $0.attributes["Id"] == sheetRid }.first
        
        // 根据 workbook.xml.rels 的 target 确定对应 sheet.xml
        if let target = xmlRels?.attributes["Target"] {
            let sheetPath = rootPath + "/xl/" + target

            let sheetXml: XML.Accessor

            do {
                let string = try String(contentsOfFile: sheetPath)
                sheetXml = try XML.parse(string)
            } catch  {
                fatalError("read sheet.xml error")
            }
            
            if let xmlRows = sheetXml["worksheet"]["sheetData"]["row"].all {
                for xmlRow in xmlRows {
                    var row = XlsxRow()
                    row.row = Int(xmlRow.attributes["r"]!)
                    row.cells = readCells(xmlRow)
                    if !row.cells.isEmpty {
                        rows.append(row)
                    }
                }
            }
        }
        
        return rows
    }
    
    
    func readCells(_ rowXml: XML.Element) -> [XlsxCell] {
        var cells: [XlsxCell] = []
        let xmlCells = rowXml.childElements.filter{ return $0.childElements.contains{$0.name == "v"} }
        for xmlCell in xmlCells {
            var cell = XlsxCell()
            if xmlCell.attributes["t"] == "s" {
                cell.value = sharedStrings[Int(xmlCell.childElements[0].text!)!]
            } else {
                cell.value = xmlCell.childElements[0].text
            }
            guard !cell.value!.isEmpty else {
                continue
            }
            cell.row = Int(rowXml.attributes["r"]!)
            cell.column = XlsxUtils.RToRC(xmlCell.attributes["r"]!).column
            cells.append(cell)
        }
        return cells
    }
    
    
    /// 读 sharedStrings.xml
    func readSharedStrings() {
        var strings: [String] = []
        
        let path = rootPath + Path.sharedStrings.rawValue
        let xml: XML.Accessor
        do {
            let string = try String(contentsOfFile: path)
            xml = try XML.parse(string)
        } catch  {
            fatalError("read sharedStrings.xml error")
        }
        for si in xml["sst"]["si"] {
            if let string = si["t"].text {
                strings.append(string)
            } else {
                var rString = String()
                for r in si["r"] {
                    if let string = r["t"].text {
                        rString = rString + string
                    }
                }
                strings.append(rString)
            }
        }
        
        for (index, string) in strings.enumerated() {
            sharedStrings[index] = string
        }
        
    }
    
    
}

//
//  XlsxEntity.swift
//  XlsxReader
//
//  Created by YZF on 9/8/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation

struct XlsxWorkbook {
    var name: String?
    var sheets: [XlsxSheet] = []
}

struct XlsxSheet {
    var name: String?
    var rid: String?
    var rows: [XlsxRow] = []
}


struct XlsxRow {
    var row: Int?
    var cells: [XlsxCell] = []
}

struct XlsxCell {
    var value: String?
    var row: Int?
    var column: Int?
}

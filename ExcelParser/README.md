### 原理

首先解压一个 .xlsx 文件，解压后获取的是多个 .xml 文件，再解析 xml 文件获取 excel 表格的信息保存到实体中

### 使用

```swift
let workbook = XlsxReader.shared.open(Bundle.main.path(forResource: "test", ofType: "xlsx")!)
```

**实体间的关系**
```swift
struct XlsxWorkbook {
    var name: String?
    var sheets: [XlsxSheet] = []
}

struct XlsxSheet {
    var name: String?
    var rid: String?
    var row: [XlsxRow] = []
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
```

### 注意

暂时没有实现解析 .xls 文件

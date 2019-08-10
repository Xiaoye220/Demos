### MemoryLayout

```swift
MemoryLayout<Int>.size           //8
MemoryLayout<Int>.alignment      //8
MemoryLayout<Int>.stride         //8

MemoryLayout<Int>.size:      Int 类型实际占用的内存大小 8 字节
MemoryLayout<Int>.alignment: Int 类型内存对其
MemoryLayout<Int>.stride:    实际占用内存大小 + 因为内存对其浪费的代销
```

#### unsafeMutablePointer

指向一个类型的指针
有地址和类型（所占内存的长度）,可以根据该指针获取指针指向的值。

#### unsafeMutableRawPointer
相当于 C 中的 void *
如果只做对指针的操作（比如遍历），可以转换成该指针类型操作，但是不能直接获取指针指向的值，需要转换成 unsafePointer 指针。


##### 自己开辟内存，创建指针：

```swift
// 开辟4个 Int 长度的地址
let intPointer = UnsafeMutablePointer<Int>.allocate(capacity: 4)
// 4个 Int 都初始化为 1
intPointer.initialize(to: 1, count: 4)
// 根据 intPointer 创建  UnsafeMutableBufferPointer<Int>，表示每 8 字节（Int长度）为一个元素。
let unsafeBufferPointer = UnsafeMutableBufferPointer.init(start: intPointer, count: 4)
// 遍历 unsafeBufferPointer，intPointer 地址为开始地址，每次遍历8字节
for bytes in unsafeBufferPointer.enumerated() {
    //print(bytes)
}
// 释放内存
intPointer.deallocate(capacity: 4)
```

##### 获取指定内容指针：

```swift
struct Person {
    var age: Int = 1

    var name: String = "Haha"

    // 指向 Person 类型的 第一个字节的指针
    mutating func headPointerOfStruct() -> UnsafeMutablePointer<Int8> {
        return withUnsafeMutablePointer(to: &self) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: MemoryLayout<Person>.stride)
    //      等价于
    //      return $0.withMemoryRebound(to: Int8.self, capacity: MemoryLayout<Person>.stride, { p in
    //            return p
    //      })
         }
    }

    // 指向整个 Person 类型的指针
    mutating func pointerOfStruct() -> UnsafeMutablePointer<Person> {
         return withUnsafeMutablePointer(to: &self) {
                return $0
         }
    }
}
```
```withUnsafeMutablePointer```: 获取某个数据的指针
```bindMemory```: 将 UnsafeMutableRawPointer 后长度为 MemoryLayout<Person>.stride 的内存 转换为 Int8 类型，即将一个结构体指针 cast 为一个 Int8 类型指针，通过这个方法可以获取结构体的每个字节。

```swift
var person = Person()

let pointer = person.headPointerOfStruct()

// 输出 1, person 第一个字节的内容，因为值是 1，没有超过 Int8 的范围，所以没出错，值大一点就会出错
pointer.pointee

// 输出 HaHa.
// 转换为 UnsafeMutableRawPointer 后偏移量为 8 个字节，截取 String 类型长度的 内存，所以值为 person 属性 name 的 值
UnsafeMutableRawPointer(pointer).advanced(by: 8).assumingMemoryBound(to: String.self).pointee
```
```assumingMemoryBound```:指针起始地址开始截取指定长度的内存


#### UnsafeRawBufferPointer：
标准库提供了一个更好的方法，那就是使用 withUnsafeBytes(of:body:) 函数，body 中能得到 UnsafeRawBufferPointer 对象，这是个什么鬼？Raw 在 Swift 中代表了 UInt8 类型，也就是为指定类型的指针类型，对其操作视为对字节的操作，Buffer 则提供了一系列操作数组的便利方法，例如你可以获取 count，也能生成迭代器，也支持 map、filter 等方法，犹如操作一个数组一样。

```swift
let _ = withUnsafeBytes(of: &person) { unsafeRawBufferPointer -> Bool in
    // person 占字节数，Int 占8字节，String 占24字节，共32字节
    unsafeRawBufferPointer.count

    // 等价于 UnsafeRawPointer(pointer)，获取 person 的 UnsafeRawPointer
    unsafeRawBufferPointer.baseAddress

    // 偏移量 8 字节获取一个 String 类型的值
    unsafeRawBufferPointer.load(fromByteOffset: 8, as: String.self)

    // 遍历每个字节
    for byte in unsafeRawBufferPointer.enumerated() {
        //print(byte)
    }

    return true
}

// 也可以通过下面方式获取 bufferPointer
let unsafeBufferPointer = UnsafeMutableBufferPointer.init(start: pointer, count: 32)
```
对于 Swift 的数组和序列对象，也可以转换成指针：
```swift
[1, 2, 3].withUnsafeBufferPointer { pointer -> Void in
    print(pointer.baseAddress) // 得到 UnsafePointer<Int> 对象
    print(pointer.first) // 得到起始地址指向的 Int 对象
}
```

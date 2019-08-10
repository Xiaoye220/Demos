//: Playground - noun: a place where people can play

import UIKit

// 开辟4个 Int 长度的地址
let intPointer = UnsafeMutablePointer<Int>.allocate(capacity: 4)
// 4个 Int 都初始化为 1
intPointer.initialize(to: 256, count: 4)
// 根据 intPointer 创建  UnsafeMutableBufferPointer<Int>，表示每 8 字节（Int长度）为一个元素。
let unsafeBufferPointer = UnsafeMutableBufferPointer.init(start: intPointer, count: 4)
// 遍历 unsafeBufferPointer，intPointer 地址为开始地址，每次遍历8字节
for bytes in unsafeBufferPointer.enumerated() {
    //print(bytes)
}
// 释放内存
intPointer.deallocate(capacity: 4)

struct Person {
    var age: Int = 1
    
    var name: String = "Haha"
    
    //var name: String = "Haha"
    
    // 指向 Person 类型的 第一个字节的指针
    mutating func headPointerOfStruct() -> UnsafeMutablePointer<Int8> {
        return withUnsafeMutablePointer(to: &self) {
//            return $0.withMemoryRebound(to: Int8.self, capacity: MemoryLayout<Person>.stride, { p in
//                return p
//            })
            return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: MemoryLayout<Person>.stride)
        }
    }
    
    // 指向整个 Person 类型的指针
    mutating func pointerOfStruct() -> UnsafeMutablePointer<Person> {
        return withUnsafeMutablePointer(to: &self) {
            return $0
        }
    }
}


var person = Person()
let pointer = person.headPointerOfStruct()
// Person 第一个字节的值
pointer.pointee
// Person 第八字节 后一个 String 类型长度的值。先将指针转换为 UnsafeMutableRawPointer 指针。
UnsafeMutableRawPointer(pointer).advanced(by: 8).assumingMemoryBound(to: String.self).pointee

// 指向整个 Person 类型的指针
let pointer2 = person.pointerOfStruct()

// 整个 person 的值
pointer2.pointee
// 将指针转换为 UnsafeMutableRawPointer 指针，值和 UnsafeMutableRawPointer(pointer) 相同
let rawPointer2 = UnsafeMutableRawPointer(pointer2)

let _ = withUnsafeBytes(of: &person) { unsafeRawBufferPointer -> Bool in
    // person 占字节，Int 占8字节，String 占24字节
    unsafeRawBufferPointer.count
    // Person 类型占字节
    MemoryLayout<Person>.size

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

// 也可以通过下面方式获取 bufferPointer，UnsafeMutableBufferPointer<Int8>
let unsafeBufferPointer2 = UnsafeMutableBufferPointer.init(start: pointer, count: 32)




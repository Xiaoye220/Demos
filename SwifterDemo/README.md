
## 使用
* 运行程序
* 根据提示在浏览器输入地址
* 在页面添加文件、上传
* 在手机沙盒 Caches 文件夹可以看到上传的文件


## 过程详解

### 创建一个 HttpServer
```swift
let server = HttpServer()
```
### 设置创建的 server
```swift
server["/:path"] = shareFilesFromDirectory(Bundle.main.resourcePath!, defaults: ["index.htm"])

server.middleware.append { r in
    print("Middleware: \(r.address ?? "unknown address") -> \(r.method) -> \(r.path)")
    return nil
}

server[""] = scopes {
    _ = self.server.routes
}

server.GET["/getName"] = { r in
    let name = UIDevice.current.name
    return HttpResponse.ok(.text(name))
}

server.POST["/upload"] = { r in
    var file = ""
    var size = ""
    for multipart in r.parseMultiPartFormData() {
        guard let fileName = multipart.fileName else { continue }
        let data = Data.init(bytes: multipart.body)
        print(data.count)
        
        do {
            try (Data.init(bytes: multipart.body)).write(to: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName))
            
        } catch  {
            print("error")
        }
        file = fileName
        size = String(multipart.body.count)
    }
    return .movedPermanently("http://localhost:8080/result.htm?fileName=\(file)&size=\(size)")
}
```

一个个讲解上面的设置都是什么意思，ip地址均用 localhost:8080 表示

#### 1）server["/:path”] 
比如访问 localhost:8080/upload.htm 那么就是访问服务器 Bundle.main.resourcePath 路劲下的 upload.htm 文件，
Defaults 为 “index.htm” 表示 访问 localhost:8080 那么就是访问服务器 Bundle.main.resourcePath 路劲下的 index.htm 文件

#### 2)  server.middleware 
中转站，所有请求都会经过这个，可以在其中 输出 log，方便调试

#### 3）server[“"]
这里面需要 执行一下 self.server.routes ，否则访问不了 localhost:8080 

#### 4）server.GET["/getName”] 
执行一个 get 请求，返回一个 text
即  localhost:8080/getName，执行 闭包中的代码，返回一个 内容为设备名字的 text

#### 5)   server.POST["/upload"]
执行一个 post 请求
闭包中执行的是 将页面上传的 file 的 Data 保存到手机服务端本地，然后跳转到 localhost:8080/result.htm?fileName=\(file)&size=\(size) 

### 3.开启关闭服务器
```swift
// 开启
do {
    try server.start(8080)
} catch {
    print("Server start error: \(error)")
}
// 关闭
server.stop()
```

### 4.注意
swfiter 没有更新到 swift 4.0，通过 CocoaPods 装好后需要进行修改 (时间：2017/12/15)

除了一处是 error，其他都是 warning

**error：Scopes.swift 730 行**
```swift
output = output + mergedAttributes.reduce("") {   
    /* 原来的
    if let value = $0.1.1 {
        return $0.0 + " \($0.1.0)=\"\(value)\""
    } else {
        return $0.0
    }
    */

    // 修改后
    if let value = $1.1 {
        return $0 + " \($1.0)=\"\(value)\""
    } else {
        return $0
    }
}
```

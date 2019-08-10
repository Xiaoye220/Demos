//
//  Server.swift
//  SwifterDemo
//
//  Created by YZF on 1/9/17.
//  Copyright © 2017年 Xiaoye. All rights reserved.
//

import Foundation
import Swifter

protocol UploadDelegate: class {
    func didUploade(fileName: String, size: String)
}

class UploadServer {
    
    weak var delegate: UploadDelegate?
    
    let server = HttpServer()
    
    init() {
        setupServer()
    }
    
    func setupServer() {
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
                
                file = fileName
                size = String(multipart.body.count)
                
                do {
                    try (Data.init(bytes: multipart.body)).write(to: FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName))
                    
                    self.delegate?.didUploade(fileName: file, size: size)
                } catch  {
                    print("error")
                }
            }
            return .movedPermanently("http://localhost:8080/result.htm?fileName=\(file)&size=\(size)")
        }
        
    }
    
}

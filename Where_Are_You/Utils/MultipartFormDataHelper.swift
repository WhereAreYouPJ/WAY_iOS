//
//  File.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/8/2024.
//

import Moya
import UIKit

class MultipartFormDataHelper {
    
    static func createMultipartData<T: Codable>(from request: T, images: [UIImage]?) -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        
        // JSON 데이터를 전체 하나의 필드로 추가
        if let requestData = try? JSONEncoder().encode(request) {
            let requestFormData = MultipartFormData(provider: .data(requestData), name: "request", mimeType: "application/json")
            multipartData.append(requestFormData)
        }
        
        // UIImage 배열을 feedImageList로 변환하여 추가
        if let images = images {
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    let fileName = "image\(index).jpg"
                    let formData = MultipartFormData(provider: .data(imageData), name: "feedImageList", fileName: fileName, mimeType: "image/jpeg")
                    multipartData.append(formData)
                }
            }
        }
        
        return multipartData
    }
}

//    static func createMultipartData<T: Codable>(from request: T, images: [UIImage]?) -> [MultipartFormData] {
//        var multipartData: [MultipartFormData] = []
//
//        // UIImage 배열을 MultipartFormData로 변환하여 추가
//        if let images = images {
//            for (index, image) in images.enumerated() {
//                if let imageData = image.jpegData(compressionQuality: 1.0) {
//                    let fileName = "image\(index).jpg"
//                    let formData = MultipartFormData(provider: .data(imageData), name: "images[]", fileName: fileName, mimeType: "image/jpeg")
//                    multipartData.append(formData)
//                }
//            }
//        }
//
//        // 텍스트 데이터를 MultipartFormData로 추가
//        if let parameters = try? JSONEncoder().encode(request),
//           let jsonObject = try? JSONSerialization.jsonObject(with: parameters, options: []),
//           let jsonDict = jsonObject as? [String: Any] {
//            for (key, value) in jsonDict {
//                let data: Data?
//                if let stringValue = value as? String {
//                    data = stringValue.data(using: .utf8)
//                } else if let intValue = value as? Int {
//                    data = String(intValue).data(using: .utf8)
//                } else {
//                    continue
//                }
//
//                if let data = data {
//                    let formData = MultipartFormData(provider: .data(data), name: key)
//                    multipartData.append(formData)
//                }
//            }
//        }
//
//        return multipartData
//    }
//}

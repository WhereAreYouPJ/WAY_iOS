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
    
    static func createMultipartData<T: Codable>(from request: T, images: UIImage) -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        
        // JSON 데이터를 전체 하나의 필드로 추가
        if let requestData = try? JSONEncoder().encode(request) {
            let requestFormData = MultipartFormData(provider: .data(requestData), name: "memberSeq", mimeType: "application/json")
            multipartData.append(requestFormData)
        }
        
        // UIImage 배열을 feedImageList로 변환하여 추가
        
                if let imageData = images.jpegData(compressionQuality: 1.0) {
                    let fileName = "image.jpg"
                    let formData = MultipartFormData(provider: .data(imageData), name: "images", fileName: fileName, mimeType: "image/jpeg")
                    multipartData.append(formData)
                }
        
        return multipartData
    }
}

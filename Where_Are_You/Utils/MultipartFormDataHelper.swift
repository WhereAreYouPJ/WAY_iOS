//
//  File.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/8/2024.
//

import UIKit
import Moya

class MultipartFormDataHelper {
    /// UIImage를 멀티파트 폼 데이터로 변환
    /// - Parameters:
    ///   - image: 전송할 UIImage
    ///   - name: 서버에서 이미지 파일을 받을 때 사용하는 필드 이름
    ///   - fileName: 서버에 업로드할 때 사용되는 파일 이름
    /// - Returns: Moya의 MultipartFormData 배열
    static func createMultipartData(from image: UIImage, name: String, fileName: String = "image.jpg") -> [MultipartFormData] {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return []
        }
        
        let multipartData = MultipartFormData(provider: .data(imageData), name: name, fileName: fileName, mimeType: "image/jpeg")
        return [multipartData]
    }
}

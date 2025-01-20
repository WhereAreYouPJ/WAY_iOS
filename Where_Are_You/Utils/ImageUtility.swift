//
//  ImageUtility.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/8/2024.
//

import UIKit

class ImageUtility {
    // 이미지를 Base64 문자열로 인코딩
    static func encodeImageToBase64String(_ image: UIImage) -> String? {
        guard let imageData = image.pngData() else { return nil }
        return imageData.base64EncodedString()
    }
    
    // Base64 문자열을 이미지로 디코딩
    static func decodeBase64StringToImage(_ base64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64String) else { return nil }
        return UIImage(data: imageData)
    }
}

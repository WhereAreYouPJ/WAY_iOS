//
//  ImageLoader.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/11/2024.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // 캐시 확인
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            completion(cachedImage)
            return
        }
        
        // URL 생성
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // 비동기 요청
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            // 캐시에 저장
            self.cache.setObject(image, forKey: urlString as NSString)
            
            // UI 업데이트
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

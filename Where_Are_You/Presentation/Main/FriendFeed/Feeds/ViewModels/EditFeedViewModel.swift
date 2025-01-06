//
//  EditFeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/1/2025.
//

import UIKit

class EditFeedViewModel {
    private let editFeedUseCase: EditFeedUseCase
    
    private var participants: [String] = [] // 참가자 이름을 저장할 배열
    private var schedules: [ScheduleContent] = []

    var selectedImages: [UIImage] = []
    var onEditFeed: (() -> Void)?
    
    // MARK: - Lifecycle
    init(editFeedUseCase: EditFeedUseCase) {
        self.editFeedUseCase = editFeedUseCase
    }
    
    // MARK: - Helpers
    func editFeed(feedSeq: Int, title: String, content: String?) {
        let feedImageOrders = Array(0..<selectedImages.count)
        
        let request = ModifyFeedRequest(feedSeq: feedSeq,
                                        memberSeq: UserDefaultsManager.shared.getMemberSeq(),
                                        title: title,
                                        content: content,
                                        feedImageOrders: feedImageOrders)
        
        editFeedUseCase.execute(request: request, images: selectedImages) { result in
            switch result {
            case .success:
                self.onEditFeed?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

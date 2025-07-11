//
//  FeedOptionsHandler.swift
//  Where_Are_You
//
//  Created by 오정석 on 14/12/2024.
//

import UIKit

class FeedOptionsHandler {
    static func showOptions(
        in parentView: UIView,
        frame: CGRect,
        isAuthor: Bool,
        isArchive: Bool,
        feed: Feed,
        deleteAction: @escaping () -> Void,
        editAction: @escaping () -> Void,
        hideAction: @escaping () -> Void
    ) -> MultiCustomOptionsContainerView {
        // Create options view
        let optionsView = MultiCustomOptionsContainerView()
        let titles: [String]
        let actions: [() -> Void]

        if isArchive {
            if isAuthor {
                titles = ["피드 삭제", "피드 복원"]
                actions = [deleteAction, hideAction]
            } else {
                titles = ["피드 복원"]
                actions = [hideAction]
            }
        } else {
            if isAuthor {
                titles = ["피드 삭제", "피드 수정", "피드 숨김"]
                actions = [deleteAction, editAction, hideAction]
            } else {
                titles = ["피드 숨김"]
                actions = [hideAction]
            }
        }

        // Configure options
        optionsView.configureOptions(titles: titles, actions: actions)
        optionsView.layer.cornerRadius = LayoutAdapter.shared.scale(value: 10)
        optionsView.clipsToBounds = true

        // Add to parent view
        parentView.addSubview(optionsView)

        let convertedFrame = parentView.convert(frame, from: nil)
        optionsView.snp.makeConstraints { make in
                make.top.equalTo(convertedFrame.maxY)
                make.trailing.equalToSuperview().inset(11)
                make.width.equalTo(LayoutAdapter.shared.scale(value: 160))
                make.height.equalTo(LayoutAdapter.shared.scale(value: CGFloat(41 * titles.count)))
            }
        
//        optionsView.snp.makeConstraints { make in
//            make.top.equalTo(frame.maxY)
//            make.top.equalTo(frame.origin.y + frame.height)
//            make.width.equalTo(LayoutAdapter.shared.scale(value: 160))
//            make.trailing.equalToSuperview().inset(11)
//            make.height.equalTo(LayoutAdapter.shared.scale(value: CGFloat(41 * titles.count)))
//        }

        // Trigger layout update
        parentView.layoutIfNeeded() // 레이아웃 강제 업데이트
        return optionsView
    }
}

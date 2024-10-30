//
//  handleOutsideTap.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/10/2024.
//

import UIKit
import ObjectiveC

extension UIView {
    func hideWhenTappedOutside(ignoreViews: [UIView] = [], onOutsideTap: @escaping () -> Void) {
        // 탭 제스처가 이미 추가되어 있는지 확인
        if objc_getAssociatedObject(self, &AssociatedKeys.tapGesture) == nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
            tapGesture.cancelsTouchesInView = false
            self.addGestureRecognizer(tapGesture)
            objc_setAssociatedObject(self, &AssociatedKeys.tapGesture, tapGesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        // 뷰와 동작 저장
        objc_setAssociatedObject(self, &AssociatedKeys.ignoreViews, ignoreViews, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &AssociatedKeys.onOutsideTap, onOutsideTap, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        guard let ignoreViews = objc_getAssociatedObject(self, &AssociatedKeys.ignoreViews) as? [UIView],
              let onOutsideTap = objc_getAssociatedObject(self, &AssociatedKeys.onOutsideTap) as? () -> Void else { return }
        
        let location = sender.location(in: self)
        
        // isHidden이 false인 뷰들만 체크
        if ignoreViews.contains(where: { !$0.isHidden && $0.frame.contains(location) }) {
            return
        }
        
        onOutsideTap()
    }
}

private struct AssociatedKeys {
    static var ignoreViews = "ignoreViews"
    static var onOutsideTap = "onOutsideTap"
    static var tapGesture = "tapGesture"
}

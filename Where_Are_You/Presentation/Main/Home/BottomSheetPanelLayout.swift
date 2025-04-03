//
//  BottomSheetPanelLayout.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/3/2025.
//

import FloatingPanel

class BottomSheetPanelLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition {
        return .bottom
    }

    var initialState: FloatingPanelState {
        return .tip
    }

    var anchors: [FloatingPanel.FloatingPanelState : any FloatingPanel.FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelLayoutAnchor(absoluteInset: 34, edge: .bottom, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(absoluteInset: LayoutAdapter.shared.scale(value: 420), edge: .bottom, referenceGuide: .safeArea)
        ]
    }
}

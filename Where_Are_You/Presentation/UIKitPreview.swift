//
//  UIKitPreview.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/8/2024.
//

// MARK: - uikitpreview

import SwiftUI
#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

#if DEBUG
struct VCPreView: PreviewProvider {
    static var previews: some View {
        AddFeedViewController().toPreview()
    }
}
#endif

//
//  GradientButton.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/1/2025.
//

import UIKit
class GradientButton: UIButton {
    private var gradientBorderColors: [CGColor] = []
    private var gradientBorderLineWidth: CGFloat = 0
    func applyGradientBackground(colors: [CGColor]) {
        // 기존 레이어 제거
        layer.sublayers?.filter { $0.name == "gradientBackground" }.forEach { $0.removeFromSuperlayer() }
        
        // 그라데이션 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientBackground"
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func applyGradientBorder(colors: [CGColor], lineWidth: CGFloat) {
        gradientBorderColors = colors
        gradientBorderLineWidth = lineWidth
        updateGradientBorder()
    }

    private func updateGradientBorder() {
        // 기존 레이어 제거
        layer.sublayers?.filter { $0.name == "gradientBorder" }.forEach { $0.removeFromSuperlayer() }

        // 그라데이션 경계 레이어 추가
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gradientBorder"
        gradientLayer.colors = gradientBorderColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = bounds

        // 모양을 따라 그리는 마스크 생성
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shapeLayer.lineWidth = gradientBorderLineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        
        print("Gradient Border Layer Frame: \(gradientLayer.frame)")
        
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientBorder() // 레이아웃이 완료된 후에 경계 업데이트
    }
}

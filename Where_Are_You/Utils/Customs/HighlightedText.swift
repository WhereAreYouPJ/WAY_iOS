//
//  HighlightedText.swift
//  Where_Are_You
//
//  Created by juhee on 30.03.25.
//

import SwiftUI

struct HighlightedText: View {
    let text: String
    let highlightText: String
    let highlightColor: Color
    
    var body: some View {
        if highlightText.isEmpty {
            Text(text)
        } else {
            highlightedText
        }
    }
    
    private var highlightedText: Text {
        do {
            // 검색어를 정규식에 사용하기 위해 특수문자 처리
            let pattern = escapeRegexPattern(highlightText)
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let range = NSRange(text.startIndex..., in: text)
            let matches = regex.matches(in: text, options: [], range: range)
            
            if matches.isEmpty {
                return Text(text)
            }
            
            var segments: [Text] = []
            var currentIndex = text.startIndex
            
            for match in matches {
                guard let matchRange = Range(match.range, in: text) else { continue }
                
                // 일치하는 부분 이전 텍스트 추가
                if currentIndex < matchRange.lowerBound {
                    let beforeMatch = String(text[currentIndex..<matchRange.lowerBound])
                    segments.append(Text(beforeMatch))
                }
                
                // 일치하는 부분을 파란색으로 강조
                let matchText = String(text[matchRange])
                segments.append(Text(matchText).foregroundColor(highlightColor))
                
                currentIndex = matchRange.upperBound
            }
            
            // 마지막 일치 부분 이후 남은 텍스트 추가
            if currentIndex < text.endIndex {
                let remainingText = String(text[currentIndex..<text.endIndex])
                segments.append(Text(remainingText))
            }
            
            return segments.reduce(Text(""), { $0 + $1 })
        } catch {
            return Text(text)
        }
    }
    
    // 정규식 특수문자 이스케이프 처리
    private func escapeRegexPattern(_ string: String) -> String {
        return string.replacingOccurrences(of: "[.*+?^${}()|[\\]\\\\]", with: "\\\\$0", options: .regularExpression)
    }
}

#Preview {
    HighlightedText(text: "안녕하세요", highlightText: "안녕", highlightColor: .brandDark)
}

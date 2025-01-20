//
//  EditFeedView.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/1/2025.
//

import Foundation

class EditFeedView: AddFeedView {
    
    func configureUI(feed: Feed) {
        // 선택된 일정 정보에 맞춰 라벨 보이기 설정
        scheduleDropDown.scheduleDateLabel.isHidden = false
        scheduleDropDown.scheduleLocationLabel.isHidden = false
        scheduleDropDown.chooseScheduleLabel.isHidden = true
        scheduleDropDown.scheduleDropDownView.isEnabled = true
        scheduleDropDown.dropDownButton.isHidden = true
        
        // 선택된 일정의 정보로 label 업데이트
        let dateParts = feed.startTime.prefix(10).split(separator: "-")
        if dateParts.count == 3 {
            let year = "\(dateParts[0])."  // 연도
            let monthDay = "\(dateParts[1]).\(dateParts[2])"  // 월.일
            
            // 두 줄로 날짜 표시
            scheduleDropDown.scheduleDateLabel.text = "\(year)\n\(monthDay)"
        }
        scheduleDropDown.scheduleLocationLabel.text = feed.location
        
        titleTextField.text = feed.title
        if feed.content == "" {
            contentTextView.textColor = .color118
            contentTextView.text = "어떤 일이 있었나요?"
        } else {
            contentTextView.textColor = .color34
            contentTextView.text = feed.content
        }
    }
}

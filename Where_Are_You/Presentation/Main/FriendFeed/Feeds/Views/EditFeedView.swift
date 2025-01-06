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
        
        scheduleDropDown.scheduleDateLabel.text = feed.startTime.prefix(10).replacingOccurrences(of: "-", with: ".")
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

//
//  ButtonMergeView.swift
//  Where_Are_You
//
//  Created by juhee on 09.04.25.
//

import SwiftUI

struct ButtonMergeView<T>: View {
    @State var isAccepted = false
    @State var showMergedButton = false
    
    // 데이터 객체
    let data: T
    
    // 커스터마이징 가능한 텍스트와 색상
    let acceptButtonTitle: String
    let refuseButtonTitle: String
    let acceptButtonColor: Color
    let refuseButtonColor: Color
    let acceptButtonTextColor: Color
    let refuseButtonTextColor: Color
    
    // 크기 관련 매개변수
    let buttonWidth: CGFloat?     // 각 버튼의 너비 (nil이면 자동 계산)
    let buttonHeight: CGFloat     // 버튼의 높이
    
    // 콜백 함수
    var onAccept: (T) -> Void
    var onRefuse: (T) -> Void
    
    // 초기화 메서드
    init(
        data: T,
        acceptButtonTitle: String = "수락하기",
        refuseButtonTitle: String = "거절하기",
        acceptButtonColor: Color = Color(.brandColor),
        refuseButtonColor: Color = Color.white,
        acceptButtonTextColor: Color = Color.white,
        refuseButtonTextColor: Color = Color(.black22),
        buttonWidth: CGFloat? = nil,
        buttonHeight: CGFloat = 46,
        onAccept: @escaping (T) -> Void,
        onRefuse: @escaping (T) -> Void
    ) {
        self.data = data
        self.acceptButtonTitle = acceptButtonTitle
        self.refuseButtonTitle = refuseButtonTitle
        self.acceptButtonColor = acceptButtonColor
        self.refuseButtonColor = refuseButtonColor
        self.acceptButtonTextColor = acceptButtonTextColor
        self.refuseButtonTextColor = refuseButtonTextColor
        self.buttonWidth = buttonWidth
        self.buttonHeight = buttonHeight
        self.onAccept = onAccept
        self.onRefuse = onRefuse
    }
    
    var body: some View {
        ZStack {
            if !showMergedButton {
                HStack(spacing: LayoutAdapter.shared.scale(value: 8)) {
                    CustomButtonSwiftUI(
                        title: acceptButtonTitle,
                        backgroundColor: acceptButtonColor,
                        titleColor: acceptButtonTextColor
                    ) {
                        withAnimation(.spring(duration: 0.5)) {
                            isAccepted = true
                            showMergedButton = true
                            onAccept(data)
                        }
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: LayoutAdapter.shared.scale(value: 140)),
                          height: LayoutAdapter.shared.scale(value: LayoutAdapter.shared.scale(value: 44)))
                    
                    CustomButtonSwiftUI(
                        title: refuseButtonTitle,
                        backgroundColor: refuseButtonColor,
                        titleColor: refuseButtonTextColor
                    ) {
                        withAnimation(.spring(duration: 0.5)) {
                            isAccepted = false
                            showMergedButton = true
                            onRefuse(data)
                        }
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: LayoutAdapter.shared.scale(value: 140)),
                          height: LayoutAdapter.shared.scale(value: LayoutAdapter.shared.scale(value: 44)))
                }
            } else {
                Button(action: {}) {
                    HStack {
                        Image(systemName: isAccepted ? "checkmark" : "xmark")
                            .foregroundColor(isAccepted ? acceptButtonTextColor : refuseButtonTextColor)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: LayoutAdapter.shared.scale(value: 44))
                    .background(isAccepted ? acceptButtonColor : refuseButtonColor)
                    .cornerRadius(LayoutAdapter.shared.scale(value: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 12))
                            .stroke(Color(.black66), lineWidth: isAccepted ? 0 : 1)
                    )
                }
                .transition(.scale)
            }
        }
        // 프리뷰 테스트를 위한 추가 패딩
        .padding(4)
    }
}

// 프리뷰 데이터 모델들
struct PreviewFriendRequest {
    let id: Int
    let name: String
}

struct PreviewSchedule {
    let id: Int
    let title: String
}

// 프리뷰 - 친구 요청 버전
struct ButtonMergeViewFriendPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            // 친구 요청 스타일의 ButtonMergeView
            ButtonMergeView(
                data: PreviewFriendRequest(id: 1, name: "김지민"),
                acceptButtonTitle: "친구 수락하기",
                refuseButtonTitle: "친구 거절하기",
                onAccept: { request in
                    print("친구 요청 수락: \(request.id) - \(request.name)")
                },
                onRefuse: { request in
                    print("친구 요청 거절: \(request.id) - \(request.name)")
                }
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            // 이미 클릭된 상태를 보여주기 위한 수동 설정 버전
            let alreadyClickedView = ButtonMergeView(
                data: PreviewFriendRequest(id: 2, name: "이태오"),
                acceptButtonTitle: "친구 수락하기",
                refuseButtonTitle: "친구 거절하기",
                onAccept: { _ in },
                onRefuse: { _ in }
            )
            
            alreadyClickedView
                .onAppear {
                    // 프리뷰에서 이미 수락된 상태 시뮬레이션
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            alreadyClickedView.isAccepted = true
                            alreadyClickedView.showMergedButton = true
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

// 프리뷰 - 일정 초대 버전
struct ButtonMergeViewSchedulePreview: View {
    var body: some View {
        VStack(spacing: 20) {
            // 일정 초대 스타일의 ButtonMergeView
            ButtonMergeView(
                data: PreviewSchedule(id: 101, title: "팀 미팅"),
                acceptButtonTitle: "수락하기",
                refuseButtonTitle: "거절하기",
                onAccept: { schedule in
                    print("일정 수락: \(schedule.id) - \(schedule.title)")
                },
                onRefuse: { schedule in
                    print("일정 거절: \(schedule.id) - \(schedule.title)")
                }
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

// 프리뷰
#Preview("친구 요청 버전") {
    ButtonMergeViewFriendPreview()
}

#Preview("일정 초대 버전") {
    ButtonMergeViewSchedulePreview()
}

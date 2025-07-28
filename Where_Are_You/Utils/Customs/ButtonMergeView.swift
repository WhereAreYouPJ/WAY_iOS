//
//  ButtonMergeView.swift
//  Where_Are_You
//
//  Created by juhee on 09.04.25.
//

import SwiftUI

struct ButtonMergeView<T>: View {
    @Binding var isAccepted: Bool // 외부에서 상태를 바인딩으로 받음
    @Binding var showMergedButton: Bool
    
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
    let buttonWidth: CGFloat      // 각 버튼의 너비 (nil이면 자동 계산)
    let buttonHeight: CGFloat     // 버튼의 높이
    
    // 콜백 함수
    var onAccept: (T) -> Void
    var onRefuse: (T) -> Void
    
    // 초기화 메서드
    init(
        data: T,
        isAccepted: Binding<Bool>,
        showMergedButton: Binding<Bool>,
        acceptButtonTitle: String = "수락하기",
        refuseButtonTitle: String = "거절하기",
        acceptButtonColor: Color = Color.brandDark,
        refuseButtonColor: Color = Color.white,
        acceptButtonTextColor: Color = Color.white,
        refuseButtonTextColor: Color = Color.brandDark,
        buttonWidth: CGFloat = 85,
        buttonHeight: CGFloat = 38,
        onAccept: @escaping (T) -> Void,
        onRefuse: @escaping (T) -> Void
    ) {
        self.data = data
        self._isAccepted = isAccepted
        self._showMergedButton = showMergedButton
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
                    .frame(width: LayoutAdapter.shared.scale(value: buttonWidth),
                          height: LayoutAdapter.shared.scale(value: buttonHeight))
                    
                    CustomButtonSwiftUI(
                        title: refuseButtonTitle,
                        backgroundColor: refuseButtonColor,
                        strokeColor: refuseButtonTextColor,
                        titleColor: refuseButtonTextColor
                    ) {
                        withAnimation(.spring(duration: 0.5)) {
                            isAccepted = false
                            showMergedButton = true
                            onRefuse(data)
                        }
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: buttonWidth),
                          height: LayoutAdapter.shared.scale(value: buttonHeight))
                }
            } else {
                Button(action: {}) {
                    HStack {
                        Image(systemName: isAccepted ? "checkmark" : "xmark")
                            .foregroundColor(isAccepted ? acceptButtonTextColor : refuseButtonTextColor)
                    }
                    .frame(maxWidth: LayoutAdapter.shared.scale(value: buttonWidth * 2 + 8))
                    .frame(height: LayoutAdapter.shared.scale(value: buttonHeight))
                    .background(isAccepted ? acceptButtonColor : refuseButtonColor)
                    .cornerRadius(LayoutAdapter.shared.scale(value: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 6))
                            .stroke(Color(refuseButtonTextColor), lineWidth: 1.5)
                    )
                }
                .transition(.scale)
            }
        }
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

// 프리뷰 - 친구 관리 버전
struct ButtonMergeViewFriendPreview: View {
    var body: some View {
        VStack(spacing: 20) {
            // 친구 요청 스타일의 ButtonMergeView
            ButtonMergeView(
                data: PreviewFriendRequest(id: 1, name: "김지민"),
                isAccepted: .constant(false),
                showMergedButton: .constant(false),
                acceptButtonTitle: "수락",
                refuseButtonTitle: "삭제",
                onAccept: { request in
                    print("친구 요청 수락: \(request.id) - \(request.name)")
                },
                onRefuse: { request in
                    print("친구 요청 거절: \(request.id) - \(request.name)")
                }
            )
            .button14Style()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            ButtonMergeView(
                data: PreviewFriendRequest(id: 1, name: "김지민"),
                isAccepted: .constant(false),
                showMergedButton: .constant(false),
                acceptButtonTitle: "수락",
                refuseButtonTitle: "삭제",
                onAccept: { request in
                    print("친구 요청 수락: \(request.id) - \(request.name)")
                },
                onRefuse: { request in
                    print("친구 요청 거절: \(request.id) - \(request.name)")
                }
            )
            .button14Style()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

// 프리뷰 - 알림페이지 버전
struct ButtonMergeViewSchedulePreview: View {
    var body: some View {
        VStack(spacing: 20) {
            // 일정 초대 스타일의 ButtonMergeView
            ButtonMergeView(
                data: PreviewSchedule(id: 101, title: "팀 미팅"),
                isAccepted: .constant(false),
                showMergedButton: .constant(false),
                acceptButtonTitle: "수락하기",
                refuseButtonTitle: "거절하기",
                buttonWidth: .infinity,
                buttonHeight: 46,
                onAccept: { schedule in
                    print("일정 수락: \(schedule.id) - \(schedule.title)")
                },
                onRefuse: { schedule in
                    print("일정 거절: \(schedule.id) - \(schedule.title)")
                }
            )
            .button16Style()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
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

//
//  NotificationView.swift
//  Where_Are_You
//
//  Created by juhee on 06.01.25.
//

import SwiftUI
import Kingfisher

struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    // 일정 섹션
    @State private var isScheduleSectionExpanded = true
    @State private var isFriendSectionExpanded = true
    @State private var isGeneralSectionExpanded = true
    
    // 친구 섹션
    @State private var isAccepted = false
    @State private var showMergedButton = false
    
    @StateObject private var viewModel: NotificationViewModel = {
        let scheduleRepo = ScheduleRepository(scheduleService: ScheduleService())
        let getInvitedListUseCase = GetInvitedListUseCaseImpl(scheduleRepository: scheduleRepo)
        let postAcceptScheduleUseCase = PostAcceptScheduleUseCaseImpl(scheduleRepository: scheduleRepo)
        let refuseInvitedScheduleUseCase = RefuseInvitedScheduleUseCaseImpl(scheduleRepository: scheduleRepo)
            
        let friendRequestRepo = FriendRequestRepository(friendRequestService: FriendRequestService())
        let getListForReceiverUseCase = GetListForReceiverUseCaseImpl(repository: friendRequestRepo)
        let acceptFriendRequestUseCase = AcceptFriendRequestUseCaseImpl(repository: friendRequestRepo)
        let refuseFriendRequestUseCase = RefuseFriendRequestUseCaseImpl(repository: friendRequestRepo)
        
        return NotificationViewModel(
            getInvitedListUseCase: getInvitedListUseCase,
            postAcceptScheduleUseCase: postAcceptScheduleUseCase,
            refuseInvitedScheduleUseCase: refuseInvitedScheduleUseCase,
            getListForReceiverUseCase: getListForReceiverUseCase,
            acceptFriendRequestUseCase: acceptFriendRequestUseCase,
            refuseFriendRequestUseCase: refuseFriendRequestUseCase
        )
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            topBar()
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 18))
            
            Divider()
            
            ZStack {
                Color(.color249)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: LayoutAdapter.shared.scale(value: 18)) {
                        scheduleSection()
                            .padding(.top, LayoutAdapter.shared.scale(value: 18))
                        
                        Divider()
                        
                        friendSection()
                        
                        Divider()
                        
                        generalSection()
                    }
                    .padding(.horizontal, LayoutAdapter.shared.scale(value: 18))
                }
            }
        }
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: LayoutAdapter.shared.scale(value: 16))))
        .onAppear {
            viewModel.fetchNotifications()
        }
    }
    
    func topBar() -> some View {
        HStack {
            Text("알림")
                .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 20))))
                .foregroundStyle(Color(.black22))

            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(.black66))
                    .frame(width: LayoutAdapter.shared.scale(value: 14), height: LayoutAdapter.shared.scale(value: 14))
            })
        }
        .padding(.vertical, LayoutAdapter.shared.scale(value: 10))
    }
    
    // MARK: Sections
    func scheduleSection() -> some View {
        DisclosureGroup(
            isExpanded: $isScheduleSectionExpanded,
            content: {
                if let schedules = viewModel.invitedSchedules, !schedules.isEmpty {
                    VStack(spacing: LayoutAdapter.shared.scale(value: 16)) {
                        ForEach(schedules, id: \.scheduleSeq) { schedule in
                            invitedScheduleCard(schedule: schedule)
                        }
                    }
                } else {
                    emptyNotification()
                }
            },
            label: {
                HStack {
                    Text("일정")
                        .foregroundStyle(Color(.color153))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
                    Spacer()
                }
            }
        )
        .accentColor(Color(.color153))
    }
    
    func friendSection() -> some View {
        DisclosureGroup(
            isExpanded: $isFriendSectionExpanded,
            content: {
                if let friendRequests = viewModel.friendRequests, !friendRequests.isEmpty {
                    VStack(spacing: LayoutAdapter.shared.scale(value: 16)) {
                        ForEach(friendRequests, id: \.friendRequestSeq) { friendRequest in
                            friendRequestCard(friendRequest: friendRequest)
                        }
                    }
                } else {
                    emptyNotification()
                }
            },
            label: {
                HStack {
                    Text("친구")
                        .foregroundStyle(Color(.color153))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
                    Spacer()
                }
            }
        )
        .accentColor(Color(.color153))
    }
    
    func generalSection() -> some View {
        DisclosureGroup(
            isExpanded: $isGeneralSectionExpanded,
            content: {
//                generalArticle()
                emptyNotification()
            },
            label: {
                HStack {
                    Text("일반")
                        .foregroundStyle(Color(.color153))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
                    Spacer()
                }
            }
        )
        .accentColor(Color(.color153))
    }
    
    // MARK: Schedule Section Cards
    func invitedScheduleCard(schedule: Schedule) -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 16)) {
                HStack {
                    Text("일정에 초대되었습니다.")
                        .foregroundStyle(Color(.black22))
                    
                    Spacer()
                    
                    Text(schedule.createdAt?.timeAgoDisplay() ?? "")
                        .foregroundStyle(Color(.color153))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
                }
                .padding(.top, LayoutAdapter.shared.scale(value: 16))
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
            
                HStack {
                    VStack {
                        Text(schedule.startTime.formatted(to: .monthDay))
                            .foregroundStyle(Color(.brandColor))
                            .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 20))))
                        
                        Text("D - \(schedule.dDay ?? 0)")
                            .foregroundStyle(Color.red)
                            .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
                    }
                    .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                    
                    VStack(alignment: .leading) {
                        Text(schedule.title)
                            .foregroundStyle(Color(.black66))
                        
                        Text(schedule.location?.location ?? "")
                            .foregroundStyle(Color(.color153))
                            .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
                    }
                    
                    Spacer()
                }
                    
                HStack {
                    CustomButtonSwiftUI(title: "수락하기", backgroundColor: Color(.brandColor), titleColor: .white) {
                        viewModel.ecceptSchedule(scheduleSeq: schedule.scheduleSeq)
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 152), height: LayoutAdapter.shared.scale(value: 46))
                    
                    CustomButtonSwiftUI(title: "거절하기", backgroundColor: .white, titleColor: Color(.black22)) {
                        viewModel.refuseInvitedSchedule(scheduleSeq: schedule.scheduleSeq)
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 152), height: LayoutAdapter.shared.scale(value: 46))
                }
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
            }
            .background(
                RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16))
                    .fill(Color(.white))
                    .strokeBorder(Color(.brandColor), lineWidth: 1)
            )
            .padding(.top, LayoutAdapter.shared.scale(value: 6))
    }
    
//    func unconfirmedScheduleArticle() -> some View {
//        VStack(spacing: LayoutAdapter.shared.scale(value: 16)) {
//            HStack {
//                Text("확인하지 않은 일정이 있습니다.")
//                    .foregroundStyle(Color(.color34))
//                
//                Spacer()
//                
//                Text("0분 전")
//                    .foregroundStyle(Color(.color153))
//                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
//            }
//            .padding(.top, LayoutAdapter.shared.scale(value: 16))
//            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
//        
//            HStack {
//                VStack {
//                    Text("4월 5일")
//                        .foregroundStyle(Color(.brandColor))
//                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 20))))
//                    
//                    Text("D - 5")
//                        .foregroundStyle(Color.red)
//                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
//                        
//                }
//                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
//                
//                VStack(alignment: .leading) {
//                    Text("기획 미팅")
//                        .foregroundStyle(Color(.color34))
//                    
//                    Text("회사")
//                        .foregroundStyle(Color(.color153))
//                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
//                }
//                
//                Spacer()
//                
//                CustomButtonSwiftUI(title: "일정 확인하기", backgroundColor: Color(.brandColor), titleColor: .white) {
//                    print("수락")
//                }
//                .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
//                .frame(width: LayoutAdapter.shared.scale(value: 100), height: LayoutAdapter.shared.scale(value: 42))
//                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
//            }
//            .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
//        }
//        .background(
//            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16))
//                .fill(Color(.white))
//                .strokeBorder(Color(.brandColor), lineWidth: 1)
//        )
//    }
    
    // MARK: Friend Section Cards
//    func acceptedFriendArticle() -> some View {
//        VStack(spacing: LayoutAdapter.shared.scale(value: 8)) {
//            HStack {
//                Text("친구수락이 되었습니다.")
//                    .foregroundStyle(Color(.color34))
//                
//                Spacer()
//                
//                Text("0분 전")
//                    .foregroundStyle(Color(.color153))
//                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
//            }
//            .padding(.top, LayoutAdapter.shared.scale(value: 16))
//            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
//        
//            profileView()
//                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
//                .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
//        }
//        .background(
//            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16))
//                .fill(Color(.white))
//                .strokeBorder(Color(.brandColor), lineWidth: 1)
//        )
//        .padding(.top, LayoutAdapter.shared.scale(value: 6))
//    }
    
    func friendRequestCard(friendRequest: FriendRequest) -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 8)) {
            HStack {
                Text("친구요청이 도착했습니다.")
                    .foregroundStyle(Color(.black22))
                
                Spacer()
                
                Text(friendRequest.createTime.timeAgoDisplay())
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
            }
            .padding(.top, LayoutAdapter.shared.scale(value: 16))
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
        
            profileView(friend: friendRequest.friend)
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                
//            HStack {
//                CustomButtonSwiftUI(title: "친구 수락하기", backgroundColor: Color(.brandColor), titleColor: .white) {
//                    print("수락")
//                }
//                .frame(width: LayoutAdapter.shared.scale(value: 152), height: LayoutAdapter.shared.scale(value: 46))
//                
//                CustomButtonSwiftUI(title: "친구 거절하기", backgroundColor: .white, titleColor: Color(.color34)) {
//                    print("수락")
//                }
//                .frame(width: LayoutAdapter.shared.scale(value: 152), height: LayoutAdapter.shared.scale(value: 46))
//            }
            buttonMergeView(friendRequest: friendRequest)
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
        }
        .background(
            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16))
                .fill(Color(.white))
                .strokeBorder(Color(.brandColor), lineWidth: 1)
        )
        .padding(.top, LayoutAdapter.shared.scale(value: 6))
    }
    
    func profileView(friend: Friend) -> some View {
        HStack {
            KFImage(URL(string: friend.profileImage))
                .resizable()
                .scaledToFill()
                .frame(width: LayoutAdapter.shared.scale(value: 64), height: LayoutAdapter.shared.scale(value: 64))
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 22)))
                .padding(.leading, LayoutAdapter.shared.scale(value: -4))
            
            VStack(alignment: .leading) {
                Text(friend.name)
                    .foregroundStyle(Color(.black22))
                
                Text(friend.memberCode)
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
            }
            .padding(.leading, LayoutAdapter.shared.scale(value: 4))
            
            Spacer()
        }
    }
    
    // MARK: General Section Articles
    func generalArticle() -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 8)) {
            HStack {
                Text("온마이웨이 리뉴얼 관련안내")
                    .foregroundStyle(Color(.black22))
                    .padding(.top, LayoutAdapter.shared.scale(value: 16))
                
                Spacer()
                
                Text("0분 전")
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
            
            Text("온마이웨이 리뉴얼 안내사항 전달드립니다. 이번 리뉴얼 어쩌고 한줄만 보이게")
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color(.black66))
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
                .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
        }
        .background(
            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16))
                .fill(Color(.white))
                .strokeBorder(Color(.brandColor), lineWidth: 1)
        )
        .padding(.top, LayoutAdapter.shared.scale(value: 6))
    }
    
    // 수락 or 거절 버튼 클릭시 하나로 합쳐짐
    // TODO: Utils로 struct 재사용 가능하게 수정하기. ManageFriendsView에서도 사용함
    func buttonMergeView(friendRequest: FriendRequest) -> some View {
        ZStack {
            if !showMergedButton {
                HStack {
                    CustomButtonSwiftUI(title: "친구 수락하기",
                                      backgroundColor: Color(.brandColor),
                                      titleColor: .white) {
                        withAnimation(.spring(duration: 0.5)) {
                            isAccepted = true
                            showMergedButton = true
                            viewModel.acceptFriendRequest(friendRequest: friendRequest)
                        }
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 152),
                          height: LayoutAdapter.shared.scale(value: 46))
                    
                    CustomButtonSwiftUI(title: "친구 거절하기",
                                      backgroundColor: .white,
                                      titleColor: Color(.black22)) {
                        withAnimation(.spring(duration: 0.5)) {
                            isAccepted = false
                            showMergedButton = true
                            viewModel.refuseFriendRequest(friendRequestSeq: friendRequest.friendRequestSeq)
                        }
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 152),
                          height: LayoutAdapter.shared.scale(value: 46))
                }
            } else {
                Button(action: {}) {
                    HStack {
                        Image(systemName: isAccepted ? "checkmark" : "xmark")
                            .foregroundColor(isAccepted ? .white : Color(.black66))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: LayoutAdapter.shared.scale(value: 46))
                    .background(isAccepted ? Color(.brandColor) : Color.white)
                    .cornerRadius(LayoutAdapter.shared.scale(value: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 12))
                            .stroke(Color(.black66), lineWidth: isAccepted ? 0 : 1)
                    )
                }
                .transition(.scale)
            }
        }
    }
//    struct ButtonMergeView: View {
//        let friendRequest: FriendRequest
//        @State private var isAccepted = false
//        @State private var showMergedButton = false
//        
//        var body: some View {
//            ZStack {
//                if !showMergedButton {
//                    HStack {
//                        CustomButtonSwiftUI(title: "친구 수락하기",
//                                          backgroundColor: Color(.brandColor),
//                                          titleColor: .white) {
//                            withAnimation(.spring(duration: 0.5)) {
//                                isAccepted = true
//                                showMergedButton = true
//                            }
//                        }
//                        .frame(width: LayoutAdapter.shared.scale(value: 152),
//                              height: LayoutAdapter.shared.scale(value: 46))
//                        
//                        CustomButtonSwiftUI(title: "친구 거절하기",
//                                          backgroundColor: .white,
//                                          titleColor: Color(.black22)) {
//                            withAnimation(.spring(duration: 0.5)) {
//                                isAccepted = false
//                                showMergedButton = true
//                            }
//                        }
//                        .frame(width: LayoutAdapter.shared.scale(value: 152),
//                              height: LayoutAdapter.shared.scale(value: 46))
//                    }
//                } else {
//                    Button(action: {}) {
//                        HStack {
//                            Image(systemName: isAccepted ? "checkmark" : "xmark")
//                                .foregroundColor(isAccepted ? .white : Color(.black66))
//                        }
//                        .frame(maxWidth: .infinity)
//                        .frame(height: LayoutAdapter.shared.scale(value: 46))
//                        .background(isAccepted ? Color(.brandColor) : Color.white)
//                        .cornerRadius(LayoutAdapter.shared.scale(value: 12))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 12))
//                                .stroke(Color(.black66), lineWidth: isAccepted ? 0 : 1)
//                        )
//                    }
//                    .transition(.scale)
//                }
//            }
//        }
//    }
    
    // MARK: 알림 없는 경우
    func emptyNotification() -> some View {
        VStack {
            Text("알림이 없습니다.")
                .foregroundStyle(Color(.color153))
                .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))))
        }
    }
}

#Preview {
    NotificationView()
}

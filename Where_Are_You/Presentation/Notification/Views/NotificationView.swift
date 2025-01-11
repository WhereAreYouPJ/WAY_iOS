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
    @State private var isScheduleSectionExpanded = true
    @State private var isFriendSectionExpanded = true
    @State private var isGeneralSectionExpanded = true
    
    var body: some View {
        VStack(spacing: 0) {
            topBar()
            
            Divider()
            
            ZStack {
                Color(.color249)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 18) {
                        scheduleSection()
                            .padding(.top, LayoutAdapter.shared.scale(value: 18))
                        
                        Divider()
                        
                        friendSection()
                        
                        Divider()
                        
                        generalSection()
                    }
                    
                }
            }
        }
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 18))
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 16)))
    }
    
    func topBar() -> some View {
        HStack {
            Text("알림")
                .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 20)))
                .foregroundStyle(Color(.color34))
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(.color102))
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
                invitedScheduleArticle()
                
                unconfirmedScheduleArticle()
            },
            label: {
                HStack {
                    Text("일정")
                        .foregroundStyle(Color(.color153))
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
                acceptedFriendArticle()
                
                friendRequestArticle()
            },
            label: {
                HStack {
                    Text("친구")
                        .foregroundStyle(Color(.color153))
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
                generalArticle()
            },
            label: {
                HStack {
                    Text("일반")
                        .foregroundStyle(Color(.color153))
                    Spacer()
                }
            }
        )
        .accentColor(Color(.color153))
    }
    
    // MARK: Schedule Section Articles
    func invitedScheduleArticle() -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 16)) {
            HStack {
                Text("일정에 초대되었습니다.")
                    .foregroundStyle(Color(.color34))
                
                Spacer()
                
                Text("0분 전")
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
            }
            .padding(.top, LayoutAdapter.shared.scale(value: 16))
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
        
            HStack {
                VStack {
                    Text("4월 5일")
                        .foregroundStyle(Color(.brandColor))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 20)))
                    
                    Text("D - 5")
                        .foregroundStyle(Color.red)
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
                        
                }
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                
                VStack(alignment: .leading) {
                    Text("한강공원")
                        .foregroundStyle(Color(.color34))
                    
                    Text("여의도 한강공원")
                        .foregroundStyle(Color(.color153))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
                }
                
                Spacer()
            }
                
            HStack {
                CustomButtonSwiftUI(title: "수락하기", backgroundColor: Color(.brandColor), titleColor: .white) {
                    print("수락")
                }
                .frame(width: LayoutAdapter.shared.scale(value: 152), height: LayoutAdapter.shared.scale(value: 46))
                
                CustomButtonSwiftUI(title: "거절하기", backgroundColor: .white, titleColor: Color(.color34)) {
                    print("수락")
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
    
    func unconfirmedScheduleArticle() -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 16)) {
            HStack {
                Text("확인하지 않은 일정이 있습니다.")
                    .foregroundStyle(Color(.color34))
                
                Spacer()
                
                Text("0분 전")
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
            }
            .padding(.top, LayoutAdapter.shared.scale(value: 16))
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
        
            HStack {
                VStack {
                    Text("4월 5일")
                        .foregroundStyle(Color(.brandColor))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 20)))
                    
                    Text("D - 5")
                        .foregroundStyle(Color.red)
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
                        
                }
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                
                VStack(alignment: .leading) {
                    Text("기획 미팅")
                        .foregroundStyle(Color(.color34))
                    
                    Text("회사")
                        .foregroundStyle(Color(.color153))
                        .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
                }
                
                Spacer()
                
                CustomButtonSwiftUI(title: "일정 확인하기", backgroundColor: Color(.brandColor), titleColor: .white) {
                    print("수락")
                }
                .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
                .frame(width: LayoutAdapter.shared.scale(value: 100), height: LayoutAdapter.shared.scale(value: 42))
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
            }
            .padding(.bottom, LayoutAdapter.shared.scale(value: 16))
        }
        .background(
            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16))
                .fill(Color(.white))
                .strokeBorder(Color(.brandColor), lineWidth: 1)
        )
    }
    
    // MARK: Friend Section Articles
    func acceptedFriendArticle() -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 8)) {
            HStack {
                Text("친구수락이 되었습니다.")
                    .foregroundStyle(Color(.color34))
                
                Spacer()
                
                Text("0분 전")
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
            }
            .padding(.top, LayoutAdapter.shared.scale(value: 16))
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
        
            profileView()
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
    
    func friendRequestArticle() -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 8)) {
            HStack {
                Text("친구요청이 도착했습니다.")
                    .foregroundStyle(Color(.color34))
                
                Spacer()
                
                Text("0분 전")
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
            }
            .padding(.top, LayoutAdapter.shared.scale(value: 16))
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
        
            profileView()
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
                
            HStack {
                CustomButtonSwiftUI(title: "친구 수락하기", backgroundColor: Color(.brandColor), titleColor: .white) {
                    print("수락")
                }
                .frame(width: LayoutAdapter.shared.scale(value: 152), height: LayoutAdapter.shared.scale(value: 46))
                
                CustomButtonSwiftUI(title: "친구 거절하기", backgroundColor: .white, titleColor: Color(.color34)) {
                    print("수락")
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
    }
    
    func profileView() -> some View {
        HStack {
            KFImage(URL(string: UserDefaultsManager.shared.getProfileImage()))
                .resizable()
                .scaledToFill()
                .frame(width: LayoutAdapter.shared.scale(value: 64), height: LayoutAdapter.shared.scale(value: 64))
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 22)))
                .padding(.leading, LayoutAdapter.shared.scale(value: -4))
            
            VStack(alignment: .leading) {
                Text("김지원")
                    .foregroundStyle(Color(.color34))
                
                Text("#1wee35")
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
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
                    .foregroundStyle(Color(.color34))
                    .padding(.top, LayoutAdapter.shared.scale(value: 16))
                
                Spacer()
                
                Text("0분 전")
                    .foregroundStyle(Color(.color153))
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 14)))
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
            
            Text("온마이웨이 리뉴얼 안내사항 전달드립니다. 이번 리뉴얼 어쩌고 한줄만 보이게")
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color(.color102))
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
}

#Preview {
    NotificationView()
}

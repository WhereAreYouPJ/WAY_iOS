//
//  DatePickerView.swift
//  Where_Are_You
//
//  Created by juhee on 14.04.25.
//

import SwiftUI

/// 년, 월, 일을 모두 선택할 수 있는 커스텀 DatePicker (소수점 없는 년도 표시 및 커스텀 폰트)
struct FullDatePickerView: View {
    // 선택된 날짜 바인딩
    @Binding var selectedDate: Date
    
    // 피커 표시 여부 바인딩
    @Binding var isPresented: Bool
    
    // 취소/완료 버튼 액션
    var onCancel: (() -> Void)?
    var onConfirm: ((Date) -> Void)?
    
    // 내부 상태 관리
    @State private var tempYear: Int
    @State private var tempMonth: Int
    @State private var tempDay: Int
    
    // 년도 범위 (기본: 현재 년도 ±10년)
    private let yearRange: [Int]
    
    // 월 범위
    private let months = Array(1...12)
    
    // 선택한 년월에 따른 일 범위
    private var days: [Int] {
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: tempYear, month: tempMonth, day: 1)) else {
            return Array(1...31) // 기본값 반환
        }
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        return Array(1...range.count)
    }
    
    // 이니셜라이저
    init(
        selectedDate: Binding<Date>,
        isPresented: Binding<Bool>,
        yearRange: [Int]? = nil,
        onCancel: (() -> Void)? = nil,
        onConfirm: ((Date) -> Void)? = nil
    ) {
        self._selectedDate = selectedDate
        self._isPresented = isPresented
        self.onCancel = onCancel
        self.onConfirm = onConfirm
        
        // 년도 범위 설정 (기본값: 현재 년도 ±10년)
        let currentYear = Calendar.current.component(.year, from: Date())
        self.yearRange = yearRange ?? Array(2000...2100)
        
        // 현재 선택된 날짜에서 연도, 월, 일 초기화
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate.wrappedValue)
        let month = calendar.component(.month, from: selectedDate.wrappedValue)
        let day = calendar.component(.day, from: selectedDate.wrappedValue)
        
        // 내부 상태 초기화
        self._tempYear = State(initialValue: year)
        self._tempMonth = State(initialValue: month)
        self._tempDay = State(initialValue: day)
    }
    
    var body: some View {
        ZStack {
            // 반투명 배경
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // 배경 탭시 닫기 (필요에 따라 주석 처리)
                     isPresented = false
                }
            
            // 피커 컨테이너
            VStack(spacing: 0) {
                Spacer()
                
                // 피커 뷰 컨테이너
                VStack(spacing: 0) {
                    // 피커
                    HStack(spacing: 0) {
                        // 년도 피커
                        Picker("", selection: $tempYear) {
                            ForEach(yearRange, id: \.self) { year in
                                Text("\(String(format: "%d", year))년")
                                    .withBodyP2Style(color: .black22)
                                    .tag(year)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        
                        // 월 피커
                        Picker("", selection: $tempMonth) {
                            ForEach(months, id: \.self) { month in
                                Text("\(month)월")
                                    .withBodyP2Style(color: .black22)
                                    .tag(month)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .onChange(of: tempMonth) { _ in
                            // 월이 변경되면 일 범위를 조정하고, 일이 범위를 벗어나면 수정
                            if tempDay > days.last! {
                                tempDay = days.last!
                            }
                        }
                        
                        // 일 피커
                        Picker("", selection: $tempDay) {
                            ForEach(days, id: \.self) { day in
                                Text("\(day)일")
                                    .withBodyP2Style(color: .black22)
                                    .tag(day)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    }
                    .padding(.top, 10)
                    .frame(height: 200)
                    .background(Color(.systemBackground))
                    
                    // 버튼 영역
                    HStack(spacing: 0) {
                        // 취소 버튼
                        Button(action: {
                            isPresented = false
                            onCancel?()
                        }) {
                            Text("취소")
                                .button16Style(color: .black22)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        
                        Divider()
                            .frame(height: 20)
                            .background(Color.blackAC)
                        
                        // 확인 버튼
                        Button(action: {
                            applySelection()
                            isPresented = false
                            onConfirm?(selectedDate)
                        }) {
                            Text("완료")
                                .button16Style(color: .black22)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                    }
                    .padding(.bottom, 10)
                    .background(Color(.systemBackground))
                }
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .padding(.bottom, 30) // 하단 안전 영역 확보
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    // 선택한 날짜로 업데이트하고 바인딩에 적용
    private func applySelection() {
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = tempYear
        dateComponents.month = tempMonth
        dateComponents.day = tempDay
        
        if let newDate = calendar.date(from: dateComponents) {
            selectedDate = newDate
        } else {
            // 유효하지 않은 날짜의 경우(예: 2월 30일), 해당 월의 마지막 날로 설정
            dateComponents.day = 1
            if let firstDayOfMonth = calendar.date(from: dateComponents),
               let lastDay = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfMonth) {
                selectedDate = lastDay
            }
        }
    }
}

// MARK: - 프리뷰
struct FullDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.3).edgesIgnoringSafeArea(.all)
            
            // 배경 콘텐츠
            Text("배경 콘텐츠")
            
            // 피커 표시
            FullDatePickerView(
                selectedDate: .constant(Date()),
                isPresented: .constant(true)
            )
        }
    }
}

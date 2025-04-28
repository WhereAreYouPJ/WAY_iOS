//
//  DatePickerView.swift
//  Where_Are_You
//
//  Created by juhee on 14.04.25.
//

import SwiftUI

struct YearMonthPicker: View {
    // 선택된 날짜를 외부와 바인딩
    @Binding var selectedDate: Date
    
    // 피커 표시 여부 컨트롤
    @Binding var isPresented: Bool
    
    // 취소/완료 버튼 액션
    var onCancel: (() -> Void)?
    var onConfirm: ((Date) -> Void)?
    
    // 내부 상태 관리
    @State private var tempSelectedDate: Date
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    
    // 년도 범위 (기본: 현재 년도 ±10년)
    private let yearRange: Range<Int>
    
    // 월 이름 표시 형식
    private let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter
    }()
    
    // 이니셜라이저
    init(
        selectedDate: Binding<Date>,
        isPresented: Binding<Bool>,
        yearRange: Range<Int>? = nil,
        onCancel: (() -> Void)? = nil,
        onConfirm: ((Date) -> Void)? = nil
    ) {
        self._selectedDate = selectedDate
        self._isPresented = isPresented
        self.onCancel = onCancel
        self.onConfirm = onConfirm
        
        // 년도 범위 결정 (기본값: 현재 년도 ±10년)
        let currentYear = Calendar.current.component(.year, from: Date())
        self.yearRange = yearRange ?? (currentYear - 10)..<(currentYear + 10)
        
        // 초기 날짜 설정
        self._tempSelectedDate = State(initialValue: selectedDate.wrappedValue)
        
        // 연도와 월 컴포넌트 추출
        let calendar = Calendar.current
        self._selectedYear = State(initialValue: calendar.component(.year, from: selectedDate.wrappedValue))
        self._selectedMonth = State(initialValue: calendar.component(.month, from: selectedDate.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 공간
            Spacer()
            
            // 피커 컴포넌트
            HStack {
                // 년도 피커
                Picker("Year", selection: $selectedYear) {
                    ForEach(yearRange, id: \.self) { year in
                        Text("\(year)년").tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: UIScreen.main.bounds.width / 2, height: 180)
                .clipped()
                .compositingGroup()
                .onChange(of: selectedYear) { newYear in
                    updateSelectedDate()
                }
                
                // 월 피커
                Picker("Month", selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(monthName(for: month)).tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: UIScreen.main.bounds.width / 2, height: 180)
                .clipped()
                .compositingGroup()
                .onChange(of: selectedMonth) { newMonth in
                    updateSelectedDate()
                }
            }
            .padding(.bottom, 8)
            
            // 하단 버튼 영역
            HStack {
                Button(action: {
                    isPresented = false
                    onCancel?()
                }) {
                    Text("취소")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                
                Divider()
                    .frame(height: 44)
                
                Button(action: {
                    selectedDate = tempSelectedDate
                    isPresented = false
                    onConfirm?(tempSelectedDate)
                }) {
                    Text("완료")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.bottom, 30) // 하단 안전 영역 확보
        .background(
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // 배경 탭시 닫기 (옵션)
                    // isPresented = false
                }
        )
    }
    
    // 월 이름 반환 함수
    private func monthName(for month: Int) -> String {
        let calendar = Calendar.current
        guard let date = calendar.date(from: DateComponents(year: 2000, month: month, day: 1)) else {
            return "\(month)월"
        }
        
        return monthFormatter.string(from: date)
    }
    
    // 선택한 년/월로 날짜 업데이트
    private func updateSelectedDate() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: tempSelectedDate)
        let day = components.day ?? 1
        
        // 새 날짜 생성
        var newComponents = DateComponents()
        newComponents.year = selectedYear
        newComponents.month = selectedMonth
        newComponents.day = day
        
        // 날짜 객체 생성 및 업데이트
        if let newDate = calendar.date(from: newComponents) {
            self.tempSelectedDate = newDate
        }
    }
}

// MARK: - 사용 예시를 위한 컨테이너 뷰
struct YearMonthPickerContainer: View {
    @State private var selectedDate = Date()
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            // 선택된 날짜 표시
            let dateString = formattedDate(selectedDate)
            Text("선택된 날짜: \(dateString)")
                .padding()
            
            // 피커 열기 버튼
            Button("년도/월 선택") {
                showPicker = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            ZStack {
                if showPicker {
                    YearMonthPicker(
                        selectedDate: $selectedDate,
                        isPresented: $showPicker,
                        onCancel: {
                            print("선택 취소됨")
                        },
                        onConfirm: { date in
                            print("선택된 날짜: \(formattedDate(date))")
                        }
                    )
                }
            }
        )
    }
    
    // 날짜 포맷팅
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        return formatter.string(from: date)
    }
}

struct YearMonthPicker_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthPickerContainer()
    }
}

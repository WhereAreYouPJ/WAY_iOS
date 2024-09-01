//
//  CreateScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI
import Moya

final class CreateScheduleViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var isAllDay: Bool = true
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var selectedFriends: [Friend] = []
    @Published var place: Place?
    @Published var color: String = "red"
    @Published var memo: String = ""
    
    private let dateFormatter: DateFormatter
    private let provider = MoyaProvider<ScheduleAPI>()
    
    @Published var isSuccess = false
    
    init() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        let startOfHour = calendar.date(from: components)!
        let endOfHour = calendar.date(byAdding: .hour, value: 1, to: startOfHour)!
        
        self.startTime = startOfHour
        self.endTime = endOfHour // TODO: 23시 이후에 하루종일 토글 on 할 경우 시작일과 종료날이 달라지는 부분 수정 필요
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    func postSchedule() {
        let invitedMemberSeqs = selectedFriends.map { $0.memberSeq }
        let body = CreateScheduleBody(title: title, startTime: dateFormatter.string(from: startTime), endTime: dateFormatter.string(from: endTime), location: place?.location, streetName: place?.streetName, x: place?.x, y: place?.y, color: color, memo: memo, invitedMemberSeqs: invitedMemberSeqs, createMemberSeq: 1)
        
        provider.request(.postSchedule(request: body)) { response in
            switch response {
            case .success(let result):
                if result.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.isSuccess = true
                        print("post 성공! \nisSuccess: \(self.isSuccess)")
                    }
                } else {
                    DispatchQueue.main.async {
                        do {
                            if let json = try result.mapJSON() as? [String: Any],
                               let detail = json["detail"] as? String {
                                print("서버 오류: \(result.statusCode)\n상세 메시지: \(detail)\nbody: \(body)")
                            } else {
                                print("서버 오류: \(result.statusCode)\n응답 파싱 실패\nbody: \(body)")
                            }
                        } catch {
                            print("서버 오류: \(result.statusCode)\nJSON 파싱 실패: \(error)\nbody: \(body)")
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("요청 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

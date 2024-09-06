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
    @Published var place: Location?
    @Published var favPlaces: [Location] = []
    @Published var color: String = "red"
    @Published var memo: String = ""
    
    private let dateFormatter: DateFormatter
    
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
        
        getFavoriteLocation()
    }
    
    func getFavoriteLocation() {
        let provider = MoyaProvider<LocationAPI>()
        let memberSeq = 1 // 실제 사용 시에는 현재 로그인한 사용자의 memberSeq를 사용해야 합니다.
        
        provider.request(.getLocation(memberSeq: memberSeq)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let genericResponse = try decoder.decode(GenericResponse<GetFavLocationResponse>.self, from: response.data)
                        
                        DispatchQueue.main.async {
                            self.favPlaces = genericResponse.data.map { location in
                                Location(location: location.location,
                                      streetName: location.streetName,
                                      x: 0, // 서버 응답에 x, y 좌표가 없으므로 임시로 0을 설정
                                      y: 0)
                            }
                            print("즐겨찾기 위치 로드 성공: \(self.favPlaces.count)개의 위치를 받았습니다.")
                        }
                    } catch {
                        print("JSON 디코딩 실패: \(error.localizedDescription)")
                    }
                } else {
                    print("서버 오류: \(response.statusCode)")
                    if let json = try? response.mapJSON() as? [String: Any],
                       let detail = json["detail"] as? String {
                        print("상세 메시지: \(detail)")
                    }
                }
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func postSchedule() {
        let provider = MoyaProvider<ScheduleAPI>()
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

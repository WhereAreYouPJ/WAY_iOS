//
//  GetCoordinateUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 09.12.24.
//

import Foundation

protocol GetCoordinateUseCase {
    func execute(schedule: Schedule, completion: @escaping (Result<[GetCoordinateResponse], Error>) -> Void)
}

class GetCoordinateUseCaseImpl: GetCoordinateUseCase {
    private let coordinateRepository: CoordinateRepositoryProtocol
    
    init(coordinateRepository: CoordinateRepositoryProtocol) {
        self.coordinateRepository = coordinateRepository
    }
    
    func execute(schedule: Schedule, completion: @escaping (Result<[GetCoordinateResponse], any Error>) -> Void) {
        print("전체 일정 정보: \(schedule)")
        print("초대된 멤버 정보: \(schedule.invitedMember)")
        print("현재 사용자 시퀀스: \(UserDefaultsManager.shared.getMemberSeq())")
        
        guard let invitedMembers = schedule.invitedMember?.filter({ $0.memberSeq != UserDefaultsManager.shared.getMemberSeq() }) else {
            print("초대된 멤버가 없거나 필터링 결과가 없습니다.")
            completion(.success([]))
            return
        }
        
        print("필터링된 초대 멤버: \(invitedMembers.map { $0.name })")
        
        var friendsLocation: [GetCoordinateResponse] = []
        let group = DispatchGroup()
        
        for member in invitedMembers {
            group.enter()
            print("\(member.name)의 위치 정보 요청 시작")
            
            coordinateRepository.getCoordinate(memberSeq: member.memberSeq, scheduleSeq: schedule.scheduleSeq) { result in
                switch result {
                case .success(let response):
                    print("서버 응답 전체: \(response)")
                    print("응답 데이터: \(response.data)")
                    friendsLocation.append(response.data)
                    print("\(member.name)의 위치 정보: \(response.data.x), \(response.data.y))")
                case .failure(let error):
                    if let decodingError = error as? DecodingError {
                        switch decodingError {
                        case .keyNotFound(let key, let context):
                            print("\(member.name)의 위치 정보 받기 실패 - Missing key: \(key)")
                            print("Context: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("\(member.name)의 위치 정보 받기 실패 - Type mismatch: expected \(type)")
                            print("Context: \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("\(member.name)의 위치 정보 받기 실패 - Value missing: expected \(type)")
                            print("Context: \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("\(member.name)의 위치 정보 받기 실패 - Data corrupted")
                            print("Context: \(context.debugDescription)")
                        @unknown default:
                            print("\(member.name)의 위치 정보 받기 실패 - Unknown decoding error")
                        }
                    }
                    print("\(member.name)의 위치 정보 받기 실패 - \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        // 모든 요청이 완료되면 결과 반환
        group.notify(queue: .main) {
            print("모든 위치 정보 요청 완료. 결과: \(friendsLocation)")
            completion(.success(friendsLocation))
        }
    }
}

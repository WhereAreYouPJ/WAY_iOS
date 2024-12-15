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
        guard let invitedMembers = schedule.invitedMember?.filter({ $0.memberSeq != UserDefaultsManager.shared.getMemberSeq() }) else {
            completion(.success([]))
            return
        }
        
        var friendsLocation: [GetCoordinateResponse] = []
        let group = DispatchGroup()
        
        for member in invitedMembers {
            group.enter()
            coordinateRepository.getCoordinate(memberSeq: member.memberSeq, scheduleSeq: schedule.scheduleSeq) { result in
                switch result {
                case .success(let response):
                    friendsLocation.append(response.data)
                case .failure(let error):
                    print("\(member.name)의 위치 정보 받기 실패 - \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        // 모든 요청이 완료되면 결과 반환
        group.notify(queue: .main) {
            completion(.success(friendsLocation))
        }
    }
}

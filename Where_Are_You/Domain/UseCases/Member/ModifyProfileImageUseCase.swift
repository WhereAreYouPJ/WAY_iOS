//
//  ModifyProfileImageUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol ModifyProfileImageUseCase {
    func execute(images: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ModifyProfileImageUseCaseImpl: ModifyProfileImageUseCase {
    private let memberRepository: MemberRepositoryProtocol
    
    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    func execute(images: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberRepository.putProfileImage(images: images, completion: completion)
    }
}

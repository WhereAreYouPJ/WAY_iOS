//
//  CommonDescription.swift
//  Where_Are_You
//
//  Created by 오정석 on 4/8/2024.
//

import Foundation

// 유저 이름 형식 확인
let invalidUserNameMessage = "최소 1자 이상 입력해주세요."

// 비밀번호 형식 확인, 일치 확인
let invalidPasswordMessage = "영문 소문자, 숫자, 특수문자만 사용하여 시작하는 6~20자의 영문 대소문자, 숫자를 \n포함해 입력해주세요."
let checkPasswordFailureMessage = "비밀번호가 일치하지 않습니다."

// 이메일 전송, 인증
let invalidEmailMessage = "유효하지 않은 이메일 형식입니다."
let duplicateEmailFailureMessage = "이미 가입한 이메일입니다."
let sendEmailVerifyCodeSuccessMessage = "인증코드가 전송되었습니다."
let emailVerifyExpiredMessage = "이메일 재인증 요청이 필요합니다."
let emailVerifySuccessMessage = "인증코드가 확인되었습니다."
let emailVerifyFailureMessage = "인증코드가 알맞지 않습니다."

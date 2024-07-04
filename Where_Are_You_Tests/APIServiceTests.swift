//
//  APIServiceTests.swift
//  Where_Are_YouTests
//
//  Created by 오정석 on 4/7/2024.
//

import XCTest
import Alamofire
@testable import Where_Are_You

class APIServiceTests: XCTestCase {
    var apiService: APIService!
    var session: Session!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockURLProtocol.self]
        session = Session(configuration: configuration)
        apiService = APIService(session: session)
    }
    
    override func tearDown() {
        apiService = nil
        session = nil
        super.tearDown()
    }
    
    func testSignUpSuccess() {
        // Given
        let user = User(userId: "testuser", password: "password123", email: "test@example.com")
        let expectedResponse = EmptyResponse()
        
        // Mock response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = try! JSONEncoder().encode(expectedResponse)
            return (response, data)
        }
        
        let expectation = self.expectation(description: "SignUp Success")
        
        // When
        apiService.signUp(request: user) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success but got failure with error \(error)")
            }
        }
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSignUpFailure() {
        // Given
        let user = User(userId: "testuser", password: "password123", email: "test@example.com")
        
        // Mock response
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        
        let expectation = self.expectation(description: "SignUp Failure")
        
        // When
        apiService.signUp(request: user) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure:
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

// Mock URL Protocol
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            let (response, data) = try handler(request)
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocolDidFinishLoading(self)
        } catch {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No-op
    }
}

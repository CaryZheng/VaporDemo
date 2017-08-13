import XCTest
import Foundation
import Testing
import HTTP
@testable import Vapor
@testable import App

/// This file shows an example of testing 
/// routes through the Droplet.

class RouteTests: TestCase {
    let drop = try! Droplet.testable()
    
    let hostname = "localhost:8080"
    
    let headers: [HTTP.HeaderKey : String] = [
        "Content-Type": "application/json"
    ]
    
    func startTestTask() throws {
        try testSignin()
        
        try testHello()
        try testInfo()
        try testPlaintext()
        
        // leaf
        try testLeaftext()
        try testLeafimage()
    }
    
    func testSignin() throws {
        // request
        var requestData = JSON()
        try requestData.set("name", "cary")
        try requestData.set("password", "123456")
        
        let res = try drop.testResponse(to: .post, at: "signin", hostname: hostname, headers: headers, body: requestData.makeBody())
        
        // check
        let resData = try JSON(bytes: res.body.bytes!)
        
        XCTAssertNotNil(resData)
        XCTAssertEqual(resData["code"]?.int, 200)
        XCTAssertEqual(resData["msg"]?.string, "success")
    }
    
    func testHello() throws {
        try drop
            .testResponse(to: .get, at: "hello")
            .assertStatus(is: .ok)
            .assertJSON("hello", equals: "world")
    }

    func testInfo() throws {
        try drop
            .testResponse(to: .get, at: "info")
            .assertStatus(is: .ok)
            .assertBody(contains: "0.0.0.0")
    }
    
    func testPlaintext() throws {
        try drop
            .testResponse(to: .get, at: "plaintext")
            .assertStatus(is: .ok)
            .assertBody(equals: "Hello, world!")
    }
    
    func testLeaftext() throws {
        try drop
            .testResponse(to: .get, at: "leaftext")
            .assertStatus(is: .ok)
    }
    
    func testLeafimage() throws {
        try drop
            .testResponse(to: .get, at: "leafimage")
            .assertStatus(is: .ok)
    }
    
}

// MARK: Manifest

extension RouteTests {
    /// This is a requirement for XCTest on Linux
    /// to function properly.
    /// See ./Tests/LinuxMain.swift for examples
    static let allTests = [
        ("startTestTask", startTestTask)
    ]
}

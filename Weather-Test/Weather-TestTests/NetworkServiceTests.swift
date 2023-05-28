//
//  NetworkServiceTests.swift
//  Weather-TestTests
//
//  Created by Monalisa Nanda on 5/28/23.
//

import XCTest
@testable import Weather_Test

class NetworkServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNetwork_ByName() async throws {
        let networkManager = NetworkManager()
        let defaultInfo2 = try await networkManager.fetchWeatherInfoByName(cityName: "Atlanta")
        XCTAssert(defaultInfo2?.name == "Atlanta")
    }

    func testNetwork_FetchByGeoPosition() async throws {
        let networkManager = NetworkManager()
        let defaultInfo = try await networkManager.fetchWeatherInfoByGeoPosition(lat: 33.749, lon: -84.388)
        XCTAssert(defaultInfo?.name == "Atlanta")
    }
}

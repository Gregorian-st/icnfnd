//
//  icnfndTests.swift
//  icnfndTests
//
//  Created by Grigory Stolyarov on 03.08.2024.
//

import XCTest
@testable import icnfnd

final class icnfndTests: XCTestCase {
    
    var networkService: NetworkService?
    var imageLoader: ImageLoader?

    override func setUpWithError() throws {
        
        networkService = NetworkService()
        imageLoader = ImageLoader()
    }

    override func tearDownWithError() throws {
        
        networkService = nil
        imageLoader = nil
    }

    func testNetworkService() throws {
        
        let getIconsExpectation = expectation(description: "Get Images from service Expectation")
        
        guard let networkService = networkService else {
            XCTFail("Network Service is not created")
            return
        }
        
        networkService.fetchIcons(searchText: "arrow") { result in
            switch result {
            case .success(let iconsResult):
                XCTAssertGreaterThan(iconsResult.items.count, 0)
                getIconsExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testImageLoader() throws {
        
        guard let imageLoader = imageLoader else {
            XCTFail("Image Loader is not created")
            return
        }
        
        let loadImageRawExpectation = expectation(description: "Image Load Not Cached Expectation")
        let urlString = "https://cdn3.iconfinder.com/data/icons/142-mini-country-flags-16x16px/32/flag-usa2x.png"
        imageLoader.fetchImage(urlString: urlString) { image in
            if let _ = image {
                loadImageRawExpectation.fulfill()
            } else {
                XCTFail("Fail to load image not cached")
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}

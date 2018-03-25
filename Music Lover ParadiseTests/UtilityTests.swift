//
//  URLTests.swift
//  Music Lover ParadiseTests
//
//  Created by Andres Wang on 25/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import XCTest
@testable import Music_Lover_Paradise

class UtilityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDiscogsURLWithSearchTextIsWorking() {
        // given
        let url = URL.discogs(searchText: "Dua Lipa")
        var result: String?
        
        // when
        do {
            result = try String(contentsOf: url, encoding: .utf8)
        } catch {
            print("Download Error: \(error.localizedDescription)")
        }
        
        // then
        XCTAssertNotNil(result)
    }
    
    func testDiscogsResourceURLIsAuthorizedAccess() {
        // given
        let resourceURL = "https://api.discogs.com/artists/3518183"
        let url = URL.discogs(resourceURL: resourceURL)
        var result: ArtistProfile?
        
        // when
        do {
            let data = try Data(contentsOf: url)
            result = data.parseTo(jsonType: ArtistProfile.self)
        } catch {
            print("Download Error: \(error.localizedDescription)")
        }
        
        // then
        XCTAssertNotNil(result?.primaryImage)
    }
    
    func testDurationParsedFromStringShouldBeCorrect() {
        // given
        let durationString = "1:20:30"
        
        // when
        let result = durationString.parseDuration()
        
        // then
        XCTAssertEqual(result, 4830)
    }
    
}

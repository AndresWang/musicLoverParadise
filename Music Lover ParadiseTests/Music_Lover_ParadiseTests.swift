//
//  Music_Lover_ParadiseTests.swift
//  Music Lover ParadiseTests
//
//  Created by Andres Wang on 23/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import XCTest
@testable import Music_Lover_Paradise

class Music_Lover_ParadiseTests: XCTestCase {
    var sut: SearchViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchView = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        sut = searchView
        _ = searchView.view // To call viewDidLoad
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSearchControllerShouldExistAfterViewDidLoad() {
        // given
        // when
        // then
        XCTAssertNotNil(sut.navigationItem.searchController)
    }
    func testNavTitleShouldExistAfterViewDidLoad() {
        // given
        // when
        // then
        XCTAssertNotNil(sut.title)
    }
    func testTableViewShouldOnlyHas1CellWhenStatusIsLoading() {
        // given
        sut.isLoading = true
        
        // when
        let numberOfRows = sut.tableView.numberOfRows(inSection: 0)
        
        // then
        XCTAssertEqual(numberOfRows, 1)
    }
}

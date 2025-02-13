/**
 *  Copyright (C) 2010-2023 The Catrobat Team
 *  (http://developer.catrobat.org/credits)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  An additional term exception under section 7 of the GNU Affero
 *  General Public License, version 3, is available at
 *  (http://developer.catrobat.org/license_additional_term)
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see http://www.gnu.org/licenses/.
 */

import XCTest

@testable import Pocket_Code

class UploadCategoryViewControllerTests: XCTestCase {

    var uploadCategoryViewController: UploadCategoryViewController!
    var delegateMock: UploadCategoryViewControllerDelegateMock!

    override func setUp() {
        delegateMock = UploadCategoryViewControllerDelegateMock()
        uploadCategoryViewController = UploadCategoryViewController(tags: [StoreProjectTag]())
        uploadCategoryViewController.delegate = delegateMock
    }

    func testDelegate() {
        XCTAssertNil(delegateMock.tags)

        uploadCategoryViewController.delegate?.categoriesSelected(tags: [
            StoreProjectTag(id: "testTag1", text: "Test Tag 1"),
            StoreProjectTag(id: "testTag2", text: "Test Tag 2")
        ])
        XCTAssertNotNil(delegateMock.tags)
        XCTAssertEqual(delegateMock.tags?.count, 2)
        XCTAssertEqual(delegateMock.tags?[0].id, "testTag1")
        XCTAssertEqual(delegateMock.tags?[0].text, "Test Tag 1")
        XCTAssertEqual(delegateMock.tags?[1].id, "testTag2")
        XCTAssertEqual(delegateMock.tags?[1].text, "Test Tag 2")
    }
}

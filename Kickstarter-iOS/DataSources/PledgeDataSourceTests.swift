import XCTest
@testable import Kickstarter_Framework
@testable import Library
@testable import KsApi

final class PledgeDataSourceTests: XCTestCase {
  let dataSource = PledgeDataSource()
  let tableView = UITableView(frame: .zero, style: .plain)

  // swiftlint:disable line_length
  func testLoad_loggedIn() {
    let data = PledgeTableViewData(amount: 100, currency: "USD", delivery: "May 2020", isLoggedIn: true, requiresShippingRules: true)
    self.dataSource.load(data: data)

    XCTAssertEqual(3, self.dataSource.numberOfSections(in: self.tableView))
    XCTAssertEqual(1, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 0))
    XCTAssertEqual(2, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 1))
    XCTAssertEqual(1, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 2))
    XCTAssertEqual(PledgeDescriptionCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 0))
    XCTAssertEqual(PledgeAmountCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 1))
    XCTAssertEqual(PledgeShippingLocationCell.defaultReusableId, self.dataSource.reusableId(item: 1, section: 1))
    XCTAssertEqual(PledgeRowCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 2))
  }

  func testLoad_loggedOut() {
    let data = PledgeTableViewData(amount: 100, currency: "USD", delivery: "May 2020", isLoggedIn: false, requiresShippingRules: true)
    self.dataSource.load(data: data)

    XCTAssertEqual(3, self.dataSource.numberOfSections(in: self.tableView))
    XCTAssertEqual(1, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 0))
    XCTAssertEqual(2, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 1))
    XCTAssertEqual(2, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 2))
    XCTAssertEqual(PledgeDescriptionCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 0))
    XCTAssertEqual(PledgeAmountCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 1))
    XCTAssertEqual(PledgeShippingLocationCell.defaultReusableId, self.dataSource.reusableId(item: 1, section: 1))
    XCTAssertEqual(PledgeRowCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 2))
    XCTAssertEqual(PledgeContinueCell.defaultReusableId, self.dataSource.reusableId(item: 1, section: 2))
  }

  func testLoad_requiresShippingRules_isFalse() {
    let data = PledgeTableViewData(amount: 100, currency: "USD", delivery: "May 2020", isLoggedIn: false, requiresShippingRules: false)
    self.dataSource.load(data: data)

    XCTAssertEqual(3, self.dataSource.numberOfSections(in: self.tableView))
    XCTAssertEqual(1, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 0))
    XCTAssertEqual(1, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 1))
    XCTAssertEqual(2, self.dataSource.tableView(self.tableView, numberOfRowsInSection: 2))
    XCTAssertEqual(PledgeDescriptionCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 0))
    XCTAssertEqual(PledgeAmountCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 1))
    XCTAssertEqual(PledgeRowCell.defaultReusableId, self.dataSource.reusableId(item: 0, section: 2))
    XCTAssertEqual(PledgeContinueCell.defaultReusableId, self.dataSource.reusableId(item: 1, section: 2))
  }
  // swiftlint:enable line_length
}

import KsApi
import Library
import Prelude
import UIKit

class PledgeTableViewController: UITableViewController {
  // MARK: - Properties

  private let dataSource: PledgeDataSource = PledgeDataSource()
  private let viewModel: PledgeViewModelType = PledgeViewModel()

  // MARK: - Lifecycle

  static func instantiate() -> PledgeTableViewController {
    return PledgeTableViewController(style: .grouped)
  }

  func configureWith(project: Project, reward: Reward) {
    self.viewModel.inputs.configureWith(project: project, reward: reward)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    _ = self.tableView
      |> \.dataSource .~ self.dataSource

    self.tableView.registerCellClass(PledgeAmountCell.self)
    self.tableView.registerCellClass(PledgeContinueCell.self)
    self.tableView.registerCellClass(PledgeDescriptionCell.self)
    self.tableView.registerCellClass(PledgeRowCell.self)
    self.tableView.registerCellClass(PledgeShippingLocationCell.self)
    self.tableView.registerHeaderFooterClass(PledgeFooterView.self)

    self.viewModel.inputs.viewDidLoad()
  }

  // MARK: - Styles

  override func bindStyles() {
    super.bindStyles()

    _ = self.tableView
      |> tableViewStyle
  }

  // MARK: - View model

  override func bindViewModel() {
    super.bindViewModel()

    self.viewModel.outputs.selectedShippingRuleData
      .observeForUI()
      .observeValues { [weak self] selectedShippingRuleData in
        self?.dataSource.loadSelectedShippingRule(data: selectedShippingRuleData)

        guard let shippingIndexPath = self?.dataSource.shippingCellIndexPath() else {
          return
        }

        self?.tableView.reloadRows(at: [shippingIndexPath], with: .automatic)
    }

    self.viewModel.outputs.reloadWithData
      .observeForUI()
      .observeValues { [weak self] data in
        self?.dataSource.load(data: data)

        self?.tableView.reloadData()
    }

    self.viewModel.outputs.shippingIsLoading
      .observeForUI()
      .observeValues { [weak self] isLoading in
        guard let _self = self,
          let shippingIndexPath = _self.dataSource.shippingCellIndexPath() else { return }

        guard let shippingLocationCell = _self.dataSource
            .tableView(_self.tableView, cellForRowAt: shippingIndexPath) as? PledgeShippingLocationCell else {
          return
        }

        shippingLocationCell.animate(isLoading)
    }
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard section < self.dataSource.numberOfSections(in: self.tableView) - 1 else { return nil }

    let footerView = tableView.dequeueReusableHeaderFooterView(withClass: PledgeFooterView.self)
    return footerView
  }

  internal override func tableView(_ tableView: UITableView,
                                   willDisplay cell: UITableViewCell,
                                   forRowAt indexPath: IndexPath) {
    if let descriptionCell = cell as? PledgeDescriptionCell {
      descriptionCell.delegate = self
    }
  }
}

extension PledgeTableViewController: PledgeDescriptionCellDelegate {
 internal func pledgeDescriptionCellDidPresentTrustAndSafety(_ cell: PledgeDescriptionCell) {
    let vc = HelpWebViewController.configuredWith(helpType: .trust)
    let nav = UINavigationController(rootViewController: vc)
    self.present(nav, animated: true, completion: nil)
  }
}

// MARK: - Styles

private func tableViewStyle(_ tableView: UITableView) -> UITableView {
  let style = tableView
    |> \.allowsSelection .~ false
    |> \.separatorStyle .~ UITableViewCell.SeparatorStyle.none
    |> \.contentInset .~ UIEdgeInsets(top: -35)
    |> \.sectionFooterHeight .~ PledgeFooterView.defaultHeight
    |> \.sectionHeaderHeight .~ 0

  if #available(iOS 11, *) { } else {
    let estimatedHeight: CGFloat = 44

    return style
      |> \.contentInset .~ UIEdgeInsets(top: 30)
      |> \.estimatedSectionFooterHeight .~ estimatedHeight
      |> \.estimatedSectionHeaderHeight .~ estimatedHeight
      |> \.estimatedRowHeight .~ estimatedHeight
      |> \.rowHeight .~ UITableView.automaticDimension
  }

  return style
}

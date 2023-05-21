//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 13.03.2023.
//

import UIKit
/// Controller to show and search for location
final class RMLocationViewController: UIViewController, RMLocationViewViewModelDelegate, RMLocationViewDelegate { /* 8 */ /* 1415 add RMLocationViewViewModelDelegate */ /* 1509 add RMLocationViewDelegate */

    private let primaryView = RMLocationView() /* 1357 */
    
    private let viewModel = RMLocationViewViewModel() /* 1363 */
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryView.delegate = self /* 1508 */
        view.addSubview(primaryView) /* 1358 */
        view.backgroundColor = .systemBackground /* 24 */
        title = "Locations" /* 19 */
        addSearchButton() /* 992 */
        addConstraints() /* 1362 */
        viewModel.delegate = self /* 1401 */
        viewModel.fetchLocations() /* 1402 */
    }
    
    private func addSearchButton() { /* 991 copy from RMCharacterViewController and paste */
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch)) /* 991 */
    }
    
    private func addConstraints() { /* 1359 */
        NSLayoutConstraint.activate([ /* 1360 */
           primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 1361 */
           primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 1361 */
           primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 1361 */
           primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) /* 1361 */
        ])
    }
    
    @objc private func didTapSearch() { /* 991 */
        let vc = RMSearchViewController(config: .init(type: .location)) /* 1526 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1527 */
        navigationController?.pushViewController(vc, animated: true) /* 1528 */
    }
    
    //MARK: -RMLocationViewDelegate
    
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) { /* 1510 rmLocationView */
        let vc = RMLocationDetailViewController(location: location) /* 1520 */
//        vc.navigationItem.largeTitleDisplayMode = .never /* 1521 */ /* 2013 comment */
        navigationController?.pushViewController(vc, animated: true) /* 1522 */
    }
    
    //MARK: - LocationViewModel Delegate
    
    func didFetchInitialLocations() { /* 1414 */
        primaryView.configure(with: viewModel) /* 1416 */
    }
}

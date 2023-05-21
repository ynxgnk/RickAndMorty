//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 01.04.2023.
//

import UIKit

/// VC to show details about single episode
final class RMLocationDetailViewController: UIViewController, RMLocationDetailViewViewModelDelegate, RMLocationDetailViewDelegate { /* 1511 */ /* 1524 copy from RMEpisodeDetailViewViewController and change */
    
    private let viewModel: RMLocationDetailViewViewModel /* 1514 */
    
    private let detailView = RMLocationDetailView() /* 1524 */
    
    //MARK: - Init
    
    init(location: RMLocation) { /* 1515 */ /* 1524 */
        let url = URL(string: location.url) /* 1516 */ /* 1525 */
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)/* 1524 */
        super.init(nibName: nil, bundle: nil) /* 1519 */
    }
    
    required init?(coder: NSCoder) { /* 1517 */
        fatalError() /* 1518 */
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView) /* 1524 */
        addConstraints() /* 1524 */
        detailView.delegate = self /* 1524 */
        title = "Location" /* 1512 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare)) /* 1524 */
        viewModel.delegate = self /* 1524 */
        viewModel.fetchLocationData() /* 1524 */
//        view.backgroundColor = .systemGreen /* 1513 */
    }
    
    private func addConstraints() { /* 1524 */
        NSLayoutConstraint.activate([ /* 1524 */
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 1524 */
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 1524 */
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 1524 */
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) /* 1524 */
        ])
    }
    
    @objc private func didTapShare() { /* 1524 */
        
    }
    
    //MARK: - View Delegate
    
    func rmEpisodeDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) { /* 1524 */
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character)) /* 1524 */
        vc.title = character.name /* 1524 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1524 */
        navigationController?.pushViewController(vc, animated: true) /* 1524 */
    }
    
    //MARK: - ViewModel Delegate
    
    func didFetchLocationDetails() { /* 1524 */
        detailView.configure(with: viewModel) /* 1524 */
    }
}

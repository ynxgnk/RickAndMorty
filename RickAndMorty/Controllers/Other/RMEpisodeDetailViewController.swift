//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 25.03.2023.
//

import UIKit

/// VC to show details about single episode
final class RMEpisodeDetailViewController: UIViewController, RMEpisodeDetailViewViewModelDelegate, RMEpisodeDetailViewDelegate { /* 896 add final */ /* 1043 add RM..VVMDeleagte */ /* 1230 add RMEpisodeDetailViewDelegate */
//    private let url: URL? /* 895 */
    private let viewModel: RMEpisodeDetailViewViewModel /* 936 */
    
    private let detailView = RMEpisodeDetailView() /* 979 */
    
    //MARK: - Init
    
    init(url: URL?) { /* 890 */
//        self.url = url /* 891 */
//        self.viewModel = .init(endpointUrl: url) /* 937 */
        self.viewModel = RMEpisodeDetailViewViewModel(endpointUrl: url)/* 1039 replace .init with RMEpisodeDetailViewViewModel */
        super.init(nibName: nil, bundle: nil) /* 892 */
    }
    
    required init?(coder: NSCoder) { /* 893 */
        fatalError() /* 894 */
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView) /* 980 */
        addConstraints() /* 984 */
        detailView.delegate = self /* 1229 */
        title = "Episode" /* 889 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare)) /* 985 add BarButton */
        viewModel.delegate = self /* 1042 */
        viewModel.fetchEpisodeData() /* 1050 */
//        view.backgroundColor = .systemGreen /* 899 */
    }
    
    private func addConstraints() { /* 983 */
        NSLayoutConstraint.activate([ /* 981 */
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 982 */
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 982 */
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 982 */
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) /* 982 */
        ])
    }
    
    @objc private func didTapShare() { /* 986 */
        
    }
    
    //MARK: - View Delegate
    
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) { /* 1231 */
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character)) /* 1232 */
        vc.title = character.name /* 1234 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1235 */
        navigationController?.pushViewController(vc, animated: true) /* 1233 */
    }
    
    //MARK: - ViewModel Delegate
    
    func didFetchEpisodeDetails() { /* 1044 didFetchEpisode */
        detailView.configure(with: viewModel) /* 1045 */
    }
}

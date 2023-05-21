//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 13.03.2023.
//

import UIKit
/// Controller to show and search for episodes
final class RMEpisodeViewController: UIViewController, RMEpisodeListViewDelegate { /* 8 */ /* 955 add RMEpisode..Delegate */
    
    private let episodeListView = RMEpisodeListView() /* 953 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 25 */
        title = "Episodes" /* 20 */
        setUpView() /* 952 */
        addSearchButton() /* 994 */
    }
    
    private func addSearchButton() { /* 993 copy from RMCharacterViewController and paste */
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch)) /* 993 */
    }
    
    @objc private func didTapSearch() { /* 993 */
        let vc = RMSearchViewController(config: .init(type: .episode)) /* 1529 copy from RMLocationViewController */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1529 */
        navigationController?.pushViewController(vc, animated: true) /* 1529 */
    }
    
    private func setUpView() { /* 954 copy from RMCharaacterViewController and change */
        episodeListView.delegate = self /* 954 */
        view.addSubview(episodeListView) /* 954 */
        NSLayoutConstraint.activate([ /* 954 this constrains says: pin the view to the top of the controller, left, right or bottom */
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 954 */
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 954 */
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 954 */
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) /* 954 */
                                    ])
    }
    
    //MARK: - RMEpisodeListViewDelegate
    
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) { /* 956 rmEpisode */
        //Open detail controller for that episode
        let viewModel = RMEpisodeDetailViewViewModel(endpointUrl: URL(string: episode.url)) /* 954 */
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url)) /* 954 */
        detailVC.navigationItem.largeTitleDisplayMode = .never /* 954 */
        navigationController?.pushViewController(detailVC, animated: true) /* 954 */
    }
}

//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 13.03.2023.
//

import UIKit

/// Controller to show and search for characters 
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate { /* 8 */ /* 346 add RMCharacterListViewDelegate */
    
    private let characterListView = RMCharacterListView() /* 152 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 23 */
        title = "Characters" /* 18 */
        setUpView() /* 212 */
        addSearchButton() /* 990 */
    }
    
        private func addSearchButton() { /* 987 */
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch)) /* 988 */
        }
        
    @objc private func didTapSearch() { /* 989 */
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .character)) /* 1007 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 1009 */
        navigationController?.pushViewController(vc, animated: true) /* 1008 */
    }
        
         /* 144 replace this code to CharacterListViewViewModel */
        /*
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self  ) /* 140 change String.self */ { result in  /* 127 */
            switch result { /* 128 */
            case .success(let model): /* 129 */
                //print(String(describing: model)) /* 130 */
                print("Total: "+String(model.info.pages)) /* 141 */
                print("Page result count: "+String(model.results.count)) /* 142 */
            case .failure(let error): /* 131 */
                print(String(describing: error)) /* 132 */
            }
        }
         */
            /*
             let request = RMRequest( /* 86 */
             endpoint: .character,  /* 87 */
             queryParameters: [ /* 88 */
             URLQueryItem(name: "name", value: "rick"), /* 89 */
             URLQueryItem(name: "status", value: "alive") /* 90 */
             ]
             )
             print(request.url) /* 91 */
             
             RMService.shared.execute(request, expecting: RMCharacter.self) { result in  /* 95 */
             switch result { /* 118 */
             case .success: /* 119 */
                 break /* 120 */
             case .failure(let error): /* 121 */
                 print(String(describing: error)) /* 122 */
             }
             }
             */
    
    
    private func setUpView() { /* 211 create func and add this parameters there */
        characterListView.delegate = self /* 345 */
        view.addSubview(characterListView) /* 153 */
        NSLayoutConstraint.activate([ /* 154 this constrains says: pin the view to the top of the controller, left, right or bottom */
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 155 */
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 155 */
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 155 */
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) /* 155 */
        ])
    }
    
    //MARK: - RMCharacterListViewDelegate
    
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) { /* 347 rmCharacterListView */
        // Open detail controller for that character
        let viewModel = RMCharacterDetailViewViewModel(character: character) /* 360 */
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel) /* 361 */
        detailVC.navigationItem.largeTitleDisplayMode = .never /* 366 */
        navigationController?.pushViewController(detailVC, animated: true) /* 362 */
    }
}

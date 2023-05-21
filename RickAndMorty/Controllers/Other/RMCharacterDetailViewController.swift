//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 19.03.2023.
//

import UIKit

/// Controller to show info about single character
final class RMCharacterDetailViewController: UIViewController { /* 348 add final */
    private let viewModel: RMCharacterDetailViewViewModel /* 363 */
    
    private let detailView: RMCharacterDetailView /* 514 */
    
    //MARK: - Init
    
    init(viewModel: RMCharacterDetailViewViewModel) { /* 350 */ /* 355 add RMCharacterDetailViewViewModel */
        self.viewModel = viewModel /* 364 */
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel) /* 583 */
        super.init(nibName: nil, bundle: nil) /* 350 */ 
        
    }
    
    required init?(coder: NSCoder) { /* 351 */
        fatalError("Unsupported") /* 352 */
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() { /* 348 */
        super.viewDidLoad() /* 348 */
        view.backgroundColor = .systemBackground /* 349 */
        title = viewModel.title /* 365 */
        view.addSubview(detailView) /* 515 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        ) /* 519 */
        addConstraints() /* 518 */
//        viewModel.fetchCharacterData() /* 523 */
        
        detailView.collectionView?.delegate = self /* 573 */
        detailView.collectionView?.dataSource = self /* 574 */
    }
    
    @objc private func didTapShare() { /* 520 */
        //Share character info
    }
    
    private func addConstraints() { /* 516 */
        NSLayoutConstraint.activate([ /* 517 copy from RMCharacterViewController and paste*/
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 517 */
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 517 */
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 517 */
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) /* 517 */
        
        ])
    }
}

//MARK: - CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource { /* 565 */
    func numberOfSections(in collectionView: UICollectionView) -> Int { /* 595 numberOfSections */
        return viewModel.sections.count /* 596 */
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 566 numberOfItems */
        let sectionType = viewModel.sections[section] /* 632 */
        switch sectionType { /* 633 */
        case .photo: /* 634 */
            return 1 /* 635 */
        case .information(let viewModels): /* 636 */
            return viewModels.count /* 637 */
        case .episodes(let viewModels): /* 638 */
            return viewModels.count /* 639 */
        }
        /*
        switch section { /* 603 */
    case 0: /* 604*/
        return 1 /* 605 */
    case 1: /* 604 */
        return 8 /* 605 */
    case 2: /* 604 */
        return 20 /* 605 */
    default: /* 604 */
        return 1 /* 605 */
    }
        */
        //return 10 /* 567 */
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 568 cellForItem */
        
        let sectionType = viewModel.sections[indexPath.section] /* 648 copy from collectionView(numOfItems) and paste */
        switch sectionType { /* 633 */
        case .photo(let viewModel): /* 634 */
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier, /* 650 replace "cell" with RM....cellIdentifier */
                for: indexPath
            ) as? RMCharacterPhotoCollectionViewCell else { /* 649 */
                fatalError() /* 651 */
            }
            cell.configure(with: viewModel) /* 666 */
//            cell.backgroundColor = .systemYellow /* 657 */
            return cell /* 652 */
            
        case .information(let viewModels): /* 636 */
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier, /* 653  */
                for: indexPath
            ) as? RMCharacterInfoCollectionViewCell else { /* 653 */
                fatalError() /* 653 */
            }
            cell.configure(with: viewModels[indexPath.row]) /* 667 */
//            cell.backgroundColor = .systemRed /* 656 */
            return cell /* 653 */
            
        case .episodes(let viewModels): /* 638 */
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, /* 654 */
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else { /* 654 */
                fatalError() /* 654 */
            }
            let viewModel = viewModels[indexPath.row] /* 825 */
//            print(viewModel) /* 824 */
            cell.configure(with: viewModel) /* 826 */
//            cell.configure(with: viewModels[indexPath.row]) /* 668 */
//            cell.backgroundColor = .systemOrange /* 655 */
            return cell /* 654 */
        }
        
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "cell",
//            for: indexPath) /* 569 */
//        cell.backgroundColor = .systemPink /* 570 */
//        if indexPath.section == 0 { /* 597 */
//            cell.backgroundColor = .systemPink /* 598 */
//        } else if indexPath.section == 1 { /* 599 */
//            cell.backgroundColor = .systemGreen /* 600 */
//        } else { /* 601 */
//            cell.backgroundColor = .systemBlue /* 602 */
//        }
//        return cell /* 571 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 879 didSelectItemAt */
        let sectionType = viewModel.sections[indexPath.section] /* 880 */
        switch sectionType { /* 881 */
        case .photo, .information: /* 882 */
            break /* 883 */
        case .episodes: /* 884 */
            let episodes = self.viewModel.episodes /* 888 */
            let selection = episodes[indexPath.row] /* 885 */
            let vc = RMEpisodeDetailViewController(url: URL(string: selection)) /* 897 */
            navigationController?.pushViewController(vc, animated: true) /* 898 */
        }
    }
}

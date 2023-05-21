//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 27.03.2023.
//

import UIKit

//Dinamic search option view
//Render results
//Render no results zero state
//Searching / API Call

/// Configurable controller to search
final class RMSearchViewController: UIViewController { /* 995 add final */
    /// Configuration for search session
    struct Config { /* 996 */
        enum `Type` { /* 997 */
            case character /* 998 */ // name | status | gender
            case episode /* 998 */ //allow name
            case location /* 998 */ //allow name | type
            
            var endpoint: RMEndpoint { /* 1840 */
                switch self { /* 1841 */
                case .character: return .character /* 1842 */
                case .episode: return .episode /* 1842 */
                case .location: return .location /* 1842 */
                }
            }
            
            var title: String { /* 1530 */
                switch self { /* 1531 */
                case .character: /* 1532 */
                    return "Search Characters" /* 1533 */
                case .location: /* 1532 */
                    return "Search Location" /* 1533 */
                case .episode: /* 1532 */
                    return "Search Episode" /* 1533 */
                }
            }
        }
        
        let type: `Type` /* 999 */
    }
    
//    private let config: Config /* 1001 */ /* 1606 comment */
    
    private let viewModel: RMSearchViewViewModel /* 1610 */
    private let searchView: RMSearchView /* 1599 */
    
    //MARK: - Init
    
    init(config: Config) { /* 1002 */
//        self.config = config /* 1003 */ /* 1607 comment */
        let viewModel = RMSearchViewViewModel(config: config) /* 1608 */
        self.viewModel = viewModel /* 1609 */
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel) /* 1605 */
        super.init(nibName: nil, bundle: nil) /* 1006 to call the super class initializer */
    }
    
    required init?(coder: NSCoder) { /* 1004 */
        fatalError("Unsupported") /* 1005 */
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title /* 1000 */ /* 1534 change Search */ /* 1606 change config.type.title to viewModel.config */
        view.backgroundColor = .systemBackground /* 1010 */
        view.addSubview(searchView) /* 1600 */
        addConstraints() /* 1602 */
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .done,
            target: self,
            action: #selector(didTapExecuteSearch)
        ) /* 1613 */
        searchView.delegate = self /* 1724 */
    }
    
    override func viewDidAppear(_ animated: Bool) { /* 1671 */
        super.viewDidDisappear(animated) /* 1672 */
        searchView.presentKeyboard() /* 1673 */
    }
    
    @objc private func didTapExecuteSearch() { /* 1614 */
        viewModel.executeSearch() /* 1615 create and comment */ /* 1801 uncomment */
    }
    
    private func addConstraints() { /* 1601 */
        NSLayoutConstraint.activate([ /* 1603 */
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 1604 safeAreaLayoutGuide let you do and tell your device "respect any area where we would have text cut off" */
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 1604 */
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 1604 */
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), /* 1604 */
        ])
    }
}

//MARK: - RMSearchViewDelegate

extension RMSearchViewController: RMSearchViewDelegate { /* 1725 */
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) { /* 1726 rmSear*/
//        print("Should present option picker") /* 1727   */
        let vc = RMSearchOptionPickerViewController(option: option) { [weak self] selection in /* 1774 add selection */ /* 1780 add weak self */
//            print("Did select \(selection)") /* 1775 */
            DispatchQueue.main.async { /* 1781 */
                self?.viewModel.set(value: selection, for: option) /* 1779 */
            }
        } /* 1730 */ /* 1760 add option */
        vc.sheetPresentationController?.detents = [.medium()] /* 1731 means: what height we allow our bottom sheet to use */
        vc.sheetPresentationController?.prefersGrabberVisible = true /* 1733 */
        present(vc, animated: true) /* 1732 */
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) { /* 2010 rmSearchView */
        let vc = RMLocationDetailViewController(location: location) /* 2011 */
        vc.navigationItem.largeTitleDisplayMode = .never /* 2014 */
        navigationController?.pushViewController(vc, animated: true) /* 2012 */
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter) { /* 2199 */
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character)) /* 2200  */
        vc.navigationItem.largeTitleDisplayMode = .never /* 2201 */
        navigationController?.pushViewController(vc, animated: true) /* 2202 */
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode) { /* 2206 */
        let vc = RMEpisodeDetailViewController(url: URL(string: episode.url)) /* 2207  */
        vc.navigationItem.largeTitleDisplayMode = .never /* 2208 */
        navigationController?.pushViewController(vc, animated: true) /* 2209 */
    }
}

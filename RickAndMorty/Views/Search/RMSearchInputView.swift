//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 02.04.2023.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject { /* 1712 */
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didSelectOption option: RMSearchInputViewViewModel.DynamicOption) /* 1713 */
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didChangeSearchText text: String) /* 1851 */
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) /* 1859 */
}

/// View for part of search screen with search bar
final class RMSearchInputView: UIView { /* 1559 add final */
    
    weak var delegate: RMSearchInputViewDelegate? /* 1714 */
    
    private let searchBar: UISearchBar = { /* 1628 */
        let searchBar = UISearchBar() /* 1629 */
        searchBar.placeholder = "Search" /* 1632 */
        searchBar.translatesAutoresizingMaskIntoConstraints = false /* 1630 */
        return searchBar /* 1631 */
    }()
    
    private var viewModel: RMSearchInputViewViewModel? { /* 1656 */
        didSet { /* 1657 */
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else { /* 1658 */
                return /* 1659 */
            }
            let options = viewModel.options /* 1660 */
            createOptionSelectionViews(options: options) /* 1663 */
        }
    }
    
    private var stackView: UIStackView? /* 1791 */
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 1616 */
        super.init(frame: frame) /* 1617 */
        translatesAutoresizingMaskIntoConstraints = false /* 1623 */
//        backgroundColor = .systemPink /* 1624 */
        addSubviews(searchBar) /* 1633 */
        addConstraints() /* 1635 */
        
        searchBar.delegate = self /* 1852 */
    }
    
    required init?(coder: NSCoder) { /* 1618 */
        fatalError() /* 1619 */
    }
    
    //MARK: - Private
    
    private func addConstraints() { /* 1620 */
        NSLayoutConstraint.activate([ /* 1621 */
            searchBar.topAnchor.constraint(equalTo: topAnchor), /* 1634 */
            searchBar.leftAnchor.constraint(equalTo: leftAnchor), /* 1634 */
            searchBar.rightAnchor.constraint(equalTo: rightAnchor), /* 1634 */
            searchBar.heightAnchor.constraint(equalToConstant: 58) /* 1634 */
        ])
    }
    
    private func createOptionStackView() -> UIStackView { /* 1690 */
        let stackView = UIStackView() /* 1675 */
        stackView.translatesAutoresizingMaskIntoConstraints = false /* 1676 */
        stackView.axis = .horizontal /* 1678 */
        stackView.spacing = 6 /* 1707 */
        stackView.distribution = .fillEqually /* 1679 */
        stackView.alignment = .center /* 1680 */
        addSubview(stackView) /* 1677 */
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor), /* 1681 */
            stackView.leftAnchor.constraint(equalTo: leftAnchor), /* 1681 */
            stackView.rightAnchor.constraint(equalTo: rightAnchor), /* 1681 */
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor), /* 1681 */
        ])
        
        return stackView /* 1692 */
    }
    
    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) { /* 1661 */
       let stackView = createOptionStackView() /* 1691 */
//        stackView.backgroundColor = .blue /* 1682 */
        self.stackView = stackView /* 1790 */
        for x in 0..<options.count { /* 1662 */ /* change option in options */
            let option = options[x] /* 1693 */
            let button = createButton(with: option, tag: x) /* 1710 */
            stackView.addArrangedSubview(button) /* 1689 */
        }
    }
    
    private func createButton(
        with option: RMSearchInputViewViewModel.DynamicOption,
        tag: Int
    ) -> UIButton { /* 1709 */
        let button = UIButton() /* 1683 */
        button.setAttributedTitle(
            NSAttributedString(
                string: option.rawValue,
                attributes: [ /* 1703 */
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium), /* 1704 */
                    .foregroundColor: UIColor.label /* 1705 */
                ]
            ),
            for: .normal) /* 1702 attributedTitle lets us nice properties on it font, color... */
//            button.setTitle(option.rawValue, for: .normal) /* 1684 */ /* 1706 comment */
//            button.setTitleColor(.label, for: .normal) /* 1686 */ /* 1706 comment */
        button.backgroundColor = .secondarySystemFill /* 1685 */ /* 1701 change systemYellow  */
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside) /* 1687 */ /* 1695 add _: to didTapButton */
//            print(option.rawValue) /* 1664 */
        button.tag = tag /* 1694 */
        button.layer.cornerRadius = 6 /* 1708 */
        
        return button /* 1711 */
    }
    
    @objc private func didTapButton(_ sender: UIButton) { /* 1688 */
        guard let options = viewModel?.options else { /* 1697 */
            return /* 1698 */
        }
        let tag = sender.tag /* 1696 */
        let selected = options[tag] /* 1699 */
        delegate?.rmSearchInputView(self, didSelectOption: selected) /* 1715 */
//        print("Did tap \(selected.rawValue)") /* 1700 */ /* 1716 comment */
    }
    
    //MARK: - Public
    
    public func configure(with viewModel: RMSearchInputViewViewModel) { /* 1622 */
        searchBar.placeholder = viewModel.searchPlaceholderText /* 1655 */
        self.viewModel = viewModel /* 1666 */
    }
    
    public func presentKeyboard() { /* 1669 */
        searchBar.becomeFirstResponder() /* 1670 it becomes the focus thing to the system in the responder chain */
    }
    
    public func update(
        option: RMSearchInputViewViewModel.DynamicOption,
        value: String
    ) { /* 1789 */
        //Update options
        guard let buttons = stackView?.arrangedSubviews as? [UIButton], /* 1796 add as? [UIButton] */
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option) else { /* 1792 */
            return /* 1793 */
        }
        
        buttons[index].setAttributedTitle( /* 1797 */
            NSAttributedString(
                string: value.uppercased(),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium), /* 1798 */
                    .foregroundColor: UIColor.link /* 1799*/
                ]
            ),
            for: .normal /* 1800 */
        )
    }
}

//MARK: - UISearchBarDelegate

extension RMSearchInputView: UISearchBarDelegate { /* 1853 */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { /* 1854 textDidChange */
        //Notify delegate of changing text
//        print(searchText) /* 1857 */
        delegate?.rmSearchInputView(self, didChangeSearchText: searchText) /* 1856 */
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { /* 1855 searchButtonClicked */
        //Notify that search button was tapped
        searchBar.resignFirstResponder() /* 1863 */
        delegate?.rmSearchInputViewDidTapSearchKeyboardButton(self) /* 1860 */ 
    }
}

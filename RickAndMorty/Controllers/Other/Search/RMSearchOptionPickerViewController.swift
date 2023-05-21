//
//  RMSearchOptionPickerViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 04.04.2023.
//

import UIKit

final class RMSearchOptionPickerViewController: UIViewController { /* 1728 add final */
    private let option: RMSearchInputViewViewModel.DynamicOption /* 1738 */
    private let selectionBlock: ((String) -> Void) /* 1769 */
    
    private let tableView: UITableView = { /* 1740 */
        let table = UITableView() /* 1741 */
        table.translatesAutoresizingMaskIntoConstraints = false /* 1742 */
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell") /* 1743 */
        return table /* 1744 */
    }()
    
    //MARK: - Init
    
    init(option: RMSearchInputViewViewModel.DynamicOption, selection: @escaping (String) -> Void) { /* 1734 */ /* 1768 */
        self.option = option /* 1739 */
        self.selectionBlock = selection /* 1770 */
        super.init(nibName: nil, bundle: nil) /* 1737 */
    }
    
    required init?(coder: NSCoder) { /* 1735 */
        fatalError() /* 1736 */
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 1729 */
        setUpTable() /* 1750 */
       
    }

    private func setUpTable() { /* 1745 */
        view.addSubview(tableView) /* 1746 */
        tableView.delegate = self /* 1747 */
        tableView.dataSource = self /* 1748 */
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 1749 */
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 1749 */
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 1749 */
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), /* 1749 */
        ])
    }
}

extension RMSearchOptionPickerViewController: UITableViewDelegate, UITableViewDataSource { /* 1751 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 1752 numberOfRows */
//        return 4 /* 1753 */
        return option.choices.count /* 1765 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 1754 cellForRowAt */
        let choice = option.choices[indexPath.row] /* 1766 */
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) /* 1757 */
        cell.textLabel?.text = choice.uppercased() /* 1758 */ /* 1767 change "ynxgnk" to choice.uppercased */
        return cell /* 1759 */
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 1755 */
        tableView.deselectRow(at: indexPath, animated: true) /* 1756 */
        let choice = option.choices[indexPath.row] /* 1772 */
        //Inform called of choice
        self.selectionBlock(choice) /* 1773 */
        dismiss(animated: true) /* 1771 */
    }
}

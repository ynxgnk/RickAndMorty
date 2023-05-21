//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 31.03.2023.
//

import UIKit

/// Interface to relay location view events
protocol RMLocationViewDelegate: AnyObject { /* 1495 */
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) /* 1496 */
}

final class RMLocationView: UIView { /* 1331 final */
    
    public weak var delegate: RMLocationViewDelegate? /* 1497 */
    
    private var viewModel: RMLocationViewViewModel? { /* 1366 */
        didSet { /* 1368 */
            spinner.stopAnimating() /* 1369 */
            tableView.isHidden = false /* 1370 */
            tableView.reloadData() /* 1371 */
            UIView.animate(withDuration: 0.3) { /* 1372 */
                self.tableView.alpha = 1 /* 1373 */
            }
            
            viewModel?.registerDidFinishPaginationBlock { [weak self] in /* 2099 */
                DispatchQueue.main.async { /* 2030 */
                    //Loading indicator go bye bye
                    self?.tableView.tableFooterView = nil /* 2100 */
                    //Reload data
                    self?.tableView.reloadData() /* 2031 */
                }
            }
        }
    }
    
    private let tableView: UITableView = { /* 1338 */
        let table = UITableView(frame: .zero, style: .grouped) /* 1339 */ /* 1491 add parameters */
        table.translatesAutoresizingMaskIntoConstraints = false /* 1340 */
        table.alpha = 0 /* 1348 */
        table.isHidden = true /* 1349 */
        table.register(RMLocationTableViewCell.self, /* 1440 change UITableViewCell */
                       forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier) /* 1341 */ /* 1433 change "cell" */
        return table /* 1342 */
    }()
    
    private let spinner: UIActivityIndicatorView = { /* 1344 */
        let spinner = UIActivityIndicatorView() /* 1345 */
        spinner.translatesAutoresizingMaskIntoConstraints = false /* 1346 */
        spinner.hidesWhenStopped = true /* 1347 */
        return spinner /* 1350 */
    }()
    
    //MARK: - Init

    override init(frame: CGRect) { /* 1332 */
        super.init(frame: frame) /* 1333 */
        backgroundColor = .systemBackground /* 1336 */
        translatesAutoresizingMaskIntoConstraints = false /* 1337 */
        addSubviews(tableView, spinner) /* 1343 */
        spinner.startAnimating() /* 1351 */
        addConstraints() /* 1356 */
        configureTable() /* 1388 */
    }
    
    required init?(coder: NSCoder) { /* 1334 */
        fatalError() /* 1335 */
    }
    
    private func configureTable() { /* 1385 */
        tableView.delegate = self /* 1386 */
        tableView.dataSource = self /* 1387 */
    }
    
    private func addConstraints() { /* 1352 */
        NSLayoutConstraint.activate([ /* 1353 */
            spinner.heightAnchor.constraint(equalToConstant: 100), /* 1354 */
            spinner.widthAnchor.constraint(equalToConstant: 100), /* 1354 */
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor), /* 1354 */
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor), /* 1354 */
            
            tableView.topAnchor.constraint(equalTo: topAnchor), /* 1355 */
            tableView.leftAnchor.constraint(equalTo: leftAnchor), /* 1355 */
            tableView.rightAnchor.constraint(equalTo: rightAnchor), /* 1355 */
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor), /* 1355 */
        ])
    }
    
    public func configure(with viewModel: RMLocationViewViewModel) { /* 1365 */
        self.viewModel = viewModel /* 1367 */
    }
}

//MARK: - UITableViewDelegate

extension RMLocationView: UITableViewDelegate { /* 1389 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { /* 1391 didselectRowAt */
        tableView.deselectRow(at: indexPath, animated: true) /* 1392 */
        //        guard let cellViewModels = viewModel?.cellViewModels else { /* 1499 */
        //            fatalError() /* 1500 */
//    }
    guard let locationModel = viewModel?.location(at: indexPath.row) else { /* 1501 */ /* 1506 rewrite */
        return /* 1507 */
    }
        delegate?.rmLocationView(self, didSelect: locationModel) /* 1498 */
    }
}

//MARK: - UITableViewDataSource

extension RMLocationView: UITableViewDataSource { /* 1390 */
//    func numberOfSections(in tableView: UITableView) -> Int { /* 1393 */
//        return 1 /* 1394 */
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { /* 1395 numberOfRowsInSection */
//        return 20 /* 1396 */
        return viewModel?.cellViewModels.count ?? 0 /* 1438 */
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { /* 1397 cellForRowAt */
        guard let cellViewModels = viewModel?.cellViewModels else { /* 1458 */
            fatalError() /* 1459 */
        }
        guard let cell = tableView.dequeueReusableCell(  /* 1437 add guard */
            withIdentifier: RMLocationTableViewCell.cellIdentifier, /* 1398 */ /* 1434 change "cell" */
            for: indexPath
        ) as? RMLocationTableViewCell else { /* 1435 */
            fatalError() /* 1436 */
        }
        let cellViewModel = cellViewModels[indexPath.row] /* 1460 */
//        cell.textLabel?.text = cellViewModel.name /* 1461 */ /* 1490 comment */
        cell.configure(with: cellViewModel) /* 1490 */
//                cell.textLabel?.text = "Hello Rick and Morty" /* 1399 */
                return cell /* 1400 */
    }
}

//MARK: - UIScrollViewDelegate

extension RMLocationView: UIScrollViewDelegate { /* 2058 */
    func scrollViewDidScroll(_ scrollView: UIScrollView) { /* 2059 */
        guard let viewModel = viewModel,
              !viewModel.cellViewModels.isEmpty, /* 2060 copy from 957 */
              viewModel.shouldShowLoadMoreIndicatior,
              !viewModel.isLoadingMoreLocations else { /* 2060 */
            return /* 2060 */
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in /* 2060 */
            let offset = scrollView.contentOffset.y /* 2060 */
            let totalContentHeight = scrollView.contentSize.height /* 2060 */
            let totalScrollViewFixedHeight = scrollView.frame.size.height /* 2060 */
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) { /* 2060 */
                self?.showLoadingIndicator() /* 2067 */
//                DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: { /* 2066 */
                    viewModel.fetchAdditionalLocations() /* 2060 */
//                })
//                DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: { /* 2094 */
//                    print("Refreshing table rows") /* 2094 */
//                    self?.tableView.reloadData() /* 2093 */
//                }) /* 2092 */
            }
            t.invalidate() /* 2060 */
        }
    }
    
    private func showLoadingIndicator() { /* 2068 */
        let footer = RMTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100)) /* 2088 */
//        footer.backgroundColor = .red /* 2089 */
        tableView.tableFooterView = footer /* 2069 */ /* 2087 change RMTableLoadingFooterView */
    }
}

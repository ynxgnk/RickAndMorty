//
//  RMLocationDetailView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 01.04.2023.
//

import UIKit

protocol RMLocationDetailViewDelegate: AnyObject { /* 1215 */
    func rmEpisodeDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter)  /* 1217 */
}

final class RMLocationDetailView: UIView { /* 931 and final */

    public weak var delegate: RMLocationDetailViewDelegate? /* 1216 */
    
    private var viewModel: RMLocationDetailViewViewModel? { /* 1048 */ /* 1097 add didSet */
        didSet { /* 1098 */
            spinner.stopAnimating() /* 1099 */
            self.collectionView?.reloadData() /* 1125 means: to retriger functions in extension RMLocationDetailView(numOfSections...)*/
            self.collectionView?.isHidden = false /* 1100 */
            UIView.animate(withDuration: 0.3) { /* 1101 */
                self.collectionView?.alpha = 1 /* 1102 */
            }
        }
    }
    
    private var collectionView: UICollectionView? /* 1051 */
    
    private let spinner: UIActivityIndicatorView = { /* 1056 */
        let spinner = UIActivityIndicatorView() /* 1057 */
        spinner.translatesAutoresizingMaskIntoConstraints = false /* 1058 */
        spinner.hidesWhenStopped = true /* 1058 */
        return spinner /* 1060  */
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) { /* 934 initframe */
        super.init(frame: frame) /* 935 */
        translatesAutoresizingMaskIntoConstraints = false /* 978 */
//        backgroundColor = .red /* 977 */
        backgroundColor = .systemBackground /* 1084 */
        self.collectionView = createCollectionView() /* 1052 */
        let collectionView = createCollectionView() /* 1072 */
        addSubviews(collectionView, spinner) /* 1074 */
        self.collectionView = collectionView /* 1073 */
        addConstraints() /* 1054 */
        
        spinner.startAnimating() /* 1074 */
    }
    
    required init?(coder: NSCoder) { /* 932 */
        fatalError("Unsupported") /* 933 */
    }

    private func addConstraints() { /* 1046 */
        guard let collectionView = collectionView else { /* 1081 */
            return /* 1082 */
        }
        
        NSLayoutConstraint.activate([ /* 1055 */
            spinner.heightAnchor.constraint(equalToConstant: 100), /* 1077 */
            spinner.widthAnchor.constraint(equalToConstant: 100), /* 1078 */
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor), /* 1079 */
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor), /* 1080 */
            
            collectionView.topAnchor.constraint(equalTo: topAnchor), /* 1083 */
            collectionView.leftAnchor.constraint(equalTo: leftAnchor), /* 1083 */
            collectionView.rightAnchor.constraint(equalTo: rightAnchor), /* 1083 */
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor) /* 1083 */
        ])
    }
    
    private func createCollectionView() -> UICollectionView { /* 1053 */
        let layout = UICollectionViewCompositionalLayout { section, _ in /* 1064 */
            return self.layout(for: section) /* 1065 */
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        ) /* 1061 */
        collectionView.translatesAutoresizingMaskIntoConstraints = false /* 1062 */
        collectionView.isHidden = true /* 1075 */
        collectionView.alpha = 0 /* 1076 */
        collectionView.delegate = self /* 1085 */
        collectionView.dataSource = self /* 1086 */
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, /* 1135 change UICollectionViewCell to RMEpisodeInfoCollectionViewCell */
                                forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier) /* 1093 */ /* 1145 change "cell" to RMEpisodeInfoCollectionViewCel.cellIdentifier */
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier) /* 1146 */
        return collectionView /* 1063  */
    }
    
    //MARK: - Public
    
    public func configure(with viewModel: RMLocationDetailViewViewModel) { /* 1047 */
        self.viewModel = viewModel /* 1049 */
    }
}

extension RMLocationDetailView: UICollectionViewDelegate, UICollectionViewDataSource { /* 1087 */
    func numberOfSections(in collectionView: UICollectionView) -> Int { /* 1088 numberOfSections */
        return viewModel?.cellViewModels.count ?? 0 /* 1126 */
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { /* 1089 */
        guard let sections = viewModel?.cellViewModels else { /* 1127 */
            return 0 /* 1128 */
        }
        let sectionType = sections[section] /* 1129 */
        switch sectionType { /* 1130 */
        case .information(let viewModels): /* 1131 */
            return viewModels.count /* 1132 */
        case .characters(let viewModels): /* 1133 */
            return viewModels.count /* 1134 */
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { /* 1090 cellForItem, to return a cell */
        
        guard let sections = viewModel?.cellViewModels else { /* 1147 copy from 1089 and paste */
            fatalError("No viewModel") /* 1148 */
        }
        let sectionType = sections[indexPath.section] /* 1149 */
        switch sectionType { /* 1150 */
        case .information(let viewModels): /* 1151 */
            let cellViewModel = viewModels[indexPath.row] /* 1152 */
            guard let cell = collectionView.dequeueReusableCell( /* 1153 */
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMEpisodeInfoCollectionViewCell else { /* 1154 */
                fatalError() /* 1155 */
            }
            cell.configure(with: cellViewModel) /* 1156 */
            return cell /* 1157 */
        case .characters(let viewModels): /* 1158 */
            let cellViewModel = viewModels[indexPath.row] /* 1159 copy from .information case and paste */
            guard let cell = collectionView.dequeueReusableCell( /* 1159 */
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? RMCharacterCollectionViewCell else { /* 1159 */
                fatalError() /* 1159 */
            }
            cell.configure(with: cellViewModel) /* 1159 */
            return cell /* 1159 */
        }
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) /* 1094 */
//        cell.backgroundColor = .systemYellow /* 1096 */
//        return cell /* 1095 */
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { /* 1091 didSelectItemAt to select a character */
        collectionView.deselectItem(at: indexPath, animated: true) /* 1092 to deselect an item (unhighlights) */
        
        guard let viewModel = viewModel else { /* 1220 */
            return /* 1221 */
        }
        let sections = viewModel.cellViewModels /* 1222 */
        let sectionType = sections[indexPath.section] /* 1218 */
        
        switch sectionType { /* 1218 */
        case .information: /* 1218 */
           break /* 1219 */
        case .characters: /* 1218 */
            guard let character = viewModel.character(at: indexPath.row) else { /* 1227 */
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character) /* 1228 */
        }
        
    }
}

extension RMLocationDetailView { /* 1066 */
    private func layout(for section: Int) -> NSCollectionLayoutSection { /* 1067 */
        guard let sections = viewModel?.cellViewModels else { /* 1161 */
            return createInfoLayout() /* 1162 */
        }
        
        switch sections[section] { /* 1163 */
        case .information: /* 1164 */
            return createInfoLayout() /* 1165 */
        case .characters: /* 1166 */
            return createCharacterLayout() /* 1167 */
        }
    }
    
    func createInfoLayout() -> NSCollectionLayoutSection { /* 1160 */
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        ) /* 1068 */
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10) /* 1103 */
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(80)),
                                                     subitems: [item]) /* 1069 */
        let section = NSCollectionLayoutSection(group: group) /* 1070 */
        return section /* 1071 */
    }
    
    func createCharacterLayout() -> NSCollectionLayoutSection { /* 1168 copy from createInfoSectionLayout(588) and paste */
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize( /* 1172 copy from */
                widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.5 : 0.25), /* 2183 add UIDevice.isiPhone */
                heightDimension: .fractionalHeight(1.0)
                                              )
        )
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 10,
            bottom: 5,
            trailing: 10
        ) /* 1173 */
        
        let group = NSCollectionLayoutGroup.horizontal( /* 1174 */
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(UIDevice.isiPhone ? 260 : 320) /* 2185 add UIDevice.isiPhone */
            ),
            subitems: UIDevice.isiPhone ? [item, item] : [item, item, item, item] /* 1175 */ /* 2184 add UIdevice and 4 items */
        )
        let section = NSCollectionLayoutSection(group: group) /* 1176 */
        return section /* 1177 */
    }
}

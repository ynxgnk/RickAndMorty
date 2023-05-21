//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 13.03.2023.
//
import StoreKit /* 1328 */
import SafariServices /* 1324 */
import SwiftUI /* 1278 */
import UIKit
/// Controller to show and search for settings
final class RMSettingsViewController: UIViewController { /* 8 */

//    private let viewModel = RMSettingsViewViewModel( /* 1259 */
//        cellViewModels: RMSettingsOption.allCases.compactMap({ /* 1260 it will loop over all cases */
//            return RMSettingsCellViewModel(type: $0) /* 1261 */
//        })
//    )
    
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>? /* 1279 */ /* 1301 UIHostingController?*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground /* 22 */
        title = "Settings" /* 21 */
        addSwiftUIController() /* 1281 */
    }
    
    private func addSwiftUIController() { /* 1280 */
        let settingsSwiftUIController = UIHostingController(
            rootView: RMSettingsView(
                viewModel: RMSettingsViewViewModel( /* 1259 */
                    cellViewModels: RMSettingsOption.allCases.compactMap({ /* 1260 it will loop over all cases */
                        return RMSettingsCellViewModel(type: $0) { [weak self] option in /* 1261 */ /* 1309 add option in */ /* 1316 add weak self */
//                            print(option.displayTitle) /* 1310 */
                            self?.handleTap(option: option) /* 1315 */
                        }
                    })
                )
            )
        ) /* 1279 */
        addChild(settingsSwiftUIController) /* 1281 */
        settingsSwiftUIController.didMove(toParent: self) /* 1282 */
    
        view.addSubview(settingsSwiftUIController.view) /* 1283 */
        settingsSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false /* 1284 */
        
        NSLayoutConstraint.activate([ /* 1285 */
            settingsSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), /* 1286 */
            settingsSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), /* 1286 */
            settingsSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), /* 1286 */
            settingsSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), /* 1286 */
        ])
        
        self.settingsSwiftUIController = settingsSwiftUIController /* 1302 */
    }
    
    private func handleTap(option: RMSettingsOption) { /* 1314 */
        guard Thread.current.isMainThread else { /* 1317 to be sure that when we do a UI interaction, this function will always be called on the main thread */
        return /* 1318 */
        }
        
        if let url = option.targetUrl { /* 1323 */
            //open website
            let vc = SFSafariViewController(url: url) /* 1325 */
            present(vc, animated: true) /* 1326 */
        } else if option == .rateApp { /* 1327 */
            //Show rating prompt
                if let windowScene = self.view.window?.windowScene { /* 1329 */
                    SKStoreReviewController.requestReview(in: windowScene) /* 1330 */
            }
        }
    }
}

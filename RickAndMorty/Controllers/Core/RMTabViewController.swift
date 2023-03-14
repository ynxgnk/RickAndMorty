//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 13.03.2023.
//

import UIKit

final class RMTabBarController: UITabBarController { /* 7 */ /* 8 final - means that it cant be subclassed */

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .red /* 0 */
        setUpTabs() /* 10 */
    }

    private func setUpTabs() { /* 9 */
        let charactersVC = RMCharacterViewController() /* 10 */
        let locationsVC = RMLocationViewController() /* 11 */
        let episodesVC = RMEpisodeViewController() /* 12 */
        let settingsVC = RMSettingsViewController() /* 13 */
        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic /* 28 */
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic /* 29 */
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic /* 30 */
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic /* 31 */
        
        /*
        charactersVC.title = "Characters" /* 18 */
        locationsVC.title = "Locations" /* 19 */
        episodesVC.title = "Episodes" /* 20 */
        settingsVC.title = "Settings" /* 21 */
        */
        
        let nav1 = UINavigationController(rootViewController: charactersVC) /* 14 */
        let nav2 = UINavigationController(rootViewController: locationsVC) /* 15 */
        let nav3 = UINavigationController(rootViewController: episodesVC) /* 16 */
        let nav4 = UINavigationController(rootViewController: settingsVC) /* 17 */
        
        nav1.tabBarItem = UITabBarItem(title: "Characters",
                                       image: UIImage(systemName: "person"),
                                       tag: 1) /* 32 */
        nav2.tabBarItem = UITabBarItem(title: "Locations",
                                       image: UIImage(systemName: "globe"),
                                       tag: 2) /* 33 */
        nav3.tabBarItem = UITabBarItem(title: "Episodes",
                                       image: UIImage(systemName: "tv"),
                                       tag: 3) /* 34 */
        nav4.tabBarItem = UITabBarItem(title: "Settings",
                                       image: UIImage(systemName: "gear"),
                                       tag: 4) /* 35 */
        
        for nav in [nav1, nav2, nav3, nav4] { /* 26 */
            nav.navigationBar.prefersLargeTitles = true /* 27 */
            
        }
        setViewControllers( /* 22 */
            [nav1, nav2, nav3, nav4],
            animated: true
        )
    }
}

//command+shift+C - to copy name

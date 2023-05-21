//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 13.03.2023.
//

import UIKit

/// Controller to house tabs and roottab controllers
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

//Equatable(allows the equation of this object whether two things are equal to one another)
//NSCache - handles getting rid of caches in session(memory) in case memory is getting low
//a Dispatch group lets you kick off any number of parallel requests and then we get notified once all done
/* 1028 defer means: this is the last thing thats going to run before the execution of our program exits the scope of this closure(switch will run firstly, and the last stand is going to run its going to tell our group "whatever thing we kicked off and started, we left that */
/* public private(set) var sections -  1111 we dont want public to be able to delete the sections or modify, it lets this property be public, but not for writing to it, only to reading */
/* 1604 safeAreaLayoutGuide let you do and tell your device "respect any area where we would have text cut off" */

//command+shift+C - to copy name
//command+/ - to comment a line
//command+B - to compile
//command+option+/ - to add a desctiption
//hold option and drug - to fastly and multyline change
//command+F - to open search
//highlight+ctrl+I - to fix all indentation
//click enter - to remove a completion handler
//command+K - to clear a console
//drag away - to delete a breakpoint
//command+shift+O - to search for any file in project
//command+W - to close files in Xcode
//command+A - to highlinght everything in file
//fn+enter = to split a provided code
//command+shift+Y - to open a console

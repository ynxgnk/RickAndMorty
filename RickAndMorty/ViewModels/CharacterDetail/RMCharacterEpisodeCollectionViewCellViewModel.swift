//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 22.03.2023.
//

import UIKit /* 971 UIKit */

protocol RMEpisodeDataRender { /* 847, this protocol is going to define  the signature of what data we need */
    var name: String { get } /* 848 */
    var air_date: String { get } /* 849 */
    var episode: String { get } /* 850 */
}

final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable { /* 615 */ /* 958 add Hashable and Equatable */
    private let episodeDataUrl: URL? /* 675 */
    private var isFetching = false /* 830 */
    private var dataBlock: ((RMEpisodeDataRender) -> Void)? /* 853 */
    
    public let borderColor: UIColor /* 970 */
    
    private var episode: RMEpisode? { /* 840 */
        didSet { /* 843 */
            guard let model = episode else { /* 844 */
                return /* 845 */
            }
            dataBlock?(model) /* 855 */
        }
    }
    
    //MARK: -init
    
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) { /* 616 */ /* 969 add borderColor */
        self.episodeDataUrl = episodeDataUrl /* 676 */
        self.borderColor = borderColor /* 972 */
    }
    
    //MARK: - Public
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) { /* 846 */ /* 852 add RMEpisodeDaraRender as parameter*/
        self.dataBlock = block /* 854 */
    }
    
    public func fetchEpisode() { /* 820 */
//        print(episodeDataUrl) /* 823 */
        guard !isFetching else { /* 831 */
            if let model = episode {
                self.dataBlock?(model) /* 859 */
            }
            return /* 832 */
        }
        
        guard let url = episodeDataUrl, let request = RMRequest(url: url) else { /* 821 */
            return /* 822 */
        }
        
        isFetching = true /* 833 */
        
//        print("created") /* 828 */
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in /* 839 */
            switch result { /* 834 */
            case .success(let model): /* 835 */ /* 841 change success to model*/
                //print(String(describing: success.id)) /* 836 */
                DispatchQueue.main.async { /* 856 */
                    self?.episode = model /* 842 */
                }
            case .failure(let failure): /* 837 */
                print(String(describing: failure)) /* 838 */
            }
        } /* 829 */
    }
    
    func hash(into hasher: inout Hasher) { /* 959 hastinto */
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "") /* 960 */
    }
    
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel, rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool { /* 961 */
        return lhs.hashValue == rhs.hashValue /* 962 */
    }
}

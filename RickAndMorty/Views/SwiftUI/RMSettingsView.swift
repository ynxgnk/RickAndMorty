//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Nazar Kopeyka on 30.03.2023.
//

import SwiftUI

struct RMSettingsView: View {
    let viewModel: RMSettingsViewViewModel /* 1270 */
    
    init(viewModel: RMSettingsViewViewModel) { /* 1271 */
        self.viewModel = viewModel /* 1272 */
    }
    
    var body: some View {
//        ScrollView(.vertical) { /* 1275 */
            List(viewModel.cellViewModels) { viewModel in /* 1276 */
                HStack { /* 1287 */
                    if let image = viewModel.image { /* 1288 */
                        Image(uiImage: image) /* 1289 */
                            .resizable() /* 1290 */
                            .renderingMode(.template) /* 1291 */
                            .foregroundColor(Color.white) /* 1292 */
                            .aspectRatio(contentMode: .fit) /* 1293 */
                            .frame(width: 20, height: 20) /* 1294 */
                            .foregroundColor(Color.red) /* 1295 */
                            .padding(8) /* 1296 */
                            .background(Color(viewModel.iconContainerColor)) /* 1297 */
                            .cornerRadius(6) /* 1298 */
                    }
                    Text(viewModel.title) /* 1277 */
                        .padding(.leading, 10) /* 1299 */
                    
                    Spacer() /* 1312 */
                }
                .padding(.bottom, 3) /* 1300 */
                .onTapGesture { /* 1303 */
                    viewModel.onTapHandler(viewModel.type) /* 1304 */
                }
//                .background(Color.red) /* 1313 */
            }
//        }
    }
}


struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({ /* 1273 */
            return RMSettingsCellViewModel(type: $0) { option in /* 1274 */ /* 1311 add { option in */
                
            }
        })))
    }
}

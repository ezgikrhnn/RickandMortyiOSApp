//
//  RMSettingsView.swift
//  RickyAndMorty
//
//  Created by Ezgi Karahan on 17.03.2024.
//
/**
 -swiftUI özellikli bir view sınıfı-
 */
import SwiftUI

struct RMSettingsView: View {
    let viewModel : RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel){
        self.viewModel = viewModel
    }
  
    var body: some View {
      
            List(viewModel.cellViewModels){ viewModel in
                HStack{
                    if let image = viewModel.image{
                        Image(uiImage: image)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .frame(width: 30, height: 30)
                            .background(Color(viewModel.iconContainerColor))
                            .cornerRadius(6)
                            
                    }
                    Text(viewModel.title)
                        .padding(.leading, 10)
                    
                    Spacer()
                }.padding(5)
                    .onTapGesture {
                        viewModel.onTapHandler(viewModel.type)
                    }
            }
    }
}

struct RMSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { option in
                
            }
        })))
    }
}

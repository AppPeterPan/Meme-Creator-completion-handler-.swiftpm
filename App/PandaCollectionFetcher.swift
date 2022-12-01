/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

class PandaCollectionFetcher: ObservableObject {
    @Published var imageData = PandaCollection(sample: [Panda.defaultPanda])
    @Published var currentPanda = Panda.defaultPanda
    var error: Error? {
         willSet {
             DispatchQueue.main.async {
                 self.showError = newValue != nil
             }
         }
     }
     @Published var showError = false
    
    let urlString = "http://playgrounds-cdn.apple.com/assets/pandaData.json"
    
    
    func fetchData()   {
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let imageData = try JSONDecoder().decode(PandaCollection.self, from: data)
                    DispatchQueue.main.async {
                        self.imageData = imageData
                        self.error = nil
                    }
                } catch  {
                    self.error = error
                }
            } else {
                self.error = error
            }
        }.resume()
    }
    
}

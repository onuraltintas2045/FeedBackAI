//
//  ViewModel.swift
//  FeedBackAI
//
//  Created by Onur Altintas on 18.04.2024.
//

import Foundation
import OpenAI

class ViewModel: ObservableObject {
    let openAI = OpenAI(apiToken: "YOUR_API_KEY")
    @Published var textResponse: String = ""
    
    func getResponseAI(prompt: String){
        DispatchQueue.main.async {
            self.textResponse = ""
        }
        let query = ChatQuery(messages: [.init(role: .user, content: prompt)!], model: .gpt4)
        openAI.chats(query: query) { result in
            switch result {
            case .success(let compResult):
                if let content = compResult.choices.first?.message.content {
                    switch content{
                    case .string(let contentString):
                        DispatchQueue.main.async {
                            self.textResponse = contentString
                        }
                    case .chatCompletionContentPartTextParam(_): break
                    case .chatCompletionContentPartImageParam(_): break
                    }
                } else {
                    print("Cevap bulunamadı")
                    self.textResponse = "Cevap bulunamadı"
                }
            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
                self.textResponse = "Hata: \(error.localizedDescription)"
            }
        }
    }
}

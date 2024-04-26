//
//  ContentView.swift
//  FeedBackAI
//
//  Created by Onur Altintas on 17.04.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var prompt: String = ""
    @State var angryLevel: Double = 0
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack {
                    TextField("Lutfen prompt giriniz", text: $prompt, axis: .vertical)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    VStack{
                        Text("Anger Level")
                            .font(.title2.bold())
                            .padding()
                        Text("\(Int(angryLevel))")
                        Slider(value: $angryLevel, in: 0...100)
                            .accentColor(.blue)
                    }
                    .padding()
                    Button(action: {
                        viewModel.getResponseAI(prompt: modifyText(promt: prompt))
                    }, label: {
                        Text("Check Feedback")
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(Color.white)
                            .cornerRadius(10)
                    })
                    .padding()
                    
                    Text(viewModel.textResponse)
                        .padding()
                        .foregroundStyle(Color.blue)
                        .frame(width: viewModel.textResponse == "" ? 0 : UIScreen.main.bounds.width * 0.95)
                        .background(Color.black.opacity(0.8))
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Feedback")
            
        }
        
    }
    
    func modifyText(promt: String) -> String {
        let newText: String = """
         Identify the following elements in a Feedback text:
                  - Publishability(true or false)
                  - Opinion(Positive or negative)
                  - Is the critic expressing anger? (true or false)
                  - Product purchased by reviewer
                  - Brand of the product
                  - Seller of the product
                  - Anger level
          The review text is given in triple single quotation marks.
          Format your response as a JSON object.
          Use "Publishability", "Opinion", "Anger", "Product", "Brand", "Vendor", "Anger Level" as keys.
         If information is not available, use "unknown".
         Keep your answer as short as possible; Your answer is written below in curly brackets; It must contain the json object.
         If the Angry Level is less than \(Int(angryLevel)), Publishability must be True. If the Angry Level is greater than \(Int(angryLevel)), Publishability must be False.
         Format the publishability value as bool.
         Format the rage value as bool.
         Calculate Anger Level from 0 to 100.

         Feedback text: '''\(prompt)'''
         """
        print(newText)
        return newText
    }
}

#Preview {
    ContentView()
}

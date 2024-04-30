//
//  ContentView.swift
//  KaaS
//
//  Created by Martynas Baranskas on 30/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var quote: String = ""
    
    var body: some View {
        VStack {
            Image("Kanye")
            
            Text("KaaS")
                .font(.title)
                .bold()
            Text("Kanye as a Service")
            
            
            Spacer()
            
            Text("\"\(quote)\"")
                .padding()
                .italic()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button("Generate Quote", action: {fetchQuote()})
                .padding()
                .background(.green)
                .foregroundColor(.white)
                .cornerRadius(20)

        }
        .onAppear {
            fetchQuote()
        }
        .padding()
    }
    
    func fetchQuote() {
        guard let url = URL(string: "https://api.kanye.rest") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let quoteResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
                DispatchQueue.main.async {
                    self.quote = quoteResponse.quote
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

struct QuoteResponse: Codable {
    let quote: String
}

#Preview {
    ContentView()
}

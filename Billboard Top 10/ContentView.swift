//
//  ContentView.swift
//  Billboard Top 10
//
//  Created by Student on 2/25/21.
//

import SwiftUI

struct ContentView: View {
    @State private var songs = [Song]()
    var body: some View {
        NavigationView {
            List(songs) { song in
                NavigationLink(
                    destination: VStack {
                        Text(song.rank)
                            .padding()
                        Text(song.title)
                            .padding()
                        Text(song.artist)
                        Text(song.lastWeek)
                    },
                    label: {
                        HStack {
                            Text(song.title)
                            Text(song.artist)
                        }
                    })
            }
            .navigationTitle("Billboard Top 10")
        }
        .onAppear(perform: {
            queryAPI()
        })
    }
    
    func queryAPI() {
        let apiKey = "&rapidapi-key=53c34bdf56msha93492520b56cffp1c92cajsn116ab7eb6ea6"
        let query = "https://billboard-api2.p.rapidapi.com/hot-100?date=2021-02-13&range=1-10\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json["contents"].arrayValue
                for item in contents {
                    let title = item["title"].stringValue
                    let artist = item["artist"].stringValue
                    let rank = item["rank"].stringValue
                    let lastWeek = item["last week"].stringValue
                    let song = Song(title: title, artist: artist, rank: rank, lastWeek: lastWeek)
                    songs.append(song)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Song: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let rank: String
    let lastWeek: String
}

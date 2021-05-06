import UIKit

struct Person: Decodable {
    
    let name: String
    let films: [URL]
}

struct Film: Decodable {
    
    let title: String
    //    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    
    static let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        //step one create URL
        guard let baseURL = baseURL else {return completion(nil)}
        let peopleURL = baseURL.appendingPathComponent("people")
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        
        //step two Data Task
        URLSession.shared.dataTask(with: finalURL) { data , _ , error in
            //step three error handling
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            //step four check for data
            guard let data = data else {return completion (nil)}
            
            //step five decode the data
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) ->Void) {
        
        // step one contact server
        
        // step two data task
        URLSession.shared.dataTask(with: url) { data , _ , error  in
            
            // error handling
            if let error = error  {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            
            // check for data
            guard let data = data else {return completion(nil)}
            // decode the data
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL) {
        SwapiService.fetchFilm(url: url) { film in
            if let film = film {
                print(film)
            }
        }
    }
}//End of Class

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person)
        for film in person.films {
            SwapiService.fetchFilm(url: film)
        }
    }
}


//
//  XmlParserManager.swift
//  WiredFeedsTestApp
//
//  Created by Володимир Ільків on 1/12/19.
//  Copyright © 2019 Володимр Ільків. All rights reserved.
//

import Foundation
import UIKit

class XmlParserManager : NSObject, XMLParserDelegate{
    
    private var rssItems : [RSSItem] = []
    private var currentElement = ""
    private var currentTitle : String = "" {
        didSet{
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription : String = "" {
        didSet{
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentLink : String = "" {
        didSet{
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate : String = "" {
        didSet{
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentImgUrlString : String = "" {
        didSet{
            currentImgUrlString = currentImgUrlString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parseComletionHandler : (([RSSItem]) -> Void)?
    
    func parseFeed(url : String, completionHandler : (([RSSItem]) -> Void)?){
        self.parseComletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with : request){(data,response,error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
        }
        task.resume()
    }
    
    //MARK : - XML Parser Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
            currentLink = ""
            currentPubDate = ""
        }else if currentElement == "media:thumbnail" {
            if let urlString = attributeDict["url"]{
                currentImgUrlString = urlString
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch  currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "link": currentLink += string
        case "pubDate": currentPubDate += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = RSSItem(title: currentTitle, description: currentDescription, link: currentLink, pubDate: currentPubDate, imgUrlString: currentImgUrlString)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parseComletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        let alert = UIAlertController(title: "Error", message: parseError.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
}

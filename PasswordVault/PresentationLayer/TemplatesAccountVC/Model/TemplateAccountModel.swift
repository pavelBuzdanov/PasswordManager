//
//  TemplateAccountModel.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 23.04.2021.
//

import Foundation

struct TemplateAccountModel {
    let title: String
    let url: String
    let imageName: String
}

extension TemplateAccountModel {
    
    static let defaultModels = [
        TemplateAccountModel(title: "Apple", url: "https://www.apple.com", imageName: "appleIcon"),
        TemplateAccountModel(title: "Google", url: "https://www.google.com", imageName: "googleIcon"),
        TemplateAccountModel(title: "Behance", url: "https://www.behance.net", imageName: "behanceIcon"),
        TemplateAccountModel(title: "Dropbox", url: "https://www.dropbox.com", imageName: "dropboxIcon"),
        TemplateAccountModel(title: "Dribble", url: "https://dribbble.com", imageName: "dribbleIcon"),
        TemplateAccountModel(title: "Facebook", url: "https://www.facebook.com", imageName: "facebookIcon"),
        TemplateAccountModel(title: "Twitter", url: "https://twitter.com", imageName: "twitterIcon"),
        TemplateAccountModel(title: "Instagram", url: "https://www.instagram.com", imageName: "instagramIcon"),
        TemplateAccountModel(title: "Linkedin", url: "https://www.linkedin.com", imageName: "linkedinIcon"),
        TemplateAccountModel(title: "Reddit", url: "https://www.reddit.com", imageName: "redditIcon"),
        TemplateAccountModel(title: "Wikipedia", url: "https://en.wikipedia.org", imageName: "wikipediaIcon"),
        TemplateAccountModel(title: "Pinterest", url: "https://www.pinterest.com", imageName: "pinterestIcon"),
        TemplateAccountModel(title: "Yahoo", url: "https://www.yahoo.com", imageName: "yahooIcon"),
        TemplateAccountModel(title: "Yelp", url: "https://www.yelp.com", imageName: "yelpIcon"),
        TemplateAccountModel(title: "Netflix", url: "https://www.netflix.com", imageName: "netflixIcon"),
    ]
    
}

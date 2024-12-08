//
//  SampleData.swift
//  Care4U
//
//  Created by Lisis Ruschel on 10.11.24.
//

import Foundation

let sampleUser = User(
    id: "12345",
    email: "sampleuser@example.com",
    fullName: "John Doe",
    birthDate: Calendar.current.date(byAdding: .year, value: -30, to: Date())!,
    location: "New York, USA",
    description: "A software developer who loves coding and coffee.",
    latitude: 40.7128,
    longitude: -74.0060,
    memberSince: Date(),
    profilePicURL: "https://example.com/path/to/profile/pic.jpg",
    bookmarks: ["post1", "post2", "post3"]
)


let sampleRequest = Request(
    id: "12345",
    senderUserId: "user123",
    recipientUserId: "user456",
    postId: "post789",
    postTitle: "Cat sitting",
    status: .accepted,
    timestamp: Date(),
    completionDate: nil,
    message: "I would like to request your service for cleaning my garden.",
    contactInfo: "contact@example.com"
)

let samplePost =  Post(
    id: "1",
    userId: "1",
    type: "Type",
    title: "Sample Post",
    description: "This is a sample post description.",
    isActive: true,
    exchangeCoins: ["Coin1", "Coin2"],
    categories: ["Category1", "Category2"],
    createdOn: Date(),
    latitude: 52.5200,
    longitude: 13.4050,
    postLocation: "Berlin"
)


let randomPosts: [Post] = [
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.offer.rawValue,
        title: "Dog Walking Service",
        description: "I can walk your dog in the afternoons for an hour. I have experience with all dog sizes.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.paid.rawValue],
        categories: [CategoriesEnum.petCare.rawValue],
        createdOn: Date(),
        latitude: 37.7749,
        longitude: -122.4194,
        postLocation: "San Francisco"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.search.rawValue,
        title: "Need Help with Grocery Shopping",
        description: "Looking for someone to help me with weekly grocery shopping and delivery.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.exchange.rawValue],
        categories: [CategoriesEnum.runErrands.rawValue],
        createdOn: Date(),
        latitude: 40.7128,
        longitude: -74.0060,
        postLocation: "New York"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.offer.rawValue,
        title: "Math Tutoring Available",
        description: "I am offering math tutoring services for high school students. Available weekday evenings.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.paid.rawValue, ExchangeCoinEnum.exchange.rawValue],
        categories: [CategoriesEnum.academic.rawValue],
        createdOn: Date(),
        latitude: 34.0522,
        longitude: -118.2437,
        postLocation: "Los Angeles"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.search.rawValue,
        title: "Looking for Pet Sitter",
        description: "I need someone to take care of my cat while I am on vacation next month.",
        isActive: false,
        exchangeCoins: [ExchangeCoinEnum.paid.rawValue],
        categories: [CategoriesEnum.petCare.rawValue],
        createdOn: Date(),
        latitude: 37.7749,
        longitude: -122.4194,
        postLocation: "San Francisco"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.offer.rawValue,
        title: "Custom Meal Preparation",
        description: "I prepare home-cooked meals based on your preferences. Vegan and gluten-free options available.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.paid.rawValue],
        categories: [CategoriesEnum.cooking.rawValue],
        createdOn: Date(),
        latitude: 40.7128,
        longitude: -74.0060,
        postLocation: "New York"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.search.rawValue,
        title: "Need Help with Website Design",
        description: "Looking for a tech-savvy person to help design my personal website. Flexible schedule.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.exchange.rawValue],
        categories: [CategoriesEnum.technologyAssistance.rawValue],
        createdOn: Date(),
        latitude: 34.0522,
        longitude: -118.2437,
        postLocation: "Los Angeles"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.offer.rawValue,
        title: "Local Rides Available",
        description: "I can offer short-distance rides within the city for a small fee. Available on weekends.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.paid.rawValue],
        categories: [CategoriesEnum.transportation.rawValue],
        createdOn: Date(),
        latitude: 40.7128,
        longitude: -74.0060,
        postLocation: "New York"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.search.rawValue,
        title: "Looking for Cleaning Service",
        description: "I need someone to clean my 2-bedroom apartment once a week.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.paid.rawValue, ExchangeCoinEnum.exchange.rawValue],
        categories: [CategoriesEnum.cleaning.rawValue],
        createdOn: Date(),
        latitude: 37.7749,
        longitude: -122.4194,
        postLocation: "San Francisco"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.offer.rawValue,
        title: "Home Office Setup Assistance",
        description: "I can help you set up and organize your home office, including tech support and furniture arrangement.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.exchange.rawValue],
        categories: [CategoriesEnum.technologyAssistance.rawValue],
        createdOn: Date(),
        latitude: 34.0522,
        longitude: -118.2437,
        postLocation: "Los Angeles"
    ),
    Post(
        id: UUID().uuidString,
        userId: "hNFI7G8kGHfWz7fu8prJnGaV0F62",
        type: PostTypeEnum.search.rawValue,
        title: "Need Childcare Services",
        description: "Looking for a babysitter to watch my 2-year-old son on weekdays. Experience required.",
        isActive: true,
        exchangeCoins: [ExchangeCoinEnum.paid.rawValue],
        categories: [CategoriesEnum.childcareServices.rawValue],
        createdOn: Date(),
        latitude: 40.7128,
        longitude: -74.0060,
        postLocation: "New York"
    )
]

let randomPostsDE: [Post] = [
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Offer",
        title: "Home-Cooked Meals Delivery",
        description: "Offering fresh, home-cooked meals delivered to your doorstep in Berlin.",
        isActive: true,
        exchangeCoins: ["Paid"],
        categories: ["Cooking", "Run Errands"],
        createdOn: Date(),
        latitude: 52.5200,
        longitude: 13.4050,
        postLocation: "Berlin"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Search",
        title: "Dog Walker Needed",
        description: "Looking for a dog walker for my golden retriever in Munich during weekdays.",
        isActive: true,
        exchangeCoins: ["Paid", "Exchange"],
        categories: ["Pet Care"],
        createdOn: Date(),
        latitude: 48.1351,
        longitude: 11.5820,
        postLocation: "Munich"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Offer",
        title: "Tech Support for Seniors",
        description: "Providing technology assistance for seniors in Hamburg. Learn to use your smartphone, computer, or tablet.",
        isActive: true,
        exchangeCoins: ["Exchange"],
        categories: ["Technology Assistance"],
        createdOn: Date(),
        latitude: 53.5511,
        longitude: 9.9937,
        postLocation: "Hamburg"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Offer",
        title: "Grocery Shopping Assistance",
        description: "Need help with grocery shopping? I'm happy to assist you in Frankfurt!",
        isActive: true,
        exchangeCoins: ["Exchange", "Paid"],
        categories: ["Run Errands", "Cleaning"],
        createdOn: Date(),
        latitude: 50.1109,
        longitude: 8.6821,
        postLocation: "Frankfurt"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Search",
        title: "Help with Assembling IKEA Furniture",
        description: "Need assistance assembling new furniture in my apartment in Stuttgart.",
        isActive: true,
        exchangeCoins: ["Paid"],
        categories: ["DIY Assistance"],
        createdOn: Date(),
        latitude: 48.7758,
        longitude: 9.1829,
        postLocation: "Stuttgart"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Offer",
        title: "Personal Training Sessions",
        description: "Offering personal fitness training sessions in Düsseldorf. Stay fit and healthy!",
        isActive: true,
        exchangeCoins: ["Paid"],
        categories: ["Health & Wellness"],
        createdOn: Date(),
        latitude: 51.2277,
        longitude: 6.7735,
        postLocation: "Düsseldorf"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Search",
        title: "Childcare Needed for 2 Children",
        description: "Looking for a babysitter for my 2 kids in Cologne for weekday afternoons.",
        isActive: true,
        exchangeCoins: ["Paid", "Exchange"],
        categories: ["Childcare Services"],
        createdOn: Date(),
        latitude: 50.9375,
        longitude: 6.9603,
        postLocation: "Cologne"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Offer",
        title: "Basic Administrative Support",
        description: "Offering administrative support for freelancers and self-employed workers in Leipzig.",
        isActive: true,
        exchangeCoins: ["Paid", "Exchange"],
        categories: ["Administrative Support"],
        createdOn: Date(),
        latitude: 51.3397,
        longitude: 12.3731,
        postLocation: "Leipzig"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Offer",
        title: "Meal Preparation Assistance",
        description: "Need help preparing meals for your family in Dresden? I can assist with cooking and meal prep.",
        isActive: true,
        exchangeCoins: ["Exchange"],
        categories: ["Cooking", "Personal Care & Assistance"],
        createdOn: Date(),
        latitude: 51.0504,
        longitude: 13.7373,
        postLocation: "Dresden"
    ),
    Post(
        id: UUID().uuidString,
        userId: "7bDxr0p08gOXm0XMKergNj2cDOH3",
        type: "Search",
        title: "Looking for Ride to Berlin",
        description: "Need a ride from Nuremberg to Berlin next week. Willing to pay for petrol costs.",
        isActive: true,
        exchangeCoins: ["Paid"],
        categories: ["Transportation"],
        createdOn: Date(),
        latitude: 49.4521,
        longitude: 11.0767,
        postLocation: "Nuremberg"
    )
]


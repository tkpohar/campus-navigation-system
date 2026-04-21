//
//  ContentView.swift
//  Reggie's Map
//
//  Created by angel hernandez on 6/17/25.
//

import SwiftUI

extension Color {
    static let PrimaryColor = Color("PrimaryColor")
    static let SecondaryColor = Color("SecondaryColor")         // used to keep color consistancy also isus color
}



struct ContentView: View {
    // state for navagation
    @State private var selection: Int = 0
    
    // states for the header
    @State private var searchBarIsPresented: Bool = false
    @State private var isSearchablePage: Bool = false
    @State private var searchBarInput: String = ""
    @State private var searchBarPrompt: String = ""
    
    
    
    var body: some View {
        VStack{
            switch selection {
            case 0:
                searchHeaderSection                                              // header to helper with searches
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.PrimaryColor)// rectangle to create underline
                ScrollView{
                    HomeView()
                }
                
            case 1:
                searchHeaderSection                                                   // header to helper with searches
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.PrimaryColor)  // rectangle to create underline
                MapView()
                
            case 2:
                VStack(spacing: 0) {
                    searchHeaderSection
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.PrimaryColor)

                    DinningView()
                        .frame(maxHeight: .infinity)
                }

                
            case 3:
                searchHeaderSection                                                   // header to helper with searches
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.PrimaryColor)// rectangle to create underline
                ExploreView()
            case 4:
                SettingsView()
                
            default:
                searchHeaderSection                                                   // header to helper with searches
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.PrimaryColor)// rectangle to create underline
                ScrollView{
                    HomeView()
                }
            }
        }
        // this is the footer / navagation bar
        Spacer()
        HStack{
            Spacer()
            Button{
                selection = 1
                searchBarIsPresented = false
                isSearchablePage = false
                searchBarPrompt = "Search for a Location"
                searchBarInput = ""
            } label: {
                Image(systemName: "map.circle")                                         // map button
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                    .foregroundColor(.PrimaryColor)
                    .padding(.top, 10)
            }
            Spacer()
            Button{
                selection = 2
                searchBarIsPresented = false
                isSearchablePage = true
                searchBarPrompt = "Search for resturants"
                searchBarInput = ""
            } label: {
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)                             //dinner button
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                    .foregroundColor(.PrimaryColor)
                    .padding(.top, 10)
            }
            Spacer()
            Button{
                selection = 0
                searchBarIsPresented = false
                isSearchablePage = false
                searchBarPrompt = ""
                searchBarInput = ""
            } label: {
                Image("ISU_we_teach_logo.png")
                    .resizable()
                    .aspectRatio(contentMode: .fit)                             // home button
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                    .padding(.top, 7)
                
            }
            Spacer()
            Button{
                selection = 3
                searchBarIsPresented = false
                isSearchablePage = true
                searchBarPrompt = "Search for Events"
                searchBarInput = ""
            } label: {
                Image(systemName: "newspaper.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)                                // events button
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                    .foregroundColor(.PrimaryColor)
                    .padding(.top ,10)
            }
            Spacer()
            Button{
                selection = 4
                searchBarIsPresented = false
                isSearchablePage = false
                searchBarPrompt = ""
                searchBarInput = ""
            } label: {
                Image(systemName: "gearshape.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)                             // settings button
                    .frame(maxWidth: .infinity , maxHeight: .infinity)
                    .foregroundColor(.PrimaryColor)
                    .padding(.top ,10)
            }
            Spacer()
        }                           // hstack end
        .overlay(alignment: .top) {
            Rectangle()
                .foregroundColor(.PrimaryColor)
                .frame(height: 1) // Adjust the height as needed
        }
        //  .background(Color("SecondaryColor"))
        .frame(height: 60 , alignment: .bottomLeading)
        
        
        
    }                                       // body end bracket
    
    //MARK: - this is the header
    var searchHeaderSection: some View {
        VStack
        {
            HStack
            {
                if !isSearchablePage{              // header for pages without search
                    Image("ISU_text_logo.svg") .resizable()  .aspectRatio(contentMode: .fit)
                    Spacer()
                }
                
                if isSearchablePage{             // header for pages with search
                    if !searchBarIsPresented
                    {
                        Image("ISU_text_logo.svg") .resizable()  .aspectRatio(contentMode: .fit)
                        Spacer()
                        Button (action: {searchBarIsPresented .toggle()})
                        { Image(systemName: "location.magnifyingglass") .resizable() .frame(width: 35, height: 35) .foregroundColor(.SecondaryColor) }   //lookup exit button
                    }
                    if searchBarIsPresented                          // if search button was pressed then show the lookup field
                    {
                        TextField("\(searchBarPrompt)", text: $searchBarInput)   //TextField for the lookup
                            .padding(5) .background(Color(.systemGray6)) .cornerRadius(5)
                        Button("Search"){ } .buttonStyle(.borderedProminent)  .cornerRadius(10) .disabled(searchBarInput.isEmpty)  // button to actually trigger the search
                        
                        Spacer()
                        Button (action: {searchBarIsPresented .toggle()})   // button to toggle search bar
                        { Image(systemName: "xmark") .resizable() .frame(width: 20, height: 20) .foregroundColor(.SecondaryColor) }   // the lookup button symbol
                    }
                }    // end braket of with search bar headaer
                
                
                
                
                
            } //end of hstack
        }
        .frame(maxWidth: .infinity , maxHeight: 40 , alignment: .topLeading)
        .padding(3)// style for the header Stack

    }
    
}                                           //contentview end braket




#Preview {
    ContentView()
}

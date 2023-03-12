//
//  ContentView.swift
//  Designs4u
//
//  Created by Gökhan Bozkurt on 10.03.2023.
//

import SwiftUI


extension Animation {
    static var easeInOutBack: Animation {
        Animation.timingCurve(0.5, -0.5, 0.5, 1.5)
    }
    static func easeInOutBack(duration: TimeInterval = 0.25) -> Animation {
        Animation.timingCurve(0.5, -0.5, 0.5, 1.5,duration: duration)
    }
}


struct ContentView: View {
    @StateObject private var model = DataModel()
    @Namespace var namespace
    @State private var selectedDesigner: Person?
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(model.searchResults) { person  in
                        DesignerRowView(person: person, namespace: namespace, model: model, selectedDesigner: $selectedDesigner)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Designs4u")
            .searchable(text: $model.searchText,tokens: $model.tokens,suggestedTokens: model.suggestedTokens,prompt: Text("Search,or use a # to select skills")) { token in
                Text(token.id)
            }
            .sheet(item: $selectedDesigner, content: DesignersDetailView.init)
            .safeAreaInset(edge: .bottom) {
                if model.selected.isEmpty == false {
                    VStack {
                        HStack(spacing: -10) {
                            ForEach(model.selected) { person in
                                Button {
                                    withAnimation {
                                        model.remove(person)
                                    }
                                } label: {
                                    AsyncImage(url: person.thumbnail, scale: 3)
                                        .frame(width: 60,height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(.white, lineWidth: 2)
                                        }
                                }
                                .buttonStyle(.plain)
                                .matchedGeometryEffect(id: person.id, in: namespace)
                            }
                        }
                        NavigationLink {
                            
                        } label: {
                            Text("Select ^[\(model.selected.count) Person](inflect: true)")
                                .frame(maxWidth: .infinity,minHeight: 44)
                        }
                        .buttonStyle(.borderedProminent)
                        .contentTransition(.identity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.horizontal,.top])
                    .background(.ultraThinMaterial)
                    
                }
            }
        }
        .task {
            do {
                try await model.fetch()
            } catch {
                print("😵😵Error Occured fetching data: \(error.localizedDescription)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

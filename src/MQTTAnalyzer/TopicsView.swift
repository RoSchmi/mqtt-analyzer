//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Philipp Arndt on 2019-06-22.
//  Copyright © 2019 Philipp Arndt. All rights reserved.
//

import SwiftUI

struct TopicsView : View {
    @EnvironmentObject var rootModel : RootModel
    
    @ObservedObject
    var model : MessageModel
    
    @ObservedObject
    var host : Host
  
    var body: some View {
        List {
            ReconnectView(host: self.host)
            
            TopicsToolsView(model: self.model)
            
            Section(header: Text("Topics")) {
                ForEach(model.displayTopics) { messages in
                    TopicCellView(messages: messages, model: self.model)
                }
            }
        }
        .navigationBarTitle(Text(host.topic), displayMode: .inline)
        .listStyle(GroupedListStyle())
        .onAppear {
            self.rootModel.connect(to: self.host)
        }
    }
}

struct TopicsToolsView : View {
    @ObservedObject
    var model : MessageModel
    
    var body: some View {
        Section(header: Text("Tools")) {
            HStack {
                Text("Topics/Messages")
                Spacer()
                Text("\(model.messagesByTopic.count)/\(model.countMessages())")
                
                Button(action: model.readall) {
                    Button(action: noAction) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .foregroundColor(.gray)
                            
                    }.contextMenu {
                        Button(action: model.clear) {
                            Text("Delete all")
                            Image(systemName: "bin.xmark")
                        }
                        Button(action: model.readall) {
                            Text("Mark all as read")
                            Image(systemName: "eye.fill")
                        }
                    }
                }
            }
         
            QuickFilterView(model: self.model)
        }
    }
    
    private func noAction() {
        
    }
}

struct TopicCellView : View {
    @ObservedObject
    var messages: MessagesByTopic
    
    @ObservedObject
    var model : MessageModel
    
    var body: some View {
        NavigationLink(destination: MessagesView(messagesByTopic: messages)) {
            HStack {
                ReadMarkerView(read: messages.read)
                
                VStack (alignment: .leading) {
                    Text(messages.topic.name)
                    Text(messagePreview())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(8)
                    Text("\(messages.messages.count) messages")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .contextMenu {
                Button(action: copy) {
                    Text("Copy topic")
                    Image(systemName: "doc.on.doc")
                }
                Button(action: focus) {
                    Text("Focus on")
                    Image(systemName: "eye.fill")
                }
                Button(action: focusParent) {
                    Text("Focus on parent")
                    Image(systemName: "eye.fill")
                }
            }
        }
    }
    
    func messagePreview() -> String {
        return self.messages.getFirst()
    }
    
    func copy() {
        UIPasteboard.general.string = self.messages.topic.name
    }
    
    func focus() {
        self.model.filter = self.messages.topic.name
    }
    
    func focusParent() {
        self.model.filter = self.messages.topic.name.pathUp()
    }
}

#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
#endif

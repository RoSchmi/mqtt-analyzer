//
//  PublishMessageFormView.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2019-12-28.
//  Copyright © 2019 Philipp Arndt. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON
import swift_petitparser


enum PublishMessagePropertyType {
	case boolean
	case number
	case text
}

class PublishMessagePropertyValue {
	var valueText: String
	var valueBool: Bool
	
	init(value: Any) {
		if let v = value as? String {
			self.valueText = v
			self.valueBool = false
		}
		else if let v = value as? Bool {
			self.valueText = ""
			self.valueBool = v
		}
		else {
			self.valueText = ""
			self.valueBool = false
		}
	}
	
	func type() -> PublishMessagePropertyType {
		return .text
	}
	
	func getTypedValue() -> Any {
		return valueText
	}
}

class PublishMessagePropertyValueBoolean: PublishMessagePropertyValue {
	override func type() -> PublishMessagePropertyType {
		return .boolean
	}
	
	override func getTypedValue() -> Any {
		return valueBool
	}
}

class PublishMessagePropertyValueNumber: PublishMessagePropertyValue {
	override func type() -> PublishMessagePropertyType {
		return .number
	}
	
	override func getTypedValue() -> Any {
		return Double(valueText) ?? 0
	}
}

class PublishMessagePropertyValueText: PublishMessagePropertyValue {
}

struct PublishMessageProperty: Identifiable {
	let id: String = NSUUID().uuidString
	let name: String
	let pathName: String
	let path: [JSONSubscriptType]
	var value: PublishMessagePropertyValue
}

class PublishMessageFormModel: ObservableObject {
	var topic: String = ""
	var message: String = ""
	var qos: Int = 0
	var retain: Bool = false
	var jsonData: JSON?
	var properties: [PublishMessageProperty] = []
	
	@Published var messageType: PublishMessageType = .plain
	
	class func of(message: Message) -> PublishMessageFormModel {
		let model = PublishMessageFormModel()
		model.message = message.data
		model.topic = message.topic
		model.qos = Int(message.qos)
		model.retain = message.retain
		model.messageType = message.isJson() ? .json : .plain
		
		if let json = message.jsonData {
			model.jsonData = json
			
			PublishMessageFormModel.createJsonProperties(json: json, path: [])
				.sorted(by: { $0.pathName < $1.pathName })
				.forEach { model.properties.append($0) }
		}
		
		return model
	}
	
	func updateMessageFromJsonData() {
		if var json = jsonData {
			for property in properties {
				json[property.path] = JSON(property.value.getTypedValue())
			}
			
			if let message = json.rawString(options: []) {
				self.message = message
			}
		}
	}
	
	class func createJsonProperties(json: JSON, path: [String]) -> [PublishMessageProperty] {
		var result: [PublishMessageProperty] = []
		json.dictionaryValue
		.forEach {
			let child = $0.value
			result += createJsonProperties(json: child, path: path + [$0.key])
		}
		
		if let property = createProperty(json: json, path: path) {
			result += [property]
		}
		
		return result
	}
	
	class func createProperty(json: JSON, path: [String]) -> PublishMessageProperty? {
		if path.isEmpty {
			return nil
		}
		
		let name = path[path.count - 1]
		let pathName = path.joined(separator: ".")
		
		let raw = json.rawString() ?? ""
		let isInt = NumbersParser.int().trim().end().accept(raw)
		
		if let value = json.bool {
			return PublishMessageProperty(name: name, pathName: pathName,
									   path: path,
									   value: PublishMessagePropertyValueBoolean(value: value))
		}
		else if isInt {
			return PublishMessageProperty(name: name, pathName: pathName,
									   path: path, value: PublishMessagePropertyValueNumber(value: "\(json.intValue)"))
		}
		else if let value = json.double {
			return PublishMessageProperty(name: name, pathName: pathName,
									   path: path, value: PublishMessagePropertyValueNumber(value: "\(value)"))
		}
		else if let value = json.string {
			return PublishMessageProperty(name: name, pathName: pathName,
									   path: path, value: PublishMessagePropertyValueText(value: value))
		}
		else {
			return nil
		}
	}
}

struct PublishMessageFormModalView: View {
	let closeCallback: () -> Void
	let root: RootModel
	let host: Host
	@ObservedObject var model: PublishMessageFormModel
	
	//RoSchmi
	@ObservedObject var fixedMessagesModel: FixedMessagesModel
		
	var body: some View {
		NavigationView {
			PublishMessageFormView(function_on_PublishMessageFormModalView: {self.startPublish(pMessage: $0, pTopic: $1, pQos: $2,
				pRetain: $3)}, message: self.model, fixedMessagesModel: fixedMessagesModel,
				type: self.$model.messageType)
				.font(.caption)
				.navigationBarTitle(Text("Publish message"))
				.navigationBarItems(
					leading: Button(action: self.cancel) {
						Text("Cancel")
						
					}.buttonStyle(ActionStyleT50()),
					trailing: Button(action: self.publish) {
						Text("Publish")
					}.buttonStyle(ActionStyleL50())
			)
			.keyboardResponsive()
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}
	
	func startPublish(pMessage: String, pTopic: String, pQos: Int, pRetain: Bool) {print(pTopic); print(pMessage); publish() }
		
	func publish() {
		if model.messageType == .json {
			model.updateMessageFromJsonData()
		}
		
		let msg = Message(data: model.message,
						  date: Date.init(),
						  qos: Int32(model.qos), retain: model.retain, topic: model.topic)
		
		root.publish(message: msg, on: self.host)
		
		closeCallback()
	}
	
	func cancel() {
		closeCallback()
	}
}

struct PublishMessageFormView: View {
	
	var function_on_PublishMessageFormModalView: (String, String, Int, Bool) -> Void
	
	@ObservedObject var message: PublishMessageFormModel
	
	//RoSchmi
	@ObservedObject var fixedMessagesModel: FixedMessagesModel
			
	@Binding var type: PublishMessageType
	var body: some View {
		Form {
			// RoSchmi
			NavigationLink(destination: PublishFixedMessagesView( function_on_PublishMessageFormView: {self.handOverToParent(pMessage: $0, pTopic: $1, pQos: $2, pRetain: $3)}, message:
				message, fixedMessagesModel: fixedMessagesModel)) {
					VStack {
					Text("Custom Commands")
					}
				}
			Section(header: Text("Topic")) {
				TextField("#", text: $message.topic)
					.disableAutocorrection(true)
					.autocapitalization(.none)
					.font(.body)
			}
			
			Section(header: Text("Settings")) {
				HStack {
					Text("QoS")
					
					QOSPicker(qos: $message.qos)
				}
				
				Toggle(isOn: $message.retain) {
					Text("Retain")
				}
			}
			Section(header: Text("Message")) {
				PublishMessageTypeView(type: self.$type)
				
				if type == .json {
					PublishMessageFormJSONView(message: message)
				}
				else {
				PublishMessageFormPlainTextView(message: $message.message)
				}
			}
		}
	}
	func handOverToParent(pMessage: String, pTopic: String, pQos: Int, pRetain: Bool){message.topic = pTopic; message.message = pMessage; message.qos = pQos; message.retain = pRetain; function_on_PublishMessageFormModalView(pMessage, pTopic, pQos, pRetain)}
	
}

enum PublishMessageType {
	case plain
	case json
}

struct PublishMessageTypeView: View {
	
	@Binding var type: PublishMessageType

	var body: some View {
		Picker(selection: $type, label: Text("Type")) {
			Text("Plain text").tag(PublishMessageType.plain)
			Text("JSON").tag(PublishMessageType.json)
		}.pickerStyle(SegmentedPickerStyle())
	}
}

struct PublishMessageFormPlainTextView: View {
	@Binding var message: String
	
	var body: some View {
		Group {
			MessageTextView(text: $message)
			.disableAutocorrection(true)
			.autocapitalization(.none)
			.font(.system(.body, design: .monospaced))
			.frame(height: 250)
		}
	}
}

struct PublishMessageFormJSONView: View {
	@ObservedObject var message: PublishMessageFormModel
	
	var body: some View {
		Group {
			ForEach(message.properties.indices) { index in
				HStack {
					Text(self.message.properties[index].pathName)
					Spacer()
					MessageProperyView(property: self.$message.properties[index])
				}
			}
		}
	}
}

struct MessageProperyView: View {
	@Binding var property: PublishMessageProperty
	
	var body: some View {

		HStack {
			if property.value.type() == .boolean {
				Toggle("", isOn: self.$property.value.valueBool)
			}
			else if property.value.type() == .text {
				TextField("", text: self.$property.value.valueText)
					.disableAutocorrection(true)
					.multilineTextAlignment(.trailing)
					.autocapitalization(.none)
					.font(.body)
			}
			else if property.value.type() == .number {
				TextField("", text: self.$property.value.valueText)
					.disableAutocorrection(true)
					.multilineTextAlignment(.trailing)
					.autocapitalization(.none)
					.font(.body)
			}
			else {
				Text("Unknown property type.")
			}
		}
	}
}

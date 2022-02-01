//  ViewController.swift
//  Autolayout
//  Created by Felipe Ramírez on 31/1/22.

import UIKit

class ViewController: UIViewController, XMLParserDelegate {
    @IBOutlet weak var txt_user: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_lastName: UITextField!
    var nom = String()
    var apel = String()
    var use = String()
    var nombreElemento = String()
    var arrayDiccionarioDatos = [[String: String]]()
    let fileManager = FileManager.default

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    func getDataXML(){
        guard let parseador: XMLParser = XMLParser(contentsOf: getFullPath2()) else {return}
        parseador.delegate = self
        parseador.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        nombreElemento = elementName
        if nombreElemento == "item" {
            use = String()
            nom = String()
            apel = String()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let caracter = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if caracter.isEmpty == false {
            if nombreElemento == "usuario"{
                use += caracter
            }
            if nombreElemento == "nombre"{
                nom += caracter
            }
            if nombreElemento == "apellido"{
                apel += caracter
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let diccionarioNuevo = ["usuario": use, "nombre": nom, "apellido": apel]
            arrayDiccionarioDatos.append(diccionarioNuevo)
        }
    }
    
    @IBAction func btn_saveXML(_ sender: Any) {
        guard let text_user = txt_user.text else {return}
        guard let text_name = txt_name.text else {return}
        guard let text_lastName = txt_lastName.text else {return}
        let diccionarioNuevo = ["usuario": text_user ,"nombre": text_name, "apellido": text_lastName]
        arrayDiccionarioDatos.append(diccionarioNuevo)
        print(diccionarioNuevo)
        let fileManager = FileManager.default
        
        let returnString = stringXML()
        
        do{
            try returnString.write(to: getFullPath2(), atomically: true, encoding: .utf8)
        }catch{
            print("error grabando xml")
        }
        arrayDiccionarioDatos = [[String: String]]()
        getDataXML()
    }
    
    func stringXML() -> String{
        var stringXml: String = "<itemFullName>\n"
        var user2: [[String: String]] = arrayDiccionarioDatos
        for i in user2{
            stringXml.append("<item>\n")
            for j in i{
                if j.key == "usuario" {
                    stringXml.append("<usuario>\n \(j.value)</usuario>\n")
                }
                if j.key == "nombre" {
                    stringXml.append("<nombre>\n \(j.value)</nombre>\n")
                }
                if j.key == "apellido" {
                    stringXml.append("<apellido>\n \(j.value)</apellido>\n")
                }
            }
            stringXml.append("</item>\n")
        }
        stringXml.append("</itemFullName>\n")
        return stringXml
    }
    
    private func getDocumentPath() -> URL{
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return URL(string: "")!}
        return path
    }
    
    private func getFullPath() -> URL {
        let path = getDocumentPath()
        let fileURL =  path.appendingPathComponent("datos.json")
        return fileURL
    }
    
    private func getFullPath2() -> URL {
        let path = getDocumentPath()
        let fileURL =  path.appendingPathComponent("datos.xml")
        return fileURL
    }
}


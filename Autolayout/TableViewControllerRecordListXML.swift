//  TableViewControllerRecordListXML.swift
//  Autolayout
//  Created by Felipe Ramírez on 31/1/22.

import UIKit

class TableViewControllerRecordListXML: UITableViewController, XMLParserDelegate {
    @IBOutlet var miTabla: UITableView!
    var nombre = String()
    var apellido = String()
    var nombreElemento: String = ""
    var urlXML = ""
    var arrayDiccionarioDatos = [["nombre": "uno","apellido": "dos"]]
    var nom = String()
    var apel = String()
    var listaUsuarios = [Item]()
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listaUsuarios =  [Item]()
        getDataXML()
        miTabla.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaUsuarios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = miTabla.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableViewCellXML
        cell.lbl_nombre.text = listaUsuarios[indexPath.row].nombre
        cell.lbl_apellido.text = listaUsuarios[indexPath.row].apellido
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        item = listaUsuarios[indexPath.row]
    }
    
    //apartir de aqui leo el xml
    func getDataXML(){
        guard let parser = XMLParser(contentsOf: getFullPath2()) else {return}
        parser.delegate = self
        parser.parse()
    }
    
    private func getDocumentPath() -> URL{
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return URL(string: "")!}
        return path
    }
    
    private func getFullPath2() -> URL {
        let path = getDocumentPath()
        let fileURL =  path.appendingPathComponent("datos.xml")
        return fileURL
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        nombreElemento = elementName
        if nombreElemento == "item" {
            nom = ""
            apel = ""
            
        }
        print(nombreElemento)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let caracter = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !caracter.isEmpty {
            if nombreElemento == "nombre"{
                nom += caracter
                
            }
            if nombreElemento == "apellido"{
                apel += caracter
            }
        }
        print(nombreElemento)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            listaUsuarios.append(Item(nombre: nom, apellido: apel))
        }
    }
    
    private func saveXML(xml: String){
        do{
            try xml.write(to: getFullPath2(), atomically: true, encoding: .utf8)
        }catch let error {
            print("error lo que sea \(error)")
        }
    }
}
